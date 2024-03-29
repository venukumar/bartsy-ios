//
//  HomeViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 01/05/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImageView+WebCache.h"
#import "CustomDrinksViewController.h"
#import "FrontViewController.h"
#import "RearViewController.h"
#import "RevealController.h"
#import "Constants.h"
#import "PeopleViewController.h"
#import "MessageListViewController.h"
#import "PeopleDetailViewController.h"
#import "SDImageCache.h"
#import "CustomDrinkViewController.h"
@interface PeopleCustomCell : UITableViewCell {}
@end
@implementation PeopleCustomCell
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0,0,60,60);
    self.textLabel.frame = CGRectMake(61,0,200,20);
    self.detailTextLabel.frame = CGRectMake(61,21,200,20);
}
@end

@interface HomeViewController ()
{
    NSMutableArray *arrMenu;
    NSMutableArray *arrOrders;
    NSMutableArray *arrPastOrders;
    NSInteger btnValue;
    BOOL isSelectedForDrinks;
    BOOL isSelectedForPastOrders;
    NSString *strTotalPrice;
    BOOL isSelectedForPeople;
    NSMutableArray *arrPeople;
    BOOL isRequestForGettingsOrders;
    BOOL isRequestForGettingsPastOrders;
    NSString *sessionToken;
    
    UIScrollView *topscrollView;
    UIPageControl *pagectrl;
    BOOL _pageControlUsed;
    
    NSMutableArray *ArrMenuSections;
    NSMutableArray *arrFavorites;
    BOOL isGettingIngradients;
    NSMutableArray *arrCustomDrinks;
    BOOL isRequestCheckin;
    BOOL isGettingCocktails;
    BOOL isUserCheckOut;
    BOOL isGetFavorites;
    NSDictionary *dictMainCustomDrinks;
    
    NSMutableArray *arrCocktailsSection;
    NSMutableArray *arrRecentOrders;
   
    float ttlPrice;
}

@end

@implementation HomeViewController
@synthesize dictVenue,dictPeopleSelectedForDrink;

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
    UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];

    if(appDelegate.isComingForOrders==YES)
    {
        appDelegate.isComingForOrders=NO;
        [arrOrdersTimedOut removeAllObjects];
        [arrOrdersTimedOut addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"OrdersTimedOut"]];
        [segmentControl setSelectedSegmentIndex:2];
        [self segmentControl_ValueChanged:segmentControl];
        return;
        
    }else if (appDelegate.isComingForPeople==YES){
        
        //appDelegate.isComingForPeople=NO;
        [segmentControl setSelectedSegmentIndex:1];
        [self segmentControl_ValueChanged:segmentControl];
        return;
    }else if(appDelegate.isComingForMenu==YES){
        
        appDelegate.isComingForMenu=NO;
        [segmentControl setSelectedSegmentIndex:0];
        [self segmentControl_ValueChanged:segmentControl];
        return;

    }
    else if(appDelegate.isCmgForShowingOrderUI==YES)
    {
        [self showMultiItemOrderUI];
        appDelegate.isCmgForShowingOrderUI=NO;
    }else if (appDelegate.isMenuUpdate==YES){
        
        appDelegate.isMenuUpdate=NO;
        isLocuMenu=YES;
        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController getMenuListWithVenueID:[dictVenue objectForKey:@"venueId"] delegate:self];
    }
    
    
    if(segmentControl.selectedSegmentIndex==1)
    {
        isRequestForPeople=YES;
        isSelectedForPastOrders = NO;
        isRequestForGettingsPastOrders = NO;

        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController gettingPeopleListFromVenue:[dictVenue objectForKey:@"venueId"]  delegate:self];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.trackedViewName = @"Drinks Screen";

    self.navigationController.navigationBarHidden=YES;
    // self.navigationItem.leftBarButtonItem=nil;
    //self.navigationItem.hidesBackButton=YES;
    
    UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [self.view addSubview:imgViewForTop];
    [imgViewForTop release];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(2, 0, 44, 44);
    [btnBack addTarget:self action:@selector(btnBack_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    UIImageView *imgViewBack = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 12, 20)];
    imgViewBack.image = [UIImage imageNamed:@"arrow-left.png"];
    [btnBack addSubview:imgViewBack];
    [imgViewBack release];
    
    self.view.backgroundColor=[UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:18.0/255.0 alpha:1.0];
    
    UILabel *lblVenueName=[self createLabelWithTitle:[dictVenue objectForKey:@"venueName"] frame:CGRectMake(40, 0, 240, 44) tag:0 font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] numberOfLines:0];
    lblVenueName.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblVenueName];
    
    
    
    UIButton *checkinBtn=[self createUIButtonWithTitle:@"" image:nil frame:CGRectMake(276, 1, 44, 44) tag:3333 selector:@selector(CheckinButton_Action:) target:self];
    [self.view addSubview:checkinBtn];
    
    UILabel *lblcheckin=[self createLabelWithTitle:@"Check in:" frame:CGRectMake(-42, 0, 140, 44) tag:9996 font:[UIFont boldSystemFontOfSize:10] color:[UIColor blackColor] numberOfLines:0];
    lblcheckin.textAlignment=NSTextAlignmentLeft;
    [checkinBtn addSubview:lblcheckin];
    
    UIImageView *imgcheckin = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 30, 30)];
    imgcheckin.image = [UIImage imageNamed:@"tick_mark"];
    imgcheckin.tag=9995;
    [checkinBtn addSubview:imgcheckin];
    [imgcheckin release];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.delegateForCurrentViewController=self;
    
    
    [[NSUserDefaults standardUserDefaults]setObject:dictVenue forKey:@"VenueDetails"];
    
    arrMenu=[[NSMutableArray alloc]init];
    arrOrders=[[NSMutableArray alloc]init];
    arrPeople=[[NSMutableArray alloc]init];
    arrBundledOrders=[[NSMutableArray alloc]init];
    arrPastOrders=[[NSMutableArray alloc]init];
    arrOrdersTimedOut=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"OrdersTimedOut"]];
    
    arrCustomDrinks=[NSMutableArray new];
    arrCocktailsSection=[[NSMutableArray alloc]init];
    arrRecentOrders=[[NSMutableArray alloc]init];

    arrStatus=[[NSArray alloc]initWithObjects:@"Waiting for bartender to accept",@"Your order was rejected by Bartender",@"Order was accepted",@"Ready for pickup",@"Order is Failed",@"Order is picked up",@"Noshow",@"Your order was timedout",@"Your order was rejected",@"Drink offered",@"Past Order", nil];
    arrOrdersOffered=[[NSMutableArray alloc]init];
    
    NSString *strOrder=[NSString stringWithFormat:@"Orders (%i)",appDelegate.intOrderCount];
    NSString *strPeopleCount=[NSString stringWithFormat:@"People (%i)",appDelegate.intPeopleCount];
    [self getPeopleList];
    [self getPastorderAsynchronously];
    // Pagecontrol with scrollview
     topscrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,45,320,180)];
     topscrollView.scrollEnabled=YES;
     topscrollView.pagingEnabled=YES;
     topscrollView.delegate=self;
     topscrollView.showsHorizontalScrollIndicator=NO;
     [topscrollView setBackgroundColor:[UIColor clearColor]];
     [self.view addSubview:topscrollView];
     NSLog(@"dictvenue %@",dictVenue);
     NSArray *temparray=[NSArray arrayWithObjects:@"background-img",@"background-img-A",@"background-img1",nil];
     for (int i=0; i<3; i++) {
     
         UIImageView *imgview=[self createImageViewWithImage:[UIImage imageNamed:[temparray objectAtIndex:i] ] frame:CGRectMake(320*i, 0, 320, 135) tag:0];
         [topscrollView addSubview:imgview];
     
         if ([[dictVenue valueForKey:@"wifiPresent"] integerValue]==1) {
             UIImageView *wifiimg=[[UIImageView alloc]initWithFrame:CGRectMake(18+(320*i),110,30, 16)];
             wifiimg.image=[UIImage imageNamed:@"wifi-icon"];
             [topscrollView addSubview:wifiimg];
             [wifiimg release];
         }
         
         UIImageView *infoimg=[[UIImageView alloc]initWithFrame:CGRectMake(275+(320*i),106,25, 25)];
         infoimg.image=[UIImage imageNamed:@"i-icon"];
         [topscrollView addSubview:infoimg];
         [infoimg release];
         if (i==0) {
             UILabel *address=[self createLabelWithTitle:[dictVenue valueForKey:@"address"] frame:CGRectMake(31, 0, 260, 120) tag:0 font:[UIFont systemFontOfSize:22] color:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] numberOfLines:3];
             address.textAlignment=NSTextAlignmentCenter;
             address.font=[UIFont fontWithName:@"Museo Sans" size:22.0];
             
             [imgview addSubview:address];
         }else if (i==1){
             
             UILabel *lblwifiname=[self createLabelWithTitle:[NSString stringWithFormat:@"%@ : %@",@"wifiPassword",[dictVenue valueForKey:@"wifiName"]] frame:CGRectMake(5, 10, 310, 30) tag:0 font:[UIFont systemFontOfSize:18] color:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] numberOfLines:1];
             lblwifiname.textAlignment=NSTextAlignmentCenter;
             lblwifiname.font=[UIFont fontWithName:@"Museo Sans" size:18.0];
             [imgview addSubview:lblwifiname];
             
             UILabel *lblwifipswd=[self createLabelWithTitle:[NSString stringWithFormat:@"%@ : %@",@"wifiName",[dictVenue valueForKey:@"wifiPassword"]] frame:CGRectMake(5, 40, 310, 30) tag:0 font:[UIFont systemFontOfSize:18] color:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] numberOfLines:1];
             lblwifipswd.textAlignment=NSTextAlignmentCenter;
             lblwifipswd.font=[UIFont fontWithName:@"Museo Sans" size:18.0];
             [imgview addSubview:lblwifipswd];
         }
     
     }
     [topscrollView setContentSize:CGSizeMake(3*320,120)];
     pagectrl=[[UIPageControl alloc]initWithFrame:CGRectMake(116, 150, 100, 20)];
     pagectrl.numberOfPages=3;
     [pagectrl setBackgroundColor:[UIColor clearColor]];
     [self.view addSubview:pagectrl];
     [pagectrl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Menu",strPeopleCount,strOrder,@"Past Orders", nil]];
    segmentControl.frame=CGRectMake(2, 187, 316, 44);
    //UIFont *font = [UIFont systemFontOfSize:14.0f];
    UIFont *font=[UIFont fontWithName:@"Museo Sans" size:14.0];

    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    [segmentControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    [segmentControl setTintColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    segmentControl.segmentedControlStyle=UISegmentedControlStyleBar;
    [segmentControl setDividerImage:[UIImage imageNamed:@"menu-bg20.png"] forLeftSegmentState:UIControlStateNormal
                      rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    segmentControl.selectedSegmentIndex=0;
    segmentControl.tag=1111;
    [segmentControl addTarget:self action:@selector(segmentControl_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
    
    [segmentControl setBackgroundImage:[UIImage imageNamed:@"menu-bg.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    [segmentControl setBackgroundImage:[UIImage imageNamed:@"menu-bg-hover.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    
    self.sharedController=[SharedController sharedController];
    
    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 356-topscrollView.frame.size.height)];
    tblView.dataSource=self;
    tblView.backgroundColor = [UIColor blackColor];
    tblView.delegate=self;
    tblView.tag=111;
    [tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tblView];
    
   
    if (IS_IPHONE_5)
    {
        tblView.frame=CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 323+120-topscrollView.frame.size.height);
    }
    
    [tblView release];
    
    //tblView.userInteractionEnabled=NO;
    
    //optional pre init, so the ZooZ screen will upload immediatly, you can skip this call
    //    ZooZ * zooz = [ZooZ sharedInstance];
    //    [zooz preInitialize:@"c7659586-f78a-4876-b317-1b617ec8ab40" isSandboxEnv:IS_SANDBOX];
    
    
    //storing venue ID to call in timerforgetmessage
    [[NSUserDefaults standardUserDefaults]setObject:[dictVenue objectForKey:@"venueId"] forKey:@"selectedVenueID"];
    
    
    //Registering local Notification
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PeopleSelected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedPeople:) name:@"PeopleSelected" object:nil];
    
    ArrMenuSections=[NSMutableArray new ];
    
    [ArrMenuSections addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"Arrow",@"Favorites",@"SectionName", nil]];
    [ArrMenuSections addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"Arrow",@"Recent Orders",@"SectionName", nil]];
    arrFavorites=[NSMutableArray new];
    [appDelegate.arrFBfriensList removeAllObjects];
    NSArray *friends=[NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"FBFriends"]];
    appDelegate.arrFBfriensList=[NSMutableArray arrayWithArray:friends];
    if(!([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]==nil)){
        
        [appDelegate startTimerTOGetMessages];

        [topscrollView removeFromSuperview];
        [pagectrl removeFromSuperview];
        UIButton *checkinBtn=(UIButton*)[self.view viewWithTag:3333];
        //[checkinBtn setImage:[UIImage imageNamed:@"tickmark_select"] forState:UIControlStateNormal];
        checkinBtn.tag=3334;
        UILabel *lblcheckout=(UILabel*)[checkinBtn viewWithTag:9996];
        lblcheckout.text=@"Check out:";
        UIImageView *imgcheckin=(UIImageView*)[self.view viewWithTag:9995];
        imgcheckin.image=[UIImage imageNamed:@"tickmark_select"];
        [checkinBtn addSubview:imgcheckin];
        //storing the tax percentage
        [[NSUserDefaults standardUserDefaults] setFloat:[[dictVenue valueForKey:@"totalTaxRate"] floatValue]  forKey:@"percentTAX"];
        UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
        segmentControl.frame=CGRectMake(2, 47, 316, 44);
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        if (IS_IPHONE_5)
            tblView.frame=CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 323+90);
        else
            tblView.frame=CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 323);
        
        UIScrollView *scrollViewOld=(UIScrollView*)[self.view viewWithTag:987];
        if(IS_IPHONE_5)
            scrollViewOld.frame=CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 327+90-42);
        else
            scrollViewOld.frame=CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 375-42);

    }
    
    
   // NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"picture", @"",@"message", nil];
    
        
}

-(void)ButtonHighlight:(UIButton*)sender{
    
        sender.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:92.0/255.0 blue:118.0/255.0 alpha:1.0];
}

-(void)btnBack_TouchUpInside
{
    [appDelegate stopTimerForGetMessages];
    [self.navigationController popViewControllerAnimated:YES];
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


-(void)reloadData
{
    UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
    
    if(appDelegate.isComingForOrders==YES)
    {
        appDelegate.isComingForOrders=NO;
        [arrOrdersTimedOut removeAllObjects];
        [arrOrdersTimedOut addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"OrdersTimedOut"]];
        [segmentControl setSelectedSegmentIndex:2];
        [self segmentControl_ValueChanged:segmentControl];
    }
    else if(segmentControl.selectedSegmentIndex==2)
    {
        [arrOrders removeAllObjects];
        //[arrOrders addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"Orders"]];
       
        //UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        //tblView.hidden=NO;
        isSelectedForDrinks=NO;
        //[tblView reloadData];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Date" ascending:NO];
        [arrOrders sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSString *strOrder=[NSString stringWithFormat:@"Orders (%i)",[arrOrders count]];
        
        [segmentControl setTitle:strOrder forSegmentAtIndex:2];
        
    }
    appDelegate.isComingForOrders=NO;
}

-(void)reloadDataPeopleAndOrderCount
{
    UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
    NSString *strOrder=[NSString stringWithFormat:@"Orders (%i)",appDelegate.intOrderCount];
    
    [segmentControl setTitle:strOrder forSegmentAtIndex:2];
    
    NSString *strPeopleCount=[NSString stringWithFormat:@"People (%i)",appDelegate.intPeopleCount];
    
    [segmentControl setTitle:strPeopleCount forSegmentAtIndex:1];
}

-(void)segmentControl_ValueChanged:(UISegmentedControl*)segmentControl
{
    UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
    UIScrollView *scrollViewOld=(UIScrollView*)[self.view viewWithTag:987];
    [scrollViewOld removeFromSuperview];
    if(segmentControl.selectedSegmentIndex==0)
    {
        isSelectedForDrinks=YES;
        isRequestForGettingsOrders=NO;
        isRequestForPeople=NO;
        tblView.hidden=NO;
        [self modifyData];
        //[self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        //[self.sharedController getMenuListWithVenueID:[dictVenue objectForKey:@"venueId"] delegate:self];
    }
    else if(segmentControl.selectedSegmentIndex==1)
    {
        isRequestForPeople=YES;
        isSelectedForPastOrders = NO;
        isRequestForGettingsPastOrders = NO;
        tblView.hidden=NO;
        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController gettingPeopleListFromVenue:[dictVenue objectForKey:@"venueId"]  delegate:self];
    }
    else if(segmentControl.selectedSegmentIndex==2)
    {
        appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        appDelegate.delegateForCurrentViewController=self;
        isRequestForGettingsPastOrders = NO;

        isRequestForGettingsOrders=YES;
        isRequestForPeople=NO;
        isRequestForOrder=NO;
       
        tblView.hidden=YES;
        isSelectedForPastOrders = NO;
        isSelectedForDrinks=NO;
        isSelectedForPeople=NO;
        
        [arrBundledOrders removeAllObjects];
        [arrBundledOrders addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"Orders"]];
        
        int intOrdersCount=0;
        for (NSArray *arrOrder in arrBundledOrders)
        {
            intOrdersCount+=[arrOrder count];
        }
        
        NSString *strOrder=[NSString stringWithFormat:@"Orders (%i)",intOrdersCount];
        
        [segmentControl setTitle:strOrder forSegmentAtIndex:2];
        

        
        //[tblView reloadData];
        
        self.sharedController=[SharedController sharedController];
        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController getUserOrdersWithBartsyId:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] delegate:self];
    }else if(segmentControl.selectedSegmentIndex==3)
    {
        tblView.hidden=NO;
        isRequestForGettingsOrders=NO;
        isRequestForPeople=NO;
        isRequestForOrder=NO;
        isRequestForGettingsPastOrders = YES;
        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        self.sharedController=[SharedController sharedController];
        [self.sharedController getPastOrderWithVenueWithId:[NSString stringWithFormat:@"%@",[dictVenue objectForKey:@"venueId"]] bartsyId:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] date:nil delegate:self];
        
    }

}

-(void)btnOrder_TouchUpInside:(UIButton*)sender
{
    if (sender.tag==1115) {
  //Showing glass image (Indicating order in list)
        UIView *popupView=(UIView*)[self.view viewWithTag:2221];
        popupView.hidden=YES;
        UIButton *checkinBtn=(UIButton*)[self.view viewWithTag:3334];
        checkinBtn.hidden=YES;
        
        UIButton *drinkBtn=(UIButton*)[self.view viewWithTag:1117];
        if (!drinkBtn) {
            UIButton *drinkBtn=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"drink"] frame:CGRectMake(280, 8, 30, 30) tag:1117 selector:@selector(btnOrder_TouchUpInside:) target:self];
            [self.view addSubview:drinkBtn];
            
        }
        
    }else if (sender.tag==1116){
   
    // Saving the order
        NSMutableArray *arrMultiItems=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"multiitemorders"]];
        
        isRequestForOrder=YES;
        self.sharedController=[SharedController sharedController];
        //NSLog(@":%@",dictPeopleSelectedForDrink);
            
        NSMutableArray *arritemlist=[[NSMutableArray alloc]init];
        for (NSDictionary *dicttemp in arrMultiItems)
        {
            
            if ([[dicttemp valueForKey:@"Viewtype"] integerValue]==2) {
                NSArray *arr1Temp=[dicttemp valueForKey:@"ArrayInfo"];
                NSMutableDictionary *dictitem=[[NSMutableDictionary alloc]init];
                NSMutableArray *arrOptionGroup=[[NSMutableArray alloc]init];
               
                for (int i=0; i<arr1Temp.count; i++) {
                    NSDictionary *dict1Temp=[arr1Temp objectAtIndex:i];

                    if ([dict1Temp valueForKey:@"option_groups"]) {
                        
                        NSArray *arroptionsgrp=[dict1Temp valueForKey:@"option_groups"];
                      
                            NSMutableDictionary *dictOptionItems=[[NSMutableDictionary alloc]init];
                            NSMutableArray *arrOptions=[[NSMutableArray alloc]init];
                            NSArray *arroptionTemp=[arroptionsgrp valueForKey:@"options"];
                             for (int k=0; k<arroptionTemp.count; k++) {
                                 NSDictionary *dict3Temp=[arroptionTemp objectAtIndex:k];
                                 NSMutableDictionary *dictsubItems=[[NSMutableDictionary alloc]init];
                                 [dictsubItems setObject:[dict3Temp valueForKey:@"name"] forKey:@"name"];
                                 [dictsubItems setObject:[dict3Temp valueForKey:@"price"] forKey:@"price"];
                                 if ([[dict3Temp valueForKey:@"selected"] integerValue]==1 && [dict3Temp valueForKey:@"selected"]) {
                                     [dictsubItems setObject:@"true" forKey:@"selected"];

                                 }else{
                                     //[dictsubItems setObject:@"false" forKey:@"selected"];

                                 }
                                 
                                 [arrOptions addObject:dictsubItems];
                                 [dictsubItems release];
                                
                             }
                            [dictOptionItems setObject:[arroptionsgrp valueForKey:@"type"] forKey:@"type"];
                            [dictOptionItems setObject:[arroptionsgrp valueForKey:@"text"] forKey:@"text"];
                            [dictOptionItems setObject:arrOptions forKey:@"options"];
                        [arrOptionGroup addObject:dictOptionItems];
                    }else{
                            NSMutableDictionary *dictOptionItems=[[NSMutableDictionary alloc]init];
                            NSMutableArray *arrOptions=[[NSMutableArray alloc]init];
                            NSArray *arroptionTemp=[dict1Temp valueForKey:@"options"];
                            for (int k=0; k<arroptionTemp.count; k++) {
                                NSDictionary *dict3Temp=[arroptionTemp objectAtIndex:k];
                                NSMutableDictionary *dictsubItems=[[NSMutableDictionary alloc]init];
                                [dictsubItems setObject:[dict3Temp valueForKey:@"name"] forKey:@"name"];
                                if ([dict3Temp valueForKey:@"price"]) {
                                    [dictsubItems setObject:[dict3Temp valueForKey:@"price"] forKey:@"price"];

                                }else{
                                    [dictsubItems setObject:@"0" forKey:@"price"];
                                }
                                if ([[dict3Temp valueForKey:@"selected"] integerValue]==1 && [dict3Temp valueForKey:@"selected"]) {
                                    [dictsubItems setObject:@"true" forKey:@"selected"];
                                    
                                }else{
                                   // [dictsubItems setObject:@"false" forKey:@"selected"];
                                    
                                }
                                
                                [arrOptions addObject:dictsubItems];
                                [dictsubItems release];
                                
                            }
                            [dictOptionItems setObject:[dict1Temp valueForKey:@"type"] forKey:@"type"];
                            [dictOptionItems setObject:[dict1Temp valueForKey:@"text"] forKey:@"text"];
                            [dictOptionItems setObject:arrOptions forKey:@"options"];
                            [arrOptionGroup addObject:dictOptionItems];
                    }
                       
                }
                [dictitem setObject:arrOptionGroup forKey:@"option_groups"];
                [dictitem setObject:[dicttemp valueForKey:@"name"] forKey:@"title"];
                [dictitem setObject:[dicttemp valueForKey:@"name"] forKey:@"itemName"];
                [dictitem setObject:[dicttemp valueForKey:@"name"] forKey:@"name"];
                [dictitem setObject:[dicttemp valueForKey:@"type"] forKey:@"type"];
                [dictitem setObject:[dicttemp valueForKey:@"price"] forKey:@"order_price"];
                if ([dicttemp valueForKey:@"price"]) {
                    [dictitem setObject:[dicttemp valueForKey:@"price"] forKey:@"price"];
                    
                }else{
                    [dictitem setObject:@"0" forKey:@"price"];
                    
                }
                [dictitem setObject:[dicttemp valueForKey:@"options_description"] forKey:@"options_description"];
                if ([dicttemp valueForKey:@"special_Instructions"]) {
                    [dictitem setObject:[dicttemp valueForKey:@"special_Instructions"] forKey:@"special_Instructions"];
                }
                [arritemlist addObject:dictitem];
               

            } else if([[dicttemp valueForKey:@"Viewtype"] integerValue]==3){
                NSArray *arr1Temp=[dicttemp valueForKey:@"ArrayInfo"];
                NSMutableDictionary *dictitem=[[NSMutableDictionary alloc]init];
                NSMutableArray *arrOptionGroup=[[NSMutableArray alloc]init];
                
                for (int i=0; i<arr1Temp.count; i++) {
                    NSDictionary *dict1Temp=[arr1Temp objectAtIndex:i];
                    if (i==0) {
                        
                        [dictitem setObject:[dict1Temp valueForKey:@"instructions"] forKey:@"instructions"];
                        [dictitem setObject:[dict1Temp valueForKey:@"category"] forKey:@"category"];

                        [dictitem setObject:[dict1Temp valueForKey:@"ingredients"] forKey:@"ingredients"];
                    }
                    NSMutableDictionary *dictOptionItems=[[NSMutableDictionary alloc]init];
                        NSMutableArray *arrOptions=[[NSMutableArray alloc]init];
                        NSArray *arroptionTemp=[dict1Temp valueForKey:@"options"];
                        for (int k=0; k<arroptionTemp.count; k++) {
                            NSDictionary *dict3Temp=[arroptionTemp objectAtIndex:k];
                            NSMutableDictionary *dictsubItems=[[NSMutableDictionary alloc]init];
                            
                            [dictsubItems setObject:[dict3Temp valueForKey:@"name"] forKey:@"name"];
                            if ([dict3Temp valueForKey:@"price"]) {
                                [dictsubItems setObject:[dict3Temp valueForKey:@"price"] forKey:@"price"];
                                
                            }else{
                                [dictsubItems setObject:@"0" forKey:@"price"];
                            }
                            if ([[dict3Temp valueForKey:@"selected"] integerValue]==1 && [dict3Temp valueForKey:@"selected"]) {
                                [dictsubItems setObject:@"true" forKey:@"selected"];
                                
                            }else{
                                //[dictsubItems setObject:@"false" forKey:@"selected"];
                                
                            }
                            
                            [arrOptions addObject:dictsubItems];
                            [dictsubItems release];
                            
                        }
                      
                        [dictOptionItems setObject:[dict1Temp valueForKey:@"type"] forKey:@"type"];
                        [dictOptionItems setObject:[dict1Temp valueForKey:@"text"] forKey:@"text"];
                        [dictOptionItems setObject:arrOptions forKey:@"options"];
                        [arrOptionGroup addObject:dictOptionItems];
                    }
                    
                [dictitem setObject:arrOptionGroup forKey:@"option_groups"];
                [dictitem setObject:[dicttemp valueForKey:@"price"] forKey:@"order_price"];
                [dictitem setObject:[dicttemp valueForKey:@"name"] forKey:@"itemName"];
                [dictitem setObject:[dicttemp valueForKey:@"name"] forKey:@"title"];
                [dictitem setObject:[dicttemp valueForKey:@"name"] forKey:@"name"];
                 [dictitem setObject:[dicttemp valueForKey:@"type"] forKey:@"type"];
                if ([dicttemp valueForKey:@"price"]) {
                    [dictitem setObject:[dicttemp valueForKey:@"price"] forKey:@"price"];
                    
                }else{
                    [dictitem setObject:@"0" forKey:@"price"];
                    
                }
                [dictitem setObject:[dicttemp valueForKey:@"options_description"] forKey:@"options_description"];
                if ([dicttemp valueForKey:@"special_Instructions"]) {
                   [dictitem setObject:[dicttemp valueForKey:@"special_Instructions"] forKey:@"special_Instructions"];
                }
                if ([dicttemp valueForKey:@"description"]) {
                    [dictitem setObject:[dicttemp valueForKey:@"description"] forKey:@"description"]; 
                }
                [arritemlist addObject:dictitem];
                
            }else if([[dicttemp valueForKey:@"Viewtype"] integerValue]==4 ||[[dicttemp valueForKey:@"Viewtype"] integerValue]==5){
                NSArray *arr1Temp=[dicttemp valueForKey:@"ArrayInfo"];
                NSMutableDictionary *dictitem=[[NSMutableDictionary alloc]init];
                NSMutableArray *arrOptionGroup=[[NSMutableArray alloc]init];
                
                for (int i=0; i<arr1Temp.count; i++) {
                    NSDictionary *dict1Temp=[arr1Temp objectAtIndex:i];
                    
                    NSMutableDictionary *dictOptionItems=[[NSMutableDictionary alloc]init];
                    NSMutableArray *arrOptions=[[NSMutableArray alloc]init];
                    NSArray *arroptionTemp=[dict1Temp valueForKey:@"options"];
                    for (int k=0; k<arroptionTemp.count; k++) {
                        NSDictionary *dict3Temp=[arroptionTemp objectAtIndex:k];
                        NSMutableDictionary *dictsubItems=[[NSMutableDictionary alloc]init];
                        
                        [dictsubItems setObject:[dict3Temp valueForKey:@"name"] forKey:@"name"];
                        if ([dict3Temp valueForKey:@"price"]) {
                            [dictsubItems setObject:[dict3Temp valueForKey:@"price"] forKey:@"price"];
                            
                        }else{
                            [dictsubItems setObject:@"0" forKey:@"price"];
                        }
                        if ([[dict3Temp valueForKey:@"selected"] integerValue]==1 && [dict3Temp valueForKey:@"selected"]) {
                            [dictsubItems setObject:@"true" forKey:@"selected"];
                            
                        }else{
                           // [dictsubItems setObject:@"false" forKey:@"selected"];
                        }
                        
                        [arrOptions addObject:dictsubItems];
                        [dictsubItems release];
                    }

                    [dictOptionItems setObject:[dict1Temp valueForKey:@"type"] forKey:@"type"];
                    [dictOptionItems setObject:[dict1Temp valueForKey:@"text"] forKey:@"text"];
                    [dictOptionItems setObject:arrOptions forKey:@"options"];
                    [arrOptionGroup addObject:dictOptionItems];
                }
                [dictitem setObject:arrOptionGroup forKey:@"option_groups"];
                [dictitem setObject:[dicttemp valueForKey:@"price"] forKey:@"order_price"];
                [dictitem setObject:[dicttemp valueForKey:@"name"] forKey:@"itemName"];
                [dictitem setObject:[dicttemp valueForKey:@"name"] forKey:@"title"];
                [dictitem setObject:[dicttemp valueForKey:@"name"] forKey:@"name"];
                [dictitem setObject:[dicttemp valueForKey:@"type"] forKey:@"type"];
                if ([dicttemp valueForKey:@"price"]) {
                    [dictitem setObject:[dicttemp valueForKey:@"price"] forKey:@"price"];
                    
                }else{
                    [dictitem setObject:@"0" forKey:@"price"];
                    
                }
                [dictitem setObject:[dicttemp valueForKey:@"type"] forKey:@"type"];
                [dictitem setObject:[dicttemp valueForKey:@"options_description"] forKey:@"options_description"];
                if ([dicttemp valueForKey:@"special_Instructions"]) {
                    [dictitem setObject:[dicttemp valueForKey:@"special_Instructions"] forKey:@"special_Instructions"];
                }
                [arritemlist addObject:dictitem];

            }else{
                if (![dicttemp valueForKey:@"price"]) {
                    
                    [self createAlertViewWithTitle:@"" message:@"Please, select the item with the price." cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
                    return;
                }
                NSMutableDictionary *dictitem=[[NSMutableDictionary alloc]init];
                NSArray *tempArray=[[NSArray alloc]init];
            
                [dictitem setObject:[dicttemp valueForKey:@"name"] forKey:@"title"];
                [dictitem setObject:[dicttemp valueForKey:@"name"] forKey:@"itemName"];
                if ([dicttemp valueForKey:@"description"]) {
                    [dictitem setObject:[dicttemp valueForKey:@"description"] forKey:@"description"];

                }else{
                    [dictitem setObject:@"" forKey:@"description"];

                }
                [dictitem setObject:@"1" forKey:@"quantity"];
                [dictitem setObject:[dicttemp valueForKey:@"price"] forKey:@"price"];
                [dictitem setObject:[dicttemp valueForKey:@"price"] forKey:@"order_price"];

                [dictitem setObject:tempArray forKey:@"option_groups"];
                if ([dicttemp valueForKey:@"id"]) {
                    [dictitem setObject:[NSString stringWithFormat:@"%@",[dicttemp valueForKey:@"id"]] forKey:@"itemId"];
                }else{
                    [dictitem setObject:@"" forKey:@"itemId"];
                    
                }
                if ([dicttemp valueForKey:@"category"]) {
                    [dictitem setObject:[dicttemp valueForKey:@"category"] forKey:@"category"];
                }
                if ([dicttemp valueForKey:@"ingredients"]) {
                     [dictitem setObject:[dicttemp valueForKey:@"ingredients"] forKey:@"ingredients"];
                }
                if ([dicttemp valueForKey:@"instructions"]) {
                    [dictitem setObject:[dicttemp valueForKey:@"instructions"] forKey:@"instructions"];
                }
                if ([dicttemp valueForKey:@"type"]) {
                    [dictitem setObject:[dicttemp valueForKey:@"type"] forKey:@"type"];
                }
                if ([dicttemp valueForKey:@"special_Instructions"]) {
                    [dictitem setObject:[dicttemp valueForKey:@"special_Instructions"] forKey:@"special_Instructions"];
                }
                [arritemlist addObject:dictitem];
                [dictitem release];
                [tempArray release];
            }
        }
        // NSLog(@"%@",arritemlist);
        float taxPrice=[[NSUserDefaults standardUserDefaults] floatForKey:@"percentTAX"];
        float floatTotalTax=(ttlPrice*((float)taxPrice/100));

        float tiptotal=(ttlPrice*((float)btnValue/100));
        NSString *totalprice=[NSString stringWithFormat:@"%.2f",tiptotal+floatTotalTax+ttlPrice];
        
        NSString *strReseverID=[NSString stringWithFormat:@"%@",[dictPeopleSelectedForDrink objectForKey:@"bartsyId"]];
        NSString *strSenderID=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]];
        if([strReseverID isEqualToString:strSenderID ] )
        {
            [self createProgressViewToParentView:self.view withTitle:@"Sending Order details to Bartender..."];
        }
        else
        {
            NSString *strMsg=[NSString stringWithFormat:@"Sending Order details to %@...",[dictPeopleSelectedForDrink objectForKey:@"nickName"]];
            [self createProgressViewToParentView:self.view withTitle:strMsg];
        }

        
        [self.sharedController SaveOrderWithOrderStatus:@"0" basePrice:[NSString stringWithFormat:@"%.2f",ttlPrice] totalPrice:totalprice tipPercentage:[NSString stringWithFormat:@"%.2f",tiptotal] itemName:@"" splcomments:@"" description:@"" itemlist:arritemlist receiverBartsyId:[dictPeopleSelectedForDrink valueForKey:@"bartsyId"] delegate:self];
        
        dictPeopleSelectedForDrink=nil;

        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"multiitemorders"];
        UIView *Backgroundview=(UIView*)[self.view viewWithTag:2221];
        [Backgroundview removeFromSuperview];
        
        UIButton *drinkBtn=(UIButton*)[self.view viewWithTag:1117];
        [drinkBtn removeFromSuperview];
        UIButton *checkinBtn=(UIButton*)[self.view viewWithTag:3334];
        //[checkinBtn setImage:[UIImage imageNamed:@"tickmark_select"] forState:UIControlStateNormal];
        checkinBtn.hidden=NO;
        UILabel *lblcheckout=(UILabel*)[checkinBtn viewWithTag:9996];
        lblcheckout.text=@"Check out:";
        UIImageView *imgcheckin=(UIImageView*)[checkinBtn viewWithTag:9995];
        imgcheckin.image=[UIImage imageNamed:@"tickmark_select"];
        imgcheckin.hidden=NO;
    }
    else if(sender.tag==1117){
        
        UIButton *drinkBtn=(UIButton*)[self.view viewWithTag:1117];
        [drinkBtn removeFromSuperview];
        UIButton *checkinBtn=(UIButton*)[self.view viewWithTag:3334];
        //[checkinBtn setImage:[UIImage imageNamed:@"tickmark_select"] forState:UIControlStateNormal];
        checkinBtn.hidden=NO;
        UIImageView *imgcheckin=(UIImageView*)[checkinBtn viewWithTag:9995];
        imgcheckin.image=[UIImage imageNamed:@"tickmark_select"];
        imgcheckin.hidden=NO;
        UILabel *lblcheckout=(UILabel*)[checkinBtn viewWithTag:9996];
        lblcheckout.text=@"Check out:";
        UIView *popupView=(UIView*)[self.view viewWithTag:2221];
        popupView.hidden=NO;

        
    }else{
    
    //[self orderTheDrink];
    UIView *viewA = (UIView*)[self.view viewWithTag:222];
    [viewA removeFromSuperview];
    isRequestForOrder=YES;
    self.sharedController=[SharedController sharedController];
    if([dictPeopleSelectedForDrink count]==0||[[dictPeopleSelectedForDrink objectForKey:@"bartsyId"] isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]])
    {
        [self createProgressViewToParentView:self.view withTitle:@"Sending Order details to Bartender..."];
    }
    else
    {
        NSString *strMsg=[NSString stringWithFormat:@"Sending Order details to %@...",[dictPeopleSelectedForDrink objectForKey:@"nickName"]];
        [self createProgressViewToParentView:self.view withTitle:strMsg];
    }
    NSString *strBasePrice=[NSString stringWithFormat:@"%f",[[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]];
    
    NSString *strTip;
    if(btnValue!=40)
        strTip=[NSString stringWithFormat:@"%i",btnValue];
    else
    {
        UITextField *txtFld=(UITextField*)[self.view viewWithTag:500];
        strTip=[NSString stringWithFormat:@"%i",[txtFld.text integerValue]];
    }
    
    //Tax on item
    float subTotal=([[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]*(([strTip floatValue]+[[NSUserDefaults standardUserDefaults] floatForKey:@"percentTAX"])))/100;
    
    float totalPrice=[[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]+subTotal;
    
    //Tip on item
    float tipTotal = ([[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]*[strTip floatValue])/100;
    
    NSString *strTipTotal=[NSString stringWithFormat:@"%.2f",tipTotal];
    
    NSLog(@"Tip is %@",strTipTotal);
    
    NSString *strTotalPrice1=[NSString stringWithFormat:@"%.2f",totalPrice];
    
    
    NSString *strBartsyId;
    if([dictPeopleSelectedForDrink count])
       strBartsyId=[NSString stringWithFormat:@"%@",[dictPeopleSelectedForDrink objectForKey:@"bartsyId"]];
    else
    strBartsyId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]];
    
    [self.sharedController createOrderWithOrderStatus:@"New" basePrice:strBasePrice totalPrice:strTotalPrice1 tipPercentage:strTipTotal itemName:[dictSelectedToMakeOrder objectForKey:@"name"] produceId:[dictSelectedToMakeOrder objectForKey:@"id"] description:[dictSelectedToMakeOrder objectForKey:@"description"] receiverBartsyId:strBartsyId delegate:self];
    
    dictPeopleSelectedForDrink=nil;
    }
}


