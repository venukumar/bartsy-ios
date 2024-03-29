//
//  VenueListViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 14/05/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "VenueListViewController.h"
#import "HomeViewController.h"

@interface VenueListViewController ()
{
    BOOL isRequestForCheckIn;
    NSInteger intIndex;
    CLLocationManager *locationManager;
}
@end

@implementation VenueListViewController
@synthesize SearchDisplayController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.delegateForCurrentViewController=self;
    
    if(appDelegate.isComingForOrders||appDelegate.isComingForPeople || appDelegate.isComingForMenu)//&&[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"])
    {
        HomeViewController *obj=[[HomeViewController alloc]init];
        obj.dictVenue=[[NSUserDefaults standardUserDefaults]objectForKey:@"VenueDetails"];
        [self.navigationController pushViewController:obj animated:YES];
        [obj release];
        return;
    }
    
    MKMapView *mapView = (MKMapView*)[self.view viewWithTag:222];
    mapView.showsUserLocation = YES;
    [locationManager startUpdatingLocation];
   
    self.navigationController.navigationBarHidden=YES;

    self.sharedController=[SharedController sharedController];
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    [self.sharedController getVenueListWithDelegate:self];
}

-(void)viewDidDisappear:(BOOL)animated
{
    MKMapView *mapView=(MKMapView*)[self.view viewWithTag:222];
    mapView.showsUserLocation = NO;
    mapView.delegate=nil;
    [locationManager stopUpdatingLocation];

}
- (void)viewWillDisappear:(BOOL)animated
{
    if (locationManager)
    {
        MKMapView *mapView = (MKMapView*)[self.view viewWithTag:222];
        mapView.showsUserLocation = NO;
        [locationManager stopUpdatingLocation];
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //    self.navigationItem.leftBarButtonItem=nil;
    //    self.navigationItem.hidesBackButton=YES;
    self.trackedViewName = @"Bartsy Venues";

    arrVenueList=[[NSMutableArray alloc]init];
    
    UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [self.view addSubview:imgViewForTop];
    [imgViewForTop release];

    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(100.25, 13.25, 119.5, 23.5)];
    imgLogo.image=[UIImage imageNamed:@"logo_Header.png"];
    [self.view addSubview:imgLogo];
    [imgLogo release];
    
   /* UIButton *btnSearch = [self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"search_icon.png"] frame:CGRectMake(10, 14.5, 22, 21) tag:0 selector:@selector(btnSearch_TouchUpInside:) target:self];
    [self.view addSubview:btnSearch];
    
    UIButton *btnGPS = [self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"up_arrow.png"] frame:CGRectMake(290, 15.5, 20,19) tag:0 selector:@selector(btnGPS_TouchUpInside:) target:self];
    [self.view addSubview:btnGPS];*/
    
    UIBarButtonItem *btnLogOut=[[UIBarButtonItem alloc]initWithTitle:@"Check out" style:UIBarButtonItemStylePlain target:self action:@selector(backLogOut_TouchUpInside)];
    self.navigationItem.rightBarButtonItem=btnLogOut;
    
    UILabel *lblHeader=[self createLabelWithTitle:@"Check in at a Bartsy venue to order drinks and see who else is there" frame:CGRectMake(0, 0, 320, 40) tag:0 font:[UIFont systemFontOfSize:12] color:[UIColor blackColor] numberOfLines:2];
    lblHeader.backgroundColor=[UIColor lightGrayColor];
    lblHeader.textAlignment=NSTextAlignmentCenter;
    //[self.view addSubview:lblHeader];
    
    MKMapView *mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 50, 320, 190)];
    mapView.showsUserLocation=YES;
    mapView.tag=222;
    [self.view addSubview:mapView];
    [mapView release];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]==nil)
    {
        UIImageView *imgViewToolTip=[self createImageViewWithImage:[UIImage imageNamed:@"select-bartsy.png"] frame:CGRectMake(10, 196, 300, 40) tag:225143];
        [self.view addSubview:imgViewToolTip];
        
       // [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeToolTip) userInfo:nil repeats:NO];
    }
    
    
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    [locationManager startUpdatingLocation];
//    [locationManager release];
    
    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 241, 320, 180)];
    tblView.dataSource=self;
    tblView.delegate=self;
    tblView.tag=111;
    tblView.backgroundColor = [UIColor blackColor];
    [tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tblView];
    //[tblView release];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568)
    {
        tblView.frame=CGRectMake(0, 241, 320, 180+108);
    }
    
   /* UISearchBar *searchbar = [[UISearchBar alloc] init];
    [searchbar setTintColor:[UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0]];
    searchbar.frame = CGRectMake(0, -50, 320,50);
    searchbar.delegate = self;
    searchbar.tag=1112;
    searchbar.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0];
    searchbar.showsCancelButton=YES;
    [self.view addSubview:searchbar];
    // create searchBar
    SearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchbar contentsController:self];
    SearchDisplayController.delegate = self;
    SearchDisplayController.searchResultsDataSource = self;
    SearchDisplayController.searchResultsDelegate = self;
    SearchDisplayController.searchResultsTableView.backgroundColor=[UIColor blackColor];
    [SearchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    for (UIView *searchbuttons in searchbar.subviews)
    {
        if ([searchbuttons isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            cancelButton.enabled = YES;
            //cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [cancelButton setBackgroundColor:[UIColor blackColor]];
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
    }*/
}

