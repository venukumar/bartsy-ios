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
}
@end

@implementation VenueListViewController

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
}

-(void)viewDidDisappear:(BOOL)animated
{
    MKMapView *mapView=(MKMapView*)[self.view viewWithTag:222];
    mapView.delegate=nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    //    self.navigationItem.leftBarButtonItem=nil;
    //    self.navigationItem.hidesBackButton=YES;
    
    self.trackedViewName = @"Bartsy Venue List screen";

    self.title=@"Bartsy Service Stations";
    
    arrVenueList=[[NSMutableArray alloc]init];
    
    UILabel *lblHeader=[self createLabelWithTitle:@"Check in at a Bartsy venue to order drinks and see who else is there" frame:CGRectMake(0, 0, 320, 40) tag:0 font:[UIFont systemFontOfSize:12] color:[UIColor blackColor] numberOfLines:2];
    lblHeader.backgroundColor=[UIColor lightGrayColor];
    lblHeader.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblHeader];
    
    MKMapView *mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 40, 320, 200)];
    mapView.showsUserLocation=YES;
    mapView.tag=222;
    [self.view addSubview:mapView];
    //[mapView release];
    
    CLLocationManager *locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    [locationManager startUpdatingLocation];
    [locationManager release];
    
    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 241, 320, 180)];
    tblView.dataSource=self;
    tblView.delegate=self;
    tblView.tag=111;
    [self.view addSubview:tblView];
    //[tblView release];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568)
    {
        tblView.frame=CGRectMake(0, 241, 320, 180+108);
    }
    
    self.sharedController=[SharedController sharedController];
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    [self.sharedController getVenueListWithDelegate:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrVenueList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=[arrVenueList objectAtIndex:indexPath.row];
    // Configure the cell...
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    UIImageView *imgViewDrink=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 70, 70)];
    imgViewDrink.image=[UIImage imageNamed:@"drinks.png"];
    [[imgViewDrink layer] setShadowOffset:CGSizeMake(0, 1)];
    [[imgViewDrink layer] setShadowColor:[[UIColor grayColor] CGColor]];
    [[imgViewDrink layer] setShadowRadius:3.0];
    [[imgViewDrink layer] setShadowOpacity:0.8];
    [cell.contentView addSubview:imgViewDrink];
    //[imgViewDrink release];
    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, 150, 20)];
    lblName.text=[dict objectForKey:@"venueName"];
    lblName.font=[UIFont boldSystemFontOfSize:14];
    [cell.contentView addSubview:lblName];
    //[lblName release];
    
    
    UILabel *lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(80, 30, 150, 50)];
    lblDescription.numberOfLines=2;
    lblDescription.text=[dict objectForKey:@"address"];
    lblDescription.font=[UIFont systemFontOfSize:12];
    [cell.contentView addSubview:lblDescription];
    //[lblDescription release];
    
    NSString *strDistance=[NSString stringWithFormat:@"%.1f",[[dict objectForKey:@"distance"] floatValue]];
    UILabel *lblDistance=[self createLabelWithTitle:strDistance frame:CGRectMake(250, 15, 60, 50) tag:0 font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] numberOfLines:1];
    lblDistance.backgroundColor=[UIColor clearColor];
    lblDistance.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:lblDistance];
    //[lblDistance release];
    
    UILabel *lblMiles=[self createLabelWithTitle:@"miles" frame:CGRectMake(250, 40, 60, 30) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:1];
    lblMiles.backgroundColor=[UIColor clearColor];
    lblMiles.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:lblMiles];
    // [lblMiles release];
    
    
    return cell;
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
            [self createAlertViewWithTitle:@"Please Confirm!" message:strMsg cancelBtnTitle:@"No" otherBtnTitle:@"Yes" delegate:self tag:143225];
        }
        else
        {
            intIndex=indexPath.row;
            isRequestForCheckIn=YES;
            self.sharedController=[SharedController sharedController];
            [self createProgressViewToParentView:self.view withTitle:@"Checking In..."];
            [self.sharedController checkInAtBartsyVenueWithId:[[arrVenueList objectAtIndex:indexPath.row] objectForKey:@"venueId"] delegate:self];
        }
        
    }
    else
    {
        HomeViewController *obj=[[HomeViewController alloc]init];
        obj.dictVenue=[arrVenueList objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:obj animated:YES];
        [obj release];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation

{
    currentLocaion=newLocation.coordinate;
    NSLog(@"Lat : %f \n Lon:%f",currentLocaion.latitude,currentLocaion.longitude);
    
    [manager stopUpdatingLocation];
    manager.delegate=nil;
    
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
        
        MyAnnotation *ann=[[MyAnnotation alloc]initWithCoordinate:venueLocation.coordinate title:[dict objectForKey:@"venueName"] subtitle:[dict objectForKey:@"address"]];
        ann.tagValue=i;
        [mapView addAnnotation:ann];
        
        //        [currentLocation release];
        //        [venueLocation release];
    }
    
    NSLog(@"Venue List %@",arrVenueList);
    
    NSSortDescriptor *sortDescriptor=[[NSSortDescriptor alloc]initWithKey:@"distance" ascending:YES selector:nil];
    [arrVenueList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    //[sortDescriptor release];
    
    NSLog(@"Venue List %@",arrVenueList);
    if([arrVenueList count])
    {
        NSDictionary *dictNearBy=[arrVenueList objectAtIndex:0];
        MKCoordinateRegion region;
        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:[[dictNearBy objectForKey:@"latitude"] floatValue] longitude:[[dictNearBy objectForKey:@"longitude"] floatValue]];
        
        region.center=venueLocation.coordinate;
        
        MKCoordinateSpan span;
        span.latitudeDelta=0.1;
        span.longitudeDelta=0.1;
        region.span=span;
        
        [mapView setRegion:region animated:YES];
    }
    
    mapView.delegate=nil;
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MyAnnotation class]])
    {
        MKPinAnnotationView *pinAnn=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
        pinAnn.pinColor=MKPinAnnotationColorGreen;
        pinAnn.animatesDrop=YES;
        pinAnn.canShowCallout=YES;
        
        MyAnnotation *ann=(MyAnnotation*)annotation;
        
        UIButton *btnDetail=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        btnDetail.tag=ann.tagValue;
        [btnDetail addTarget:self action:@selector(btnDetail_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        pinAnn.rightCalloutAccessoryView=btnDetail;
        
        return pinAnn;
    }
    //    else
    //    {
    //        MKUserLocation *ann=[[MKPointAnnotation alloc]init];
    //        ann.coordinate=currentLocaion;
    //        return ann;
    //    }
    
}

-(void)btnDetail_TouchUpInside:(UIButton*)sender
{
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
}

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    
    [self hideProgressView:nil];
    
    if(isRequestForCheckIn==NO)
    {
        [arrVenueList removeAllObjects];
        [arrVenueList addObjectsFromArray:result];
        
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        [tblView reloadData];
        [self reloadMapView];
    }
    else
    {
        if([[result objectForKey:@"errorCode"] integerValue]==0)
        {
            isRequestForCheckIn=NO;
            appDelegate.intPeopleCount=[[result objectForKey:@"userCount"]integerValue];
            appDelegate.intOrderCount=0;
            [[NSUserDefaults standardUserDefaults]setObject:[[arrVenueList objectAtIndex:intIndex] objectForKey:@"venueId"] forKey:@"CheckInVenueId"];
            [[NSUserDefaults standardUserDefaults]setObject:[arrVenueList objectAtIndex:intIndex] forKey:@"VenueDetails"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            HomeViewController *obj=[[HomeViewController alloc]init];
            obj.dictVenue=[arrVenueList objectAtIndex:intIndex];
            [self.navigationController pushViewController:obj animated:YES];
            [obj release];
        }
        else
        {
            [self createAlertViewWithTitle:@"Error" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
        }
        
    }
    
}


-(void)controllerDidFailLoadingWithError:(NSError*)error
{
    [self hideProgressView:nil];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==143225&&buttonIndex==1)
    {
        isRequestForCheckIn=YES;
        self.sharedController=[SharedController sharedController];
        [self createProgressViewToParentView:self.view withTitle:@"Checking In..."];
        [self.sharedController checkInAtBartsyVenueWithId:[[arrVenueList objectAtIndex:intIndex] objectForKey:@"venueId"] delegate:self];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