-(void)btnTip_TouchUpInside:(id)sender
{
    
    UIView *popview=(UIView*)[self.view viewWithTag:2221];
    UIButton *btn=(UIButton*)[popview viewWithTag:btnValue];
    //[btn setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
    [btn setSelected:NO];
    btnValue=[sender tag];
     float tiptotal=(ttlPrice*((float)btnValue/100));
    UILabel *lblTipprice=(UILabel*)[popview viewWithTag:4446];
    lblTipprice.text=[NSString stringWithFormat:@"+ %.2f",tiptotal];
    
    UILabel *lbltaxprice=(UILabel*)[popview viewWithTag:4447];

    UILabel *lblttlprice=(UILabel*)[popview viewWithTag:4448];
lblttlprice.text=[NSString stringWithFormat:@"+ %.2f",tiptotal+[lbltaxprice.text floatValue]+ttlPrice];
    //[sender setBackgroundImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
    [sender setSelected:YES];
}

-(void)btnCancel_TouchUpInside
{
    dictPeopleSelectedForDrink=nil;
    UIView *viewA = (UIView*)[self.view viewWithTag:222];
    [viewA removeFromSuperview];
}

/*
 - (void)openPaymentRequestFailed:(ZooZPaymentRequest *)request withErrorCode:(int)errorCode andErrorMessage:(NSString *)errorMessage{
 NSLog(@"failed: %@", errorMessage);
 //this is a network / integration failure, not a payment processing failure.
 
 }
 
 //Called in the background thread - before user closes the payment dialog
 //Do not refresh UI at this callback - see paymentSuccessDialogClosed
 - (void)paymentSuccessWithResponse:(ZooZPaymentResponse *)response
 {
 NSLog(@"payment success with payment Id: %@, %@, %@, %f %@", response.transactionDisplayID, response.fundSourceType, response.lastFourDigits, response.paidAmount, response.transactionID);
 [self btnOrder_TouchUpInside];
 }
 
 //called after successful payment and after the user closed the payment dialog
 //Do the UI changes on success at this point
 -(void)paymentSuccessDialogClosed{
 NSLog(@"Payment dialog closed after success");
 //see paymentSuccessWithResponse: for the response transaction ID.
 }
 
 - (void)paymentCanceled{
 NSLog(@"payment cancelled");
 //dialog closed without payment completed
 }
 */

-(void)controllerDidFinishLoadingWithResult:(id)result
{
   
    if([[result objectForKey:@"errorCode"] integerValue]!=0)
    {
         [self hideProgressView:nil];
        if ([[result objectForKey:@"errorMessage"] isKindOfClass:[NSNull class]])
        [self createAlertViewWithTitle:@"Error" message:@"Oops! Server failed to return" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
        else{
            if (!isGetFavorites && !isGettingCocktails && !isGettingIngradients && !isLocuMenu) {
                [self createAlertViewWithTitle:@"" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
            }
        }
        
        
        if (isRequestForOrder==NO&&isRequestForPeople==NO&&isRequestForGettingsOrders==NO&&isRequestForGettingsPastOrders == NO && isGettingIngradients==NO && isRequestCheckin==NO && isGettingCocktails==NO && isUserCheckOut==NO && isGetFavorites==NO && isLocuMenu==YES) {
            
            isGettingIngradients=YES;
            //[self createProgressViewToParentView:self.view withTitle:@"Loading..."];
            [self.sharedController getIngredientsListWithVenueId:[dictVenue objectForKey:@"venueId"] delegate:self];
        }else if (isGettingIngradients){
           
            isGettingIngradients=NO;
            isSelectedForDrinks=YES;
            isSelectedForPastOrders=NO;
            isSelectedForPeople=NO;
            
            isGettingCocktails=YES;
            //[self createProgressViewToParentView:self.view withTitle:@"Loading..."];
            [self.sharedController getCocktailsbyvenueID:[dictVenue objectForKey:@"venueId"] delegate:self];
        }else if (isGettingCocktails){
            
            isGettingCocktails=NO;
            //isSelectedForDrinks=YES;
            isSelectedForPastOrders=NO;
            isSelectedForPeople=NO;

            isGetFavorites=YES;
            //[self createProgressViewToParentView:self.view withTitle:@"Loading..."];
            [self.sharedController getFavoriteDrinksbybartsyID:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] venueID:[dictVenue objectForKey:@"venueId"] delegate:self];
        }else if (isGetFavorites){
            
            isGetFavorites=NO;
            isGettingCocktails=NO;
            isSelectedForDrinks=YES;
            isSelectedForPastOrders=NO;
            isSelectedForPeople=NO;
            
            UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
            [tblView reloadData];
        }

    }
    else if(isRequestForOrder==NO&&isRequestForPeople==NO&&isRequestForGettingsOrders==NO&&isRequestForGettingsPastOrders == NO && isGettingIngradients==NO && isRequestCheckin==NO && isGettingCocktails==NO && isUserCheckOut==NO && isGetFavorites==NO && isLocuMenu==YES)
    {
        isLocuMenu=NO;
        [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"LocuMenu"];
            //[[NSUserDefaults standardUserDefaults]synchronize];
          //  [arrMenu addObjectsFromArray:result];
          //  [self hideProgressView:nil];
            [self modifyData];

        isGettingIngradients=YES;
        //[self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController getIngredientsListWithVenueId:[dictVenue objectForKey:@"venueId"] delegate:self];
        
        
    }
    else if(isRequestForOrder==YES)
    {
        [self hideProgressView:nil];
        isRequestForOrder=NO;
        
//        UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
//        segmentControl.selectedSegmentIndex=2;
//        [self segmentControl_ValueChanged:segmentControl];
        
        UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
        NSString *strOrder=[NSString stringWithFormat:@"Orders (%i)",[[result objectForKey:@"orderCount"] integerValue]];
        appDelegate.intOrderCount=[[result objectForKey:@"orderCount"] integerValue];
        [segmentControl setTitle:strOrder forSegmentAtIndex:2];
        [appDelegate startTimerToCheckOrderStatusUpdate];
        
        NSMutableArray *arrPlacedOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"PlacedOrders"]];
        NSMutableDictionary *dictOrderPlaced=[[NSMutableDictionary alloc]initWithDictionary:dictSelectedToMakeOrder];
        [dictOrderPlaced setValue:[result objectForKey:@"orderId"] forKey:@"orderId"];
        [dictOrderPlaced setValue:[result objectForKey:@"orderStatus"] forKey:@"orderStatus"];
        [dictOrderPlaced setValue:[result objectForKey:@"orderTimeout"] forKey:@"orderTimeout"];
        [dictOrderPlaced setValue:[NSNumber numberWithInteger:btnValue] forKey:@"tipPercentage"];
        
        NSDate* date = [NSDate date];

         [dictOrderPlaced setValue:date forKey:@"Time"];
       
        NSLog(@"Order is %@",dictOrderPlaced);
        
        [arrPlacedOrders addObject:dictOrderPlaced];
        [[NSUserDefaults standardUserDefaults]setObject:arrPlacedOrders forKey:@"PlacedOrders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [arrPlacedOrders release];
        
        [self createAlertViewWithTitle:nil message:@"Your order was sent" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
    }
    else if(isRequestForPeople==YES)
    {
        [self hideProgressView:nil];
        NSLog(@"people result %@",result);
        SDImageCache *sharedSDImageCache=[SDImageCache sharedImageCache];
        [sharedSDImageCache clearMemory];
        [sharedSDImageCache clearDisk];
        [sharedSDImageCache cleanDisk];
        
        isSelectedForDrinks=NO;
        isSelectedForPeople=YES;
        [arrPeople removeAllObjects];
        NSArray *arrNewhasmsglist=[result objectForKey:@"checkedInUsers"];
        //[arrPeople addObjectsFromArray:[result objectForKey:@"checkedInUsers"]];
        
        NSArray *newfilterarr=[arrNewhasmsglist filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(hasMessages == %@)",@"New"]];
        [arrPeople addObjectsFromArray:newfilterarr];
        NSArray *oldfilterarr=[arrNewhasmsglist filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(hasMessages == %@)",@"Old"]];
        [arrPeople addObjectsFromArray:oldfilterarr];
        NSArray *nonefilterarr=[arrNewhasmsglist filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(hasMessages == %@)",@"None"]];
        [arrPeople addObjectsFromArray:nonefilterarr];
        
        [appDelegate.arrPeople removeAllObjects];
        [appDelegate.arrPeople addObjectsFromArray:arrPeople];
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        [tblView reloadData];
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reloadTable) userInfo:nil repeats:NO];
        
        UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
        NSString *strOrder=[NSString stringWithFormat:@"People (%i)",[arrPeople count]];
        
        [segmentControl setTitle:strOrder forSegmentAtIndex:1];
    }
    else if (isRequestForGettingsPastOrders == YES)
    {
        [self hideProgressView:nil];
        isRequestForGettingsPastOrders=NO;
        isSelectedForPastOrders = YES;
        isSelectedForDrinks=NO;
        isSelectedForPeople=NO;
        [arrPastOrders removeAllObjects];
        [arrPastOrders addObjectsFromArray:[result objectForKey:@"pastOrders"]];
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderStatus == [c]'1' OR orderStatus == [c]'4' OR orderStatus == [c]'5' OR orderStatus == [c]'6' OR orderStatus == [c]'7' OR orderStatus == [c]'8'"];
        //[arrPastOrders filterUsingPredicate:predicate];
        
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        [tblView reloadData];

    }
    else if(isRequestForGettingsOrders==YES)
    {
         [self hideProgressView:nil];
        SDImageCache *sharedSDImageCache=[SDImageCache sharedImageCache];
        [sharedSDImageCache clearMemory];
        [sharedSDImageCache clearDisk];
        [sharedSDImageCache cleanDisk];
        
        [arrOrders removeAllObjects];
        [appDelegate.arrOrders removeAllObjects];
        [appDelegate.arrOrders addObjectsFromArray:[result objectForKey:@"orders"]];
        NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:[result objectForKey:@"orders"]];
        
        for (int i=0;i<[arrTemp count];i++)
        {
            NSMutableDictionary *dictOrder=[[NSMutableDictionary alloc] initWithDictionary:[arrTemp objectAtIndex:i]];
            //if(![[dictOrder objectForKey:@"orderStatus"] isEqualToString:@"5"])
            //{
                NSDateFormatter *dateFormatter = [NSDateFormatter new];
                dateFormatter.dateFormat       = @"dd MM yyyy HH:mm:ss zzz";
                NSDate *date    = [dateFormatter dateFromString:[dictOrder objectForKey:@"orderTime"]];
                [dictOrder setObject:date forKey:@"Date"];
                [arrOrders addObject:dictOrder];
            //}
            [dictOrder release];
        }
        
        [arrTemp release];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Date" ascending:NO];
        [arrOrders sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        [arrBundledOrders removeAllObjects];
        //[arrBundledOrders addObjectsFromArray:arrOrders];
        NSMutableArray *arrTemp1=[[NSMutableArray alloc]initWithArray:arrOrders]; //Array for Loop
        NSMutableArray *arrTemp2=[[NSMutableArray alloc]initWithArray:arrOrders]; //Array to remove the added orders to bundled array
        
        //Without Bundling
        for (int i=0; i<[arrTemp1 count]; i++)
        {
            NSArray *arrayOrder=[[NSArray alloc] initWithObjects:[arrTemp1 objectAtIndex:i], nil];
            [arrBundledOrders addObject:arrayOrder];
            [arrayOrder release];
        }
        
        /*
         //Loop for bundling with same status and same bartsyId
        for (int i=0; i<[arrTemp1 count]; i++)
        {
            //Array to sort for a particular order status
            NSMutableArray *arrTemp3=[[NSMutableArray alloc]initWithArray:arrOrders];
            NSDictionary *dictOrder=[arrTemp1 objectAtIndex:i];
                    
            //Checking weather the order is there in arrTemp2 or not
            if([arrTemp2 indexOfObject:dictOrder]!= NSNotFound)
            {
                NSString *strBartsyId=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]]];
                NSString *strSenderBartsyId=[NSString stringWithFormat:@"'%@'",[NSNumber numberWithDouble:[[dictOrder objectForKey:@"senderBartsyId"] doubleValue]]];
                NSString *strRecieverBartsyId=[NSString stringWithFormat:@"'%@'",[NSNumber numberWithDouble:[[dictOrder objectForKey:@"recieverBartsyId"] doubleValue]]];

                //Checking weather order is ordered for self and bundling the self orders with same status
                if([[dictOrder objectForKey:@"senderBartsyId"]doubleValue]==[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]&&[[dictOrder objectForKey:@"recieverBartsyId"]doubleValue]==[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue])
                {
                    NSPredicate *pred1=[NSPredicate predicateWithFormat:[self getPredicateWithOrderStatus:[[dictOrder objectForKey:@"orderStatus"] integerValue]]];
                    NSPredicate *pred2=[NSPredicate predicateWithFormat:@"senderBartsyId==[c]%@",strBartsyId];
                    NSPredicate *pred3=[NSPredicate predicateWithFormat:@"recieverBartsyId==[c]%@",strBartsyId];
                    
                    NSPredicate *predCompound=[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:pred1,pred2,pred3, nil]];

                    [arrTemp3 filterUsingPredicate:predCompound];
                    
                    if([arrTemp3 count])
                    {
                        [arrBundledOrders addObject:arrTemp3];
                        [arrTemp2 removeObjectsInArray:arrTemp3];
                    }
                }
                //Checking weather order is ordered to others and bundling those orders with same status
                else if([[dictOrder objectForKey:@"senderBartsyId"]doubleValue]==[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]&&[[dictOrder objectForKey:@"recieverBartsyId"]doubleValue]!=[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue])
                {
                    NSPredicate *pred1=[NSPredicate predicateWithFormat:[self getPredicateWithOrderStatus:[[dictOrder objectForKey:@"orderStatus"] integerValue]]];
                    NSPredicate *pred2=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"senderBartsyId == [c]'%@'",strBartsyId]];
                    NSPredicate *pred3=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"recieverBartsyId == [c]%@",strRecieverBartsyId]];
                    NSPredicate *predCompound=[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:pred1,pred2,pred3, nil]];
                    
                    [arrTemp3 filterUsingPredicate:predCompound];
                    
                    if([arrTemp3 count])
                    {
                        [arrBundledOrders addObject:arrTemp3];
                        [arrTemp2 removeObjectsInArray:arrTemp3];
                    }
                }
                //Checking weather order is offered to me by others and bundling those orders with same status
                else if([[dictOrder objectForKey:@"senderBartsyId"]doubleValue]!=[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]&&[[dictOrder objectForKey:@"recieverBartsyId"]doubleValue]==[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue])
                {
                    NSPredicate *pred1=[NSPredicate predicateWithFormat:[self getPredicateWithOrderStatus:[[dictOrder objectForKey:@"orderStatus"] integerValue]]];
                    NSPredicate *pred2=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"senderBartsyId == [c]%@",strSenderBartsyId]];
                    NSPredicate *pred3=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"recieverBartsyId == [c]'%@'",strBartsyId]];
                    NSPredicate *predCompound=[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:pred1,pred2,pred3, nil]];
                    
                    [arrTemp3 filterUsingPredicate:predCompound];
                    
                    if([arrTemp3 count])
                    {
                        [arrBundledOrders addObject:arrTemp3];
                        [arrTemp2 removeObjectsInArray:arrTemp3];
                    }
                }
            }
            
            [arrTemp3 release];
        }
        */
        NSLog(@"Orders %@",arrBundledOrders);

        [[NSUserDefaults standardUserDefaults]setObject:arrBundledOrders forKey:@"Orders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if([arrOrders count])
            [appDelegate startTimerToCheckOrderStatusUpdate];
        else
            [appDelegate stopTimerForOrderStatusUpdate];
        
        //UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        //[tblView reloadData];
        
        [self loadOrdersView];
        
        UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
        NSString *strOrder=[NSString stringWithFormat:@"Orders (%i)",[arrOrders count]];
        [segmentControl setTitle:strOrder forSegmentAtIndex:2];
        appDelegate.intOrderCount=[arrOrders count];
        
    }else if (isGettingIngradients==YES){
        
        isGettingIngradients=NO;
        isSelectedForDrinks=YES;
        isSelectedForPastOrders=NO;
        isSelectedForPeople=NO;
        if([[result objectForKey:@"errorCode"] integerValue]==1)
        {
            //[self createAlertViewWithTitle:@"Error" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
        }
        else
        {
            [arrCustomDrinks removeAllObjects];
            [self ParsinggetIngredients:result];
            dictMainCustomDrinks=[[NSDictionary alloc ]initWithDictionary:result];

        }

        //UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        //[tblView reloadData];
        isGettingCocktails=YES;
        //[self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController getCocktailsbyvenueID:[dictVenue objectForKey:@"venueId"] delegate:self];
    }else if (isRequestCheckin){
         [self hideProgressView:nil];
        if([[result objectForKey:@"errorCode"] integerValue]==1)
        {
            [self createAlertViewWithTitle:@"Error" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"multiitemorders"];
            //home-footer
            UIImageView *homecheckimg=[[UIImageView alloc]initWithFrame:CGRectMake(40,10,21, 21)];
            homecheckimg.image=[UIImage imageNamed:@"home-footer"];
            homecheckimg.tag=5555;
            [self.tabBarController.tabBar addSubview:homecheckimg];
            [self getPeopleList];
            isRequestCheckin=NO;
            [topscrollView removeFromSuperview];
            [pagectrl removeFromSuperview];
            UIButton *checkinBtn=(UIButton*)[self.view viewWithTag:3333];
            //[checkinBtn setImage:[UIImage imageNamed:@"tickmark_select"] forState:UIControlStateNormal];
            checkinBtn.tag=3334;
            UIImageView *imgcheckin=(UIImageView*)[checkinBtn viewWithTag:9995];
            imgcheckin.image=[UIImage imageNamed:@"tickmark_select"];
            [checkinBtn addSubview:imgcheckin];
            UILabel *lblcheckout=(UILabel*)[checkinBtn viewWithTag:9996];
            lblcheckout.text=@"Check out:";
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"OrdersTimedOut"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            appDelegate.intPeopleCount=[[result objectForKey:@"userCount"]integerValue];
            appDelegate.intOrderCount=0;
            [[NSUserDefaults standardUserDefaults]setObject:[dictVenue objectForKey:@"venueId"] forKey:@"CheckInVenueId"];
            [[NSUserDefaults standardUserDefaults]setObject:dictVenue forKey:@"VenueDetails"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [appDelegate startTimerToCheckHeartBeat];
            [appDelegate startTimerTOGetMessages];

            //storing the tax percentage
            [[NSUserDefaults standardUserDefaults] setFloat:[[dictVenue valueForKey:@"totalTaxRate"] floatValue]  forKey:@"percentTAX"];
            UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
            segmentControl.frame=CGRectMake(2, 47, 316, 40);
            UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
            if (IS_IPHONE_5)
                tblView.frame=CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 323+90);
            else
                tblView.frame=CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 323);
            
            UIScrollView *scrollViewOld=(UIScrollView*)[self.view viewWithTag:987];
            if(IS_IPHONE_5)
                scrollViewOld.frame=CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 327+90-42);
            else
                scrollViewOld.frame=CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 375-42);
        }
       
    }else if (isGettingCocktails){
        isGettingCocktails=NO;
        isSelectedForDrinks=YES;
        isSelectedForPastOrders=NO;
        isSelectedForPeople=NO;
        
        if([[result objectForKey:@"errorCode"] integerValue]==1)
        {
            //[self createAlertViewWithTitle:@"Error" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
        }
        else
        {
            [self ParsinggetCocktails:result];
           // NSLog(@"result %@",result);
        }
    
        isGetFavorites=YES;
        //[self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController getFavoriteDrinksbybartsyID:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] venueID:[dictVenue objectForKey:@"venueId"] delegate:self];
    

    }else if (isUserCheckOut){
         [self hideProgressView:nil];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"multiitemorders"];
        UIImageView *checkinimg=(UIImageView*)[self.tabBarController.tabBar viewWithTag:5555];
        [checkinimg removeFromSuperview];
        isUserCheckOut=NO;
        [appDelegate stopTimerForGetMessages];
        [self.navigationController popViewControllerAnimated:YES];

        
    }else if (isGetFavorites){
        [self hideProgressView:nil];
        isGetFavorites=NO;
        isGettingCocktails=NO;
        isSelectedForDrinks=YES;
        isSelectedForPastOrders=NO;
        isSelectedForPeople=NO;
        if([[result objectForKey:@"errorCode"] integerValue]==1)
        {
            //[self createAlertViewWithTitle:@"Error" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
        }
        else
        {
            [self ParsingGetFavorites:result];
            //NSLog(@"result %@",result);
        }
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        [tblView reloadData];
    }
}

-(void)controllerDidFailLoadingWithError:(NSError*)error
{
    [self hideProgressView:nil];
    
    if(isRequestForPeople==YES)
    {
        isSelectedForDrinks=NO;
        isSelectedForPeople=YES;
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        [tblView reloadData];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(reloadTable) userInfo:nil repeats:NO];
        
        UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
        NSString *strOrder=[NSString stringWithFormat:@"People (%i)",[arrPeople count]];
        [segmentControl setTitle:strOrder forSegmentAtIndex:1];
    }
    else if(isRequestForGettingsOrders==YES)
    {
        //UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        //[tblView reloadData];
        
        //        UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
        //        NSString *strOrder=[NSString stringWithFormat:@"ORDERS (%i)",[arrOrders count]];
        //        [segmentControl setTitle:strOrder forSegmentAtIndex:2];
        [arrBundledOrders removeAllObjects];
        [arrBundledOrders addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"Orders"]];
        [self loadOrdersView];
        
    }
    
    
}

-(void)reloadTable
{
    UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
    [tblView reloadData];
}