-(void)btnSearch_TouchUpInside:(UIButton*)sender
{
   // UISearchBar *searchbar=(UISearchBar*)[self.view viewWithTag:1112];
    //searchbar.frame=CGRectMake(0, 0, 320,50);

}

-(void)btnGPS_TouchUpInside:(UIButton*)sender
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] integerValue]!=[[[arrVenueList objectAtIndex:0] objectForKey:@"venueId"] integerValue])
    {
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]!=nil)
        {
            intIndex=0;
            NSDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"VenueDetails"];
            NSString *strMsg=[NSString stringWithFormat:@"You are already checked-in to %@.Do you want to checkout from %@",[dict objectForKey:@"venueName"],[dict objectForKey:@"venueName"]];
            
            if(appDelegate.intOrderCount!=0)
            {
                strMsg=[NSString stringWithFormat:@"You have open orders placed at %@. If you checkout they will be cancelled and you will still be charged for it.Do you want to checkout from %@",[dict objectForKey:@"venueName"],[dict objectForKey:@"venueName"]];
            }
            [self createAlertViewWithTitle:@"Please Confirm!" message:strMsg cancelBtnTitle:@"No" otherBtnTitle:@"Yes" delegate:self tag:143225];
        }
        else
        {
            intIndex=0;
            isRequestForCheckIn=YES;
            self.sharedController=[SharedController sharedController];
            [self createProgressViewToParentView:self.view withTitle:@"Checking In..."];
            [self.sharedController checkInAtBartsyVenueWithId:[[arrVenueList objectAtIndex:0] objectForKey:@"venueId"] delegate:self];
        }
        
    }
    else
    {
        HomeViewController *obj=[[HomeViewController alloc]init];
        obj.dictVenue=[arrVenueList objectAtIndex:0];
        [self.navigationController pushViewController:obj animated:YES];
        [obj release];
    }
}

-(void)removeToolTip
{
    UIImageView *imgView=(UIImageView*)[self.view viewWithTag:225143];
    [imgView removeFromSuperview];
}