-(void)showMultiItemOrderUI
{
    
    UIView *popview=(UIView*)[self.view viewWithTag:2221];
    if (popview) {
        [popview removeFromSuperview];
    }
    
    NSMutableArray *arrMultiItems=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"multiitemorders"]];
    
    NSMutableDictionary *dictuserInfo;
    if([dictPeopleSelectedForDrink count])
    {
        dictuserInfo=[[NSMutableDictionary alloc] initWithDictionary:dictPeopleSelectedForDrink];
    }
    else
    {
        for (int i=0; i<[arrPeople count]; i++)
        {
            NSDictionary *dictMember=[arrPeople objectAtIndex:i];
            if([[NSString stringWithFormat:@"%@",[dictMember objectForKey:@"bartsyId"]]isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]]])
            {
                dictuserInfo=[[NSMutableDictionary alloc] initWithDictionary:dictMember];
                break;
            }
        }
    }
    dictPeopleSelectedForDrink=[[NSDictionary alloc ]initWithDictionary:dictuserInfo];

    UIView *Backgroundview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    Backgroundview.backgroundColor=[UIColor blackColor];
    Backgroundview.tag=2221;
    //Backgroundview.userInteractionEnabled=NO;
    //Backgroundview.exclusiveTouch=NO;
    [self.view addSubview:Backgroundview];
    
    UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [Backgroundview addSubview:imgViewForTop];
    [imgViewForTop release];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(2, 0, 44, 44);
    [btnBack addTarget:self action:@selector(Btn_Closepopup:) forControlEvents:UIControlEventTouchUpInside];
    [Backgroundview addSubview:btnBack];
    
    UIImageView *imgViewBack = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 12, 20)];
    imgViewBack.image = [UIImage imageNamed:@"arrow-left.png"];
    [btnBack addSubview:imgViewBack];
    [imgViewBack release];

    UILabel *lblVenueName=[self createLabelWithTitle:@"Place Order" frame:CGRectMake(40, 0, 240, 44) tag:0 font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] numberOfLines:0];
    lblVenueName.textAlignment=NSTextAlignmentCenter;
    [Backgroundview addSubview:lblVenueName];
    
    UIImageView *imgcount = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 25, 25)];
    imgcount.tag=1005;
    imgcount.image = [UIImage imageNamed:@"count_circle.png"];
    [Backgroundview addSubview:imgcount];
    [imgcount release];
    UILabel *lblitemCount=[[UILabel alloc]initWithFrame:CGRectMake(2.5, 2, 21, 21)];
    lblitemCount.text=[NSString stringWithFormat:@"%d",arrMultiItems.count];
    lblitemCount.font=[UIFont fontWithName:@"Museo Sans" size:15];
    lblitemCount.tag=111222333;
    lblitemCount.backgroundColor=[UIColor clearColor];
    lblitemCount.textAlignment=NSTextAlignmentCenter;
    lblitemCount.textColor=[UIColor colorWithRed:255.0/255.0 green:55.0/255.0 blue:184.0/255.0 alpha:1.0];
    [imgcount addSubview:lblitemCount];
    [lblitemCount release];
    UIView *popupView=[[UIView alloc]initWithFrame:CGRectMake(0, 45, 320, 366)];
    if (IS_IPHONE_5) {
        
        popupView.frame=CGRectMake(0, 45, 320, 453);
    }
    popupView.backgroundColor=[UIColor colorWithRed:(40.0f/255.0f) green:(40.0f/255.0f) blue:(40.0f/255.0f) alpha:1.0];
    popupView.tag=2222;
    popview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Bartsy_main-bg"]];
   // popupView.layer.borderWidth=1;
   // popupView.layer.borderColor=[UIColor whiteColor].CGColor;
    [Backgroundview addSubview:popupView];
    
    UILabel *lbltitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 120, 40)];
    lbltitle.text=@"Is this order\nfor a friend?";
    lbltitle.font=[UIFont systemFontOfSize:15];
    lbltitle.tag=111222333;
    lbltitle.backgroundColor=[UIColor clearColor];
    lbltitle.numberOfLines=2;
    lbltitle.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
    [popupView addSubview:lbltitle];
    [lbltitle release];

    /*UIButton *btnclose=[UIButton buttonWithType:UIButtonTypeCustom];
    btnclose.frame=CGRectMake(277, 1, 34, 34);
    [btnclose setImage:[UIImage imageNamed:@"deleteicon.png"] forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(Btn_Closepopup:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:btnclose];*/
   
   /* UIButton *btnclose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnclose.frame = CGRectMake(210,1,120,40);
    [btnclose setTitle:@"Cancel Order" forState:UIControlStateNormal];
    btnclose.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    btnclose.titleLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:55.0/255.0 blue:184.0/255.0 alpha:1.0];
   [btnclose addTarget:self action:@selector(Btn_Closepopup:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:btnclose];*/

   /* UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 35, 320, 1.0)];
    lineview.backgroundColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f];
    [popupView addSubview:lineview];
    [lineview release];*/
   
    UIImageView *imgViewPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(10,67,60,60)];
    NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictuserInfo objectForKey:@"userImagePath"]];
    [imgViewPhoto setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]]]];
    imgViewPhoto.tag=143225;
    [imgViewPhoto setImageWithURL:[NSURL URLWithString:strURL]];
    [popupView addSubview:imgViewPhoto];
    [imgViewPhoto release];
    
    UIButton *btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPhoto.frame = CGRectMake(190,24,125,30);
    [btnPhoto addTarget:self action:@selector(btnPhoto_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [btnPhoto setTitle:@"Select a Friend  >" forState:UIControlStateNormal];
    btnPhoto.titleLabel.font=[UIFont systemFontOfSize:14];
    btnPhoto.titleLabel.font=[UIFont fontWithName:@"MuseoSans-300" size:14];
    [btnPhoto setTitleColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    btnPhoto.backgroundColor=[UIColor blackColor];
    [popupView addSubview:btnPhoto];
    
   /* UILabel *lbleditrecpt=[[UILabel alloc]initWithFrame:CGRectMake(10,26, 75, 40)];
    lbleditrecpt.text=@"Change recipient";
    lbleditrecpt.font=[UIFont systemFontOfSize:10];
    lbleditrecpt.backgroundColor=[UIColor clearColor];
    lbleditrecpt.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
    lbleditrecpt.numberOfLines=2;
    lbleditrecpt.lineBreakMode=NSLineBreakByWordWrapping;
    [btnPhoto addSubview:lbleditrecpt];
    [lbleditrecpt release];*/
    
    UILabel *lblNametitle=[[UILabel alloc]initWithFrame:CGRectMake(110, 45+27, 150, 22)];
    lblNametitle.text=@"This order is for:";
    lblNametitle.font=[UIFont systemFontOfSize:15];
    lblNametitle.tag=111222333;
    lblNametitle.backgroundColor=[UIColor clearColor];
    lblNametitle.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
    [popupView addSubview:lblNametitle];
    [lblNametitle release];

    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(110, 90, 150, 22)];
    lblName.text=[dictuserInfo valueForKey:@"nickName"];
    lblName.font=[UIFont systemFontOfSize:18];
    lblName.font=[UIFont fontWithName:@"Museo Sans" size:18];
    lblName.tag=2223;
    lblName.backgroundColor=[UIColor clearColor];
    lblName.textColor=[UIColor whiteColor];
    [popupView addSubview:lblName];
    [lblName release];

    UIView *scrollstrtlineview=[[UIView alloc]initWithFrame:CGRectMake(0, imgViewPhoto.frame.origin.y+imgViewPhoto.frame.size.height+4, 320, 1.0)];
    scrollstrtlineview.backgroundColor=[UIColor colorWithRed:28.0/255.0 green:28.0/255.0 blue:28.0/255.0 alpha:1.0];
    [popupView addSubview:scrollstrtlineview];
    [scrollstrtlineview release];
    UIScrollView *popupscrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0,imgViewPhoto.frame.origin.y+imgViewPhoto.frame.size.height+5, 320, 125)];
    if (IS_IPHONE_5) {
        
        popupscrollview.frame=CGRectMake(0,imgViewPhoto.frame.origin.y+imgViewPhoto.frame.size.height+5, 320, 210);
    }
    popupscrollview.backgroundColor=[UIColor blackColor];
    [popupView addSubview:popupscrollview];
    float totalPrice = 0.0;
    for (int i=0; i<[arrMultiItems count]; i++) {
        
        UIButton *btnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
        btnDelete.frame=CGRectMake(3,(i*60)+15, 22, 22);
        [btnDelete setImage:[UIImage imageNamed:@"deleteicon.png"] forState:UIControlStateNormal];
        btnDelete.tag=i+1;
        [btnDelete addTarget:self action:@selector(Btn_DeleteOrder:) forControlEvents:UIControlEventTouchUpInside];
        [popupscrollview addSubview:btnDelete];
        
        UILabel *lblitemName=[[UILabel alloc]initWithFrame:CGRectMake(40, (i*60)+5, 220, 22)];
        lblitemName.text=[[arrMultiItems objectAtIndex:i] valueForKey:@"name"];
        lblitemName.font=[UIFont systemFontOfSize:16];
        lblitemName.font=[UIFont fontWithName:@"MuseoSans-300" size:16];
        lblitemName.tag=111222333;
        lblitemName.backgroundColor=[UIColor clearColor];
        lblitemName.textColor=[UIColor whiteColor];
        [popupscrollview addSubview:lblitemName];
        [lblitemName release];
        
        UILabel *lbl_Optdespt=[[UILabel alloc]initWithFrame:CGRectMake(40, (i*60)+25, 290, 22)];
        lbl_Optdespt.text=[[arrMultiItems objectAtIndex:i] valueForKey:@"options_description"];
        lbl_Optdespt.font=[UIFont systemFontOfSize:10];
        lbl_Optdespt.font=[UIFont fontWithName:@"MuseoSans-300" size:10];
        lbl_Optdespt.tag=111222333;
        lbl_Optdespt.backgroundColor=[UIColor clearColor];
        lbl_Optdespt.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        [popupscrollview addSubview:lbl_Optdespt];
        [lbl_Optdespt release];
        
        UILabel *lbl_splinst=[[UILabel alloc]initWithFrame:CGRectMake(40, (i*60)+38, 290, 22)];
        lbl_splinst.text=[[arrMultiItems objectAtIndex:i] valueForKey:@"special_Instructions"];
        lbl_splinst.font=[UIFont systemFontOfSize:10];
        lbl_splinst.font=[UIFont fontWithName:@"MuseoSans-300" size:10];
        lbl_splinst.tag=111222333;
        lbl_splinst.backgroundColor=[UIColor clearColor];
        lbl_splinst.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        [popupscrollview addSubview:lbl_splinst];
        [lbl_splinst release];

        UILabel *lblprice=[[UILabel alloc]initWithFrame:CGRectMake(275, (i*60)+5, 190, 22)];
        lblprice.text=[NSString stringWithFormat:@"$%d",[[[arrMultiItems objectAtIndex:i] valueForKey:@"price"] integerValue]];
        lblprice.font=[UIFont boldSystemFontOfSize:18];
        lblprice.font=[UIFont fontWithName:@"Museo Sans" size:18];
        lblprice.tag=111222333;
        lblprice.backgroundColor=[UIColor clearColor];
        lblprice.textColor=[UIColor colorWithRed:0.0/255.0 green:175.0/255.0 blue:222.0/255.0 alpha:1.0];
        [popupscrollview addSubview:lblprice];
        [lblprice release];
        if (lbl_Optdespt.text.length<1) {
            
            lblitemName.frame=CGRectMake(lblitemName.frame.origin.x, lblitemName.frame.origin.y+10, lblitemName.frame.size.width, lblitemName.frame.size.height);
            lblprice.frame=CGRectMake(lblprice.frame.origin.x, lblprice.frame.origin.y+10, lblprice.frame.size.width, lblprice.frame.size.height);

        }
        UIButton *indexButton=[UIButton buttonWithType:UIButtonTypeCustom];
        indexButton.tag=i;
        indexButton.frame=CGRectMake(25, (i*60), 290, 60);
        [indexButton addTarget:self action:@selector(Button_Popview:) forControlEvents:UIControlEventTouchUpInside];
        [popupscrollview addSubview:indexButton];
        
        UIView *scrollendlineview=[[UIView alloc]initWithFrame:CGRectMake(0,(i*60)+59, 320, 1)];
        scrollendlineview.backgroundColor=[UIColor colorWithRed:28.0/255.0 green:28.0/255.0 blue:28.0/255.0 alpha:1.0];
        [popupscrollview addSubview:scrollendlineview];
        [scrollendlineview release];
        totalPrice+=[[[arrMultiItems objectAtIndex:i] valueForKey:@"price"] floatValue];
    }
    
    ttlPrice=totalPrice;
    [popupscrollview setContentSize:CGSizeMake(320,[arrMultiItems count]*60)];
    UIView *scrollendlineview=[[UIView alloc]initWithFrame:CGRectMake(0, imgViewPhoto.frame.origin.y+imgViewPhoto.frame.size.height+2, 320, 1.0)];
    scrollendlineview.backgroundColor=[UIColor grayColor];
    [popupView addSubview:scrollendlineview];
    [scrollendlineview release];
    UILabel *lblTip = [[UILabel alloc]initWithFrame:CGRectMake(8, popupView.frame.size.height-110, 30, 30)];
    lblTip.font = [UIFont boldSystemFontOfSize:12];
    lblTip.text = @"Tip:";
    lblTip.backgroundColor = [UIColor clearColor];
    lblTip.textColor =[ UIColor whiteColor];
    lblTip.textAlignment = NSTextAlignmentLeft;
    [popupView addSubview:lblTip];
    [lblTip release];
    
    UIButton *btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn10.frame = CGRectMake(37,popupView.frame.size.height-105,18,18);
    btn10.tag = 10;
    [btn10 setBackgroundImage:[UIImage imageNamed:@"circle.png"] forState:UIControlStateNormal];
    [btn10 setBackgroundImage:[UIImage imageNamed:@"percentage_count-selected.png"] forState:UIControlStateSelected];
    [btn10 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:btn10];
    
    UILabel *lbl10 = [[UILabel alloc]initWithFrame:CGRectMake(56, popupView.frame.size.height-110, 30, 30)];
    lbl10.font = [UIFont boldSystemFontOfSize:12];
    lbl10.font=[UIFont fontWithName:@"Museo Sans" size:12];
    lbl10.text = @"10%";
    lbl10.backgroundColor = [UIColor clearColor];
    lbl10.textColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:122.0/255.0 alpha:1.0] ;
    lbl10.textAlignment = NSTextAlignmentCenter;
    [popupView addSubview:lbl10];
    [lbl10 release];
    
    UIButton *btn20 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn20.frame = CGRectMake(90,popupView.frame.size.height-105,18,18);
    btn20.tag = 15;
    [btn20 setBackgroundImage:[UIImage imageNamed:@"circle.png"] forState:UIControlStateNormal];
    [btn20 setBackgroundImage:[UIImage imageNamed:@"percentage_count-selected.png"] forState:UIControlStateSelected];

    [btn20 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:btn20];
    
    UILabel *lbl15 = [[UILabel alloc]initWithFrame:CGRectMake(110, popupView.frame.size.height-110, 30, 30)];
    lbl15.font = [UIFont boldSystemFontOfSize:12];
    lbl15.font=[UIFont fontWithName:@"Museo Sans" size:12];
    lbl15.text = @"15%";
    lbl15.backgroundColor = [UIColor clearColor];
    lbl15.textColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:122.0/255.0 alpha:1.0] ;
    lbl15.textAlignment = NSTextAlignmentCenter;
    [popupView addSubview:lbl15];
    [lbl15 release];
    
    UIButton *btn30 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn30.frame = CGRectMake(148,popupView.frame.size.height-105,18,18);
    [btn30 setBackgroundImage:[UIImage imageNamed:@"circle.png"] forState:UIControlStateNormal];
    [btn30 setBackgroundImage:[UIImage imageNamed:@"percentage_count-selected.png"] forState:UIControlStateSelected];
    btn30.tag = 20;
    [btn30 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:btn30];
    btn30.selected=YES;
    btnValue=20;
    
    UILabel *lbl20 = [[UILabel alloc]initWithFrame:CGRectMake(170, popupView.frame.size.height-110, 30, 30)];
    lbl20.font = [UIFont boldSystemFontOfSize:12];
    lbl20.font=[UIFont fontWithName:@"Museo Sans" size:12];
    lbl20.text = @"20%";
    lbl20.backgroundColor = [UIColor clearColor];
    lbl20.textColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:122.0/255.0 alpha:1.0] ;
    lbl20.textAlignment = NSTextAlignmentCenter;
    [popupView addSubview:lbl20];
    [lbl20 release];
    
    float tiptotal=(ttlPrice*((float)btnValue/100));

    UILabel *lblTipprice = [[UILabel alloc]initWithFrame:CGRectMake(235, popupView.frame.size.height-110, 100, 30)];
    lblTipprice.font = [UIFont boldSystemFontOfSize:13];
    lblTipprice.font=[UIFont fontWithName:@"Museo Sans" size:13];
    lblTipprice.text = [NSString stringWithFormat:@"+ $%.2f",tiptotal];
    lblTipprice.backgroundColor = [UIColor clearColor];
    lblTipprice.textColor = [UIColor colorWithRed:0.0/255.0 green:175.0/255.0 blue:222.0/255.0 alpha:1.0];
    lblTipprice.tag=4446;
    lblTipprice.textAlignment = NSTextAlignmentLeft;
    [popupView addSubview:lblTipprice];
    [lblTipprice release];

    
    UIView *lineview2=[[UIView alloc]initWithFrame:CGRectMake(0, popupView.frame.size.height-81, 320, 1.0)];
    lineview2.backgroundColor=[UIColor colorWithRed:28.0/255.0 green:28.0/255.0 blue:28.0/255.0 alpha:1.0];
    [popupView addSubview:lineview2];
    [lineview2 release];
    
    float taxPrice=[[NSUserDefaults standardUserDefaults] floatForKey:@"percentTAX"];
    float floatTotalTax=(totalPrice*((float)taxPrice/100));

    UILabel *lblTax = [[UILabel alloc]initWithFrame:CGRectMake(8, popupView.frame.size.height-80, 175, 30)];
    lblTax.font = [UIFont systemFontOfSize:14];
    lblTax.text = [NSString stringWithFormat:@"Tax:"];
    lblTax.backgroundColor = [UIColor clearColor];
    lblTax.textColor = [UIColor whiteColor] ;
    lblTax.font=[UIFont fontWithName:@"Museo Sans" size:14];
    lblTax.textAlignment = NSTextAlignmentLeft;
    lblTax.tag=2228;
    [popupView addSubview:lblTax];
    [lblTax release];
    
    UILabel *lblTaxPrice = [[UILabel alloc]initWithFrame:CGRectMake(40, popupView.frame.size.height-80, 175, 30)];
    lblTaxPrice.font = [UIFont systemFontOfSize:14];
    lblTaxPrice.font=[UIFont fontWithName:@"Museo Sans" size:14];
    lblTaxPrice.text = [NSString stringWithFormat:@"$%.2f",floatTotalTax];
    lblTaxPrice.backgroundColor = [UIColor clearColor];
    lblTaxPrice.textColor = [UIColor colorWithRed:0.0/255.0 green:175.0/255.0 blue:222.0/255.0 alpha:1.0];
    lblTaxPrice.textAlignment = NSTextAlignmentLeft;
    lblTaxPrice.tag=4447;
    [popupView addSubview:lblTaxPrice];
    
    UILabel *lblTotal = [[UILabel alloc]initWithFrame:CGRectMake(235, popupView.frame.size.height-80, 150, 30)];
    lblTotal.font = [UIFont systemFontOfSize:12];
    lblTotal.text = [NSString stringWithFormat:@"Total:"];
    lblTotal.backgroundColor = [UIColor clearColor];
    lblTotal.textColor = [UIColor whiteColor] ;
    lblTotal.textAlignment = NSTextAlignmentLeft;
    lblTotal.tag=2229;
    [popupView addSubview:lblTotal];
    lblTotal.font=[UIFont fontWithName:@"Museo Sans" size:14];
    [lblTotal release];
    
    UILabel *lblTotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(272, popupView.frame.size.height-80, 150, 30)];
    lblTotalPrice.font = [UIFont systemFontOfSize:12];
    lblTotalPrice.text = [NSString stringWithFormat:@"$%@",[NSString stringWithFormat:@"%.2f",totalPrice+tiptotal+floatTotalTax]];
    lblTotalPrice.backgroundColor = [UIColor clearColor];
    lblTotalPrice.textColor = [UIColor colorWithRed:0.0/255.0 green:175.0/255.0 blue:222.0/255.0 alpha:1.0];
    lblTotalPrice.textAlignment = NSTextAlignmentLeft;
    lblTotalPrice.tag=4448;
    [popupView addSubview:lblTotalPrice];
    lblTotalPrice.font=[UIFont fontWithName:@"Museo Sans" size:14];
    [lblTotalPrice release];
    
    UIView *lineview3=[[UIView alloc]initWithFrame:CGRectMake(0, popupView.frame.size.height-46, 320, 1.0)];
    lineview3.backgroundColor=[UIColor colorWithRed:28.0/255.0 green:28.0/255.0 blue:28.0/255.0 alpha:1.0];
    [popupView addSubview:lineview3];
    [lineview3 release];

    UIButton *btnaddmore = [UIButton buttonWithType:UIButtonTypeCustom];
    btnaddmore.frame = CGRectMake(0,popupView.frame.size.height-41,160,40);
    [btnaddmore setTitle:@"Add more items" forState:UIControlStateNormal];
    btnaddmore.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    btnaddmore.titleLabel.font=[UIFont fontWithName:@"Museo Sans" size:14.0];
    btnaddmore.titleLabel.textColor = [UIColor blackColor];
   // btnaddmore.backgroundColor=[UIColor colorWithRed:92.0/255.0 green:92.0/255.0 blue:104.0/255.0 alpha:1.0];
    //[btnaddmore addTarget:self action:@selector(ButtonHighlight:) forControlEvents:UIControlEventTouchDown];

    btnaddmore.tag=1115;
    [btnaddmore addTarget:self action:@selector(btnOrder_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    btnaddmore.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:175.0/255.0 blue:222.0/255.0 alpha:1.0];

    [popupView addSubview:btnaddmore];

   /* UIView *lineview4=[[UIView alloc]initWithFrame:CGRectMake(161, popupView.frame.size.height-42, 1.0, 40)];
    lineview4.backgroundColor=[UIColor grayColor];
    [popupView addSubview:lineview4];
    [lineview4 release];*/
    
    UIButton *btnOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOrder.frame = CGRectMake(161,popupView.frame.size.height-41,159,40);
    [btnOrder setTitle:@"Place Order" forState:UIControlStateNormal];
    btnOrder.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    btnOrder.titleLabel.font=[UIFont fontWithName:@"Museo Sans" size:14.0];
    [btnOrder addTarget:self action:@selector(ButtonHighlight:) forControlEvents:UIControlEventTouchDown];

    btnOrder.titleLabel.textColor = [UIColor blackColor];
   // btnOrder.backgroundColor=[UIColor colorWithRed:92.0/255.0 green:92.0/255.0 blue:104.0/255.0 alpha:1.0];
    btnOrder.tag=1116;
    [btnOrder addTarget:self action:@selector(btnOrder_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    btnOrder.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:175.0/255.0 blue:222.0/255.0 alpha:1.0];

    [popupView addSubview:btnOrder];
    
   /* [[popview subviews]
     makeObjectsPerformSelector:@selector(setUserInteractionEnabled:)
     withObject:[NSNumber numberWithBool:FALSE]];
    popview.userInteractionEnabled=YES;*/
 /*
//     id object=[arrMenu objectAtIndex:indexPath.section-(2+[arrCustomDrinks count])];
//     NSDictionary *dict;
//     if(indexPath.section==1&&[object isKindOfClass:[NSArray class]])
//     {
//     dict=[object objectAtIndex:indexPath.row];
//     }
//     else
//     {
//     NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
//     dict=[arrContents objectAtIndex:indexPath.row];
//     
//     }
    
     //dictSelectedToMakeOrder=[[NSDictionary alloc]initWithDictionary:dict];
     //[tableView deselectRowAtIndexPath:indexPath animated:YES];
     
     UIView *viewA=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480+23)];
     viewA.backgroundColor=[UIColor clearColor];
     viewA.tag=222;
     [self.view addSubview:viewA];
     
     UIView *viewB=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480+23)];
     viewB.backgroundColor=[UIColor blackColor];
     viewB.layer.opacity=0.6;
     viewB.tag=333;
     [viewA addSubview:viewB];
     
     UIView *viewC = [[UIView alloc]initWithFrame:CGRectMake(12, 20, 295, 358)];
     viewC.layer.cornerRadius = 2;
     viewC.layer.borderWidth = 2;
     viewC.backgroundColor = [UIColor redColor];
     viewC.layer.borderColor = [UIColor redColor].CGColor;
     viewC.layer.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
     viewC.tag=444;
     [viewB addSubview:viewC];
     
     UIView *viewHeaderPhoto = [[UIView alloc]initWithFrame:CGRectMake(11, 5, 268, 90)];
     viewHeaderPhoto.backgroundColor = [UIColor blackColor];
     viewHeaderPhoto.layer.cornerRadius = 6;
     viewHeaderPhoto.tag = 11111;
     [viewC addSubview:viewHeaderPhoto];
     
     //NSMutableArray *arrPeopleTemp=[[NSMutableArray alloc]initWithArray:arrPeople];
     //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"bartsyId == %i",[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] integerValue]];
     //[arrPeopleTemp filterUsingPredicate:predicate];
     
     NSLog(@"Bartsy id is %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]);
     if([dictPeopleSelectedForDrink count])
     {
     dictTemp=[[NSMutableDictionary alloc] initWithDictionary:dictPeopleSelectedForDrink];
     }
     else
     {
     for (int i=0; i<[arrPeople count]; i++)
     {
     NSDictionary *dictMember=[arrPeople objectAtIndex:i];
     if([[NSString stringWithFormat:@"%@",[dictMember objectForKey:@"bartsyId"]]isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]]])
     {
     dictTemp=[[NSMutableDictionary alloc] initWithDictionary:dictMember];
     break;
     }
     }
     }
     
     
     UIImageView *imgViewPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(10,10,60,60)];
     NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictTemp objectForKey:@"userImagePath"]];
     NSLog(@"URL is %@",dictTemp);
     //[imgViewPhoto setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]]]];
     imgViewPhoto.tag=143225;
     [imgViewPhoto setImageWithURL:[NSURL URLWithString:strURL]];
     [viewHeaderPhoto addSubview:imgViewPhoto];
     [imgViewPhoto release];
     
     NSLog(@"nickname is %@",[dictTemp objectForKey:@"nickname"]);
     
     UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 72, 120, 18)];
     lblName.text=[dictTemp objectForKey:@"nickName"];
     lblName.font=[UIFont systemFontOfSize:10];
     lblName.tag=111222333;
     lblName.backgroundColor=[UIColor clearColor];
     lblName.textColor=[UIColor whiteColor];
     [viewHeaderPhoto addSubview:lblName];
     [lblName release];
     
     UILabel *lblMsg=[[UILabel alloc]initWithFrame:CGRectMake(85, 10, 160, 60)];
     lblMsg.text=@"Click on photo if you would like to send drink to other people";
     lblMsg.font=[UIFont systemFontOfSize:15];
     lblMsg.numberOfLines=3;
     lblMsg.backgroundColor=[UIColor clearColor];
     lblMsg.textColor=[UIColor whiteColor];
     [viewHeaderPhoto addSubview:lblMsg];
     [lblMsg release];
     
     
     UIButton *btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
     btnPhoto.frame = CGRectMake(10,5,105,50);
     [btnPhoto addTarget:self action:@selector(btnPhoto_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
     btnPhoto.backgroundColor=[UIColor clearColor];
     [viewHeaderPhoto addSubview:btnPhoto];
     
     [viewHeaderPhoto release];
     
     
     UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(11, 100, 268, 45)];
     viewHeader.backgroundColor = [UIColor blackColor];
     viewHeader.layer.cornerRadius = 6;
     viewHeader.tag = 555;
     [viewC addSubview:viewHeader];
     [viewHeader release];
     
     UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(7, 7, 250, 30)];
     lblTitle.font = [UIFont boldSystemFontOfSize:15];
     lblTitle.text = [dict objectForKey:@"name"];
     lblTitle.tag = 666;
     lblTitle.backgroundColor = [UIColor clearColor];
     lblTitle.textColor = [UIColor whiteColor] ;
     lblTitle.textAlignment = NSTextAlignmentCenter;
     [viewHeader addSubview:lblTitle];
     [lblTitle release];
     
     UIButton *btnLike = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     btnLike.frame = CGRectMake(10,153,60,35);
     btnLike.titleLabel.font = [UIFont boldSystemFontOfSize:12];
     [btnLike setTitle:@"Like" forState:UIControlStateNormal];
     btnLike.titleLabel.textColor = [UIColor blackColor];
     [btnLike addTarget:self action:@selector(btnLike_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
     [viewC addSubview:btnLike];
     
     UIButton *btnComment = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     btnComment.frame = CGRectMake(75,153,60,35);
     btnComment.titleLabel.font = [UIFont boldSystemFontOfSize:12];
     [btnComment setTitle:@"Comment" forState:UIControlStateNormal];
     btnComment.titleLabel.textColor = [UIColor blackColor];
     [btnComment addTarget:self action:@selector(btnComment_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
     [viewC addSubview:btnComment];
     
     UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     btnShare.frame = CGRectMake(140,153,60,35);
     btnShare.titleLabel.font = [UIFont boldSystemFontOfSize:12];
     [btnShare setTitle:@"Share" forState:UIControlStateNormal];
     btnShare.titleLabel.textColor = [UIColor blackColor];
     [btnShare addTarget:self action:@selector(btnShare_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
     [viewC addSubview:btnShare];
     
     UIButton *btnFav = [UIButton buttonWithType:UIButtonTypeCustom];
     [btnFav setImage:[UIImage imageNamed:@"icon_favorites.png"] forState:UIControlStateNormal];
     btnFav.frame = CGRectMake(205,150,52,40);
     [btnFav addTarget:self action:@selector(btnFav_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
     [viewC addSubview:btnFav];
     
     UIView *viewDetail = [[UIView alloc]initWithFrame:CGRectMake(11, 153+40, 200, 60)];
     viewDetail.backgroundColor = [UIColor whiteColor];
     viewDetail.layer.borderWidth = 1;
     viewDetail.layer.borderColor = [UIColor grayColor].CGColor;
     viewDetail.layer.cornerRadius = 6;
     viewDetail.tag = 777;
     [viewC addSubview:viewDetail];
     [viewDetail release];
     
     //    UIImageView *imgViewDrink = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 80)];
     //    imgViewDrink.image = [UIImage imageNamed:@"drinks.png"];
     //    imgViewDrink.layer.borderWidth = 1;
     //    imgViewDrink.layer.cornerRadius = 2;
     //    imgViewDrink.layer.borderColor = [UIColor grayColor].CGColor;
     //    [[imgViewDrink layer] setShadowOffset:CGSizeMake(0, 1)];
     //    [[imgViewDrink layer] setShadowColor:[[UIColor grayColor] CGColor]];
     //    [[imgViewDrink layer] setShadowRadius:3.0];
     //    [[imgViewDrink layer] setShadowOpacity:0.8];
     //    [viewDetail addSubview:imgViewDrink];
     //    [imgViewDrink release];
     
     UITextView *txtViewNotes = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 185, 50)];
     txtViewNotes.delegate = self;
     txtViewNotes.tag = 1000;
     txtViewNotes.backgroundColor = [UIColor clearColor];
     txtViewNotes.editable = NO;
     txtViewNotes.text = [dict objectForKey:@"description"];
     txtViewNotes.textColor = [UIColor blackColor];
     txtViewNotes.font = [UIFont boldSystemFontOfSize:10];
     [viewDetail addSubview:txtViewNotes];
     [txtViewNotes release];
     
     UIButton *btnCustomise = [UIButton buttonWithType:UIButtonTypeCustom];
     btnCustomise.frame = CGRectMake(50,65,105,25);
     btnCustomise.titleLabel.font = [UIFont boldSystemFontOfSize:12];
     [btnCustomise setTitle:@"Customise" forState:UIControlStateNormal];
     btnCustomise.titleLabel.textColor = [UIColor whiteColor];
     btnCustomise.backgroundColor=[UIColor blackColor];
     [btnCustomise addTarget:self action:@selector(btnCustomise_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
     //[viewDetail addSubview:btnCustomise];
     
     UIView *viewPrice = [[UIView alloc]initWithFrame:CGRectMake(216, 153+40, 63, 60)];
     viewPrice.backgroundColor = [UIColor whiteColor];
     viewPrice.layer.borderWidth = 1;
     viewPrice.layer.borderColor = [UIColor grayColor].CGColor;
     viewPrice.layer.cornerRadius = 6;
     viewPrice.tag = 888;
     [viewC addSubview:viewPrice];
     [viewPrice release];
     
     UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 63, 60)];
     lblPrice.font = [UIFont boldSystemFontOfSize:20];
     lblPrice.text = [NSString
     stringWithFormat:@"$%@",[dict objectForKey:@"price"]];
     lblPrice.backgroundColor = [UIColor clearColor];
     lblPrice.textColor = [UIColor brownColor] ;
     lblPrice.textAlignment = NSTextAlignmentCenter;
     [viewPrice addSubview:lblPrice];
     [lblPrice release];
     
     //    UILabel *lblPriceOff = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 63, 30)];
     //    lblPriceOff.font = [UIFont boldSystemFontOfSize:12];
     //    lblPriceOff.text = @"($2 off)";
     //    lblPriceOff.backgroundColor = [UIColor clearColor];
     //    lblPriceOff.textColor = [UIColor blackColor] ;
     //    lblPriceOff.textAlignment = NSTextAlignmentCenter;
     //    [viewPrice addSubview:lblPriceOff];
     //    [lblPriceOff release];
     
     UIView *viewTip = [[UIView alloc]initWithFrame:CGRectMake(11, 261, 268, 45)];
     viewTip.backgroundColor = [UIColor whiteColor];
     viewTip.layer.borderWidth = 1;
     viewTip.layer.borderColor = [UIColor grayColor].CGColor;
     viewTip.layer.cornerRadius = 6;
     viewTip.tag = 999;
     [viewC addSubview:viewTip];
     [viewTip release];
     
     UILabel *lblTip = [[UILabel alloc]initWithFrame:CGRectMake(8, 7, 30, 30)];
     lblTip.font = [UIFont boldSystemFontOfSize:12];
     lblTip.text = @"Tip:";
     lblTip.backgroundColor = [UIColor clearColor];
     lblTip.textColor = [UIColor blackColor] ;
     lblTip.textAlignment = NSTextAlignmentCenter;
     [viewTip addSubview:lblTip];
     [lblTip release];
     
     
     UIButton *btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
     btn10.frame = CGRectMake(37,10,23,23);
     btn10.tag = 10;
     [btn10 setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
     [btn10 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
     [viewTip addSubview:btn10];
     
     
     UILabel *lbl10 = [[UILabel alloc]initWithFrame:CGRectMake(60, 7, 30, 30)];
     lbl10.font = [UIFont boldSystemFontOfSize:12];
     lbl10.text = @"10%";
     lbl10.backgroundColor = [UIColor clearColor];
     lbl10.textColor = [UIColor blackColor] ;
     lbl10.textAlignment = NSTextAlignmentCenter;
     [viewTip addSubview:lbl10];
     [lbl10 release];
     
     UIButton *btn20 = [UIButton buttonWithType:UIButtonTypeCustom];
     btn20.frame = CGRectMake(90,10,23,23);
     btn20.tag = 15;
     [btn20 setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
     [btn20 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
     [viewTip addSubview:btn20];
     
     UILabel *lbl15 = [[UILabel alloc]initWithFrame:CGRectMake(118, 7, 30, 30)];
     lbl15.font = [UIFont boldSystemFontOfSize:12];
     lbl15.text = @"15%";
     lbl15.backgroundColor = [UIColor clearColor];
     lbl15.textColor = [UIColor blackColor] ;
     lbl15.textAlignment = NSTextAlignmentCenter;
     [viewTip addSubview:lbl15];
     [lbl15 release];
     
     UIButton *btn30 = [UIButton buttonWithType:UIButtonTypeCustom];
     btn30.frame = CGRectMake(148,10,23,23);
     [btn30 setBackgroundImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
     btn30.tag = 20;
     [btn30 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
     [viewTip addSubview:btn30];
     
     btnValue=btn30.tag;
     
     UILabel *lbl20 = [[UILabel alloc]initWithFrame:CGRectMake(180, 7, 30, 30)];
     lbl20.font = [UIFont boldSystemFontOfSize:12];
     lbl20.text = @"20%";
     lbl20.backgroundColor = [UIColor clearColor];
     lbl20.textColor = [UIColor blackColor] ;
     lbl20.textAlignment = NSTextAlignmentCenter;
     [viewTip addSubview:lbl20];
     [lbl20 release];
     
     UIButton *btn40 = [UIButton buttonWithType:UIButtonTypeCustom];
     btn40.frame = CGRectMake(210,10,23,23);
     [btn40 setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
     btn40.tag = 40;
     [btn40 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
     //[viewTip addSubview:btn40];
     
     UITextField *txtFieldTip = [[UITextField alloc] initWithFrame:CGRectMake(223,7, 40, 30)];
     [txtFieldTip setBackground:[UIImage imageNamed:@"txt-box1.png"]];
     txtFieldTip.delegate = self;
     txtFieldTip.tag = 500;
     txtFieldTip.font = [UIFont boldSystemFontOfSize:12];
     txtFieldTip.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
     txtFieldTip.textAlignment = NSTextAlignmentCenter;
     txtFieldTip.autocorrectionType = UITextAutocorrectionTypeNo;
     //[viewTip addSubview:txtFieldTip];
     [txtFieldTip release];
     
     UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
     btnCancel.frame = CGRectMake(148,317,120,30);
     btnCancel.titleLabel.textColor = [UIColor whiteColor];
     [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
     btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:12];
     btnCancel.backgroundColor=[UIColor blackColor];
     [btnCancel addTarget:self action:@selector(btnCancel_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
     [viewC addSubview:btnCancel];
     
     UIButton *btnOrder = [UIButton buttonWithType:UIButtonTypeCustom];
     btnOrder.frame = CGRectMake(20,317,115,30);
     [btnOrder setTitle:@"Order" forState:UIControlStateNormal];
     btnOrder.titleLabel.font = [UIFont boldSystemFontOfSize:12];
     btnOrder.titleLabel.textColor = [UIColor whiteColor];
     btnOrder.backgroundColor=[UIColor blackColor];
     [btnOrder addTarget:self action:@selector(btnOrder_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
     [viewC addSubview:btnOrder];
     
     [viewA release];
     [viewB release];
     [viewC release];*/
}

-(void)Btn_DeleteOrder:(UIButton*)sender{
    
    UIView *popview=(UIView*)[self.view viewWithTag:2221];
    [popview removeFromSuperview];
    
    NSMutableArray *arrMultiItemOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"multiitemorders"]];
    [arrMultiItemOrders removeObjectAtIndex:sender.tag-1];
    [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if ([arrMultiItemOrders count]>0) {
        [self showMultiItemOrderUI];

    }else{
        
    }

}

-(void)Button_Popview:(UIButton*)sender{
    
    NSMutableArray *arrMultiItemOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"multiitemorders"]];
    NSDictionary *dicttemp=[[NSDictionary alloc]initWithDictionary:[arrMultiItemOrders objectAtIndex:sender.tag]];
    
    if ([[dicttemp valueForKey:@"Viewtype"] integerValue]==2) {
        
        //return;
        
    }
    CustomDrinkViewController *obj=[[CustomDrinkViewController alloc]initWithNibName:@"CustomDrinkViewController" bundle:nil];
    obj.viewtype=[[dicttemp valueForKey:@"Viewtype"] integerValue];
    obj.arrIndex=sender.tag;
    obj.isEdit=YES;
    
    if ([[dicttemp valueForKey:@"Viewtype"] integerValue]==2 || [[dicttemp valueForKey:@"Viewtype"] integerValue]==3 ||[[dicttemp valueForKey:@"Viewtype"] integerValue]==4 ||[[dicttemp valueForKey:@"Viewtype"] integerValue]==5){

        obj.arrayEditInfo=[dicttemp valueForKey:@"ArrayInfo"];
        obj.dictitemdetails=[arrMultiItemOrders objectAtIndex:sender.tag];
    }else{
        obj.dictitemdetails=[arrMultiItemOrders objectAtIndex:sender.tag];
    }
    [self.navigationController pushViewController:obj animated:YES];
    [arrMultiItemOrders release];
}

//Removing the OrderView from top
-(void)Btn_Closepopup:(UIButton*)sender
{
    NSArray *arraylistitem=[[NSUserDefaults standardUserDefaults]arrayForKey:@"multiitemorders"];
    if (arraylistitem.count) {
        UIView *popupView=(UIView*)[self.view viewWithTag:2221];
        popupView.hidden=YES;
        UIButton *checkinBtn=(UIButton*)[self.view viewWithTag:3334];
        checkinBtn.hidden=YES;
        
        UIButton *drinkBtn=(UIButton*)[self.view viewWithTag:1117];
        if (!drinkBtn) {
            UIButton *drinkBtn=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"drink"] frame:CGRectMake(280, 8, 30, 30) tag:1117 selector:@selector(btnOrder_TouchUpInside:) target:self];
            [self.view addSubview:drinkBtn];
            
        }

    }else{
        //Deleting all orders added to list
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"multiitemorders"];

    UIView *Backgroundview=(UIView*)[self.view viewWithTag:2221];
    [Backgroundview removeFromSuperview];
    
    UIButton *drinkBtn=(UIButton*)[self.view viewWithTag:1117];
    [drinkBtn removeFromSuperview];
    UIButton *checkinBtn=(UIButton*)[self.view viewWithTag:3334];
    //[checkinBtn setImage:[UIImage imageNamed:@"tickmark_select"] forState:UIControlStateNormal];
    checkinBtn.hidden=NO;
    UILabel *lblcheckout=(UILabel*)[checkinBtn viewWithTag:9996];
    lblcheckout.text=@"Check out:";
    UIImageView *imgcheckin=(UIImageView*)[checkinBtn viewWithTag:9995];
    imgcheckin.image=[UIImage imageNamed:@"tickmark_select"];
    [checkinBtn addSubview:imgcheckin];
    }
}
#pragma mark----------Parsing the Locumenu Data
-(void)modifyData
{
    [arrMenu removeAllObjects];
    id results=[[NSUserDefaults standardUserDefaults]objectForKey:@"LocuMenu"];
    NSArray *arrmenues=[results valueForKey:@"menus"];
    for (int i=0; i<[arrmenues count]; i++) {
        NSDictionary *dicmainsections=[arrmenues objectAtIndex:i];
        
        NSArray *arrsections=[dicmainsections valueForKey:@"sections"];
        for (int j=0; j<[arrsections count]; j++) {
            
            NSDictionary *dictsection=[arrsections objectAtIndex:j];
            if ([[dictsection valueForKey:@"section_name"] length]!=0) {
                
                NSArray *arrsubSection=[dictsection valueForKey:@"subsections"];
                for (int k=0; k<[arrsubSection count];k++) {
                    NSDictionary *dictSubSection=[ arrsubSection objectAtIndex:k];
                    NSMutableDictionary *sectionDict=[[NSMutableDictionary alloc]init];
                    if ([[dictSubSection valueForKey:@"subsection_name"] length]>0)
                        [sectionDict setObject:[NSString stringWithFormat:@"%@->%@->%@",[dicmainsections valueForKey:@"menu_name"],[dictsection valueForKey:@"section_name"],[dictSubSection valueForKey:@"subsection_name"]] forKey:@"section_name"];
                    else
                        [sectionDict setObject:[NSString stringWithFormat:@"%@->%@",[dicmainsections valueForKey:@"menu_name"],[dictsection valueForKey:@"section_name"]] forKey:@"section_name"];
                    
                    NSArray *arrContent=[dictSubSection valueForKey:@"contents"];
                    NSMutableArray *arrSubContent=[[NSMutableArray alloc]init];
                    for (int x=0; x<[arrContent count]; x++) {
                        
                        NSDictionary *dictContent=[arrContent objectAtIndex:x];
                       // if (![dictContent valueForKey:@"option_groups"]) {
                            
                            if ([dictContent valueForKey:@"name"]) {
                                
                                [arrSubContent addObject:dictContent];
                            }
                       // }
                        
                    }
                    
                    [sectionDict setObject:arrSubContent forKey:@"contents"];
                    [arrMenu addObject:sectionDict];
                    [sectionDict release];
                    [arrSubContent release];
                }
                
            }else{
                NSArray *arrsubSection=[dictsection valueForKey:@"subsections"];
                for (int k=0; k<[arrsubSection count];k++) {
                    NSDictionary *dictSubSection=[ arrsubSection objectAtIndex:k];
                    //NSLog(@"**** %@-->%@ ",[dictsection valueForKey:@"section_name"],[dictSubSection valueForKey:@"subsection_name"]);
                    NSMutableDictionary *sectionDict=[[NSMutableDictionary alloc]init];
                    
                    [sectionDict setObject:@"Various Items" forKey:@"section_name"];
                    NSArray *arrContent=[dictSubSection valueForKey:@"contents"];
                    NSMutableArray *arrSubContent=[[NSMutableArray alloc]init];
                    for (int x=0; x<[arrContent count]; x++) {
                        
                        NSDictionary *dictContent=[arrContent objectAtIndex:x];
                        [arrSubContent addObject:dictContent];
                    }
                    
                    [sectionDict setObject:arrSubContent forKey:@"contents"];
                    [arrMenu addObject:sectionDict];
                    [sectionDict release];
                    [arrSubContent release];
                }
                
            }
            
        }
        
        
    }
    NSLog(@"arrmenu %@",arrMenu);
    UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
    [tblView reloadData];
    
}

#pragma mark----------Parsing the getIngredientsInLocu Data

-(void)ParsinggetIngredients:(id)result{
    
    [arrCustomDrinks removeAllObjects];
    NSArray *arrmenues=[result valueForKey:@"menus"];
    for (int i=0; i<[arrmenues count]; i++) {
        NSDictionary *dicmainsections=[arrmenues objectAtIndex:i];
        if (![[dicmainsections valueForKey:@"show_menu"] isEqualToString:@"No"])
        {
            NSArray *arrsections=[dicmainsections valueForKey:@"sections"];
            for (int j=0; j<[arrsections count]; j++) {
                
                NSDictionary *dictsection=[arrsections objectAtIndex:j];
                    
                    NSArray *arrsubSection=[dictsection valueForKey:@"subsections"];
                    for (int k=0; k<[arrsubSection count];k++) {
                        NSDictionary *dictSubSection=[ arrsubSection objectAtIndex:k];
                        NSMutableDictionary *sectionDict=[[NSMutableDictionary alloc]init];

                        [sectionDict setObject:[NSString stringWithFormat:@"%@",[dicmainsections valueForKey:@"menu_name"]] forKey:@"section_name"];
                        NSArray *arrContent=[dictSubSection valueForKey:@"contents"];
                        NSMutableArray *arroptions=[[NSMutableArray alloc]init];
                        for (int x=0; x<[arrContent count]; x++) {
                            
                            NSDictionary *dictsuboptions=[arrContent objectAtIndex:x];
                            
                                [arroptions addObject:dictsuboptions];
                                [[NSUserDefaults standardUserDefaults] setObject:dictsuboptions forKey:[dictsuboptions valueForKey:@"name"]];
                            
                        }
                        [sectionDict setObject:arroptions forKey:@"contents"];

                        [arrCustomDrinks addObject:sectionDict];
                        
                        [sectionDict release];
                        [arroptions release];

                    }
            }
        
        }else{
            
            NSArray *arrsections=[dicmainsections valueForKey:@"sections"];
            for (int j=0; j<[arrsections count]; j++) {
                
                NSDictionary *dictsection=[arrsections objectAtIndex:j];
                for (NSDictionary *dict1Temp in [dictsection valueForKey:@"subsections"]) {
                    
                    for (NSDictionary *dict2Temp in [dict1Temp valueForKey:@"contents"]) {
                        
                        for (NSDictionary *dict3Temp in [dict2Temp valueForKey:@"option_groups"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:dict3Temp forKey:[dict2Temp valueForKey:@"name"]];
                        }
                        
                    }
                }
            }
        }
    }

    /*  NSArray *arrmenues=[[result valueForKey:@"menus"] valueForKey:@"sections"];
        
        for (int j=0; j<[arrmenues count]; j++) {
            
            NSDictionary *dictsection=[arrmenues objectAtIndex:j];
            if ([[dictsection valueForKey:@"section_name"] isEqualToString:@"Spirit"]) {
                
                NSArray *arrsubSection=[dictsection valueForKey:@"subsections"];
                for (int k=0; k<[arrsubSection count];k++) {
                    NSDictionary *dictSubSection=[ arrsubSection objectAtIndex:k];
                    
                    NSMutableDictionary *sectionDict=[[NSMutableDictionary alloc]init];
                    
                    [sectionDict setObject:[NSString stringWithFormat:@"%@->%@",[dictsection valueForKey:@"section_name"],[dictSubSection valueForKey:@"subsection_name"]] forKey:@"section_name"];
                    NSArray *arrContent=[dictSubSection valueForKey:@"contents"];
                    NSMutableArray *arrSubContent=[[NSMutableArray alloc]init];
                    for (int x=0; x<[arrContent count]; x++) {
                        
                        NSDictionary *dictContent=[arrContent objectAtIndex:x];
                        [arrSubContent addObject:dictContent];
                    }
                    
                    [sectionDict setObject:arrSubContent forKey:@"contents"];
                    [arrCustomDrinks addObject:sectionDict];
                    [sectionDict release];
            }
        }
    }*/
}

#pragma mark----------Parsing the getCocktails Data
-(void)ParsinggetCocktails:(id)result{
    
    [arrCocktailsSection removeAllObjects];
    NSArray *arrmenues=[result valueForKey:@"menus"];
    for (int i=0; i<[arrmenues count]; i++) {
        NSDictionary *dicmainsections=[arrmenues objectAtIndex:i];
        
        NSArray *arrsections=[dicmainsections valueForKey:@"sections"];
        for (int j=0; j<[arrsections count]; j++) {
            
            NSDictionary *dictsection=[arrsections objectAtIndex:j];
                
                NSArray *arrsubSection=[dictsection valueForKey:@"subsections"];
                for (int k=0; k<[arrsubSection count];k++) {
                    NSDictionary *dictSubSection=[ arrsubSection objectAtIndex:k];
                    NSMutableDictionary *sectionDict=[[NSMutableDictionary alloc]init];
                    [sectionDict setObject:[NSString stringWithFormat:@"%@",[dicmainsections valueForKey:@"menuName"]] forKey:@"section_name"];
                    NSArray *arrContent=[dictSubSection valueForKey:@"contents"];
                    NSMutableArray *arrSubContent=[[NSMutableArray alloc]init];
                    for (int x=0; x<[arrContent count]; x++) {
                        
                        NSDictionary *dictContent=[arrContent objectAtIndex:x];
                        [arrSubContent addObject:dictContent];
                    }
                    
                    [sectionDict setObject:arrSubContent forKey:@"contents"];
                    [arrCocktailsSection addObject:sectionDict];
                    [sectionDict release];
                    [arrSubContent release];
                }
            }
        }
}

#pragma mark------------Parsing GetFavorites Data
-(void)ParsingGetFavorites:(id)result{
    
    [arrFavorites removeAllObjects];
    NSArray *arrmenues=[result valueForKey:@"menus"];
    for (int i=0; i<[arrmenues count]; i++) {
        NSDictionary *dicmainsections=[arrmenues objectAtIndex:i];
        
        NSArray *arrsections=[dicmainsections valueForKey:@"sections"];
        for (int j=0; j<[arrsections count]; j++) {
            
            NSDictionary *dictsection=[arrsections objectAtIndex:j];
            
            NSArray *arrsubSection=[dictsection valueForKey:@"subsections"];
            for (int k=0; k<[arrsubSection count];k++) {
                NSDictionary *dictSubSection=[ arrsubSection objectAtIndex:k];
                NSMutableDictionary *sectionDict=[[NSMutableDictionary alloc]init];
               
                NSArray *arrContent=[dictSubSection valueForKey:@"contents"];
                NSMutableArray *arrSubContent=[[NSMutableArray alloc]init];
                for (int x=0; x<[arrContent count]; x++) {
                    
                    NSDictionary *dictContent=[arrContent objectAtIndex:x];
                    //[arrSubContent addObject:dictContent];
                    [arrFavorites addObject:dictContent];
                }
                //[sectionDict setObject:arrSubContent forKey:@"contents"];
                //[arrFavorites addObject:sectionDict];
                [sectionDict release];
                [arrSubContent release];
            }
        }
    }
    
}

-(void)ParsingRecentOrders:(id)result{
    
    
    NSArray *arrmenues=[result valueForKey:@"menus"];
    for (int i=0; i<[arrmenues count]; i++) {
        NSDictionary *dicmainsections=[arrmenues objectAtIndex:i];
        
        NSArray *arrsections=[dicmainsections valueForKey:@"sections"];
        for (int j=0; j<[arrsections count]; j++) {
            
            NSDictionary *dictsection=[arrsections objectAtIndex:j];
            
            NSArray *arrsubSection=[dictsection valueForKey:@"subsections"];
            for (int k=0; k<[arrsubSection count];k++) {
                NSDictionary *dictSubSection=[ arrsubSection objectAtIndex:k];
                
                NSArray *arrContent=[dictSubSection valueForKey:@"contents"];
                for (int x=0; x<[arrContent count]; x++) {
                    
                    NSDictionary *dictContent=[arrContent objectAtIndex:x];
                    [arrRecentOrders addObject:dictContent];
                    
                }
                
            }
        }
    }

}
-(void)getPastorderAsynchronously{
    
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/order/getRecentOrders",KServerURL];
    
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] init ];
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];
    [dictCheckIn setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthCode"] forKey:@"oauthCode"];
    
    
    [dictCheckIn setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] forKey:@"bartsyId"];
    [dictCheckIn setObject:[dictVenue objectForKey:@"venueId"] forKey:@"venueId"];
    
    NSLog(@"dict is %@",dictCheckIn);
    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictCheckIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *dataOrder, NSError *error)
     {
         if(error==nil)
         {
             
             SBJSON *jsonParser = [[SBJSON new] autorelease];
             
             NSString *jsonString = [[[NSString alloc] initWithData:dataOrder encoding:NSUTF8StringEncoding] autorelease];
             
             //NSLog(@" JSON String ----- :%@",jsonString);
             
             NSError *outError = nil;
             
             id result = [jsonParser objectWithString:jsonString error:&outError];
             [arrRecentOrders removeAllObjects];
             [self ParsingRecentOrders:result];
             NSLog(@"arrRecentOrders%@",arrPastOrders);
             
            // [arrPastOrders addObjectsFromArray:[result objectForKey:@"pastOrders"]];
               isSelectedForDrinks=YES;
             if(0)//appDelegate.isComingForOrders==YES)
             {
                 UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];

                 appDelegate.isComingForOrders=NO;
                 [arrOrdersTimedOut removeAllObjects];
                 [arrOrdersTimedOut addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"OrdersTimedOut"]];
                 [segmentControl setSelectedSegmentIndex:2];
                 [self segmentControl_ValueChanged:segmentControl];
                 
             }
             else
             if([[[NSUserDefaults standardUserDefaults] objectForKey:[dictVenue objectForKey:@"venueId"]]count]==0)
                 {
                     isLocuMenu=YES;
                     [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
                     [self.sharedController getMenuListWithVenueID:[dictVenue objectForKey:@"venueId"] delegate:self];
                 }
                 else
                 {
                    [self modifyData];
                     //[self createProgressViewToParentView:self.view withTitle:@"Loading..."];
                     //[self.sharedController getMenuListWithVenueID:[dictVenue objectForKey:@"venueId"] delegate:self];
                    /*isGettingIngradients=YES;
                
                    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
                    [self.sharedController getIngredientsListWithVenueId:[dictVenue objectForKey:@"venueId"] delegate:self];*/
                     
                     
                 }
             }


         
         else
         {
             NSLog(@"Error is %@",error);
         }
         
     }
     ];

}
-(void)getPeopleList
{
    
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/data/checkedInUsersList",KServerURL];
    
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[dictVenue objectForKey:@"venueId"],@"venueId",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"],@"bartsyId",nil];
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];
    [dictCheckIn setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthCode"] forKey:@"oauthCode"];

    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictCheckIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *dataOrder, NSError *error)
     {
         if(error==nil)
         {
             SBJSON *jsonParser = [[SBJSON new] autorelease];
             NSString *jsonString = [[[NSString alloc] initWithData:dataOrder encoding:NSUTF8StringEncoding] autorelease];
             id result = [jsonParser objectWithString:jsonString error:nil];
             [arrPeople removeAllObjects];
             [arrPeople addObjectsFromArray:[result objectForKey:@"checkedInUsers"]];
             [appDelegate.arrPeople removeAllObjects];
             [appDelegate.arrPeople addObjectsFromArray:arrPeople];
             UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
             NSString *strOrder=[NSString stringWithFormat:@"People (%i)",[arrPeople count]];
             appDelegate.intPeopleCount=[arrPeople count];
             [segmentControl setTitle:strOrder forSegmentAtIndex:1];
             int i=0;
             for (NSDictionary *dic in appDelegate.arrPeople) {
                 
                 if ([[dic valueForKey:@"hasMessages"] isEqualToString:@"New"]) {
                    
                     i++;
                 }
                 if (i!=0) {
                     [[appDelegate.tabBar.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [NSString stringWithFormat:@"%d",i];
                 }
             
             }
             
             if([appDelegate.arrPeople count])
             {
                 NSDictionary *dictPeople=[appDelegate.arrPeople objectAtIndex:0];
                 NSString *strImagePath=[dictPeople objectForKey:@"userImagePath"];
                 NSString *strImgPath=[strImagePath stringByReplacingOccurrencesOfString:[dictPeople objectForKey:@"bartsyId"] withString:@""];
                 [[NSUserDefaults standardUserDefaults]setObject:strImgPath forKey:@"ImagePath"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
             }
         }
         else
         {
             NSLog(@"Error is %@",error);
         }
         
     }
     ];

    
    [url release];
    [request release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==225&&buttonIndex==1)
    {
        
        
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]!=nil)
        {
            isUserCheckOut=YES;
            isRequestCheckin=NO;
            isRequestForGettingsOrders=NO;
            isRequestForGettingsPastOrders=NO;
            isRequestForPeople=NO;
            isRequestForOrder=NO;
            isGettingCocktails=NO;
            isGettingIngradients=NO;
            self.sharedController=[SharedController sharedController];
            [self createProgressViewToParentView:self.view withTitle:@"Checkout..."];

            [self.sharedController checkOutAtBartsyVenueWithId:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] delegate:self];

        }
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"CheckInVenueId"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"OrdersTimedOut"];
        //[[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"bartsyId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"percentTAX"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [appDelegate stopTimerForHeartBeat];
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"logOut" object:nil];
    }
}

-(NSString*)getPredicateWithOrderStatus:(NSInteger)intStatus
{
    NSString *strPred;
    if(intStatus==0)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'0'"];
    else if(intStatus==2)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'2'"];
    else if(intStatus==3)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'3'"];
    else if(intStatus==4)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'4'"];
    else if(intStatus==5)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'5'"];
    else if(intStatus==6)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'6'"];
    else if(intStatus==7)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'7'"];
    else if(intStatus==8)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'8'"];
    else
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'9'"];
    
    return strPred;
}