-(void)backLogOut_TouchUpInside
{
    NSDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"VenueDetails"];
    NSString *strMsg=nil;
   
    if(appDelegate.intOrderCount)
    {
        strMsg=[NSString stringWithFormat:@"You have open orders placed at %@. If you logout they will be cancelled and you will still be charged for it.Do you want to logout from %@",[dict objectForKey:@"venueName"],[dict objectForKey:@"venueName"]];
    }
    else
    {
        strMsg=[NSString stringWithFormat:@"Do you want to logout"];
    }
    [self createAlertViewWithTitle:@"" message:strMsg cancelBtnTitle:@"No" otherBtnTitle:@"Yes" delegate:self tag:225];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [arrVenueList count];
    }else
    return [arrVenueList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=[arrVenueList objectAtIndex:indexPath.row];
    // Configure the cell...
    
    VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell"];
    
    if (cell == nil)
    {
        cell = [[VenueCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VenueCell"];
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fathers_office-bg.png"]];
        cell.backgroundView = bg;
        [bg release];
    }

    NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dict objectForKey:@"venueImagePath"]];
    [cell.imgVenue setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    cell.lblVenueName.text=[dict objectForKey:@"venueName"];
    cell.lblVenueName.font=[UIFont fontWithName:@"Museo Sans" size:18];
    cell.lblVenueName.textColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
   
    NSString *strTrim=[[NSString alloc]initWithString:[dict objectForKey:@"address"]];
    NSRange range = [strTrim rangeOfString:@",United"];
    NSString *shortString = [strTrim substringToIndex:range.location];
    
    cell.lblVenueAddress.text=shortString;
    cell.lblVenueAddress.font=[UIFont fontWithName:@"Museo Sans" size:12];
    cell.lblVenueAddress.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];

    if([[dict objectForKey:@"venueStatus"]isEqualToString:@"OPEN"] || [[dict objectForKey:@"venueStatus"]isEqualToString:@"OFFLINE"])
    {
        cell.lblNoCheckin.text=[NSString stringWithFormat:@"%i",[[dict objectForKey:@"checkedInUsers"] integerValue]];
        cell.lblNoCheckin.font=[UIFont fontWithName:@"Museo Sans" size:12];
        cell.lblNoCheckin.textColor=[UIColor colorWithRed:248.0/255.0 green:58.0/255.0 blue:179.0/255.0 alpha:1.0];

        cell.lblVenueStatus.text=@"checkins";
        cell.lblVenueStatus.font=[UIFont fontWithName:@"Museo Sans" size:12];
        cell.lblVenueStatus.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];

    }else{
        
        cell.lblVenueStatus.text=@"Closed";
        cell.lblVenueStatus.font=[UIFont fontWithName:@"Museo Sans" size:12];
        cell.lblVenueStatus.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        cell.lblNoCheckin.text=nil;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"CheckInVenueId"] integerValue]==[[dict valueForKey:@"venueId"] integerValue]) {
        
        cell.lbldistance.text=nil;
        cell.lblmiles.text=nil;
         cell.imgChecked.hidden=NO;
        
    }else{
        
        cell.imgChecked.hidden=YES;
        NSString *strDistance=[NSString stringWithFormat:@"%.1f",[[dict objectForKey:@"distance"] floatValue]];
        cell.lbldistance.text=strDistance;
        cell.lbldistance.font=[UIFont fontWithName:@"Museo Sans" size:20];
       
        if(![[dict objectForKey:@"venueStatus"]isEqualToString:@"OPEN"] )
        {
            cell.lbldistance.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        }
        if ([[dict objectForKey:@"venueStatus"]isEqualToString:@"OPEN"] || [[dict objectForKey:@"venueStatus"]isEqualToString:@"OFFLINE"]) {
            cell.lbldistance.textColor=[UIColor colorWithRed:35.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0];
        }else{
            cell.lbldistance.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        }
        cell.lblmiles.font=[UIFont fontWithName:@"Museo Sans" size:12];
        cell.lblmiles.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
    }
    if ([[dict valueForKey:@"wifiPresent"] boolValue]==NO) {
        
        cell.imgwifi.image=nil;
    }

    
   /* UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        cell.textLabel.text = [dict objectForKey:@"venueName"];
    }else{
    if((indexPath.row)==0)
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage            imageNamed:@"city_tavern_bg.png"]]; //set image for cell 0
    else
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage            imageNamed:@"fathers_office-bg.png"]];

     NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dict objectForKey:@"venueImagePath"]];

    UIImageView *imgViewDrink=[[UIImageView alloc]initWithFrame:CGRectMake(4, 6,72, 72)];
    //imgViewDrink.image=[UIImage imageNamed:@"drinks.png"];
    [imgViewDrink setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

   
    imgViewDrink.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:imgViewDrink];
    [imgViewDrink release];
    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(85, 15, 240, 20)];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.text=[dict objectForKey:@"venueName"];
    lblName.font=[UIFont systemFontOfSize:18];
    lblName.font=[UIFont fontWithName:@"Museo Sans" size:18];
    lblName.textColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    [cell.contentView addSubview:lblName];
    //[lblName release];
    
    NSString *strTrim=[[NSString alloc]initWithString:[dict objectForKey:@"address"]];
    NSRange range = [strTrim rangeOfString:@",United"];
    NSString *shortString = [strTrim substringToIndex:range.location];
    UILabel *lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(85, 40, 240, 20)];
    lblDescription.numberOfLines=1;
    lblDescription.text=shortString;
    lblDescription.font=[UIFont systemFontOfSize:12];
    lblDescription.font=[UIFont fontWithName:@"Museo Sans" size:12];
    lblDescription.backgroundColor=[UIColor clearColor];
    lblDescription.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
    [cell.contentView addSubview:lblDescription];
    //[lblDescription release];
    
    if([[dict objectForKey:@"venueStatus"]isEqualToString:@"OPEN"] || [[dict objectForKey:@"venueStatus"]isEqualToString:@"OFFLINE"])
    {
        UILabel *lblNoOfPeople=[[UILabel alloc]initWithFrame:CGRectMake(85, 60, 15, 20)];
        lblNoOfPeople.numberOfLines=1;
        lblNoOfPeople.text=[NSString stringWithFormat:@"%i",[[dict objectForKey:@"checkedInUsers"] integerValue]];
        lblNoOfPeople.font=[UIFont systemFontOfSize:12];
        lblNoOfPeople.font=[UIFont fontWithName:@"Museo Sans" size:12];
        lblNoOfPeople.backgroundColor=[UIColor clearColor];
        lblNoOfPeople.adjustsFontSizeToFitWidth=YES;
        lblNoOfPeople.textColor=[UIColor colorWithRed:248.0/255.0 green:58.0/255.0 blue:179.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lblNoOfPeople];
        
        UILabel *lblMsg=[[UILabel alloc]initWithFrame:CGRectMake(20+80, 60, 200, 20)];
        lblMsg.numberOfLines=1;
        lblMsg.text=@"checkins";
        lblMsg.font=[UIFont systemFontOfSize:12];
        lblMsg.font=[UIFont fontWithName:@"Museo Sans" size:12];
        lblMsg.backgroundColor=[UIColor clearColor];
        lblMsg.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lblMsg];

    }
    else
    {
        UIImageView *imgViewClosed=[self createImageViewWithImage:[UIImage imageNamed:@"exclamatory_icon.png"] frame:CGRectMake(85, 64, 12.5, 12.5) tag:0];
        [cell.contentView addSubview:imgViewClosed];
        
        UILabel *lblMsg=[[UILabel alloc]initWithFrame:CGRectMake(20+80, 60, 200, 20)];
        lblMsg.numberOfLines=1;
        lblMsg.text=@"Closed";
        lblMsg.font=[UIFont systemFontOfSize:12];
        lblMsg.backgroundColor=[UIColor clearColor];
        lblMsg.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lblMsg];
    }
        
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"CheckInVenueId"] integerValue]==[[dict valueForKey:@"venueId"] integerValue]) {
        
        UIImageView *homecheckimg=[[UIImageView alloc]initWithFrame:CGRectMake(269,24,32, 32)];
        homecheckimg.image=[UIImage imageNamed:@"home-footer"];
        [cell.contentView addSubview:homecheckimg];
        [homecheckimg release];
        
    }else{
        
        NSString *strDistance=[NSString stringWithFormat:@"%.1f",[[dict objectForKey:@"distance"] floatValue]];
        UILabel *lblDistance=[self createLabelWithTitle:strDistance frame:CGRectMake(250, 26, 60, 15) tag:0 font:[UIFont systemFontOfSize:20] color:[UIColor colorWithRed:35.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] numberOfLines:1];
        lblDistance.adjustsFontSizeToFitWidth=YES;
        lblDistance.backgroundColor=[UIColor clearColor];
        lblDistance.font=[UIFont fontWithName:@"Museo Sans" size:20];
        lblDistance.textAlignment=NSTextAlignmentCenter;
        [cell.contentView addSubview:lblDistance];
        //[lblDistance release];
        if(![[dict objectForKey:@"venueStatus"]isEqualToString:@"OPEN"] )
        {
            lblDistance.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        }
        if ([[dict objectForKey:@"venueStatus"]isEqualToString:@"OPEN"] || [[dict objectForKey:@"venueStatus"]isEqualToString:@"OFFLINE"]) {
            lblDistance.textColor=[UIColor colorWithRed:35.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0];
        }else{
            lblDistance.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        }
        UILabel *lblMiles=[self createLabelWithTitle:@"miles" frame:CGRectMake(250, 45, 60, 30) tag:0 font:[UIFont systemFontOfSize:12] color:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] numberOfLines:1];
        lblMiles.backgroundColor=[UIColor clearColor];
        lblMiles.font=[UIFont fontWithName:@"Museo Sans" size:12];
        lblMiles.textAlignment=NSTextAlignmentCenter;
        [cell.contentView addSubview:lblMiles];
    }
    if ([[dict valueForKey:@"wifiPresent"] boolValue]==YES) {
        
        UIImageView *homecheckimg=[[UIImageView alloc]initWithFrame:CGRectMake(208,64,23, 12)];
        homecheckimg.image=[UIImage imageNamed:@"wifi-icon"];        
        [cell.contentView addSubview:homecheckimg];
    }
    // [lblMiles release];
    
//    if([[dict objectForKey:@"venueStatus"] isEqualToString:@"OFFLINE"])
//    {
//        [cell setUserInteractionEnabled:NO];
//        cell.contentView.backgroundColor=[UIColor grayColor];
//        imgViewDrink.alpha=0.1;
//    }
    }*/
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewFooter=[[UIView alloc]init];
    return viewFooter;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] integerValue]!=[[[arrVenueList objectAtIndex:indexPath.row] objectForKey:@"venueId"] integerValue])
    {
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]!=nil)
        {
            intIndex=indexPath.row;
            NSDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"VenueDetails"];
            NSString *strMsg=[NSString stringWithFormat:@"You are already checked-in to %@.Do you want to checkout from %@",[dict objectForKey:@"venueName"],[dict objectForKey:@"venueName"]];
            
            if(appDelegate.intOrderCount!=0)
            {
                strMsg=[NSString stringWithFormat:@"You have open orders placed at %@. If you checkout they will be cancelled and you will still be charged for it.Do you want to checkout from %@",[dict objectForKey:@"venueName"],[dict objectForKey:@"venueName"]];
            }
            [self createAlertViewWithTitle:@"Please Confirm!" message:strMsg cancelBtnTitle:@"No" otherBtnTitle:@"Yes" delegate:self tag:143225];
        }
        else
        {
            intIndex=indexPath.row;
            //isRequestForCheckIn=YES;
            //self.sharedController=[SharedController sharedController];
            //[self createProgressViewToParentView:self.view withTitle:@"Checking In..."];
            //[self.sharedController checkInAtBartsyVenueWithId:[[arrVenueList objectAtIndex:indexPath.row] objectForKey:@"venueId"] delegate:self];
            HomeViewController *obj=[[HomeViewController alloc]init];
            obj.dictVenue=[arrVenueList objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:obj animated:YES];
            [obj release];
        }
        
    }
    else
    {
        //storing the tax percentage
        [[NSUserDefaults standardUserDefaults] setFloat:[[[arrVenueList objectAtIndex:indexPath.row] valueForKey:@"totalTaxRate"] floatValue]  forKey:@"percentTAX"];
        
        HomeViewController *obj=[[HomeViewController alloc]init];
        obj.dictVenue=[arrVenueList objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:obj animated:YES];
        [obj release];
    }
    
    NSLog(@"Index is %i",intIndex);
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation

{
    currentLocaion=newLocation.coordinate;
    NSLog(@"Lat : %f \n Lon:%f",currentLocaion.latitude,currentLocaion.longitude);
    
    [manager stopUpdatingLocation];
    manager.delegate=nil;
    
    [self reloadMapView];
    UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
    [tblView reloadData];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Error is %@",[error description]);
    [manager stopUpdatingLocation];
    manager.delegate=nil;
}

-(void)reloadMapView
{
    MKMapView *mapView=(MKMapView*)[self.view viewWithTag:222];
    mapView.delegate=self;
    
    NSMutableArray * annotationsToRemove = [ mapView.annotations mutableCopy ] ;
    [annotationsToRemove removeObject:mapView.userLocation ] ;
    [mapView removeAnnotations:annotationsToRemove] ;
    
    for (int i=0;i<[arrVenueList count];i++)
    {
        NSMutableDictionary *dict=[arrVenueList objectAtIndex:i];
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentLocaion.latitude longitude:currentLocaion.longitude];
        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:[[dict objectForKey:@"latitude"] floatValue] longitude:[[dict objectForKey:@"longitude"] floatValue]];
        
        CLLocationDistance distance = [currentLocation distanceFromLocation:venueLocation];
        float distanceInMiles=distance/1609.344;
        NSNumber *miles=[NSNumber numberWithFloat:distanceInMiles];
        [dict setObject:miles forKey:@"distance"];
        [arrVenueList replaceObjectAtIndex:i withObject:dict];
    
    }
    
    NSLog(@"Venue List %@",arrVenueList);
    
    NSSortDescriptor *sortDescriptor=[[NSSortDescriptor alloc]initWithKey:@"distance" ascending:YES selector:nil];
    [arrVenueList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    //Saving all venue details to show the wifi details incase of internet lost
    [[NSUserDefaults standardUserDefaults]setObject:arrVenueList forKey:@"Venues"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //[sortDescriptor release];
    
    for (int i=0;i<[arrVenueList count];i++)
    {
        NSMutableDictionary *dict=[arrVenueList objectAtIndex:i];
        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:[[dict objectForKey:@"latitude"] floatValue] longitude:[[dict objectForKey:@"longitude"] floatValue]];
        
        MyAnnotation *ann=[[MyAnnotation alloc]initWithCoordinate:venueLocation.coordinate title:[dict objectForKey:@"venueName"] subtitle:[dict objectForKey:@"address"]];
        ann.tagValue=i;
        [mapView addAnnotation:ann];
    }
    
    NSLog(@"Venue List %@",arrVenueList);
    if([arrVenueList count])
    {
        NSDictionary *dictNearBy=[arrVenueList objectAtIndex:0];
        MKCoordinateRegion region;
        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:[[dictNearBy objectForKey:@"latitude"] floatValue] longitude:[[dictNearBy objectForKey:@"longitude"] floatValue]];
        
        region.center=venueLocation.coordinate;
        
        MKCoordinateSpan span;
        span.latitudeDelta=0.01;
        span.longitudeDelta=0.01;
        region.span=span;
        
        [mapView setRegion:region animated:YES];
    }
    
    mapView.delegate=nil;
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MyAnnotation class]])
    {
        /*
        MKPinAnnotationView *pinAnn=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
        pinAnn.pinColor=MKPinAnnotationColorGreen;
        pinAnn.animatesDrop=YES;
        pinAnn.canShowCallout=YES;
        
        MyAnnotation *ann=(MyAnnotation*)annotation;
        
        UIButton *btnDetail=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        NSLog(@"Tag is %i title is %@",ann.tagValue,ann.title);
        btnDetail.tag=ann.tagValue;
        [btnDetail addTarget:self action:@selector(btnDetail_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        pinAnn.rightCalloutAccessoryView=btnDetail;
        
        return pinAnn;
         */
        
        MKAnnotationView *annView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
        
        MyAnnotation *ann=(MyAnnotation*)annotation;

        UIImageView *imgViewBall = [[UIImageView alloc] init];
        UILabel *lbl = [[UILabel alloc] init];

        if(ann.tagValue==0)
        {
            imgViewBall.frame=CGRectMake(0, 0, 25, 44);
            imgViewBall.image=[UIImage imageNamed:@"map_point_icon.png"];
            lbl.frame=CGRectMake(0, 0, 25, 20.5);
        }
        else
        {
            imgViewBall.frame=CGRectMake(0, 0, 20.5, 20.5);
            imgViewBall.image=[UIImage imageNamed:@"map-circle.png"];
            lbl.frame=CGRectMake(0, 0, 20.5, 20.5);
        }

        
        NSDictionary *dictVenue=[arrVenueList objectAtIndex:ann.tagValue];

        lbl.text=[NSString stringWithFormat:@"%i",[[dictVenue objectForKey:@"checkedInUsers"] integerValue]];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor blackColor];
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.font=[UIFont boldSystemFontOfSize:10];
        lbl.adjustsFontSizeToFitWidth=YES;
        [imgViewBall addSubview:lbl];
        [lbl release];
        //Following lets the callout still work if you tap on the label...
        annView.canShowCallout = YES;
        annView.frame = imgViewBall.frame;
        
        [annView addSubview:imgViewBall];
        [imgViewBall release];

        
        return annView;
        
    }
}
/*
-(void)btnDetail_TouchUpInside:(UIButton*)sender
{
    NSLog(@"Tag is %i",sender.tag);
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] integerValue]!=[[[arrVenueList objectAtIndex:sender.tag] objectForKey:@"venueId"] integerValue])
    {
        intIndex=sender.tag;
        isRequestForCheckIn=YES;
        self.sharedController=[SharedController sharedController];
        [self createProgressViewToParentView:self.view withTitle:@"Checking In..."];
        [self.sharedController checkInAtBartsyVenueWithId:[[arrVenueList objectAtIndex:sender.tag] objectForKey:@"venueId"] delegate:self];
    }
    else
    {
        HomeViewController *obj=[[HomeViewController alloc]init];
        obj.dictVenue=[arrVenueList objectAtIndex:sender.tag];
        [self.navigationController pushViewController:obj animated:YES];
        [obj release];
    }
}*/

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    
    [self hideProgressView:nil];
    
    if([result isKindOfClass:[NSDictionary class]]&&[[result objectForKey:@"errorCode"] integerValue]!=0)
    {
        [self createAlertViewWithTitle:@"" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
    }
    else if(isRequestForCheckIn==NO)
    {
        [arrVenueList removeAllObjects];
        [arrVenueList addObjectsFromArray:[result objectForKey:@"venues"]];
        
        [self reloadMapView];
        
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        [tblView reloadData];
        
    }
    else
    {
        NSLog(@"Venue List is %@",arrVenueList);
        NSLog(@"Index is %i",intIndex);

        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"OrdersTimedOut"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        isRequestForCheckIn=NO;
        appDelegate.intPeopleCount=[[result objectForKey:@"userCount"]integerValue];
        appDelegate.intOrderCount=0;
        [[NSUserDefaults standardUserDefaults]setObject:[[arrVenueList objectAtIndex:intIndex] objectForKey:@"venueId"] forKey:@"CheckInVenueId"];
        [[NSUserDefaults standardUserDefaults]setObject:[arrVenueList objectAtIndex:intIndex] forKey:@"VenueDetails"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [appDelegate startTimerToCheckHeartBeat];
        
        //storing the tax percentage
        [[NSUserDefaults standardUserDefaults] setFloat:[[[arrVenueList objectAtIndex:intIndex] valueForKey:@"totalTaxRate"] floatValue]  forKey:@"percentTAX"];
        HomeViewController *obj=[[HomeViewController alloc]init];
        obj.dictVenue=[arrVenueList objectAtIndex:intIndex];
        [self.navigationController pushViewController:obj animated:YES];
        [obj release];
    }
    
}


-(void)controllerDidFailLoadingWithError:(NSError*)error
{
    [self hideProgressView:nil];
    
}

#pragma mark----------Search Delegates
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
    [searchBar resignFirstResponder];
    searchBar.frame=CGRectMake(0, -50, 320,50);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==143225&&buttonIndex==1)
    {
        //isRequestForCheckIn=YES;
        self.sharedController=[SharedController sharedController];
        //[self createProgressViewToParentView:self.view withTitle:@"Checking In..."];
        //[self.sharedController checkInAtBartsyVenueWithId:[[arrVenueList objectAtIndex:intIndex] objectForKey:@"venueId"] delegate:self];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CheckInVenueId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OrdersTimedOut"];
        //[[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"bartsyId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"percentTAX"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        HomeViewController *obj=[[HomeViewController alloc]init];
        obj.dictVenue=[arrVenueList objectAtIndex:intIndex];
        [self.navigationController pushViewController:obj animated:YES];
        [obj release];

    }
    else if(alertView.tag==225&&buttonIndex==1)
    {
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]!=nil)
        [self.sharedController checkOutAtBartsyVenueWithId:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] delegate:nil];
        
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"bartsyId"];

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