//Showing the Orders on ScrollView
-(void)loadOrdersView
{
    UIScrollView *scrollViewOld=(UIScrollView*)[self.view viewWithTag:987];
    [scrollViewOld removeFromSuperview];
    UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 320)];
    scrollView.tag=987;
    scrollView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:scrollView];
    
    if (IS_IPHONE_5)
    {
        scrollView.frame=CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 410);
    }
    
    if (arrBundledOrders.count==0) {
        
        UILabel *lblItemName = [self createLabelWithTitle:@"No orders\nGo to menu tab to place an order" frame:CGRectMake(30, 50, 250,50) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:5];
        lblItemName.backgroundColor=[UIColor clearColor];
        lblItemName.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:lblItemName];
    }else{

    //NSDictionary *dicttemp= [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"VenueDetails"];

   // NSURL *urlPhoto=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KServerURL,[dicttemp objectForKey:@"venueImagePath"]]];
   // [imgSender setImageWithURL:urlPhoto];
        NSLog(@"%@",arrBundledOrders);
        NSMutableArray *arrTempBundleorders=[[NSMutableArray alloc]init];
        for (int k=0; k<arrBundledOrders.count;k++) {
            NSArray *arrBundledOrdersObject=[arrBundledOrders objectAtIndex:k];
            
            NSDictionary *dict=[arrBundledOrdersObject objectAtIndex:0];
            [arrTempBundleorders addObject:dict];
        }
    NSInteger Xposition=0;
    btnDismiss.titleLabel.font=[UIFont fontWithName:@"MuseoSans-300" size:14.0];
        
        
 #pragma mark-------- Drink Recieved for self or from friend       
         NSString *stringid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] ];
        NSMutableArray *arrOrdersTemp2=[[NSMutableArray alloc]initWithArray:arrTempBundleorders];
        NSPredicate *pred2=[NSPredicate predicateWithFormat:@"(recieverBartsyId ==%@)",stringid];
        [arrOrdersTemp2 filterUsingPredicate:pred2];
        if (arrOrdersTemp2.count) {
            UIScrollView *scrollCodeView=[[[NSBundle mainBundle] loadNibNamed:@"OrdersView" owner:self options:nil] objectAtIndex:0];
            scrollCodeView.frame=CGRectMake(0,Xposition, 320, 118);
            [scrollView addSubview:scrollCodeView];
            Xposition+=118;
            NSDictionary *dicttemp= [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"VenueDetails"];
            
             NSURL *urlPhoto=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KServerURL,[dicttemp objectForKey:@"venueImagePath"]]];
            [imgSender setImageWithURL:urlPhoto];
        }
        
        for (int i=0; i<arrOrdersTemp2.count; i++) {
            
            NSDictionary *dict=[arrOrdersTemp2 objectAtIndex:i];

            
           /* NSURL *urlPhoto=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KServerURL,[dict objectForKey:@"recipientImagePath"]]];
            [imgSender setImageWithURL:urlPhoto];*/
            lblOrderCode.font=[UIFont fontWithName:@"MuseoSans-300" size:62.0];
            
            lblOrderCode.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"userSessionCode"]];
            lblPickInfo.font=[UIFont fontWithName:@"MuseoSans-100" size:10.0];
            lblOrderCode.textColor = [UIColor colorWithRed:0.98f green:0.223f blue:0.709f alpha:1.0];
            
            UIView *innerView = [[[NSBundle mainBundle] loadNibNamed:@"OrdersView" owner:self options:nil] objectAtIndex:1];
            innerView.backgroundColor=[self getTheColorForOrderStatus:[[dict objectForKey:@"orderStatus"] integerValue]];
            
            //innerView.frame=CGRectMake(0, Xposition, 320, 159);
            lblOrderStatus.text=[self getTheStatusMessageForOrder:dict];
            lblOrderStatus.font=[UIFont fontWithName:@"MuseoSans-300" size:14.0];
            
            
            if([[dict objectForKey:@"orderStatus"] integerValue]==1||[[dict objectForKey:@"orderStatus"] integerValue]==4||[[dict objectForKey:@"orderStatus"] integerValue]==5||[[dict objectForKey:@"orderStatus"] integerValue]==6||[[dict objectForKey:@"orderStatus"] integerValue]==7||[[dict objectForKey:@"orderStatus"] integerValue]==8)
            {
                btnDismiss.hidden=NO;
                btnDismiss.titleLabel.font=[UIFont fontWithName:@"MuseoSans-300" size:14.0];
                
            }else{
                btnDismiss.hidden=YES;
            }
            btnDismiss.tag=i;
            
            lblOrderID.text = [NSString stringWithFormat:@"#%@",[dict objectForKey:@"orderId"]];
            lblOrderID.textColor = [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] ;
            lblOrderID.font=[UIFont fontWithName:@"MuseoSans-100" size:15.0];
            //Calculating the number of minutes from ordered time
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat       = @"dd MM yyyy HH:mm:ssZZZ";
            NSDate *indate   = [dateFormatter dateFromString:[dict objectForKey:@"orderTime"]];
            dateFormatter.dateFormat = @"dd MM yyyy HH:mm:ssZZZ";
            NSDate *outDate=[dateFormatter dateFromString:[dict objectForKey:@"currentTime"]];
            NSTimeInterval distanceBetweenDates = [outDate timeIntervalSinceDate:indate];
            
            NSInteger minutes = floor(distanceBetweenDates/60);
            NSString *minlength=[NSString stringWithFormat:@"%d",minutes];
            [dateFormatter release];
            
            lblPlacedtime.font=[UIFont fontWithName:@"Museo Sans" size:10.0];
            lblPlacedtime.text = [NSString stringWithFormat:@"Placed: %d mins ago",minutes];
            lblPlacedtime.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: lblPlacedtime.attributedText];
            [text addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] range: NSMakeRange(7, minlength.length+10)];
            [lblPlacedtime setAttributedText: text];
            [text release];
            
            lblExpires.font=[UIFont fontWithName:@"Museo Sans" size:10.0];
            lblExpires.text = [NSString stringWithFormat:@"Expires:%@",@"<15 min"];
            lblExpires.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrg = [[NSMutableAttributedString alloc] initWithAttributedString: lblExpires.attributedText];
            [attribstrg addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] range: NSMakeRange(8, 7)];
            [lblExpires setAttributedText: attribstrg];
            [attribstrg release];
            
            float floatPrice=0;
            float floatTotalPrice=0;
            float floatTaxFee=0;
            float floattipvalue=0;
            
            for (int j=0; j<[[dict objectForKey:@"itemsList"] count]; j++)
            {
                NSDictionary *dictTempOrder=[[dict objectForKey:@"itemsList"] objectAtIndex:j];
                
                
                lblIOrdertemName.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"itemName"]];
                lblIOrdertemName.font=[UIFont fontWithName:@"MuseoSans-300" size:12.0];
                if ([dictTempOrder objectForKey:@"options_description"]) {
                    lblOrderOpt_Desp.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"options_description"]];
                }else if([dictTempOrder objectForKey:@"description"]){
                    lblOrderOpt_Desp.text =[dictTempOrder objectForKey:@"description"];
                }
                
                lblOrderOpt_Desp.textColor = [UIColor colorWithRed:191.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0] ;
                lblOrderOpt_Desp.font=[UIFont fontWithName:@"MuseoSans-100" size:12.0];
                
                
                lblItemPrice.text = [NSString stringWithFormat:@"$%.2f",[[dictTempOrder objectForKey:@"price"] floatValue]];
                lblItemPrice.textColor = [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] ;
                lblItemPrice.font=[UIFont fontWithName:@"MuseoSans-100" size:12.0];
                
                floatTotalPrice=[[dict objectForKey:@"totalPrice"]floatValue];
                floatPrice=[[dict objectForKey:@"basePrice"] integerValue];
                if([[dict objectForKey:@"senderBartsyId"]doubleValue]!=[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]&&[[dictTempOrder objectForKey:@"orderStatus"] integerValue]!=9)
                {
                    lblItemPrice.text=@"-";
                }
            }
            
            lblOrderTip.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            floattipvalue= [[dict objectForKey:@"tipPercentage"] floatValue];
            if(floattipvalue>0.01)
            {
                lblOrderTip.text = [NSString stringWithFormat:@"Tip: $%.2f",floattipvalue];
            }
            else
                lblOrderTip.text = [NSString stringWithFormat:@"Tip: -"];
            
            lblOrderTip.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            
            NSMutableAttributedString *attribstrgTIP = [[NSMutableAttributedString alloc] initWithAttributedString: lblOrderTip.attributedText];
            [attribstrgTIP addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(lblOrderTip.text.length-sizeof(floattipvalue)-1,sizeof(floattipvalue)+1 )];
            [lblOrderTip setAttributedText: attribstrgTIP];
            [attribstrgTIP release];
            
            lblOrderTax.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            floatTaxFee=floatTotalPrice-(floattipvalue+floatPrice);
            if(floatTaxFee>0.01)
            {
                lblOrderTax.text = [NSString stringWithFormat:@"Tax: $%.2f",floatTaxFee];
            }
            else
                lblOrderTax.text = [NSString stringWithFormat:@"Tax: -"];
            lblOrderTax.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrgTAX = [[NSMutableAttributedString alloc] initWithAttributedString: lblOrderTax.attributedText];
            [attribstrgTAX addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(lblOrderTax.text.length-sizeof(floatTaxFee)-1,sizeof(floatTaxFee)+1 )];
            [lblOrderTax setAttributedText: attribstrgTAX];
            [attribstrgTAX release];
            
            NSString *ttpricelenght=[NSString stringWithFormat:@"%.2f",floatTotalPrice];
            
            
            lblOrderTotal.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            if(floatTotalPrice>0.01)
                lblOrderTotal.text = [NSString stringWithFormat:@"Total:$%.2f",floatTotalPrice];
            else
                lblOrderTotal.text = [NSString stringWithFormat:@"Total:-"];
            lblOrderTotal.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrgTP = [[NSMutableAttributedString alloc] initWithAttributedString: lblOrderTotal.attributedText];
            [attribstrgTP addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(6,ttpricelenght.length+1 )];
            [lblOrderTotal setAttributedText: attribstrgTP];
            [attribstrgTP release];
            //Accept and Reject Buttons
            btnAccept.tag=i;
            btnReject.tag=i;
            if([[dict objectForKey:@"orderStatus"] integerValue]==9&&[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]==[[dict objectForKey:@"recieverBartsyId"] doubleValue])
            {
                btnAccept.hidden=NO;
                btnReject.hidden=NO;
                innerView.frame=CGRectMake(innerView.frame.origin.x, Xposition, innerView.frame.size.width, innerView.frame.size.height);
                Xposition+=202;
            }else{
                btnAccept.hidden=YES;
                btnReject.hidden=YES;
                innerView.frame=CGRectMake(innerView.frame.origin.x, Xposition, innerView.frame.size.width, innerView.frame.size.height-45);
                Xposition+=153;
                
            }
            
            
            [scrollView addSubview:innerView];
        }
        
        [arrOrdersTemp2 release];
#pragma mark--------Sending Drink to friend
        NSMutableArray *arrOrdersSent=[[NSMutableArray alloc]initWithArray:arrTempBundleorders];
        NSPredicate *pred=[NSPredicate predicateWithFormat:@"(recieverBartsyId !=%@)",stringid];
        [arrOrdersSent filterUsingPredicate:pred];
        
        for (int i=0; i<arrOrdersSent.count; i++){
            
            
            NSDictionary *dict=[arrOrdersSent objectAtIndex:i];
            UIView *innerView = [[[NSBundle mainBundle] loadNibNamed:@"OrdersView" owner:self options:nil] objectAtIndex:2];
            innerView.backgroundColor=[self getTheColorForOrderStatus:[[dict objectForKey:@"orderStatus"] integerValue]];
            
            innerView.frame=CGRectMake(0, Xposition, 320, 211);
            lblfOrderStatus.text=[self getTheStatusMessageForOrder:dict];
            lblfOrderStatus.font=[UIFont fontWithName:@"MuseoSans-300" size:14.0];
            
            
            if([[dict objectForKey:@"orderStatus"] integerValue]==1||[[dict objectForKey:@"orderStatus"] integerValue]==4||[[dict objectForKey:@"orderStatus"] integerValue]==5||[[dict objectForKey:@"orderStatus"] integerValue]==6||[[dict objectForKey:@"orderStatus"] integerValue]==7||[[dict objectForKey:@"orderStatus"] integerValue]==8)
            {
                btnfDismiss.hidden=NO;
                btnfDismiss.titleLabel.font=[UIFont fontWithName:@"MuseoSans-300" size:14.0];
            }else{
                btnfDismiss.hidden=YES;
            }
            btnfDismiss.tag=i;
            
            lblfOrderID.text = [NSString stringWithFormat:@"#%@",[dict objectForKey:@"orderId"]];
            lblfOrderID.textColor = [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] ;
            lblfOrderID.font=[UIFont fontWithName:@"MuseoSans-100" size:15.0];
            //Calculating the number of minutes from ordered time
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat       = @"dd MM yyyy HH:mm:ssZZZ";
            NSDate *indate   = [dateFormatter dateFromString:[dict objectForKey:@"orderTime"]];
            dateFormatter.dateFormat = @"dd MM yyyy HH:mm:ssZZZ";
            NSDate *outDate=[dateFormatter dateFromString:[dict objectForKey:@"currentTime"]];
            NSTimeInterval distanceBetweenDates = [outDate timeIntervalSinceDate:indate];
            
            NSInteger minutes = floor(distanceBetweenDates/60);
            NSString *minlength=[NSString stringWithFormat:@"%d",minutes];
            [dateFormatter release];
            
            
            lblfPlacedtime.font=[UIFont fontWithName:@"Museo Sans" size:10.0];
            lblfPlacedtime.text = [NSString stringWithFormat:@"Placed: %d mins ago",minutes];
            lblfPlacedtime.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: lblfPlacedtime.attributedText];
            [text addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] range: NSMakeRange(7, minlength.length+10)];
            [lblfPlacedtime setAttributedText: text];
            [text release];
            
            lblfExpires.font=[UIFont fontWithName:@"Museo Sans" size:10.0];
            lblfExpires.text = [NSString stringWithFormat:@"Expires:%@",@"<15 min"];
            lblfExpires.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrg = [[NSMutableAttributedString alloc] initWithAttributedString: lblfExpires.attributedText];
            [attribstrg addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] range: NSMakeRange(8, 7)];
            [lblfExpires setAttributedText: attribstrg];
            [attribstrg release];
            
            float floatPrice=0;
            float floatTotalPrice=0;
            float floatTaxFee=0;
            float floattipvalue=0;
            
            NSURL *urlPhoto=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KServerURL,[dict objectForKey:@"senderImagePath"]]];
            [Senderimg setImageWithURL:urlPhoto];
            lblfOrdersender.text=[dict objectForKey:@"senderNickname"];
            lblfOrdersender.font=[UIFont fontWithName:@"Museo Sans" size:15.0];
            lblfOrderreciever.text=[dict objectForKey:@"recipientNickname"];
            lblfOrderreciever.font=[UIFont fontWithName:@"Museo Sans" size:15.0];
            NSURL *urlrecPhoto=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KServerURL,[dict objectForKey:@"recipientImagePath"]]];
            [Recieverimg setImageWithURL:urlrecPhoto];
            
            for (int j=0; j<[[dict objectForKey:@"itemsList"] count]; j++)
            {
                NSDictionary *dictTempOrder=[[dict objectForKey:@"itemsList"] objectAtIndex:j];
                
                
                lblfOrdertemName.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"itemName"]];
                lblfOrdertemName.font=[UIFont fontWithName:@"MuseoSans-300" size:12.0];
                if ([dictTempOrder objectForKey:@"options_description"]) {
                    lblfOrderOpt_Desp.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"options_description"]];
                }else if([dictTempOrder objectForKey:@"description"]){
                    lblOrderOpt_Desp.text =[dictTempOrder objectForKey:@"description"];
                }
                
                lblfOrderOpt_Desp.textColor = [UIColor colorWithRed:191.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0] ;
                lblfOrderOpt_Desp.font=[UIFont fontWithName:@"MuseoSans-100" size:12.0];
                
                
                lblfItemPrice.text = [NSString stringWithFormat:@"$%.2f",[[dictTempOrder objectForKey:@"price"] floatValue]];
                lblfItemPrice.textColor = [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] ;
                lblfItemPrice.font=[UIFont fontWithName:@"MuseoSans-100" size:12.0];
                
                floatTotalPrice=[[dict objectForKey:@"totalPrice"]floatValue];
                floatPrice=[[dict objectForKey:@"basePrice"] integerValue];
                if([[dict objectForKey:@"senderBartsyId"]doubleValue]!=[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]&&[[dictTempOrder objectForKey:@"orderStatus"] integerValue]!=9)
                {
                    lblfItemPrice.text=@"-";
                }
            }
            
            lblfOrderTip.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            floattipvalue= [[dict objectForKey:@"tipPercentage"] floatValue];
            if(floattipvalue>0.01)
            {
                lblfOrderTip.text = [NSString stringWithFormat:@"Tip: $%.2f",floattipvalue];
            }
            else
                lblfOrderTip.text = [NSString stringWithFormat:@"Tip: -"];
            
            lblfOrderTip.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            
            NSMutableAttributedString *attribstrgTIP = [[NSMutableAttributedString alloc] initWithAttributedString: lblfOrderTip.attributedText];
            [attribstrgTIP addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(lblfOrderTip.text.length-sizeof(floattipvalue)-1,sizeof(floattipvalue)+1 )];
            [lblfOrderTip setAttributedText: attribstrgTIP];
            [attribstrgTIP release];
            
            lblfOrderTax.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            floatTaxFee=floatTotalPrice-(floattipvalue+floatPrice);
            if(floatTaxFee>0.01)
            {
                lblfOrderTax.text = [NSString stringWithFormat:@"Tax: $%.2f",floatTaxFee];
            }
            else
                lblfOrderTax.text = [NSString stringWithFormat:@"Tax: -"];
            lblfOrderTax.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrgTAX = [[NSMutableAttributedString alloc] initWithAttributedString: lblfOrderTax.attributedText];
            [attribstrgTAX addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(lblfOrderTax.text.length-sizeof(floatTaxFee)-1,sizeof(floatTaxFee)+1 )];
            [lblfOrderTax setAttributedText: attribstrgTAX];
            [attribstrgTAX release];
            
            NSString *ttpricelenght=[NSString stringWithFormat:@"%.2f",floatTotalPrice];
            
            
            lblfOrderTotal.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            if(floatTotalPrice>0.01)
                lblfOrderTotal.text = [NSString stringWithFormat:@"Total:$%.2f",floatTotalPrice];
            else
                lblfOrderTotal.text = [NSString stringWithFormat:@"Total:-"];
            lblfOrderTotal.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrgTP = [[NSMutableAttributedString alloc] initWithAttributedString: lblfOrderTotal.attributedText];
            [attribstrgTP addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(6,ttpricelenght.length+1 )];
            [lblfOrderTotal setAttributedText: attribstrgTP];
            [attribstrgTP release];
            
            
            Xposition+=212;
            [scrollView addSubview:innerView];
        }
        [arrOrdersSent release];
    /*for (int i=0; i<arrBundledOrders.count; i++) {
        NSArray *arrBundledOrdersObject=[arrBundledOrders objectAtIndex:i];
        
        NSDictionary *dict=[arrBundledOrdersObject objectAtIndex:0];
  //Sending and Recieving the Order for self      
        if (([[dict valueForKey:@"recieverBartsyId"] doubleValue] ==[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]doubleValue] && [[dict valueForKey:@"senderBartsyId"]doubleValue ] ==[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]doubleValue] )|| ([[dict valueForKey:@"recieverBartsyId"] doubleValue] ==[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]doubleValue] && [[dict valueForKey:@"senderBartsyId"]doubleValue ] !=[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]doubleValue])) {
            UIScrollView *scrollCodeView=[[[NSBundle mainBundle] loadNibNamed:@"OrdersView" owner:self options:nil] objectAtIndex:0];
            scrollCodeView.frame=CGRectMake(0,Xposition, 320, 118);
            [scrollView addSubview:scrollCodeView];
            NSURL *urlPhoto=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KServerURL,[dict objectForKey:@"recipientImagePath"]]];
            [imgSender setImageWithURL:urlPhoto];
            lblOrderCode.font=[UIFont fontWithName:@"MuseoSans-100" size:62.0];
            
            lblOrderCode.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"userSessionCode"]];
            lblPickInfo.font=[UIFont fontWithName:@"MuseoSans-100" size:10.0];
            lblOrderCode.textColor = [UIColor colorWithRed:0.98f green:0.223f blue:0.709f alpha:1.0];
            Xposition+=118;
            UIView *innerView = [[[NSBundle mainBundle] loadNibNamed:@"OrdersView" owner:self options:nil] objectAtIndex:1];
            innerView.backgroundColor=[self getTheColorForOrderStatus:[[dict objectForKey:@"orderStatus"] integerValue]];
                
            //innerView.frame=CGRectMake(0, Xposition, 320, 159);
            lblOrderStatus.text=[self getTheStatusMessageForOrder:dict];
            lblOrderStatus.font=[UIFont fontWithName:@"MuseoSans-300" size:14.0];

           
            if([[dict objectForKey:@"orderStatus"] integerValue]==1||[[dict objectForKey:@"orderStatus"] integerValue]==4||[[dict objectForKey:@"orderStatus"] integerValue]==5||[[dict objectForKey:@"orderStatus"] integerValue]==6||[[dict objectForKey:@"orderStatus"] integerValue]==7||[[dict objectForKey:@"orderStatus"] integerValue]==8)
            {
                btnDismiss.hidden=NO;
                btnDismiss.titleLabel.font=[UIFont fontWithName:@"MuseoSans-300" size:14.0];

            }else{
                btnDismiss.hidden=YES;
            }
            
            
            lblOrderID.text = [NSString stringWithFormat:@"#%@",[dict objectForKey:@"orderId"]];
            lblOrderID.textColor = [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] ;
            lblOrderID.font=[UIFont fontWithName:@"MuseoSans-100" size:15.0];
            //Calculating the number of minutes from ordered time
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat       = @"dd MM yyyy HH:mm:ssZZZ";
            NSDate *indate   = [dateFormatter dateFromString:[dict objectForKey:@"orderTime"]];
            dateFormatter.dateFormat = @"dd MM yyyy HH:mm:ssZZZ";
            NSDate *outDate=[dateFormatter dateFromString:[dict objectForKey:@"currentTime"]];
            NSTimeInterval distanceBetweenDates = [outDate timeIntervalSinceDate:indate];
            
            NSInteger minutes = floor(distanceBetweenDates/60);
            NSString *minlength=[NSString stringWithFormat:@"%d",minutes];
            [dateFormatter release];
            
            lblPlacedtime.font=[UIFont fontWithName:@"Museo Sans" size:10.0];
            lblPlacedtime.text = [NSString stringWithFormat:@"Placed: %d mins ago",minutes];
            lblPlacedtime.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: lblPlacedtime.attributedText];
            [text addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] range: NSMakeRange(7, minlength.length+10)];
            [lblPlacedtime setAttributedText: text];
            [text release];
            
            lblExpires.font=[UIFont fontWithName:@"Museo Sans" size:10.0];
            lblExpires.text = [NSString stringWithFormat:@"Expires:%@",@"<15 min"];
            lblExpires.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrg = [[NSMutableAttributedString alloc] initWithAttributedString: lblExpires.attributedText];
            [attribstrg addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] range: NSMakeRange(8, 7)];
            [lblExpires setAttributedText: attribstrg];
            [attribstrg release];
            
            float floatPrice=0;
            float floatTotalPrice=0;
            float floatTaxFee=0;
            float floattipvalue=0;
            
            for (int j=0; j<[[dict objectForKey:@"itemsList"] count]; j++)
            {
                NSDictionary *dictTempOrder=[[dict objectForKey:@"itemsList"] objectAtIndex:j];
                
                
                lblIOrdertemName.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"itemName"]];
                lblIOrdertemName.font=[UIFont fontWithName:@"MuseoSans-300" size:12.0];
                if ([dictTempOrder objectForKey:@"options_description"]) {
                    lblOrderOpt_Desp.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"options_description"]];
                }else{
                    lblOrderOpt_Desp.text =@"";
                }
                
                lblOrderOpt_Desp.textColor = [UIColor colorWithRed:191.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0] ;
                lblOrderOpt_Desp.font=[UIFont fontWithName:@"MuseoSans-100" size:12.0];
                
                
                lblItemPrice.text = [NSString stringWithFormat:@"$%.2f",[[dictTempOrder objectForKey:@"price"] floatValue]];
                lblItemPrice.textColor = [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] ;
                lblItemPrice.font=[UIFont fontWithName:@"MuseoSans-100" size:12.0];
                
                floatTotalPrice=[[dict objectForKey:@"totalPrice"]floatValue];
                floatPrice=[[dict objectForKey:@"basePrice"] integerValue];
                if([[dict objectForKey:@"senderBartsyId"]doubleValue]!=[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]&&[[dictTempOrder objectForKey:@"orderStatus"] integerValue]!=9)
                {
                    lblItemPrice.text=@"-";
                }
            }
            
            lblOrderTip.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            floattipvalue= [[dict objectForKey:@"tipPercentage"] floatValue];
            if(floattipvalue>0.01)
            {
                lblOrderTip.text = [NSString stringWithFormat:@"Tip: $%.2f",floattipvalue];
            }
            else
                lblOrderTip.text = [NSString stringWithFormat:@"Tip: -"];
            
            lblOrderTip.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            
            NSMutableAttributedString *attribstrgTIP = [[NSMutableAttributedString alloc] initWithAttributedString: lblOrderTip.attributedText];
            [attribstrgTIP addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(lblOrderTip.text.length-sizeof(floattipvalue)-1,sizeof(floattipvalue)+1 )];
            [lblOrderTip setAttributedText: attribstrgTIP];
            [attribstrgTIP release];
            
            lblOrderTax.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            floatTaxFee=floatTotalPrice-(floattipvalue+floatPrice);
            if(floatTaxFee>0.01)
            {
                lblOrderTax.text = [NSString stringWithFormat:@"Tax: $%.2f",floatTaxFee];
            }
            else
                lblOrderTax.text = [NSString stringWithFormat:@"Tax: -"];
            lblOrderTax.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrgTAX = [[NSMutableAttributedString alloc] initWithAttributedString: lblOrderTax.attributedText];
            [attribstrgTAX addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(lblOrderTax.text.length-sizeof(floatTaxFee)-1,sizeof(floatTaxFee)+1 )];
            [lblOrderTax setAttributedText: attribstrgTAX];
            [attribstrgTAX release];
            
            NSString *ttpricelenght=[NSString stringWithFormat:@"%.2f",floatTotalPrice];
            
            
            lblOrderTotal.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            if(floatTotalPrice>0.01)
                lblOrderTotal.text = [NSString stringWithFormat:@"Total:$%.2f",floatTotalPrice];
            else
                lblOrderTotal.text = [NSString stringWithFormat:@"Total:-"];
            lblOrderTotal.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrgTP = [[NSMutableAttributedString alloc] initWithAttributedString: lblOrderTotal.attributedText];
            [attribstrgTP addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(6,ttpricelenght.length+1 )];
            [lblOrderTotal setAttributedText: attribstrgTP];
            [attribstrgTP release];
    //Accept and Reject Buttons
            btnAccept.tag=i;
            btnReject.tag=i;
            if([[dict objectForKey:@"orderStatus"] integerValue]==9&&[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]==[[dict objectForKey:@"recieverBartsyId"] doubleValue])
            {
                btnAccept.hidden=NO;
                btnReject.hidden=NO;
                innerView.frame=CGRectMake(innerView.frame.origin.x, Xposition, innerView.frame.size.width, innerView.frame.size.height);
                 Xposition+=202;
            }else{
                btnAccept.hidden=YES;
                btnReject.hidden=YES;
                innerView.frame=CGRectMake(innerView.frame.origin.x, Xposition, innerView.frame.size.width, innerView.frame.size.height-45);
                Xposition+=153;

            }

            
            [scrollView addSubview:innerView];
           

            
        }
        else if ([[dict valueForKey:@"recieverBartsyId"] doubleValue] !=[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]doubleValue] && [[dict valueForKey:@"senderBartsyId"]doubleValue ] ==[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]doubleValue]){
//Sending the Order to friend
            UIView *innerView = [[[NSBundle mainBundle] loadNibNamed:@"OrdersView" owner:self options:nil] objectAtIndex:2];
            innerView.backgroundColor=[self getTheColorForOrderStatus:[[dict objectForKey:@"orderStatus"] integerValue]];
            
            innerView.frame=CGRectMake(0, Xposition, 320, 211);
            lblfOrderStatus.text=[self getTheStatusMessageForOrder:dict];
            lblfOrderStatus.font=[UIFont fontWithName:@"MuseoSans-300" size:14.0];

            
            if([[dict objectForKey:@"orderStatus"] integerValue]==1||[[dict objectForKey:@"orderStatus"] integerValue]==4||[[dict objectForKey:@"orderStatus"] integerValue]==5||[[dict objectForKey:@"orderStatus"] integerValue]==6||[[dict objectForKey:@"orderStatus"] integerValue]==7||[[dict objectForKey:@"orderStatus"] integerValue]==8)
            {
                btnfDismiss.hidden=NO;
                btnfDismiss.titleLabel.font=[UIFont fontWithName:@"MuseoSans-300" size:14.0];
            }else{
                btnfDismiss.hidden=YES;
            }
            
            
            lblfOrderID.text = [NSString stringWithFormat:@"#%@",[dict objectForKey:@"orderId"]];
            lblfOrderID.textColor = [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] ;
            lblfOrderID.font=[UIFont fontWithName:@"MuseoSans-100" size:15.0];
            //Calculating the number of minutes from ordered time
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat       = @"dd MM yyyy HH:mm:ssZZZ";
            NSDate *indate   = [dateFormatter dateFromString:[dict objectForKey:@"orderTime"]];
            dateFormatter.dateFormat = @"dd MM yyyy HH:mm:ssZZZ";
            NSDate *outDate=[dateFormatter dateFromString:[dict objectForKey:@"currentTime"]];
            NSTimeInterval distanceBetweenDates = [outDate timeIntervalSinceDate:indate];
            
            NSInteger minutes = floor(distanceBetweenDates/60);
            NSString *minlength=[NSString stringWithFormat:@"%d",minutes];
            [dateFormatter release];
            
            
            lblfPlacedtime.font=[UIFont fontWithName:@"Museo Sans" size:10.0];
            lblfPlacedtime.text = [NSString stringWithFormat:@"Placed: %d mins ago",minutes];
            lblfPlacedtime.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: lblfPlacedtime.attributedText];
            [text addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] range: NSMakeRange(7, minlength.length+10)];
            [lblfPlacedtime setAttributedText: text];
            [text release];
            
            lblfExpires.font=[UIFont fontWithName:@"Museo Sans" size:10.0];
            lblfExpires.text = [NSString stringWithFormat:@"Expires:%@",@"<15 min"];
            lblfExpires.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrg = [[NSMutableAttributedString alloc] initWithAttributedString: lblfExpires.attributedText];
            [attribstrg addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] range: NSMakeRange(8, 7)];
            [lblfExpires setAttributedText: attribstrg];
            [attribstrg release];
            
            float floatPrice=0;
            float floatTotalPrice=0;
            float floatTaxFee=0;
            float floattipvalue=0;
            
            NSURL *urlPhoto=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KServerURL,[dict objectForKey:@"senderImagePath"]]];
            [Senderimg setImageWithURL:urlPhoto];
            lblfOrdersender.text=[dict objectForKey:@"senderNickname"];
            lblfOrdersender.font=[UIFont fontWithName:@"Museo Sans" size:15.0];
            lblfOrderreciever.text=[dict objectForKey:@"recipientNickname"];
            lblfOrderreciever.font=[UIFont fontWithName:@"Museo Sans" size:15.0];
            NSURL *urlrecPhoto=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KServerURL,[dict objectForKey:@"recipientImagePath"]]];
            [Recieverimg setImageWithURL:urlrecPhoto];
            
            for (int j=0; j<[[dict objectForKey:@"itemsList"] count]; j++)
            {
                NSDictionary *dictTempOrder=[[dict objectForKey:@"itemsList"] objectAtIndex:j];
                
                
                lblfOrdertemName.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"itemName"]];
                lblfOrdertemName.font=[UIFont fontWithName:@"MuseoSans-300" size:12.0];
                if ([dictTempOrder objectForKey:@"options_description"]) {
                    lblfOrderOpt_Desp.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"options_description"]];
                }else{
                    lblfOrderOpt_Desp.text =@"";
                }
                
                lblfOrderOpt_Desp.textColor = [UIColor colorWithRed:191.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0] ;
                lblfOrderOpt_Desp.font=[UIFont fontWithName:@"MuseoSans-100" size:12.0];
                
                
                lblfItemPrice.text = [NSString stringWithFormat:@"$%.2f",[[dictTempOrder objectForKey:@"price"] floatValue]];
                lblfItemPrice.textColor = [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] ;
                lblfItemPrice.font=[UIFont fontWithName:@"MuseoSans-100" size:12.0];
                
                floatTotalPrice=[[dict objectForKey:@"totalPrice"]floatValue];
                floatPrice=[[dict objectForKey:@"basePrice"] integerValue];
                if([[dict objectForKey:@"senderBartsyId"]doubleValue]!=[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]&&[[dictTempOrder objectForKey:@"orderStatus"] integerValue]!=9)
                {
                    lblfItemPrice.text=@"-";
                }
            }
            
            lblfOrderTip.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            floattipvalue= [[dict objectForKey:@"tipPercentage"] floatValue];
            if(floattipvalue>0.01)
            {
                lblfOrderTip.text = [NSString stringWithFormat:@"Tip: $%.2f",floattipvalue];
            }
            else
                lblfOrderTip.text = [NSString stringWithFormat:@"Tip: -"];
            
            lblfOrderTip.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            
            NSMutableAttributedString *attribstrgTIP = [[NSMutableAttributedString alloc] initWithAttributedString: lblfOrderTip.attributedText];
            [attribstrgTIP addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(lblfOrderTip.text.length-sizeof(floattipvalue)-1,sizeof(floattipvalue)+1 )];
            [lblfOrderTip setAttributedText: attribstrgTIP];
            [attribstrgTIP release];
            
            lblfOrderTax.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            floatTaxFee=floatTotalPrice-(floattipvalue+floatPrice);
            if(floatTaxFee>0.01)
            {
                lblfOrderTax.text = [NSString stringWithFormat:@"Tax: $%.2f",floatTaxFee];
            }
            else
                lblfOrderTax.text = [NSString stringWithFormat:@"Tax: -"];
            lblfOrderTax.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrgTAX = [[NSMutableAttributedString alloc] initWithAttributedString: lblfOrderTax.attributedText];
            [attribstrgTAX addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(lblfOrderTax.text.length-sizeof(floatTaxFee)-1,sizeof(floatTaxFee)+1 )];
            [lblfOrderTax setAttributedText: attribstrgTAX];
            [attribstrgTAX release];
            
            NSString *ttpricelenght=[NSString stringWithFormat:@"%.2f",floatTotalPrice];
            
            
            lblfOrderTotal.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            if(floatTotalPrice>0.01)
                lblfOrderTotal.text = [NSString stringWithFormat:@"Total:$%.2f",floatTotalPrice];
            else
                lblfOrderTotal.text = [NSString stringWithFormat:@"Total:-"];
            lblfOrderTotal.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrgTP = [[NSMutableAttributedString alloc] initWithAttributedString: lblfOrderTotal.attributedText];
            [attribstrgTP addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(6,ttpricelenght.length+1 )];
            [lblfOrderTotal setAttributedText: attribstrgTP];
            [attribstrgTP release];
            

            Xposition+=212;
            [scrollView addSubview:innerView];
        }
        
    }*/
   
        scrollView.contentSize=CGSizeMake(320, Xposition);
        [scrollView release];
        
        [arrTempBundleorders release];
    }

   /* NSString *stringid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] ];
    NSMutableArray *arrOrdersTemp2=[[NSMutableArray alloc]initWithArray:arrBundledOrders];
     NSPredicate *pred2=[NSPredicate predicateWithFormat:@"NOT (recieverBartsyId ==%@)",stringid];
    [arrOrdersTemp2 filterUsingPredicate:pred2];
        
    for (int i=0; i<[arrOrdersTemp2 count]; i++)
    {
        NSArray *arrBundledOrdersObject=[arrOrdersTemp2 objectAtIndex:i];
            
        NSDictionary *dict=[arrBundledOrdersObject objectAtIndex:0];
        if([[dict objectForKey:@"orderStatus"] integerValue]==9&&[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]==[[dict objectForKey:@"recieverBartsyId"] doubleValue])
        {
                btnAccept.hidden=NO;
                btnReject.hidden=NO;
                
        }else{
                btnAccept.hidden=YES;
                btnReject.hidden=YES;
               
        }
        UIView *innerView;
        
        if([[dict objectForKey:@"senderBartsyId"] doubleValue]==[[dict objectForKey:@"recieverBartsyId"] doubleValue])
            {
                innerView = [[[NSBundle mainBundle] loadNibNamed:@"OrdersView" owner:self options:nil] objectAtIndex:1];
                innerView.backgroundColor=[self getTheColorForOrderStatus:[[dict objectForKey:@"orderStatus"] integerValue]];
                
                innerView.frame=CGRectMake(0, 125, 320, 144);
                lblOrderStatus.text=[self getTheStatusMessageForOrder:dict];
                
        }
            
        if([[dict objectForKey:@"orderStatus"] integerValue]==1||[[dict objectForKey:@"orderStatus"] integerValue]==4||[[dict objectForKey:@"orderStatus"] integerValue]==5||[[dict objectForKey:@"orderStatus"] integerValue]==6||[[dict objectForKey:@"orderStatus"] integerValue]==7||[[dict objectForKey:@"orderStatus"] integerValue]==8)
            {
                btnDismiss.hidden=NO;
            }else{
                btnDismiss.hidden=YES;
            }
            
            lblOrderCode.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"userSessionCode"]];
            lblOrderCode.textColor = [UIColor colorWithRed:0.98f green:0.223f blue:0.709f alpha:1.0];
            lblOrderCode.font=[UIFont fontWithName:@"MuseoSans-100" size:62.0];
            
            lblOrderID.text = [NSString stringWithFormat:@"#%@",[dict objectForKey:@"orderId"]];
            lblOrderID.textColor = [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] ;
            lblOrderID.font=[UIFont fontWithName:@"MuseoSans-100" size:15.0];
            //Calculating the number of minutes from ordered time
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat       = @"dd MM yyyy HH:mm:ssZZZ";
            NSDate *indate   = [dateFormatter dateFromString:[dict objectForKey:@"orderTime"]];
            dateFormatter.dateFormat = @"dd MM yyyy HH:mm:ssZZZ";
            NSDate *outDate=[dateFormatter dateFromString:[dict objectForKey:@"currentTime"]];
            NSTimeInterval distanceBetweenDates = [outDate timeIntervalSinceDate:indate];
            
            NSInteger minutes = floor(distanceBetweenDates/60);
            NSString *minlength=[NSString stringWithFormat:@"%d",minutes];
            [dateFormatter release];
            
            lblPlacedtime.font=[UIFont fontWithName:@"Museo Sans" size:10.0];
            lblPlacedtime.text = [NSString stringWithFormat:@"Placed: %d mins ago",minutes];
            lblPlacedtime.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: lblPlacedtime.attributedText];
            [text addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] range: NSMakeRange(7, minlength.length+10)];
            [lblPlacedtime setAttributedText: text];
            [text release];
            
            lblExpires.font=[UIFont fontWithName:@"Museo Sans" size:10.0];
            lblExpires.text = [NSString stringWithFormat:@"Expires:%@",@"<15 min"];
            lblExpires.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrg = [[NSMutableAttributedString alloc] initWithAttributedString: lblExpires.attributedText];
            [attribstrg addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] range: NSMakeRange(8, 7)];
            [lblExpires setAttributedText: attribstrg];
            [attribstrg release];
            
            
            float floatPrice=0;
            float floatTotalPrice=0;
            float floatTaxFee=0;
            float floattipvalue=0;

            for (int j=0; j<[[dict objectForKey:@"itemsList"] count]; j++)
            {
                NSDictionary *dictTempOrder=[[dict objectForKey:@"itemsList"] objectAtIndex:j];
                
        
                lblIOrdertemName.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"itemName"]];
                lblIOrdertemName.font=[UIFont fontWithName:@"MuseoSans-300" size:12.0];
                if ([dictTempOrder objectForKey:@"options_description"]) {
                    lblOrderOpt_Desp.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"options_description"]];
                }else{
                    lblOrderOpt_Desp.text =@"";
                }
                
                lblOrderOpt_Desp.textColor = [UIColor colorWithRed:191.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0] ;
                lblOrderOpt_Desp.font=[UIFont fontWithName:@"MuseoSans-100" size:12.0];
                
                
                lblItemPrice.text = [NSString stringWithFormat:@"$%.2f",[[dictTempOrder objectForKey:@"price"] floatValue]];
                lblItemPrice.textColor = [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] ;
                lblItemPrice.font=[UIFont fontWithName:@"MuseoSans-100" size:12.0];
                
                floatTotalPrice=[[dict objectForKey:@"totalPrice"]floatValue];
                floatPrice=[[dict objectForKey:@"basePrice"] integerValue];
                if([[dict objectForKey:@"senderBartsyId"]doubleValue]!=[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]&&[[dictTempOrder objectForKey:@"orderStatus"] integerValue]!=9)
                {
                    lblItemPrice.text=@"-";
                }
            }
            
            lblOrderTip.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            floattipvalue= [[dict objectForKey:@"tipPercentage"] floatValue];
            if(floattipvalue>0.01)
            {
                lblOrderTip.text = [NSString stringWithFormat:@"Tip: $%.2f",floattipvalue];
            }
            else
                lblOrderTip.text = [NSString stringWithFormat:@"Tip: -"];
            
            lblOrderTip.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            
            NSMutableAttributedString *attribstrgTIP = [[NSMutableAttributedString alloc] initWithAttributedString: lblOrderTip.attributedText];
            [attribstrgTIP addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(lblOrderTip.text.length-sizeof(floattipvalue)-1,sizeof(floattipvalue)+1 )];
            [lblOrderTip setAttributedText: attribstrgTIP];
            [attribstrgTIP release];
            
            lblOrderTax.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            floatTaxFee=floatTotalPrice-(floattipvalue+floatPrice);
            if(floatTaxFee>0.01)
            {
                lblOrderTax.text = [NSString stringWithFormat:@"Tax: $%.2f",floatTaxFee];
            }
            else
                lblOrderTax.text = [NSString stringWithFormat:@"Tax: -"];
            lblOrderTax.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrgTAX = [[NSMutableAttributedString alloc] initWithAttributedString: lblOrderTax.attributedText];
            [attribstrgTAX addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(lblOrderTax.text.length-sizeof(floatTaxFee)-1,sizeof(floatTaxFee)+1 )];
            [lblOrderTax setAttributedText: attribstrgTAX];
            [attribstrgTAX release];
            
            NSString *ttpricelenght=[NSString stringWithFormat:@"%.2f",floatTotalPrice];
            
            
            lblOrderTotal.font=[UIFont fontWithName:@"MuseoSans-100" size:11.0];
            if(floatTotalPrice>0.01)
                lblOrderTotal.text = [NSString stringWithFormat:@"Total:$%.2f",floatTotalPrice];
            else
                lblOrderTotal.text = [NSString stringWithFormat:@"Total:-"];
            lblOrderTotal.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
            NSMutableAttributedString *attribstrgTP = [[NSMutableAttributedString alloc] initWithAttributedString: lblOrderTotal.attributedText];
            [attribstrgTP addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(6,ttpricelenght.length+1 )];
            [lblOrderTotal setAttributedText: attribstrgTP];
            [attribstrgTP release];
            
            [scrollView addSubview:innerView];
            
    }*/
    
}

-(IBAction)btnDismiss_TouchUpInside:(UIButton*)sender
{
    NSMutableArray *arrTempBundleorders=[[NSMutableArray alloc]init];
    for (int k=0; k<arrBundledOrders.count;k++) {
        NSArray *arrBundledOrdersObject=[arrBundledOrders objectAtIndex:k];
        
        NSDictionary *dict=[arrBundledOrdersObject objectAtIndex:0];
        [arrTempBundleorders addObject:dict];
    }
    
    NSString *stringid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] ];
    NSMutableArray *arrOrdersFilter=[[NSMutableArray alloc]initWithArray:arrTempBundleorders];
    NSPredicate *pred2=[NSPredicate predicateWithFormat:@"(recieverBartsyId ==%@)",stringid];
    [arrOrdersFilter filterUsingPredicate:pred2];

    
    self.sharedController=[SharedController sharedController];
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate checkNetworkStatus:nil];
    if(appDelegate.internetActive)
    {
       /* NSArray *arrBundledOrdersObject=[arrBundledOrders objectAtIndex:sender.tag];
        NSMutableArray *arrOrderIds=[[NSMutableArray alloc]init];
        for (int i=0; i<[arrBundledOrdersObject count]; i++)
        {
            NSDictionary *dictOrder=[[NSDictionary alloc]initWithObjectsAndKeys:[[arrBundledOrdersObject objectAtIndex:i] objectForKey:@"orderId"],@"orderId",@"10",@"orderStatus",@"",@"errorReason", nil];
            [arrOrderIds addObject:dictOrder];
        }*/
         NSMutableArray *arrOrderIds=[[NSMutableArray alloc]init];
        NSDictionary *dictOrder=[[NSDictionary alloc]initWithObjectsAndKeys:[[arrOrdersFilter objectAtIndex:sender.tag] objectForKey:@"orderId"],@"orderId",@"10",@"orderStatus",@"",@"errorReason", nil];
        [arrOrderIds addObject:dictOrder];
        NSMutableDictionary *dictJSON=[[NSMutableDictionary alloc] initWithObjectsAndKeys:arrOrderIds,@"orderList",nil];
        [dictJSON setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] forKey:@"venueId"];
        [dictJSON setValue:KAPIVersionNumber forKey:@"apiVersion"];
        [dictJSON setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthCode"] forKey:@"oauthCode"];

        SBJSON *jsonObj=[SBJSON new];
        NSString *strJson=[jsonObj stringWithObject:dictJSON];
        NSData *dataJSON=[strJson dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/order/updateOrderStatus",KServerURL];
        NSURL *url=[[NSURL alloc]initWithString:strURL];
        NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:dataJSON];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *dataOrder, NSError *error)
         {
             if(error==nil)
             {
                 
                 SBJSON *jsonParser = [[SBJSON new] autorelease];
                 NSString *jsonString = [[[NSString alloc] initWithData:dataOrder encoding:NSUTF8StringEncoding] autorelease];
                 id result = [jsonParser objectWithString:jsonString error:nil];
                 NSLog(@"Result is %@",result);
                 
             }
             else
             {
                 NSLog(@"Error is %@",error);
             }
             
         }
         ];
        
        [url release];
        [request release];

        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getOpenOrders) userInfo:nil repeats:NO];
        
    }
    else
    {
        [self hideProgressView:nil];
        [self createAlertViewWithTitle:@"NetWorkStatus" message:@"Internet Connection Required" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
    }
}

-(IBAction)btnfDismiss_TouchUpInside:(UIButton*)sender
{
    
    NSMutableArray *arrTempBundleorders=[[NSMutableArray alloc]init];
    for (int k=0; k<arrBundledOrders.count;k++) {
        NSArray *arrBundledOrdersObject=[arrBundledOrders objectAtIndex:k];
        
        NSDictionary *dict=[arrBundledOrdersObject objectAtIndex:0];
        [arrTempBundleorders addObject:dict];
    }

    NSString *stringid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] ];
    NSMutableArray *arrOrdersFilter=[[NSMutableArray alloc]initWithArray:arrTempBundleorders];
    NSPredicate *pred2=[NSPredicate predicateWithFormat:@"(recieverBartsyId !=%@)",stringid];
    [arrOrdersFilter filterUsingPredicate:pred2];
    
    self.sharedController=[SharedController sharedController];
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate checkNetworkStatus:nil];
    if(appDelegate.internetActive)
    {
       /* NSArray *arrBundledOrdersObject=[arrBundledOrders objectAtIndex:sender.tag];
        NSMutableArray *arrOrderIds=[[NSMutableArray alloc]init];
        for (int i=0; i<[arrBundledOrdersObject count]; i++)
        {
            NSDictionary *dictOrder=[[NSDictionary alloc]initWithObjectsAndKeys:[[arrBundledOrdersObject objectAtIndex:i] objectForKey:@"orderId"],@"orderId",@"10",@"orderStatus",@"",@"errorReason", nil];
            [arrOrderIds addObject:dictOrder];
        }*/
        NSMutableArray *arrOrderIds=[[NSMutableArray alloc]init];

        NSDictionary *dictOrder=[[NSDictionary alloc]initWithObjectsAndKeys:[[arrOrdersFilter objectAtIndex:sender.tag] objectForKey:@"orderId"],@"orderId",@"10",@"orderStatus",@"",@"errorReason", nil];
        [arrOrderIds addObject:dictOrder];
        NSMutableDictionary *dictJSON=[[NSMutableDictionary alloc] initWithObjectsAndKeys:arrOrderIds,@"orderList",nil];
        [dictJSON setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] forKey:@"venueId"];
        [dictJSON setValue:KAPIVersionNumber forKey:@"apiVersion"];
        [dictJSON setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthCode"] forKey:@"oauthCode"];
        
        SBJSON *jsonObj=[SBJSON new];
        NSString *strJson=[jsonObj stringWithObject:dictJSON];
        NSData *dataJSON=[strJson dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/order/updateOrderStatus",KServerURL];
        NSURL *url=[[NSURL alloc]initWithString:strURL];
        NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:dataJSON];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *dataOrder, NSError *error)
         {
             if(error==nil)
             {
                 
                 SBJSON *jsonParser = [[SBJSON new] autorelease];
                 NSString *jsonString = [[[NSString alloc] initWithData:dataOrder encoding:NSUTF8StringEncoding] autorelease];
                 id result = [jsonParser objectWithString:jsonString error:nil];
                 NSLog(@"Result is %@",result);
                 
             }
             else
             {
                 NSLog(@"Error is %@",error);
             }
             
         }
         ];
        
        [url release];
        [request release];
        
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getOpenOrders) userInfo:nil repeats:NO];
        
    }
    else
    {
        [self hideProgressView:nil];
        [self createAlertViewWithTitle:@"NetWorkStatus" message:@"Internet Connection Required" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
    }
}


-(IBAction)btnReject_TouchUpInside:(UIButton*)sender
{
    
    NSMutableArray *arrTempBundleorders=[[NSMutableArray alloc]init];
    for (int k=0; k<arrBundledOrders.count;k++) {
        NSArray *arrBundledOrdersObject=[arrBundledOrders objectAtIndex:k];
        
        NSDictionary *dict=[arrBundledOrdersObject objectAtIndex:0];
        [arrTempBundleorders addObject:dict];
    }
    NSString *stringid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] ];
    NSMutableArray *arrOrdersFilter=[[NSMutableArray alloc]initWithArray:arrTempBundleorders];
    NSPredicate *pred2=[NSPredicate predicateWithFormat:@"(recieverBartsyId ==%@)",stringid];
    [arrOrdersFilter filterUsingPredicate:pred2];
    self.sharedController=[SharedController sharedController];
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate checkNetworkStatus:nil];
    if(appDelegate.internetActive)
    {
       /* NSArray *arrBundledOrdersObject=[arrBundledOrders objectAtIndex:sender.tag];
        for (int i=0; i<[arrBundledOrdersObject count]; i++)
        {
            NSDictionary *dictOrder=[arrBundledOrdersObject objectAtIndex:i];
            [self updateOrderStatusForaOfferedDrinkWithStatus:@"8" withOrderId:[dictOrder objectForKey:@"orderId"]];
        }*/
        
        NSDictionary *dictOrder=[arrOrdersFilter objectAtIndex:sender.tag];
        [self updateOrderStatusForaOfferedDrinkWithStatus:@"8" withOrderId:[dictOrder objectForKey:@"orderId"]];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getOpenOrders) userInfo:nil repeats:NO];
    }
    else
    {
        [self hideProgressView:nil];
        [self createAlertViewWithTitle:@"NetWorkStatus" message:@"Internet Connection Required" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
    }

    [arrTempBundleorders release];
    [arrOrdersFilter release];
}

-(IBAction)btnAccept_TouchUpInside:(UIButton*)sender
{
    
    NSMutableArray *arrTempBundleorders=[[NSMutableArray alloc]init];
    for (int k=0; k<arrBundledOrders.count;k++) {
        NSArray *arrBundledOrdersObject=[arrBundledOrders objectAtIndex:k];
        
        NSDictionary *dict=[arrBundledOrdersObject objectAtIndex:0];
        [arrTempBundleorders addObject:dict];
    }

    NSString *stringid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] ];
    NSMutableArray *arrOrdersFilter=[[NSMutableArray alloc]initWithArray:arrTempBundleorders];
    NSPredicate *pred2=[NSPredicate predicateWithFormat:@"(recieverBartsyId ==%@)",stringid];
    [arrOrdersFilter filterUsingPredicate:pred2];

    
    self.sharedController=[SharedController sharedController];
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate checkNetworkStatus:nil];
    if(appDelegate.internetActive)
    {
       /* NSArray *arrBundledOrdersObject=[arrBundledOrders objectAtIndex:sender.tag];
        for (int i=0; i<[arrBundledOrdersObject count]; i++)
        {
            NSDictionary *dictOrder=[arrBundledOrdersObject objectAtIndex:i];
            [self updateOrderStatusForaOfferedDrinkWithStatus:@"0" withOrderId:[dictOrder objectForKey:@"orderId"]];
        }*/
        NSDictionary *dictOrder=[arrOrdersFilter objectAtIndex:sender.tag];
        [self updateOrderStatusForaOfferedDrinkWithStatus:@"0" withOrderId:[dictOrder objectForKey:@"orderId"]];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getOpenOrders) userInfo:nil repeats:NO];
    }
    else
    {
        [self hideProgressView:nil];
        [self createAlertViewWithTitle:@"NetWorkStatus" message:@"Internet Connection Required" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
    }
    
    [arrTempBundleorders release];
    [arrOrdersFilter release];
}

-(void)CheckinButton_Action:(UIButton*)sender{
   
    if (sender.tag==3333) {
        isRequestCheckin=YES;
        isRequestForPeople=NO;
        isRequestForOrder=NO;
        isRequestForGettingsPastOrders=NO;
        isRequestForGettingsOrders=NO;
        isGettingCocktails=NO;
        isGettingIngradients=NO;
        isGetFavorites=NO;
        
        [self createProgressViewToParentView:self.view withTitle:@"Checking In..."];
        [self.sharedController checkInAtBartsyVenueWithId:[dictVenue objectForKey:@"venueId"] delegate:self];
    }else{
        
        NSDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"VenueDetails"];
        NSString *strMsg=nil;
        
        if(appDelegate.intOrderCount)
        {
            strMsg=[NSString stringWithFormat:@"You have open orders placed at %@. If you checkout they will be cancelled and you will still be charged for it.Do you want to checkout from %@",[dict objectForKey:@"venueName"],[dict objectForKey:@"venueName"]];
        }
        else
        {
            strMsg=[NSString stringWithFormat:@"Do you want to checkout"];
        }
        [self createAlertViewWithTitle:@"" message:strMsg cancelBtnTitle:@"No" otherBtnTitle:@"Yes" delegate:self tag:225];
    }
    
    
}
-(void)getOpenOrders
{
    isRequestForGettingsPastOrders = NO;
    
    isRequestForGettingsOrders=YES;
    isRequestForPeople=NO;
    isRequestForOrder=NO;
    
    isSelectedForPastOrders = NO;
    isSelectedForDrinks=NO;
    isSelectedForPeople=NO;
    
    [arrBundledOrders removeAllObjects];
    [arrBundledOrders addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"Orders"]];
   
    [self.sharedController getUserOrdersWithBartsyId:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] delegate:self];
}

-(UIColor*)getTheColorForOrderStatus:(NSInteger)intStatus
{
    UIColor *color;
    switch (intStatus)
    {
        case 0:
            color=[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:43.0/255.0 alpha:1.0];
            break;
        case 1:
            color=[UIColor redColor];
            break;
        case 2:
            color=[UIColor orangeColor];
            break;
        case 3:
            color=[UIColor greenColor];
            break;
        case 4:
            color=[UIColor redColor];
            break;
        case 5:
            color=[UIColor greenColor];
            break;
        case 6:
            color=[UIColor redColor];
            break;
        case 7:
            color=[UIColor redColor];
            break;
        case 8:
            color=[UIColor redColor];
            break;
        case 9:
            color=[UIColor colorWithRed:187.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
            break;
        default:
            color=[UIColor redColor];
            break;
    }

    return color;
}

-(NSString*)getTheStatusMessageForOrder:(NSDictionary*)dictOrder
{
    arrStatus=[[NSArray alloc]initWithObjects:@"Waiting for bartender to accept",@"Your order was rejected by Bartender",@"Order was accepted",@"Ready for pickup",@"Order is Failed",@"Order is picked up",@"Noshow",@"Your order was timedout",@"Your order was rejected",@"Drink offered",@"Past Order", nil];

    if([[dictOrder objectForKey:@"orderStatus"] integerValue]==0)
    {
       return @"Waiting for bartender to accept";
    }
    else if([[dictOrder objectForKey:@"orderStatus"] integerValue]==1)
    {
        return @"Your order was rejected by Bartender";
    }
    else if([[dictOrder objectForKey:@"orderStatus"] integerValue]==2)
    {
        return @"Order was accepted by Bartender";
    }
    else if([[dictOrder objectForKey:@"orderStatus"] integerValue]==3)
    {
        return @"Go to the Bartsy area of the bar and present this screen to the bartender to pick up your order";
    }
    else if([[dictOrder objectForKey:@"orderStatus"] integerValue]==4)
    {
        return @"Order was failed";
    }
    else if([[dictOrder objectForKey:@"orderStatus"] integerValue]==5)
    {
        return @"Your order is picked up";
    }
    else if([[dictOrder objectForKey:@"orderStatus"] integerValue]==6)
    {
        return @"Order is noshow";
    }
    else if([[dictOrder objectForKey:@"orderStatus"] integerValue]==7)
    {
        return @"Your order was timed out";
    }
    else if([[dictOrder objectForKey:@"orderStatus"] integerValue]==8)
    {
        NSString *strStatusMessage;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]==[[dictOrder objectForKey:@"senderBartsyId"] doubleValue])
        strStatusMessage=[NSString stringWithFormat:@"Your order was rejected by %@",[dictOrder objectForKey:@"recipientNickname"]];
        else
        strStatusMessage=[NSString stringWithFormat:@"You rejected the order offered by %@",[dictOrder objectForKey:@"senderNickname"]];
        return strStatusMessage;
    }
    else if([[dictOrder objectForKey:@"orderStatus"] integerValue]==9)
    {
        NSString *strStatusMessage;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]==[[dictOrder objectForKey:@"senderBartsyId"] doubleValue])
        strStatusMessage=[NSString stringWithFormat:@"Waiting for %@ to accept",[dictOrder objectForKey:@"recipientNickname"]];
        else
            strStatusMessage=[NSString stringWithFormat:@"You were offered a drink by %@. Accept it or let it timeout",[dictOrder objectForKey:@"senderNickname"]];
    
        return strStatusMessage;
    }
    else
        return @"";
    
}


-(void)updateOrderStatusForaOfferedDrinkWithStatus:(NSString*)strStatus withOrderId:(NSString*)strOrderId
{
    //Updating the Order Status by the Receiver
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/order/updateOfferedDrinkStatus",KServerURL];
    
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"],@"bartsyId",strOrderId,@"orderId",strStatus,@"orderStatus",[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"],@"venueId",nil];
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];
    [dictCheckIn setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthCode"] forKey:@"oauthCode"];

    
    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictCheckIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *dataOrder, NSError *error)
     {
         if(error==nil)
         {
             SBJSON *jsonParser = [[SBJSON new] autorelease];
             NSString *jsonString = [[[NSString alloc] initWithData:dataOrder encoding:NSUTF8StringEncoding] autorelease];
             id result = [jsonParser objectWithString:jsonString error:nil];
             NSLog(@"Result is %@",result);
             
         }
         else
         {
             NSLog(@"Error is %@",error);
         }
         
     }
     ];
    
    
    [url release];
    [request release];
    
}


#pragma mark - Table view Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(isSelectedForDrinks){
        return 2+[arrCustomDrinks count]+[arrMenu count]+[arrCocktailsSection count];
    }
    else if(isSelectedForPeople)
        return 1; 
    else
    {
        return 1;
    }
    
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}


-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(isSelectedForDrinks)
        if (section==0) {
            if ([arrFavorites count]==0)
                return 0;
            else
                return 54;
        }else if (section==1){
            if ([arrRecentOrders count]==0)
                return 0;
            else
                return 54;
        }else if(section>1+[arrCustomDrinks count]+[arrMenu count]&&section<2+[arrCustomDrinks count]+[arrMenu count]+[arrCocktailsSection count]){
            
            if ([[[arrCocktailsSection objectAtIndex:section-(2+[arrCustomDrinks count]+[arrMenu count])] objectForKey:@"contents"] count]==0)
                return 0;
            else
                return 54;
            
        }else if( section>1+[arrCustomDrinks count]&&section<2+[arrCustomDrinks count]+[arrMenu count]){
            
            if ([[[arrMenu objectAtIndex:section-(2+[arrCustomDrinks count])] objectForKey:@"contents"] count]==0)
                return 0;
            else
                return 54;
            
        }else if (section>1&&section<2+[arrCustomDrinks count]){
        
            if ([[[arrCustomDrinks objectAtIndex:section-2] objectForKey:@"contents"] count]==0)
                return 0;
            else
                return 54;
                
            
        }
        else
        return 54;
    else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(isSelectedForDrinks)
    {
        
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 53)];
        UIImageView *headerBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sectionBg.png"]];
        [headerView addSubview:headerBg];
        [headerBg release];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 0, 600, 44);
        button.tag=section+1;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
     
        [button setImage:[UIImage imageNamed:@"shrink.png"] forState:UIControlStateNormal];   
        [button setImage:[UIImage imageNamed:@"disclosure.png"] forState:UIControlStateSelected];
        if (section>1&&section<2+[arrCustomDrinks count]) {
            if([[[arrCustomDrinks objectAtIndex:section-2]valueForKey:@"Arrow"] intValue]==0)
                button.selected=YES;
            else
                button.selected=NO;

        }else if( section>1+[arrCustomDrinks count]&&section<2+[arrCustomDrinks count]+[arrMenu count])
        {
            if([[[arrMenu objectAtIndex:section-(2+[arrCustomDrinks count])]valueForKey:@"Arrow"] intValue]==0)
                button.selected=YES;
            else
                button.selected=NO;
            
        }else if(section==0|| section==1){
            if([[[ArrMenuSections objectAtIndex:section]valueForKey:@"Arrow"] intValue]==0)
                button.selected=YES;
            else
                button.selected=NO;
        }else if(section>1+[arrCustomDrinks count]+[arrMenu count]&&section<2+[arrCustomDrinks count]+[arrMenu count]+[arrCocktailsSection count]){
            
            if([[[arrCocktailsSection objectAtIndex:section-(2+[arrCustomDrinks count]+[arrMenu count])]valueForKey:@"Arrow"] intValue]==0)
                button.selected=YES;
            else
                button.selected=NO;
        }
        
        [headerView addSubview:button];
        
        UILabel *headerTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 280, 53)];
        [headerTitle setBackgroundColor:[UIColor clearColor]];
        [headerTitle setFont:[UIFont systemFontOfSize:18]];
        headerTitle.font=[UIFont fontWithName:@"Museo Sans" size:18.0];
        [headerTitle setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
        if (section==0|| section==1) {
            headerTitle.text= [NSString stringWithFormat:@"%@",[[ArrMenuSections objectAtIndex:section]valueForKey:@"SectionName"]];
        }else if (section>1&&section<2+[arrCustomDrinks count])
        {
            headerTitle.text=[[arrCustomDrinks objectAtIndex:section-2] valueForKey:@"section_name"];
                       
        }else if ( section>1+[arrCustomDrinks count]&&section<2+[arrCustomDrinks count]+[arrMenu count]){
           
            id object=[arrMenu objectAtIndex:section-(2+[arrCustomDrinks count])];
            
            if([[object objectForKey:@"subsection_name"] length])
            {
                headerTitle.text= [NSString stringWithFormat:@"%@->%@",[object objectForKey:@"section_name"],[object objectForKey:@"subsection_name"]];
            }
            else
            {
                headerTitle.text= [NSString stringWithFormat:@"%@",[object objectForKey:@"section_name"]];
            }

        }else if(section>1+[arrCustomDrinks count]+[arrMenu count]&&section<2+[arrCustomDrinks count]+[arrMenu count]+[arrCocktailsSection count]){
            NSLog(@"%@",[arrCocktailsSection objectAtIndex:section-(2+[arrCustomDrinks count]+[arrMenu count])]);
            headerTitle.text=[[arrCocktailsSection objectAtIndex:section-(2+[arrCustomDrinks count]+[arrMenu count])] valueForKey:@"section_name"];
        }
        
        [headerView addSubview:headerTitle];
        
        return headerView;
    }
    else
    {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(isSelectedForDrinks)
    {
        if (section==1) {
            NSMutableDictionary *dict=[ArrMenuSections objectAtIndex:section];
            BOOL isSelected=!([[dict objectForKey:@"Arrow"] integerValue]);

            if (isSelected) 
                return 0;
            else
                return [arrRecentOrders count];
        }else if (section==0){
            NSMutableDictionary *dict=[ArrMenuSections objectAtIndex:section];
           
            BOOL isSelected=!([[dict objectForKey:@"Arrow"] integerValue]);

            if (isSelected)
                return 0;
            else
            return [arrFavorites count];
        }else if (section>1&&section<2+[arrCustomDrinks count]){
        
            NSMutableDictionary *dict=[arrCustomDrinks objectAtIndex:section-2];
            BOOL isSelected=!([[dict objectForKey:@"Arrow"] integerValue]);
            if (isSelected)
                return 0;
            else
                return [[[arrCustomDrinks objectAtIndex:section-2] objectForKey:@"contents"] count];
        }else if( section>1+[arrCustomDrinks count]&&section<2+[arrCustomDrinks count]+[arrMenu count])
        {
            NSMutableDictionary *dict=[arrMenu objectAtIndex:section-(2+[arrCustomDrinks count])];
            BOOL isSelected=!([[dict objectForKey:@"Arrow"] integerValue]);
            if (isSelected)
                return 0;
            else
                return [[[arrMenu objectAtIndex:section-(2+[arrCustomDrinks count])] objectForKey:@"contents"] count];

        }else if(section>1+[arrCustomDrinks count]+[arrMenu count]&&section<2+[arrCustomDrinks count]+[arrMenu count]+[arrCocktailsSection count]){
            
            NSMutableDictionary *dict=[arrCocktailsSection objectAtIndex:section-(2+[arrCustomDrinks count]+[arrMenu count])];
            BOOL isSelected=!([[dict objectForKey:@"Arrow"] integerValue]);
            if (isSelected)
                return 0;
            else
                return [[[arrCocktailsSection objectAtIndex:section-(2+[arrCustomDrinks count]+[arrMenu count])] objectForKey:@"contents"] count];
        }
        
    }
    else if(isSelectedForPeople)
    {
        return [arrPeople count];
    }else if (isSelectedForPastOrders==YES){
        if ([arrPastOrders count]) {
            return [arrPastOrders count];
        }
        else
        {
            return 1;
        }
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isSelectedForDrinks){
        return 86;
    }else if(isSelectedForPeople)
        return 110;
    else if(isSelectedForPastOrders == YES)
    {
        return 90;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    
    if(isSelectedForDrinks==YES)
    {
        UITableViewCell *cell;

        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage            imageNamed:@"fathers_office-bg.png"]];

        UIImageView *drinkImg=[[UIImageView alloc]initWithFrame:CGRectMake(5,12,20, 20)];
        drinkImg.image=[UIImage imageNamed:@"drink"];
        [cell.contentView addSubview:drinkImg];
        [drinkImg release];
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(34,0, 260,46)];
        if (indexPath.section==1)
        {
               
                NSDictionary *dictRecTemp=[arrRecentOrders objectAtIndex:indexPath.row];
                
                lblName.text=[dictRecTemp valueForKey:@"name"];
            
        }
        else if (indexPath.section==0)
        {
             NSDictionary *dictFavTemp=[arrFavorites objectAtIndex:indexPath.row];
            lblName.text=[dictFavTemp valueForKey:@"name"];
        }
        else if (indexPath.section>1&&indexPath.section<2+[arrCustomDrinks count])
        {
            
            NSArray *tempArray=[[arrCustomDrinks objectAtIndex:indexPath.section-2] valueForKey:@"contents"];
            lblName.text=[[tempArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        }else if(indexPath.section>1+[arrCustomDrinks count]&&indexPath.section<2+[arrCustomDrinks count]+[arrMenu count]){
            
            
            id object=[arrMenu objectAtIndex:indexPath.section-([arrCustomDrinks count]+2)];
            
                NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
                NSDictionary *dict=[arrContents objectAtIndex:indexPath.row];
                lblName.text=[dict objectForKey:@"name"];
            

        }else if (indexPath.section>1+[arrCustomDrinks count]+[arrMenu count]&&indexPath.section<2+[arrCustomDrinks count]+[arrMenu count]+[arrCocktailsSection count]){
            
            NSArray *tempArray=[[arrCocktailsSection objectAtIndex:indexPath.section-([arrCustomDrinks count]+2+[arrMenu count])] valueForKey:@"contents"];
            lblName.text=[[tempArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        }
        
        lblName.font=[UIFont systemFontOfSize:16];
        lblName.font=[UIFont fontWithName:@"MuseoSans-100" size:16.0];
        lblName.numberOfLines=2;
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lblName];
        [lblName release];
        
      //  CGSize lblnamesize=[lblName.text sizeWithFont:[UIFont systemFontOfSize:14] forWidth:260 lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(32,25, 280, 50)];
        lblDescription.numberOfLines=2;
        if(indexPath.section==1)
        {
            NSDictionary *dictRecTemp=[arrRecentOrders objectAtIndex:indexPath.row];
            if ([dictRecTemp valueForKey:@"options_description"]) {
                lblDescription.text=[dictRecTemp valueForKey:@"options_description"];

            }else{
                lblDescription.text=@"";
            }
        }
        else if(indexPath.section==0)
        {
            NSDictionary *dictFavTemp=[arrFavorites objectAtIndex:indexPath.row];
            if ([dictFavTemp valueForKey:@"options_description"])
            
                lblDescription.text=[dictFavTemp valueForKey:@"options_description"];
            else
                lblDescription.text=@"";
            
        }else if (indexPath.section>1+[arrCustomDrinks count]&&indexPath.section<2+[arrCustomDrinks count]+[arrMenu count]){
            id object=[arrMenu objectAtIndex:indexPath.section-(2+[arrCustomDrinks count])];

            NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
            NSDictionary *dict=[arrContents objectAtIndex:indexPath.row];
            lblDescription.text=[dict objectForKey:@"description"];
        }else if(indexPath.section>1&&indexPath.section<2+[arrCustomDrinks count]){
            
            NSArray *tempArray=[[arrCustomDrinks objectAtIndex:indexPath.section-2] valueForKey:@"contents"];
            lblDescription.text=[[tempArray objectAtIndex:indexPath.row] valueForKey:@"description"];
        }else if (indexPath.section>1+[arrCustomDrinks count]+[arrMenu count]&&indexPath.section<2+[arrCustomDrinks count]+[arrMenu count]+[arrCocktailsSection count]){
            
            NSArray *tempArray=[[arrCocktailsSection objectAtIndex:indexPath.section-([arrCustomDrinks count]+2+[arrMenu count])] valueForKey:@"contents"];
            lblDescription.text=[[tempArray objectAtIndex:indexPath.row] valueForKey:@"description"];
        }
        
        lblDescription.font=[UIFont systemFontOfSize:12];
        lblDescription.font=[UIFont fontWithName:@"Museo Sans" size:12.0];
        lblDescription.backgroundColor=[UIColor clearColor];
        lblDescription.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lblDescription];
        [lblDescription release];
        
        UILabel *lblOpt_Desp=[[UILabel alloc]initWithFrame:CGRectMake(32,45, 280, 50)];
        lblOpt_Desp.numberOfLines=2;
        lblOpt_Desp.font=[UIFont systemFontOfSize:12];
        lblOpt_Desp.font=[UIFont fontWithName:@"Museo Sans" size:12.0];
        lblOpt_Desp.backgroundColor=[UIColor clearColor];
        lblOpt_Desp.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lblOpt_Desp];
        [lblOpt_Desp release];
        if(indexPath.section==1)
        {
            NSDictionary *dictRecTemp=[arrRecentOrders objectAtIndex:indexPath.row];
            if ([dictRecTemp valueForKey:@"special_instructions"]) {
                lblOpt_Desp.text=[dictRecTemp valueForKey:@"special_instructions"];
                
            }else{
                lblOpt_Desp.text=@"";
            }
        }
        else if(indexPath.section==0)
        {
            NSDictionary *dictFavTemp=[arrFavorites objectAtIndex:indexPath.row];
            if ([dictFavTemp valueForKey:@"special_instructions"])
                
                lblOpt_Desp.text=[dictFavTemp valueForKey:@"special_instructions"];
            else
                lblOpt_Desp.text=@"";
            
        }
        UILabel *lblPrice=[[UILabel alloc]initWithFrame:CGRectMake(285, 0, 50, 46)];
        if(indexPath.section==1)
        {
            NSDictionary *dictRecTemp=[arrRecentOrders objectAtIndex:indexPath.row];
        
            if ([dictRecTemp valueForKey:@"price"] && [[dictRecTemp valueForKey:@"price"] integerValue] !=0) {
                lblPrice.text=[NSString stringWithFormat:@"$%d",[[dictRecTemp valueForKey:@"price"] integerValue]];
            }else
                lblPrice.text=@"";

        }else if (indexPath.section==0){
            
            NSDictionary *dictFavTemp=[arrFavorites objectAtIndex:indexPath.row];
            if ([dictFavTemp valueForKey:@"price"] && [[dictFavTemp valueForKey:@"price"] integerValue] !=0) {
                 lblPrice.text=[NSString stringWithFormat:@"$%d",[[dictFavTemp valueForKey:@"price"] integerValue]];
            }else
                lblPrice.text=@"";
        }
        else if(indexPath.section>1+[arrCustomDrinks count]&&indexPath.section<2+[arrCustomDrinks count]+[arrMenu count])
        {
            id object=[arrMenu objectAtIndex:indexPath.section-([arrCustomDrinks count]+2)];
            NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
            NSDictionary *dict=[arrContents objectAtIndex:indexPath.row];
             if ([dict valueForKey:@"price"] && [[dict valueForKey:@"price"] integerValue] !=0) {
            lblPrice.text=[NSString stringWithFormat:@"$%d",[[dict valueForKey:@"price"] integerValue]];
                 
             }else{
                 lblPrice.text=@"";
             }
        }else if(indexPath.section>1&&indexPath.section<2+[arrCustomDrinks count]){
            NSArray *tempArray=[[arrCustomDrinks objectAtIndex:indexPath.section-2] valueForKey:@"contents"];
            if ([[[tempArray objectAtIndex:indexPath.row] valueForKey:@"price"] integerValue]!=0) {
                lblPrice.text=[NSString stringWithFormat:@"$%d",[[[tempArray objectAtIndex:indexPath.row] valueForKey:@"price"] integerValue]];
            }else{
                lblPrice.text=@"";
            }
            
        }else if (indexPath.section>1+[arrCustomDrinks count]+[arrMenu count]&&indexPath.section<2+[arrCustomDrinks count]+[arrMenu count]+[arrCocktailsSection count]){
            
            NSArray *tempArray=[[arrCocktailsSection objectAtIndex:indexPath.section-([arrCustomDrinks count]+2+[arrMenu count])] valueForKey:@"contents"];
            
            if ([[[tempArray objectAtIndex:indexPath.row] valueForKey:@"price"] integerValue]!=0) {
                
            lblPrice.text=[NSString stringWithFormat:@"$%d",[[[tempArray objectAtIndex:indexPath.row] valueForKey:@"price"] integerValue]];
            }else{
                lblPrice.text=@"";
            }
        }
        
        lblPrice.font=[UIFont systemFontOfSize:18];
        lblPrice.font=[UIFont fontWithName:@"Museo Sans" size:19.0];
        lblPrice.textColor=[UIColor colorWithRed:33.0/255.0 green:169.0/255.0 blue:204.0/255.0 alpha:1.0];
        //lblPrice.adjustsFontSizeToFitWidth=YES;
        lblPrice.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lblPrice];
        [lblPrice release];
        
        if (![lblDescription.text length]>0) {
            lblName.frame=CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+20,lblName.frame.size.width,lblName.frame.size.height);
            drinkImg.frame=CGRectMake(drinkImg.frame.origin.x, drinkImg.frame.origin.y+20,drinkImg.frame.size.width,drinkImg.frame.size.height);
            lblPrice.frame=CGRectMake(lblPrice.frame.origin.x, lblPrice.frame.origin.y+20,lblPrice.frame.size.width,lblPrice.frame.size.height);
            
        }
        
        /*UILabel *lblDollars=[[UILabel alloc]initWithFrame:CGRectMake(270, 45, 50, 10)];
        lblDollars.text=@"dollars";
        lblDollars.font=[UIFont systemFontOfSize:10];
        lblDollars.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        lblDollars.adjustsFontSizeToFitWidth=YES;
        lblDollars.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lblDollars];
        [lblDollars release];*/
        return cell;
    }
    else if(isSelectedForPeople)
    {
         NSDictionary *dictPeople=[arrPeople objectAtIndex:indexPath.row];
        PeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleCell"];
        
        if (cell == nil)
        {
            cell = [[PeopleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PeopleCell"];
            UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
            bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fathers_office-bg.png"]];
            cell.backgroundView = bg;
            [bg release];
        }
         NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictPeople objectForKey:@"userImagePath"]];
       [cell.imgProfile setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        cell.lblName.text = [dictPeople objectForKey:@"nickName"];
        cell.lblName.font=[UIFont fontWithName:@"MuseoSans-300" size:16.0];
        
        NSMutableString *strdetails=[[NSMutableString alloc]init];
        [strdetails appendFormat:@"%d",[[dictPeople valueForKey:@"age"] integerValue]];
        if ([dictPeople valueForKey:@"gender"]) {
            [strdetails appendFormat:@"/%@",[dictPeople valueForKey:@"gender"]];
        }
        
        if ([dictPeople valueForKey:@"orientation"]) {
            [strdetails appendFormat:@"/%@",[dictPeople valueForKey:@"orientation"]];
        }
        cell.lbldetails.text=strdetails;
        cell.lbldetails.font=[UIFont fontWithName:@"Museo Sans" size:11.0];
        
        if ([dictPeople valueForKey:@"status"] && [[dictPeople valueForKey:@"status"] length])
        {
            cell.lblStatus.text = [dictPeople valueForKey:@"status"];
            cell.lblStatus.font=[UIFont fontWithName:@"Museo Sans" size:11.0];
        }else{
            cell.lblStatus.text=nil;
            cell.imgRelation.image=nil;
        }
        if ([dictPeople valueForKey:@"faceBookId"] && [[dictPeople valueForKey:@"faceBookId"] length]) {
            NSLog(@"%@",appDelegate.arrFBfriensList);
            
                if ([[appDelegate.arrFBfriensList valueForKey:@"id"] containsObject:[dictPeople valueForKey:@"faceBookId"]]) {
                    cell.lblfacebookid.font=[UIFont fontWithName:@"Museo Sans" size:11.0];
                }else{
                    cell.lblfacebookid.text=nil;
                    cell.imgFacebook.image=nil;
                }
        
            
           
        }else{
            cell.lblfacebookid.text=nil;
            cell.imgFacebook.image=nil;
        }
        NSString *strBartsyId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]];

        if ([strBartsyId doubleValue] != [[dictPeople objectForKey:@"bartsyId"] doubleValue])
        {
            if ([[dictPeople objectForKey:@"hasMessages"] isEqualToString:@"New"]) {
               // UIButton *btnChat=[self createUIButtonWithTitle:nil image:[UIImage imageNamed:@"mail.png"] frame:CGRectMake(75, 58, 18, 12) tag:indexPath.row selector:@selector(btnChat_TouchUpInside:) target:self];
                cell.imgMsg.image=[UIImage imageNamed:@"mail.png"];
                cell.lblMessage.text = @"You have new chats";
                
                cell.lblMessage.font=[UIFont fontWithName:@"Museo Sans" size:12.0];
                cell.lblMessage.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
                if (appDelegate.isComingForPeople) {
                    appDelegate.isComingForPeople=NO;
                    
                    [tableView
                     selectRowAtIndexPath:indexPath
                     animated:TRUE
                     scrollPosition:UITableViewScrollPositionNone
                     ];
                    
                    [[tableView delegate]
                     tableView:tableView
                     didSelectRowAtIndexPath:indexPath
                     ];

                }
                                
            }else if([[dictPeople objectForKey:@"hasMessages"] isEqualToString:@"Old"]){
                //UIButton *btnChat=[self createUIButtonWithTitle:nil image:[UIImage imageNamed:@"mail_gray.png"] frame:CGRectMake(75, 58, 18, 12) tag:indexPath.row selector:@selector(btnChat_TouchUpInside:) target:self];
                cell.imgMsg.image=[UIImage imageNamed:@"mail_gray.png"];
                
              
                cell.lblMessage.text = @"You've chatted!";
                cell.lblMessage.font=[UIFont fontWithName:@"Museo Sans" size:12.0];
                cell.lblMessage.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
                
            }else{
                cell.lblMessage.text=nil;
                cell.imgMsg.image=nil;
            }
        }
        return cell;
       /* cell =[[PeopleCustomCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage            imageNamed:@"fathers_office-bg.png"]];
        NSString *strBartsyId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]];

        NSDictionary *dictPeople=[arrPeople objectAtIndex:indexPath.row];
        NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictPeople objectForKey:@"userImagePath"]];
      
        UIImageView *imageForPeople = [[UIImageView alloc]initWithFrame:CGRectMake(5, 7, 64, 60)];
        [imageForPeople setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        //[imageForPeople.layer setShadowColor:[[UIColor whiteColor] CGColor]];
       // [imageForPeople.layer setShadowOffset:CGSizeMake(0, 1)];
       // [imageForPeople.layer setShadowRadius:3.0];
       // [imageForPeople.layer setShadowOpacity:0.8];
        [cell.contentView addSubview:imageForPeople];
        [imageForPeople release];

        UILabel *lblForPeopleName = [[UILabel alloc]initWithFrame:CGRectMake(75, -2, 220, 35)];
        lblForPeopleName.text = [dictPeople objectForKey:@"nickName"];
        lblForPeopleName.font = [UIFont boldSystemFontOfSize:16];
        lblForPeopleName.font=[UIFont fontWithName:@"MuseoSans-300" size:16.0];
        lblForPeopleName.backgroundColor = [UIColor clearColor];
        lblForPeopleName.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
        [cell.contentView addSubview:lblForPeopleName];
        [lblForPeopleName release];

        UIImageView *imgTickMark = [[UIImageView alloc] initWithFrame:CGRectMake(75, 25, 15, 15)];
        imgTickMark.image=[UIImage imageNamed:@"exclamatory_icon_ping"];
        [cell.contentView addSubview:imgTickMark];
        [imgTickMark release];
        
        if ([dictPeople valueForKey:@"status"])
        {
            
            UIImageView *imgstatus = [[UIImageView alloc] initWithFrame:CGRectMake(75, 42, 15, 15)];
            imgstatus.image=[UIImage imageNamed:@"flower_icon-selected"];
            [cell.contentView addSubview:imgstatus];            
            [imgstatus release];

            UILabel *lblstatus = [[UILabel alloc]initWithFrame:CGRectMake(93, 30, 150, 35)];
            lblstatus.text = [dictPeople valueForKey:@"status"];
            lblstatus.font = [UIFont systemFontOfSize:11];
            lblstatus.font=[UIFont fontWithName:@"Museo Sans" size:11.0];
            lblstatus.backgroundColor = [UIColor clearColor];
            lblstatus.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
            [cell.contentView addSubview:lblstatus];
            [lblstatus release];
        }
        

        NSMutableString *strdetails=[[NSMutableString alloc]init];
        [strdetails appendFormat:@"%d",[[dictPeople valueForKey:@"age"] integerValue]];
        if ([dictPeople valueForKey:@"gender"]) {
            [strdetails appendFormat:@"/%@",[dictPeople valueForKey:@"gender"]];
        }
        
        if ([dictPeople valueForKey:@"orientation"]) {
            [strdetails appendFormat:@"/%@",[dictPeople valueForKey:@"orientation"]];
        }
        
        UIImageView *imgForRightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 28, 10, 15)];
        imgForRightArrow.image=[UIImage imageNamed:@"right-arrow.png"];
        [cell.contentView addSubview:imgForRightArrow];
        [imgForRightArrow release];

        UILabel *lblForCheckIn = [[UILabel alloc]initWithFrame:CGRectMake(93, 15, 150, 35)];
        lblForCheckIn.text = strdetails;
        lblForCheckIn.font = [UIFont systemFontOfSize:11];
        lblForCheckIn.font=[UIFont fontWithName:@"Museo Sans" size:11.0];
        lblForCheckIn.backgroundColor = [UIColor clearColor];
        lblForCheckIn.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
        [cell.contentView addSubview:lblForCheckIn];
        [lblForCheckIn release];
        [strdetails release];
        
       

//        cell.textLabel.text=[dictPeople objectForKey:@"nickName"];
//        cell.detailTextLabel.text=[dictPeople objectForKey:@"gender"];
        
        if ([strBartsyId doubleValue] != [[dictPeople objectForKey:@"bartsyId"] doubleValue])
        {
            if ([[dictPeople objectForKey:@"hasMessages"] isEqualToString:@"New"]) {
                UIButton *btnChat=[self createUIButtonWithTitle:nil image:[UIImage imageNamed:@"mail.png"] frame:CGRectMake(75, 58, 18, 12) tag:indexPath.row selector:@selector(btnChat_TouchUpInside:) target:self];
                [cell.contentView addSubview:btnChat];
                UILabel *lblForPeopleGender = [[UILabel alloc]initWithFrame:CGRectMake(100, 45, 220, 35)];
                lblForPeopleGender.text = @"You have new chats";
                lblForPeopleGender.font = [UIFont systemFontOfSize:12];
                lblForPeopleGender.font=[UIFont fontWithName:@"Museo Sans" size:12.0];
                lblForPeopleGender.backgroundColor = [UIColor clearColor];
                lblForPeopleGender.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
                [cell.contentView addSubview:lblForPeopleGender];
                [lblForPeopleGender release];
               
            }else if([[dictPeople objectForKey:@"hasMessages"] isEqualToString:@"Old"]){
                UIButton *btnChat=[self createUIButtonWithTitle:nil image:[UIImage imageNamed:@"mail_gray.png"] frame:CGRectMake(75, 58, 18, 12) tag:indexPath.row selector:@selector(btnChat_TouchUpInside:) target:self];
    
                [cell.contentView addSubview:btnChat];
                UILabel *lblForPeopleGender = [[UILabel alloc]initWithFrame:CGRectMake(100, 45, 220, 35)];
                lblForPeopleGender.text = @"You've chatted!";
                lblForPeopleGender.font = [UIFont systemFontOfSize:12];
                lblForPeopleGender.font=[UIFont fontWithName:@"Museo Sans" size:12.0];
                lblForPeopleGender.backgroundColor = [UIColor clearColor];
                lblForPeopleGender.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
                [cell.contentView addSubview:lblForPeopleGender];
                [lblForPeopleGender release];

                
            }
            
        }

        //UILabel *lbl
    */
}else if (isSelectedForPastOrders == YES)
    {
        UITableViewCell *cell;

        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage            imageNamed:@"fathers_office-bg.png"]];
        
        if ([arrPastOrders count])
        {
            
            UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
            topView.backgroundColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f];
            [cell.contentView addSubview:topView];
            NSDictionary *dictForOrder = [arrPastOrders objectAtIndex:indexPath.row];
            
            NSMutableString *itemName = [[NSMutableString alloc]init];
            NSArray *array1Temp=[dictForOrder valueForKey:@"itemsList"];
            for (int i=0; i<array1Temp.count; i++) {
                NSDictionary *dict1Temp=[array1Temp objectAtIndex:i];
                
                [itemName appendFormat:@"%@,",[dict1Temp valueForKey:@"itemName"]];
                
            }
            NSString *strTrim;
            if ([itemName length]>1) {
                strTrim = (NSMutableString*)[itemName substringToIndex:[itemName length]-1];
            }
            UILabel *lblItemName = [self createLabelWithTitle:strTrim frame:CGRectMake(10, 50, 250, 20) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
            lblItemName.backgroundColor=[UIColor clearColor];
            lblItemName.textAlignment = NSTextAlignmentLeft;
            lblItemName.font=[UIFont fontWithName:@"MuseoSans-300" size:14.0];
            lblItemName.textColor=[UIColor whiteColor];
            [cell.contentView addSubview:lblItemName];
            [itemName release];
            UILabel *lbldescription;
           /* if ([[dictForOrder objectForKey:@"description"] isKindOfClass:[NSNull class]])
                lbldescription = [self createLabelWithTitle:@"" frame:CGRectMake(10, 20,250, 35) tag:0 font:[UIFont systemFontOfSize:15] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:2];
            else
                lbldescription = [self createLabelWithTitle:[dictForOrder objectForKey:@"description"] frame:CGRectMake(10, 20,250, 35) tag:0 font:[UIFont systemFontOfSize:15] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:2];
            
            lbldescription.backgroundColor=[UIColor clearColor];
            lbldescription.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lbldescription];*/
            
            
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat       = @"yyyy-MM-dd'T'HH:mm:ssZ";
            NSDate *date    = [dateFormatter dateFromString:[dictForOrder objectForKey:@"dateCreated"]];
            
            
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"aa kk:mm 'on' EEEE MMMM d"];
            
            NSString *newDateString = [outputFormatter stringFromDate:date];
            
            NSMutableArray *arrDateComps=[[NSMutableArray alloc]initWithArray:[newDateString componentsSeparatedByString:@" "]];
            
            if([arrDateComps count]==5)
            {
                NSString *strMeridian;
                NSString *strTime=[arrDateComps objectAtIndex:0];
                NSInteger intHours=[[[strTime componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
                if(intHours>=12)
                {
                    strMeridian=[NSString stringWithFormat:@"PM"];
                    NSString *strTime;
                    
                    if(intHours==12)
                    {
                        strTime=[NSString stringWithFormat:@"%i:%i",12,[[arrDateComps objectAtIndex:1] integerValue]];
                    }
                    else
                    {
                        strTime=[NSString stringWithFormat:@"%i:%i",intHours-12,[[arrDateComps objectAtIndex:1] integerValue]];
                        
                    }
                    [arrDateComps replaceObjectAtIndex:0 withObject:strTime];
                }
                else
                {
                    strMeridian=[NSString stringWithFormat:@"AM"];
                }
                [arrDateComps insertObject:strMeridian atIndex:0];
            }
            
            
            NSCalendar * cal = [NSCalendar currentCalendar];
            NSDateComponents *comps = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit) fromDate:date];
            
            if([[arrDateComps objectAtIndex:0] isEqualToString:@"PM"]&&comps.hour>12)
                comps.hour-=12;
            
            NSString *strDate1 = [NSString stringWithFormat:@"Placed on: %@%i:%@%i:%@%i %@ on %@ %i,%i",(comps.hour<10? @"0" : @""),comps.hour,(comps.minute<10? @"0":@""),comps.minute,(comps.second<10? @"0":@""),comps.second,[arrDateComps objectAtIndex:0],[arrDateComps objectAtIndex:4],comps.day,comps.year];
            
            
            UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 280, 15)];
            lblTime.font = [UIFont systemFontOfSize:14];
            lblTime.text = strDate1;
            lblTime.tag = 1234234567;
            lblTime.backgroundColor = [UIColor clearColor];
            lblTime.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
            lblTime.font=[UIFont fontWithName:@"MuseoSans-100" size:14.0];
            lblTime.textColor=[UIColor whiteColor];
            lblTime.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblTime];
            [lblTime release];
            
           /* UILabel *lblSender = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 280, 15)];
            lblSender.font = [UIFont systemFontOfSize:14];
            lblSender.text = [NSString stringWithFormat:@"Sender : %@",[dictForOrder objectForKey:@"senderNickname"]];
            lblSender.tag = 1234234567;
            lblSender.backgroundColor = [UIColor clearColor];
            lblSender.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
            lblSender.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblSender];
            [lblSender release];*/
            
            UILabel *lblRecepient = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 280, 20)];
            lblRecepient.font = [UIFont systemFontOfSize:14];
            lblRecepient.text = [NSString stringWithFormat:@"To : %@",[dictForOrder objectForKey:@"recipientNickname"]];
            lblRecepient.tag = 1234234567;
            lblRecepient.backgroundColor = [UIColor clearColor];
            lblRecepient.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
            lblRecepient.textColor = [UIColor whiteColor] ;
            lblRecepient.font=[UIFont fontWithName:@"Museo Sans" size:14.0];
            lblRecepient.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblRecepient];
            [lblRecepient release];
            
            
            if([[[arrPastOrders objectAtIndex:indexPath.row] objectForKey:@"senderBartsyId"]doubleValue]==[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]&&[[arrPastOrders objectAtIndex:indexPath.row] objectForKey:@"lastState"]!=(id)[NSNull null]&&[[[arrPastOrders objectAtIndex:indexPath.row] objectForKey:@"lastState"] integerValue]!=1)
            {
                NSString *stringFortotalPrice = [NSString stringWithFormat:@"$%.2f",[[dictForOrder objectForKey:@"totalPrice"] floatValue]];
                
                UILabel *lblTotalPrice = [self createLabelWithTitle:stringFortotalPrice frame:CGRectMake(270, 0, 200, 30) tag:0 font:[UIFont boldSystemFontOfSize:11] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
                lblTotalPrice.backgroundColor=[UIColor clearColor];
                lblTotalPrice.font=[UIFont fontWithName:@"Museo Sans" size:13.0];
                lblTotalPrice.textColor=[UIColor whiteColor];
                lblTotalPrice.textAlignment = NSTextAlignmentLeft;
                [topView addSubview:lblTotalPrice];
            }
            
            UILabel *lblOrderId = [[UILabel alloc]initWithFrame:CGRectMake(10,0, 280, 30)];
            lblOrderId.font = [UIFont systemFontOfSize:14];
            lblOrderId.font=[UIFont fontWithName:@"Museo Sans" size:14.0];
            lblOrderId.text = [NSString stringWithFormat:@"# %@",[dictForOrder objectForKey:@"orderId"]];
            lblOrderId.backgroundColor = [UIColor clearColor];
            lblOrderId.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
            lblOrderId.textColor = [UIColor whiteColor];
            lblOrderId.textAlignment = NSTextAlignmentLeft;
            [topView addSubview:lblOrderId];
            [lblOrderId release];
            
        
        }
        else
        {
            UILabel *lblItemName = [self createLabelWithTitle:@"No past orders\nGo to menu tab to place an order" frame:CGRectMake(30, 50, 250,50) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:5];
            lblItemName.backgroundColor=[UIColor clearColor];
            lblItemName.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:lblItemName];
        }
        
        return cell;
    }

    else
    {
        UITableViewCell *cell;

        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        return cell;
    }
    
    
}

-(void)btnChat_TouchUpInside:(UIButton*)sender
{
    MessageListViewController *obj = [[MessageListViewController alloc] init];
    obj.dictForReceiver = [arrPeople objectAtIndex:sender.tag];
    [self.navigationController pushViewController:obj animated:YES];
    [obj release];

}

-(void)btnGoToPastOrders_TouchUpInside
{
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"OrdersTimedOut"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [arrOrdersTimedOut removeAllObjects];
    UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
    [tblView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(isSelectedForDrinks)
    {
      
        if (![[NSUserDefaults standardUserDefaults] valueForKey:@"CheckInVenueId"]) {
            
            [self createAlertViewWithTitle:@"" message:@"Please checkin the venue to proceed" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
            return;
        }
        
        
    if(indexPath.section>1&&indexPath.section<2+[arrCustomDrinks count]){
        
      /*  NSMutableArray *arrMultiItemOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"multiitemorders"]];
        
        id object=[arrCustomDrinks objectAtIndex:indexPath.section-2];
        NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
        
        
        NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:[arrContents objectAtIndex:indexPath.row]];
        [dictItem setObject:@"" forKey:@"specialInstructions"];
        [dictItem setObject:@"Menu" forKey:@"ItemType"];
        [arrMultiItemOrders addObject:dictItem];
        
        [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [arrMultiItemOrders release];
        [dictItem release];
        [self showMultiItemOrderUI];*/

        id object=[arrCustomDrinks objectAtIndex:indexPath.section-2];
        NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
        CustomDrinkViewController *obj=[[CustomDrinkViewController alloc]initWithNibName:@"CustomDrinkViewController" bundle:nil];
        obj.viewtype=2;
        obj.isEdit=NO;
        obj.dictitemdetails=[arrContents objectAtIndex:indexPath.row];
        [arrContents release];
       // obj.dictCustomDrinks=[NSDictionary dictionaryWithDictionary:dictMainCustomDrinks];
        [self.navigationController pushViewController:obj animated:YES];

    }else if (indexPath.section>1+[arrCustomDrinks count]&&indexPath.section<2+[arrCustomDrinks count]+[arrMenu count]){
        
        

        id object=[arrMenu objectAtIndex:indexPath.section-(2+[arrCustomDrinks count])];
        NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
        NSDictionary *dictTemp=[arrContents objectAtIndex:indexPath.row];
        if ([dictTemp valueForKey:@"option_groups"]) {
            CustomDrinkViewController *obj=[[CustomDrinkViewController alloc]initWithNibName:@"CustomDrinkViewController" bundle:nil];
            obj.viewtype=5;
            obj.isEdit=NO;
            obj.dictitemdetails=[arrContents objectAtIndex:indexPath.row];
            [arrContents release];
            // obj.dictCustomDrinks=[NSDictionary dictionaryWithDictionary:dictMainCustomDrinks];
            [self.navigationController pushViewController:obj animated:YES];

        }else{
           
            NSMutableArray *arrMultiItemOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"multiitemorders"]];
            NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:[arrContents objectAtIndex:indexPath.row]];
            [dictItem setObject:@"" forKey:@"special_Instructions"];
            [dictItem setObject:@"Menu" forKey:@"ItemType"];
            [dictItem setObject:[NSNumber numberWithInt:1] forKey:@"Viewtype"];
            [dictItem setObject:[object objectForKey:@"section_name"] forKey:@"menu_path"];
            [arrMultiItemOrders addObject:dictItem];
            
            [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
            // [[NSUserDefaults standardUserDefaults]synchronize];
            [arrMultiItemOrders release];
            [dictItem release];
            [arrContents release];
            [self showMultiItemOrderUI];

        }
        

        /*
        CustomDrinkViewController *obj=[[CustomDrinkViewController alloc]initWithNibName:@"CustomDrinkViewController" bundle:nil];
        obj.viewtype=1;
        id object=[arrMenu objectAtIndex:indexPath.section-(2+[arrCustomDrinks count])];
        NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
        obj.dictitemdetails=[arrContents objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:obj animated:YES];
         */
          /*  id object=[arrMenu objectAtIndex:indexPath.section-(2+[arrCustomDrinks count])];
            NSDictionary *dict;
            if(indexPath.section==1&&[object isKindOfClass:[NSArray class]])
            {
                dict=[object objectAtIndex:indexPath.row];
            }
            else
            {
                NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
                dict=[arrContents objectAtIndex:indexPath.row];
                
            }

        dictSelectedToMakeOrder=[[NSDictionary alloc]initWithDictionary:dict];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UIView *viewA=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480+23)];
        viewA.backgroundColor=[UIColor clearColor];
        viewA.tag=222;
        [self.view addSubview:viewA];
        
        UIView *viewB=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480+23)];
        viewB.backgroundColor=[UIColor blackColor];
        viewB.layer.opacity=0.6;
        viewB.tag=333;
        [viewA addSubview:viewB];
        
        UIView *viewC = [[UIView alloc]initWithFrame:CGRectMake(12, 20, 295, 358)];
        viewC.layer.cornerRadius = 2;
        viewC.layer.borderWidth = 2;
        viewC.backgroundColor = [UIColor redColor];
        viewC.layer.borderColor = [UIColor redColor].CGColor;
        viewC.layer.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
        viewC.tag=444;
        [viewB addSubview:viewC];
        
        UIView *viewHeaderPhoto = [[UIView alloc]initWithFrame:CGRectMake(11, 5, 268, 90)];
        viewHeaderPhoto.backgroundColor = [UIColor blackColor];
        viewHeaderPhoto.layer.cornerRadius = 6;
        viewHeaderPhoto.tag = 11111;
        [viewC addSubview:viewHeaderPhoto];
                
        //NSMutableArray *arrPeopleTemp=[[NSMutableArray alloc]initWithArray:arrPeople];
        //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"bartsyId == %i",[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] integerValue]];
        //[arrPeopleTemp filterUsingPredicate:predicate];
        
        NSLog(@"Bartsy id is %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]);
        if([dictPeopleSelectedForDrink count])
        {
            dictTemp=[[NSMutableDictionary alloc] initWithDictionary:dictPeopleSelectedForDrink];
        }
        else
        {
            for (int i=0; i<[arrPeople count]; i++)
            {
                NSDictionary *dictMember=[arrPeople objectAtIndex:i];
                if([[NSString stringWithFormat:@"%@",[dictMember objectForKey:@"bartsyId"]]isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]]])
                {
                    dictTemp=[[NSMutableDictionary alloc] initWithDictionary:dictMember];
                    break;
                }
            }
        }
       
        
        UIImageView *imgViewPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(10,10,60,60)];
        NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictTemp objectForKey:@"userImagePath"]];
        NSLog(@"URL is %@",dictTemp);
        //[imgViewPhoto setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]]]];
        imgViewPhoto.tag=143225;
        [imgViewPhoto setImageWithURL:[NSURL URLWithString:strURL]];
        [viewHeaderPhoto addSubview:imgViewPhoto];
        [imgViewPhoto release];
        
        NSLog(@"nickname is %@",[dictTemp objectForKey:@"nickname"]);
        
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 72, 120, 18)];
        lblName.text=[dictTemp objectForKey:@"nickName"];
        lblName.font=[UIFont systemFontOfSize:10];
        lblName.tag=111222333;
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=[UIColor whiteColor];
        [viewHeaderPhoto addSubview:lblName];
        [lblName release];
        
        UILabel *lblMsg=[[UILabel alloc]initWithFrame:CGRectMake(85, 10, 160, 60)];
        lblMsg.text=@"Click on photo if you would like to send drink to other people";
        lblMsg.font=[UIFont systemFontOfSize:15];
        lblMsg.numberOfLines=3;
        lblMsg.backgroundColor=[UIColor clearColor];
        lblMsg.textColor=[UIColor whiteColor];
        [viewHeaderPhoto addSubview:lblMsg];
        [lblMsg release];

        
        UIButton *btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPhoto.frame = CGRectMake(10,5,105,50);
        [btnPhoto addTarget:self action:@selector(btnPhoto_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        btnPhoto.backgroundColor=[UIColor clearColor];
        [viewHeaderPhoto addSubview:btnPhoto];
        
        [viewHeaderPhoto release];

        
        UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(11, 100, 268, 45)];
        viewHeader.backgroundColor = [UIColor blackColor];
        viewHeader.layer.cornerRadius = 6;
        viewHeader.tag = 555;
        [viewC addSubview:viewHeader];
        [viewHeader release];
        
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(7, 7, 250, 30)];
        lblTitle.font = [UIFont boldSystemFontOfSize:15];
        lblTitle.text = [dict objectForKey:@"name"];
        lblTitle.tag = 666;
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = [UIColor whiteColor] ;
        lblTitle.textAlignment = NSTextAlignmentCenter;
        [viewHeader addSubview:lblTitle];
        [lblTitle release];
        
        UIButton *btnLike = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnLike.frame = CGRectMake(10,153,60,35);
        btnLike.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btnLike setTitle:@"Like" forState:UIControlStateNormal];
        btnLike.titleLabel.textColor = [UIColor blackColor];
        [btnLike addTarget:self action:@selector(btnLike_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [viewC addSubview:btnLike];
        
        UIButton *btnComment = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnComment.frame = CGRectMake(75,153,60,35);
        btnComment.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btnComment setTitle:@"Comment" forState:UIControlStateNormal];
        btnComment.titleLabel.textColor = [UIColor blackColor];
        [btnComment addTarget:self action:@selector(btnComment_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [viewC addSubview:btnComment];
        
        UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnShare.frame = CGRectMake(140,153,60,35);
        btnShare.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btnShare setTitle:@"Share" forState:UIControlStateNormal];
        btnShare.titleLabel.textColor = [UIColor blackColor];
        [btnShare addTarget:self action:@selector(btnShare_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [viewC addSubview:btnShare];
        
        UIButton *btnFav = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFav setImage:[UIImage imageNamed:@"icon_favorites.png"] forState:UIControlStateNormal];
        btnFav.frame = CGRectMake(205,150,52,40);
        [btnFav addTarget:self action:@selector(btnFav_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [viewC addSubview:btnFav];
        
        UIView *viewDetail = [[UIView alloc]initWithFrame:CGRectMake(11, 153+40, 200, 60)];
        viewDetail.backgroundColor = [UIColor whiteColor];
        viewDetail.layer.borderWidth = 1;
        viewDetail.layer.borderColor = [UIColor grayColor].CGColor;
        viewDetail.layer.cornerRadius = 6;
        viewDetail.tag = 777;
        [viewC addSubview:viewDetail];
        [viewDetail release];
        
        //    UIImageView *imgViewDrink = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 80)];
        //    imgViewDrink.image = [UIImage imageNamed:@"drinks.png"];
        //    imgViewDrink.layer.borderWidth = 1;
        //    imgViewDrink.layer.cornerRadius = 2;
        //    imgViewDrink.layer.borderColor = [UIColor grayColor].CGColor;
        //    [[imgViewDrink layer] setShadowOffset:CGSizeMake(0, 1)];
        //    [[imgViewDrink layer] setShadowColor:[[UIColor grayColor] CGColor]];
        //    [[imgViewDrink layer] setShadowRadius:3.0];
        //    [[imgViewDrink layer] setShadowOpacity:0.8];
        //    [viewDetail addSubview:imgViewDrink];
        //    [imgViewDrink release];
        
        UITextView *txtViewNotes = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 185, 50)];
        txtViewNotes.delegate = self;
        txtViewNotes.tag = 1000;
        txtViewNotes.backgroundColor = [UIColor clearColor];
        txtViewNotes.editable = NO;
        txtViewNotes.text = [dict objectForKey:@"description"];
        txtViewNotes.textColor = [UIColor blackColor];
        txtViewNotes.font = [UIFont boldSystemFontOfSize:10];
        [viewDetail addSubview:txtViewNotes];
        [txtViewNotes release];
        
        UIButton *btnCustomise = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCustomise.frame = CGRectMake(50,65,105,25);
        btnCustomise.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btnCustomise setTitle:@"Customise" forState:UIControlStateNormal];
        btnCustomise.titleLabel.textColor = [UIColor whiteColor];
        btnCustomise.backgroundColor=[UIColor blackColor];
        [btnCustomise addTarget:self action:@selector(btnCustomise_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        //[viewDetail addSubview:btnCustomise];
        
        UIView *viewPrice = [[UIView alloc]initWithFrame:CGRectMake(216, 153+40, 63, 60)];
        viewPrice.backgroundColor = [UIColor whiteColor];
        viewPrice.layer.borderWidth = 1;
        viewPrice.layer.borderColor = [UIColor grayColor].CGColor;
        viewPrice.layer.cornerRadius = 6;
        viewPrice.tag = 888;
        [viewC addSubview:viewPrice];
        [viewPrice release];
        
        UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 63, 60)];
        lblPrice.font = [UIFont boldSystemFontOfSize:20];
        lblPrice.text = [NSString
                         stringWithFormat:@"$%@",[dict objectForKey:@"price"]];
        lblPrice.backgroundColor = [UIColor clearColor];
        lblPrice.textColor = [UIColor brownColor] ;
        lblPrice.textAlignment = NSTextAlignmentCenter;
        [viewPrice addSubview:lblPrice];
        [lblPrice release];
        
        //    UILabel *lblPriceOff = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 63, 30)];
        //    lblPriceOff.font = [UIFont boldSystemFontOfSize:12];
        //    lblPriceOff.text = @"($2 off)";
        //    lblPriceOff.backgroundColor = [UIColor clearColor];
        //    lblPriceOff.textColor = [UIColor blackColor] ;
        //    lblPriceOff.textAlignment = NSTextAlignmentCenter;
        //    [viewPrice addSubview:lblPriceOff];
        //    [lblPriceOff release];
        
        UIView *viewTip = [[UIView alloc]initWithFrame:CGRectMake(11, 261, 268, 45)];
        viewTip.backgroundColor = [UIColor whiteColor];
        viewTip.layer.borderWidth = 1;
        viewTip.layer.borderColor = [UIColor grayColor].CGColor;
        viewTip.layer.cornerRadius = 6;
        viewTip.tag = 999;
        [viewC addSubview:viewTip];
        [viewTip release];
        
        UILabel *lblTip = [[UILabel alloc]initWithFrame:CGRectMake(8, 7, 30, 30)];
        lblTip.font = [UIFont boldSystemFontOfSize:12];
        lblTip.text = @"Tip:";
        lblTip.backgroundColor = [UIColor clearColor];
        lblTip.textColor = [UIColor blackColor] ;
        lblTip.textAlignment = NSTextAlignmentCenter;
        [viewTip addSubview:lblTip];
        [lblTip release];
        
        
        UIButton *btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn10.frame = CGRectMake(37,10,23,23);
        btn10.tag = 10;
        [btn10 setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
        [btn10 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [viewTip addSubview:btn10];
        
        
        UILabel *lbl10 = [[UILabel alloc]initWithFrame:CGRectMake(60, 7, 30, 30)];
        lbl10.font = [UIFont boldSystemFontOfSize:12];
        lbl10.text = @"10%";
        lbl10.backgroundColor = [UIColor clearColor];
        lbl10.textColor = [UIColor blackColor] ;
        lbl10.textAlignment = NSTextAlignmentCenter;
        [viewTip addSubview:lbl10];
        [lbl10 release];
        
        UIButton *btn20 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn20.frame = CGRectMake(90,10,23,23);
        btn20.tag = 15;
        [btn20 setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
        [btn20 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [viewTip addSubview:btn20];
        
        UILabel *lbl15 = [[UILabel alloc]initWithFrame:CGRectMake(118, 7, 30, 30)];
        lbl15.font = [UIFont boldSystemFontOfSize:12];
        lbl15.text = @"15%";
        lbl15.backgroundColor = [UIColor clearColor];
        lbl15.textColor = [UIColor blackColor] ;
        lbl15.textAlignment = NSTextAlignmentCenter;
        [viewTip addSubview:lbl15];
        [lbl15 release];
        
        UIButton *btn30 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn30.frame = CGRectMake(148,10,23,23);
        [btn30 setBackgroundImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
        btn30.tag = 20;
        [btn30 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [viewTip addSubview:btn30];
        
        btnValue=btn30.tag;

        UILabel *lbl20 = [[UILabel alloc]initWithFrame:CGRectMake(180, 7, 30, 30)];
        lbl20.font = [UIFont boldSystemFontOfSize:12];
        lbl20.text = @"20%";
        lbl20.backgroundColor = [UIColor clearColor];
        lbl20.textColor = [UIColor blackColor] ;
        lbl20.textAlignment = NSTextAlignmentCenter;
        [viewTip addSubview:lbl20];
        [lbl20 release];
        
        UIButton *btn40 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn40.frame = CGRectMake(210,10,23,23);
        [btn40 setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
        btn40.tag = 40;
        [btn40 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        //[viewTip addSubview:btn40];
        
        UITextField *txtFieldTip = [[UITextField alloc] initWithFrame:CGRectMake(223,7, 40, 30)];
        [txtFieldTip setBackground:[UIImage imageNamed:@"txt-box1.png"]];
        txtFieldTip.delegate = self;
        txtFieldTip.tag = 500;
        txtFieldTip.font = [UIFont boldSystemFontOfSize:12];
        txtFieldTip.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtFieldTip.textAlignment = NSTextAlignmentCenter;
        txtFieldTip.autocorrectionType = UITextAutocorrectionTypeNo;
        //[viewTip addSubview:txtFieldTip];
        [txtFieldTip release];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame = CGRectMake(148,317,120,30);
        btnCancel.titleLabel.textColor = [UIColor whiteColor];
        [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        btnCancel.backgroundColor=[UIColor blackColor];
        [btnCancel addTarget:self action:@selector(btnCancel_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [viewC addSubview:btnCancel];
        
        UIButton *btnOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        btnOrder.frame = CGRectMake(20,317,115,30);
        [btnOrder setTitle:@"Order" forState:UIControlStateNormal];
        btnOrder.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        btnOrder.titleLabel.textColor = [UIColor whiteColor];
        btnOrder.backgroundColor=[UIColor blackColor];
        [btnOrder addTarget:self action:@selector(btnOrder_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [viewC addSubview:btnOrder];
        
        [viewA release];
        [viewB release];
        [viewC release];*/
    
    }else if (indexPath.section>1+[arrCustomDrinks count]+[arrMenu count]&&indexPath.section<2+[arrCustomDrinks count]+[arrMenu count]+[arrCocktailsSection count]){
        
       /* NSMutableArray *arrMultiItemOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"multiitemorders"]];
        
        id object=[arrCocktailsSection objectAtIndex:indexPath.section-(2+[arrCustomDrinks count]+[arrMenu count])];
        NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
        
        NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:[arrContents objectAtIndex:indexPath.row]];
        if ([dictItem valueForKey:@"option_groups"]) {
            
        }else{
            
        }
        [dictItem setObject:@"" forKey:@"specialInstructions"];
        [dictItem setObject:@"Menu" forKey:@"ItemType"];
        [dictItem setObject:[NSNumber numberWithInt:3] forKey:@"Viewtype"];

        [arrMultiItemOrders addObject:dictItem];
        
        [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [arrMultiItemOrders release];
        [dictItem release];
        [self showMultiItemOrderUI];*/

        
        NSArray *tempArray=[[arrCocktailsSection objectAtIndex:indexPath.section-([arrCustomDrinks count]+2+[arrMenu count])] valueForKey:@"contents"];

        if ([[tempArray objectAtIndex:indexPath.row] valueForKey:@"option_groups"]) {
            CustomDrinkViewController *obj=[[CustomDrinkViewController alloc]initWithNibName:@"CustomDrinkViewController" bundle:nil];
            obj.viewtype=3;
            obj.dictitemdetails=[tempArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:obj animated:YES];
        }else{
            
            NSMutableArray *arrMultiItemOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"multiitemorders"]];
            
            id object=[arrCocktailsSection objectAtIndex:indexPath.section-(2+[arrCustomDrinks count]+[arrMenu count])];
            NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
            
            NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:[arrContents objectAtIndex:indexPath.row]];
            
            [dictItem setObject:@"" forKey:@"special_Instructions"];
            [dictItem setObject:@"Menu" forKey:@"ItemType"];
            [dictItem setObject:[NSNumber numberWithInt:1] forKey:@"Viewtype"];
            
            [arrMultiItemOrders addObject:dictItem];
            
            [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
           // [[NSUserDefaults standardUserDefaults]synchronize];
            [arrMultiItemOrders release];
            [dictItem release];
            [arrContents release];
            [self showMultiItemOrderUI];
        }
        
        
    }else if (indexPath.section==0){
        NSDictionary *dictFavTemp=[arrFavorites objectAtIndex:indexPath.row];
        if ([dictFavTemp valueForKey:@"option_groups"]) {
           // NSLog(@"%@",dictFavTemp);
            if ([dictFavTemp valueForKey:@"price"] && [[dictFavTemp valueForKey:@"price"] integerValue]==0) {
                CustomDrinkViewController *obj=[[CustomDrinkViewController alloc]initWithNibName:@"CustomDrinkViewController" bundle:nil];
                obj.viewtype=4;
                obj.isEdit=NO;
                obj.dictitemdetails=dictFavTemp;
                [self.navigationController pushViewController:obj animated:YES];
            }else{
                
                NSMutableArray *arrMultiItemOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"multiitemorders"]];
                
                id object=[arrFavorites objectAtIndex:indexPath.row];
                
                NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:object];
                [dictItem setObject:@"" forKey:@"special_Instructions"];
                [dictItem setObject:@"Menu" forKey:@"ItemType"];
                [dictItem setObject:[NSNumber numberWithInt:1] forKey:@"Viewtype"];
                //[dictItem setObject:[object objectForKey:@"section_name"] forKey:@"menu_path"];
                [arrMultiItemOrders addObject:dictItem];
                
                [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
                //[[NSUserDefaults standardUserDefaults]synchronize];
                [arrMultiItemOrders release];
                [dictItem release];
                
                [self showMultiItemOrderUI];

            }
            
        }

    }else if (indexPath.section==1){
        
        NSDictionary *dictFavTemp=[arrRecentOrders objectAtIndex:indexPath.row];
        if ([dictFavTemp valueForKey:@"option_groups"]) {
            // NSLog(@"%@",dictFavTemp);
            if ([dictFavTemp valueForKey:@"price"] && [[dictFavTemp valueForKey:@"price"] integerValue]==0) {
                CustomDrinkViewController *obj=[[CustomDrinkViewController alloc]initWithNibName:@"CustomDrinkViewController" bundle:nil];
                obj.viewtype=4;
                obj.isEdit=NO;
                obj.dictitemdetails=dictFavTemp;
                [self.navigationController pushViewController:obj animated:YES];
            }else{
                
                NSMutableArray *arrMultiItemOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"multiitemorders"]];
                
                id object=[arrRecentOrders objectAtIndex:indexPath.row];
                
                NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:object];
                [dictItem setObject:@"" forKey:@"special_Instructions"];
                [dictItem setObject:@"Menu" forKey:@"ItemType"];
                [dictItem setObject:[NSNumber numberWithInt:1] forKey:@"Viewtype"];
                //[dictItem setObject:[object objectForKey:@"section_name"] forKey:@"menu_path"];
                [arrMultiItemOrders addObject:dictItem];
                
                [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
                //[[NSUserDefaults standardUserDefaults]synchronize];
                [arrMultiItemOrders release];
                [dictItem release];
                
                [self showMultiItemOrderUI];
                
            }
            
        }


    }
   }
    else if(isSelectedForPeople)
    {
        if (![[NSUserDefaults standardUserDefaults] valueForKey:@"CheckInVenueId"]) {
            
            [self createAlertViewWithTitle:@"" message:@"Please checkin the venue to proceed" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
            return;
        }
        NSDictionary *dictPeople=[arrPeople objectAtIndex:indexPath.row];

        if ([[dictPeople objectForKey:@"hasMessages"] isEqualToString:@"New"]) {
        
            MessageListViewController *obj = [[MessageListViewController alloc] init];
            obj.dictForReceiver = [arrPeople objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:obj animated:YES];
            [obj release];
        }else{
            PeopleDetailViewController *obj = [[PeopleDetailViewController alloc] init];
            obj.dictPeople = [arrPeople objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:obj animated:YES];
            [obj release];
        }
        
    }
    // Navigation logic may go here. Create and push another view controller.
}

-(void)btnPhoto_TouchUpInside
{
    
    PeopleViewController *obj=[[PeopleViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:obj];
    obj.arrPeople=arrPeople;
    [self presentViewController:nav animated:YES completion:nil];
    [nav release];
    [obj release];
    
}

-(void)selectedPeople:(NSNotification*)notification
{
    
    UIButton *checkinBtn=(UIButton*)[self.view viewWithTag:3334];
    checkinBtn.hidden=YES;
    
    UIButton *drinkBtn=(UIButton*)[self.view viewWithTag:1117];
    if (!drinkBtn) {
        UIButton *drinkBtn=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"drink"] frame:CGRectMake(280, 8, 30, 30) tag:1117 selector:@selector(btnOrder_TouchUpInside:) target:self];
        [self.view addSubview:drinkBtn];
        
    }

    UIView *popview=(UIView*)[self.view viewWithTag:2221];
    [self.view bringSubviewToFront:popview];
    //UIButton *drinkBtn=(UIButton*)[self.view viewWithTag:1117];
    //UIImageView *imgcount=(UIImageView*)[popview viewWithTag:1005];
   // imgcount.image=[UIImage imageNamed:@"drink"];
    /*[imgcount removeFromSuperview];
    if (!drinkBtn) {
        UIButton *drinkBtn=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"drink"] frame:CGRectMake(280, 8, 30, 30) tag:1117 selector:@selector(btnOrder_TouchUpInside:) target:self];
        [popview addSubview:drinkBtn];
        
    }else{
        [popview addSubview:drinkBtn];
    }*/

    dictPeopleSelectedForDrink=[[NSDictionary alloc]initWithDictionary:notification.object];
    UIImageView *imgView=(UIImageView*)[self.view viewWithTag:143225];
    NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictPeopleSelectedForDrink objectForKey:@"userImagePath"]];
    NSLog(@"URL is %@",dictPeopleSelectedForDrink);
    //[imgView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]]]];
    [imgView setImageWithURL:[NSURL URLWithString:strURL]];
    UILabel *lblName=(UILabel*)[self.view viewWithTag:2223];
    lblName.text=[dictPeopleSelectedForDrink objectForKey:@"nickName"];

    
}

-(void)btnLike_TouchUpInside
{
    /*
    NSString *urlToLikeFor = @"https://www.facebook.com/techvedika";
    
    NSString *theWholeUrl = [NSString stringWithFormat:@"https://graph.facebook.com/me/og.likes?object=%@&access_token=%@", urlToLikeFor, appDelegate.session.accessTokenData.accessToken];
    NSURL *facebookUrl = [NSURL URLWithString:theWholeUrl];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:facebookUrl];
    [req setHTTPMethod:@"POST"];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&err];
    NSString *content = [NSString stringWithUTF8String:[responseData bytes]];
    
    NSLog(@"responseData: %@", content);
     */
}

-(void)btnComment_TouchUpInside
{
    
}

-(void)btnShare_TouchUpInside
{
    
}

-(void)btnFav_TouchUpInside
{
    
}

#pragma mark - TextFields Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *viewC=(UIView*)[self.view viewWithTag:444];
    viewC.frame=CGRectMake(12, -2, 295, 268);
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    UIView *viewC=(UIView*)[self.view viewWithTag:444];
    viewC.frame=CGRectMake(12, 50, 295, 268);
    return YES;
}

- (void)loginToGateway
{
    [self createProgressViewToParentView:self.view withTitle:@"Payment is processing..."];
   
    MobileDeviceLoginRequest *mobileDeviceLoginRequest =
    [MobileDeviceLoginRequest mobileDeviceLoginRequest];
    
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.name = @"sudheerp143";
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.password =@"Techvedika@007";
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.mobileDeviceId =@"ABCDEF";
    
    //[[[UIDevice currentDevice] uniqueIdentifier]
     //stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    
    [AuthNet authNetWithEnvironment:ENV_TEST];
    
    AuthNet *an = [AuthNet getInstance];    
    [an setDelegate:self];

    [an mobileDeviceLoginRequest: mobileDeviceLoginRequest];
}

- (void) createTransaction
{
    AuthNet *an = [AuthNet getInstance];
    
    [an setDelegate:self];
    
    CreditCardType *creditCardType = [CreditCardType creditCardType];
    creditCardType.cardNumber = @"4111111111111111";
    creditCardType.cardCode = @"100";
    creditCardType.expirationDate = @"1213";
    
    PaymentType *paymentType = [PaymentType paymentType];
    paymentType.creditCard = creditCardType;
    
    ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeTax.amount = @"0";
    extendedAmountTypeTax.name = @"Tax";
    
    ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeShipping.amount = @"0";
    extendedAmountTypeShipping.name = @"Shipping";
    
    NSString *strTip;
    if(btnValue!=40)
        strTip=[NSString stringWithFormat:@"%i",btnValue];
    else
    {
        UITextField *txtFld=(UITextField*)[self.view viewWithTag:500];
        strTip=[NSString stringWithFormat:@"%i",[txtFld.text integerValue]];
    }    
    float subTotal=([[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]*(([strTip floatValue]+9)))/100;
    float totalPrice=[[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]+subTotal;
    NSString *strPrice=[NSString stringWithFormat:@"%.2f",totalPrice];
    
    LineItemType *lineItem = [LineItemType lineItem];
    lineItem.itemName = [dictSelectedToMakeOrder objectForKey:@"name"];
    lineItem.itemDescription = [dictSelectedToMakeOrder objectForKey:@"description"];
    lineItem.itemQuantity = @"1";
    lineItem.itemPrice = strPrice;
    lineItem.itemID = [dictSelectedToMakeOrder objectForKey:@"id"];
    
    TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
    requestType.lineItems = [NSArray arrayWithObject:lineItem];
    requestType.amount = strPrice;
    requestType.payment = paymentType;
    requestType.tax = extendedAmountTypeTax;
    requestType.shipping = extendedAmountTypeShipping;
    
    CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
    request.transactionRequest = requestType;
    request.transactionType = AUTH_ONLY;
    request.anetApiRequest.merchantAuthentication.mobileDeviceId =
    [[[UIDevice currentDevice] uniqueIdentifier]
     stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    request.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
    [an purchaseWithRequest:request];
}

- (void) requestFailed:(AuthNetResponse *)response
{
    // Handle a failed request
}

- (void) connectionFailed:(AuthNetResponse *)response
{
    // Handle a failed connection
}

- (void) paymentSucceeded:(CreateTransactionResponse *) response
{
    // Handle payment success
    [self hideProgressView:nil];
    [self btnOrder_TouchUpInside:nil];
    
    
    
}

- (void) mobileDeviceLoginSucceeded:(MobileDeviceLoginResponse *)response
{
    sessionToken = [response.sessionToken retain];
    NSLog(@"Token is %@",sessionToken);
    [self createTransaction];
};



-(void)btnCustomise_TouchUpInside
{
    
}
-(void)buttonClicked:(UIButton*)sender
{
    NSInteger intTag=sender.tag-1;
    if(sender.tag>=0)
    {
        if (intTag==0 || intTag==1) {
            NSMutableDictionary *dict=[ArrMenuSections objectAtIndex:intTag];
            BOOL boolArrow=!([[dict objectForKey:@"Arrow"] integerValue]);
            NSString *strArrow=[NSString stringWithFormat:@"%i",boolArrow];
            [dict setObject:strArrow forKey:@"Arrow"];
            [ArrMenuSections replaceObjectAtIndex:intTag withObject:dict];
 
        }else if(intTag>1+[arrCustomDrinks count]&&intTag<2+[arrCustomDrinks count]+[arrMenu count]){
            //[self createAlertViewWithTitle:@"" message:@"Work in Progress" cancelBtnTitle:nil otherBtnTitle:@"OK" delegate:self tag:0];
            NSMutableDictionary *dict=[arrMenu objectAtIndex:intTag-(2+[arrCustomDrinks count])];
            BOOL boolArrow=!([[dict objectForKey:@"Arrow"] integerValue]);
            NSString *strArrow=[NSString stringWithFormat:@"%i",boolArrow];
            [dict setObject:strArrow forKey:@"Arrow"];
            [arrMenu replaceObjectAtIndex:intTag-(2+[arrCustomDrinks count]) withObject:dict];
           
        }else if(intTag>1 && intTag<(2+[arrCustomDrinks count]))
        {
            NSMutableDictionary *dict=[arrCustomDrinks objectAtIndex:intTag-2];
            BOOL boolArrow=!([[dict objectForKey:@"Arrow"] integerValue]);
            NSString *strArrow=[NSString stringWithFormat:@"%i",boolArrow];
            [dict setObject:strArrow forKey:@"Arrow"];
            [arrCustomDrinks replaceObjectAtIndex:intTag-2 withObject:dict];

        }else{
            NSMutableDictionary *dict=[arrCocktailsSection objectAtIndex:intTag-(2+[arrCustomDrinks count]+[arrMenu count])];
            BOOL boolArrow=!([[dict objectForKey:@"Arrow"] integerValue]);
            NSString *strArrow=[NSString stringWithFormat:@"%i",boolArrow];
            [dict setObject:strArrow forKey:@"Arrow"];
            [arrCocktailsSection replaceObjectAtIndex:intTag-(2+[arrCustomDrinks count]+[arrMenu count]) withObject:dict];

        }
               
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        [tblView reloadData];
    }
    else
    {
        /*
        CustomDrinksViewController *obj=[[CustomDrinksViewController alloc]init];
        [self.navigationController pushViewController:obj animated:YES];
        [obj release];
        */
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Back" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moveBack) name:@"Back" object:nil];

        self.navigationController.navigationBarHidden=YES;
        
        FrontViewController *frontViewController = [[FrontViewController alloc] init];
        RearViewController *rearViewController = [[RearViewController alloc] init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        
        RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:rearViewController];
        [self.navigationController pushViewController:revealController animated:YES];
         
        
    }
    
}

-(void)moveBack
{
    for (UIViewController *viewController in self.navigationController.viewControllers)
    {
        if([viewController isKindOfClass:[HomeViewController class]])
        {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}

#pragma mark----------PageControl

- (void)changePage:(id)sender {
    
    int page = ((UIPageControl *)sender).currentPage;
    
    // update the scroll view to the appropriate page
    CGRect frame = topscrollView.frame;
    CGFloat axis = frame.size.width * page;
    frame.origin.y = 0;
    
    
    frame.origin.x=axis;
    [topscrollView scrollRectToVisible:frame animated:YES];
    
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;
}

#pragma mark----------ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (sender==topscrollView) {
        
    
    //if (_pageControlUsed) {
        
      //  return;
    //}
    CGFloat pageWidth = topscrollView.frame.size.width;
    int page = floor((topscrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    pagectrl.currentPage = page;
    }
}

-(void)dealloc{
    [super dealloc];
    [arrMenu release];
    [arrPastOrders release];
    [arrFavorites release];
    [arrCocktailsSection release];
    [arrCustomDrinks release];
    [ArrMenuSections release];
    [arrPeople release];
    [arrRecentOrders release];
    [topscrollView release];
    [pagectrl release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
