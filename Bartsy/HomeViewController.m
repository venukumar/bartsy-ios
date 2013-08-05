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
        
        appDelegate.isComingForPeople=NO;
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
    btnBack.frame = CGRectMake(5, 0, 50, 40);
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
    
    
    UIBarButtonItem *btnLogOut=[[UIBarButtonItem alloc]initWithTitle:@"Check out" style:UIBarButtonItemStylePlain target:self action:@selector(backLogOut_TouchUpInside)];
    self.navigationItem.rightBarButtonItem=btnLogOut;
    
   
   /* UIButton *btnCheckOut=[self createUIButtonWithTitle:@"Checkout" image:nil frame:CGRectMake(250, 5, 65, 35) tag:0 selector:@selector(backLogOut_TouchUpInside) target:self];
    btnCheckOut.titleLabel.font=[UIFont systemFontOfSize:14];
    [btnCheckOut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btnCheckOut];*/
    
    
    UIButton *checkinBtn=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"tick_mark"] frame:CGRectMake(280, 8, 28, 28) tag:3333 selector:@selector(CheckinButton_Action:) target:self];
    [self.view addSubview:checkinBtn];
    
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

    arrStatus=[[NSArray alloc]initWithObjects:@"Waiting for bartender to accept",@"Your order was rejected by Bartender",@"Order was accepted",@"Ready for pickup",@"Order is Failed",@"Order is picked up",@"Noshow",@"Your order was timedout",@"Your order was rejected",@"Drink offered",@"Past Order", nil];
    arrOrdersOffered=[[NSMutableArray alloc]init];
    
    NSString *strOrder=[NSString stringWithFormat:@"Orders (%i)",appDelegate.intOrderCount];
    NSString *strPeopleCount=[NSString stringWithFormat:@"People (%i)",appDelegate.intPeopleCount];
    [self getPeopleList];
    [self getPastorderAsynchronously];
    // Pagecontrol with scrollview
     topscrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,45,320,120)];
     topscrollView.scrollEnabled=YES;
     topscrollView.pagingEnabled=YES;
     topscrollView.delegate=self;
     topscrollView.showsHorizontalScrollIndicator=NO;
     [topscrollView setBackgroundColor:[UIColor clearColor]];
     [self.view addSubview:topscrollView];
     NSLog(@"dictvenue %@",dictVenue);
     NSArray *temparray=[NSArray arrayWithObjects:@"background-img",@"background-img-A",@"background-img1",nil];
     for (int i=0; i<3; i++) {
     
         UIImageView *imgview=[self createImageViewWithImage:[UIImage imageNamed:[temparray objectAtIndex:i] ] frame:CGRectMake(320*i, 0, 320, 120) tag:0];
         [topscrollView addSubview:imgview];
     
         UIImageView *wifiimg=[[UIImageView alloc]initWithFrame:CGRectMake(18+(320*i),85,34, 16)];
         wifiimg.image=[UIImage imageNamed:@"wifi-icon"];
         [topscrollView addSubview:wifiimg];
         [wifiimg release];
         
         UIImageView *infoimg=[[UIImageView alloc]initWithFrame:CGRectMake(275+(320*i),80,25, 25)];
         infoimg.image=[UIImage imageNamed:@"i-icon"];
         [topscrollView addSubview:infoimg];
         [infoimg release];
         if (i==0) {
             UILabel *address=[self createLabelWithTitle:[dictVenue valueForKey:@"address"] frame:CGRectMake(31, 0, 260, 120) tag:0 font:[UIFont systemFontOfSize:22] color:[UIColor colorWithRed:191.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0] numberOfLines:3];
             address.textAlignment=NSTextAlignmentCenter;
             [imgview addSubview:address];
         }
        
     
     
     }
     [topscrollView setContentSize:CGSizeMake(3*320,120)];
     pagectrl=[[UIPageControl alloc]initWithFrame:CGRectMake(110, 140, 100, 20)];
     pagectrl.numberOfPages=3;
     [pagectrl setBackgroundColor:[UIColor clearColor]];
     [self.view addSubview:pagectrl];
     [pagectrl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Menu",strPeopleCount,strOrder,@"Past Orders", nil]];
    segmentControl.frame=CGRectMake(2, 167, 316, 40);
    UIFont *font = [UIFont systemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    [segmentControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    segmentControl.segmentedControlStyle=UISegmentedControlStyleBar;
    segmentControl.selectedSegmentIndex=0;
    segmentControl.tag=1111;
    [segmentControl addTarget:self action:@selector(segmentControl_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
    
    [segmentControl setBackgroundImage:[UIImage imageNamed:@"menu-bg.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    [segmentControl setBackgroundImage:[UIImage imageNamed:@"menu-bg-hover.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    
    
    self.sharedController=[SharedController sharedController];
    
    
    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 323-topscrollView.frame.size.height)];
    tblView.dataSource=self;
    tblView.backgroundColor = [UIColor blackColor];
    tblView.delegate=self;
    tblView.tag=111;
    [self.view addSubview:tblView];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568)
    {
        tblView.frame=CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 323+90-topscrollView.frame.size.height);
    }
    
    [tblView release];
    
    //tblView.userInteractionEnabled=NO;
    
    //optional pre init, so the ZooZ screen will upload immediatly, you can skip this call
    //    ZooZ * zooz = [ZooZ sharedInstance];
    //    [zooz preInitialize:@"c7659586-f78a-4876-b317-1b617ec8ab40" isSandboxEnv:IS_SANDBOX];
    
    
    //storing venue ID to call in timerforgetmessage
    [[NSUserDefaults standardUserDefaults]setObject:[dictVenue objectForKey:@"venueId"] forKey:@"selectedVenueID"];
    
    [appDelegate startTimerTOGetMessages];
    
    //Registering local Notification
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PeopleSelected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedPeople:) name:@"PeopleSelected" object:nil];
    
    ArrMenuSections=[NSMutableArray new ];
    [ArrMenuSections addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"Arrow",@"Recent Orders",@"SectionName", nil]];
    [ArrMenuSections addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"Arrow",@"Favorites",@"SectionName", nil]];
    
    arrFavorites=[NSMutableArray new];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]);
    if(!([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]==nil)){
        
        [topscrollView removeFromSuperview];
        [pagectrl removeFromSuperview];
        UIButton *checkinBtn=(UIButton*)[self.view viewWithTag:3333];
        [checkinBtn setImage:[UIImage imageNamed:@"tickmark_select"] forState:UIControlStateNormal];
        checkinBtn.tag=3334;
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
        
        UIView *popupView=(UIView*)[self.view viewWithTag:2221];
        popupView.hidden=YES;
        UIButton *checkinBtn=(UIButton*)[self.view viewWithTag:3334];
        checkinBtn.hidden=YES;
        UIButton *drinkBtn=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"drink"] frame:CGRectMake(280, 8, 27, 27) tag:1117 selector:@selector(btnOrder_TouchUpInside:) target:self];
        [self.view addSubview:drinkBtn];
        
        
    }else if (sender.tag==1116){
        
        NSMutableArray *arrMultiItems=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"multiitemorders"]];
        
        isRequestForOrder=YES;
        self.sharedController=[SharedController sharedController];
        if([[dictPeopleSelectedForDrink objectForKey:@"bartsyId"] isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]])
        {
            [self createProgressViewToParentView:self.view withTitle:@"Sending Order details to Bartender..."];
        }
        else
        {
            NSString *strMsg=[NSString stringWithFormat:@"Sending Order details to %@...",[dictPeopleSelectedForDrink objectForKey:@"nickName"]];
            [self createProgressViewToParentView:self.view withTitle:strMsg];
        }
      /*  NSString *strBasePrice=[NSString stringWithFormat:@"%.2f",[lblTotalPrice.text floatValue]];
        
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
            strBartsyId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]];*/
        NSMutableArray *arritemlist=[[NSMutableArray alloc]init];
        for (NSDictionary *dicttemp in arrMultiItems)
        {
            NSMutableDictionary *dictitem=[[NSMutableDictionary alloc]init];
            [dictitem setObject:[dicttemp valueForKey:@"name"] forKey:@"title"];
            [dictitem setObject:[dicttemp valueForKey:@"name"] forKey:@"itemName"];
            [dictitem setObject:[dicttemp valueForKey:@"description"] forKey:@"description"];
            [dictitem setObject:@"1" forKey:@"quantity"];
            [dictitem setObject:[dicttemp valueForKey:@"price"] forKey:@"basePrice"];
            [dictitem setObject:@"1" forKey:@"quantity"];
            if ([dicttemp valueForKey:@"id"]) {
                [dictitem setObject:[NSString stringWithFormat:@"%@",[dicttemp valueForKey:@"id"]] forKey:@"itemId"];

            }else{
                [dictitem setObject:@"" forKey:@"itemId"];

            }
            //[dictitem setObject:[dicttemp valueForKey:@"description"] forKey:@"specialInstructions"];
            [arritemlist addObject:dictitem];
            [dictitem release];
        }
        float taxPrice=[[NSUserDefaults standardUserDefaults] floatForKey:@"percentTAX"];
        float floatTotalTax=(ttlPrice*((float)taxPrice/100));

        float tiptotal=(ttlPrice*((float)btnValue/100));
        NSString *totalprice=[NSString stringWithFormat:@"%.2f",tiptotal+floatTotalTax+ttlPrice];
        [self.sharedController SaveOrderWithOrderStatus:@"0" basePrice:[NSString stringWithFormat:@"%.2f",ttlPrice] totalPrice:totalprice tipPercentage:[NSString stringWithFormat:@"%d",btnValue] itemName:@"" splcomments:@"" description:@"" itemlist:arritemlist receiverBartsyId:[dictPeopleSelectedForDrink valueForKey:@"bartsyId"] delegate:self];
        
        dictPeopleSelectedForDrink=nil;

        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"multiitemorders"];
        UIView *Backgroundview=(UIView*)[self.view viewWithTag:2221];
        [Backgroundview removeFromSuperview];
        
        UIButton *drinkBtn=(UIButton*)[self.view viewWithTag:1117];
        [drinkBtn removeFromSuperview];
        UIButton *checkinBtn=(UIButton*)[self.view viewWithTag:3334];
        [checkinBtn setImage:[UIImage imageNamed:@"tickmark_select"] forState:UIControlStateNormal];
        checkinBtn.hidden=NO;

        
    }
    else if(sender.tag==1117){
        
        UIButton *drinkBtn=(UIButton*)[self.view viewWithTag:1117];
        [drinkBtn removeFromSuperview];
        UIButton *checkinBtn=(UIButton*)[self.view viewWithTag:3334];
        [checkinBtn setImage:[UIImage imageNamed:@"tickmark_select"] forState:UIControlStateNormal];
        checkinBtn.hidden=NO;
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
    [self hideProgressView:nil];
    
    if([[result objectForKey:@"errorCode"] integerValue]!=0)
    {
        
        if ([[result objectForKey:@"errorMessage"] isKindOfClass:[NSNull class]])
        [self createAlertViewWithTitle:@"Error" message:@"Oops! Server failed to return" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
      else
        [self createAlertViewWithTitle:@"" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
        
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        [tblView reloadData];

    }
    else if(isRequestForOrder==NO&&isRequestForPeople==NO&&isRequestForGettingsOrders==NO&&isRequestForGettingsPastOrders == NO && isGettingIngradients==NO && isRequestCheckin==NO && isGettingCocktails==NO && isUserCheckOut==NO && isGetFavorites==NO)
    {
        
            [[NSUserDefaults standardUserDefaults] setObject:result forKey:[dictVenue objectForKey:@"venueId"]];
           // [[NSUserDefaults standardUserDefaults]synchronize];
          //  [arrMenu addObjectsFromArray:result];
          //  [self hideProgressView:nil];
            
            [self modifyData];

        
               
        isGettingIngradients=YES;
        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController getIngredientsListWithVenueId:[dictVenue objectForKey:@"venueId"] delegate:self];
        
        
    }
    else if(isRequestForOrder==YES)
    {
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
        NSLog(@"people result %@",result);
        SDImageCache *sharedSDImageCache=[SDImageCache sharedImageCache];
        [sharedSDImageCache clearMemory];
        [sharedSDImageCache clearDisk];
        [sharedSDImageCache cleanDisk];
        
        isSelectedForDrinks=NO;
        isSelectedForPeople=YES;
        [arrPeople removeAllObjects];
        [arrPeople addObjectsFromArray:[result objectForKey:@"checkedInUsers"]];
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
        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController getCocktailsbyvenueID:[dictVenue objectForKey:@"venueId"] delegate:self];
    }else if (isRequestCheckin){
        
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
        [checkinBtn setImage:[UIImage imageNamed:@"tickmark_select"] forState:UIControlStateNormal];
        checkinBtn.tag=3334;
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"OrdersTimedOut"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        appDelegate.intPeopleCount=[[result objectForKey:@"userCount"]integerValue];
        appDelegate.intOrderCount=0;
        [[NSUserDefaults standardUserDefaults]setObject:[dictVenue objectForKey:@"venueId"] forKey:@"CheckInVenueId"];
        [[NSUserDefaults standardUserDefaults]setObject:dictVenue forKey:@"VenueDetails"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [appDelegate startTimerToCheckHeartBeat];
        
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
        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController getFavoriteDrinksbybartsyID:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] venueID:[dictVenue objectForKey:@"venueId"] delegate:self];
    

    }else if (isUserCheckOut){
        
        UIImageView *checkinimg=(UIImageView*)[self.tabBarController.tabBar viewWithTag:5555];
        [checkinimg removeFromSuperview];
        isUserCheckOut=NO;
        [appDelegate stopTimerForGetMessages];
        [self.navigationController popViewControllerAnimated:YES];

        
    }else if (isGetFavorites){
        
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
    Backgroundview.backgroundColor=[UIColor clearColor];
    Backgroundview.tag=2221;
    //Backgroundview.userInteractionEnabled=NO;
    //Backgroundview.exclusiveTouch=NO;
    [self.view addSubview:Backgroundview];
    //[[[UIApplication sharedApplication] keyWindow] addSubview:Backgroundview];
    
    UIView *popupView=[[UIView alloc]initWithFrame:CGRectMake(0, 55, 320, 350)];
    popupView.backgroundColor=[UIColor blackColor];
    popupView.tag=2222;
    popupView.layer.borderWidth=1;
    popupView.layer.borderColor=[UIColor whiteColor].CGColor;
    [Backgroundview addSubview:popupView];
    
    

    UILabel *lbltitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 35)];
    lbltitle.text=@"Review your order";
    lbltitle.font=[UIFont systemFontOfSize:18];
    lbltitle.tag=111222333;
    lbltitle.backgroundColor=[UIColor clearColor];
    lbltitle.textColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f];
    [popupView addSubview:lbltitle];
    [lbltitle release];

    UIButton *btnclose=[UIButton buttonWithType:UIButtonTypeCustom];
    btnclose.frame=CGRectMake(276, 6, 22, 22);
    [btnclose setImage:[UIImage imageNamed:@"deleteicon.png"] forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(Btn_Closepopup:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:btnclose];
   
    UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 35, 320, 1.5)];
    lineview.backgroundColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f];
    [popupView addSubview:lineview];
    [lineview release];
   
    UIImageView *imgViewPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(10,lineview.frame.origin.y+2,60,60)];
    NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictuserInfo objectForKey:@"userImagePath"]];
    [imgViewPhoto setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]]]];
    imgViewPhoto.tag=143225;
    [imgViewPhoto setImageWithURL:[NSURL URLWithString:strURL]];
    [popupView addSubview:imgViewPhoto];
    [imgViewPhoto release];
    
    UIButton *btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPhoto.frame = CGRectMake(10,lineview.frame.origin.y+2,60,60);
    [btnPhoto addTarget:self action:@selector(btnPhoto_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    btnPhoto.backgroundColor=[UIColor clearColor];
    [popupView addSubview:btnPhoto];
    
    UILabel *lblNametitle=[[UILabel alloc]initWithFrame:CGRectMake(110, lineview.frame.origin.y+7, 150, 22)];
    lblNametitle.text=@"This order is for:";
    lblNametitle.font=[UIFont systemFontOfSize:15];
    lblNametitle.tag=111222333;
    lblNametitle.backgroundColor=[UIColor clearColor];
    lblNametitle.textColor=[UIColor whiteColor];
    [popupView addSubview:lblNametitle];
    [lblNametitle release];

    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(110, 70, 150, 22)];
    lblName.text=[dictuserInfo valueForKey:@"nickName"];
    lblName.font=[UIFont systemFontOfSize:18];
    lblName.tag=2223;
    lblName.backgroundColor=[UIColor clearColor];
    lblName.textColor=[UIColor whiteColor];
    [popupView addSubview:lblName];
    [lblName release];

    UIView *scrollstrtlineview=[[UIView alloc]initWithFrame:CGRectMake(0, imgViewPhoto.frame.origin.y+imgViewPhoto.frame.size.height+2, 320, 1.5)];
    scrollstrtlineview.backgroundColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f];
    [popupView addSubview:scrollstrtlineview];
    [scrollstrtlineview release];
    UIScrollView *popupscrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0,imgViewPhoto.frame.origin.y+imgViewPhoto.frame.size.height+3, 320, 100)];
    popupscrollview.backgroundColor=[UIColor clearColor];
    [popupView addSubview:popupscrollview];
    float totalPrice = 0.0;
    for (int i=0; i<[arrMultiItems count]; i++) {
        
        UIButton *btnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
        btnDelete.frame=CGRectMake(3,(i*30)+5, 22, 22);
        [btnDelete setImage:[UIImage imageNamed:@"deleteicon.png"] forState:UIControlStateNormal];
        btnDelete.tag=i+1;
        [btnDelete addTarget:self action:@selector(Btn_DeleteOrder:) forControlEvents:UIControlEventTouchUpInside];
        [popupscrollview addSubview:btnDelete];
        
        UILabel *lblitemName=[[UILabel alloc]initWithFrame:CGRectMake(40, (i*30)+5, 190, 22)];
        lblitemName.text=[[arrMultiItems objectAtIndex:i] valueForKey:@"name"];
        lblitemName.font=[UIFont systemFontOfSize:16];
        lblitemName.tag=111222333;
        lblitemName.backgroundColor=[UIColor clearColor];
        lblitemName.textColor=[UIColor whiteColor];
        [popupscrollview addSubview:lblitemName];
        [lblitemName release];
        
        UILabel *lblprice=[[UILabel alloc]initWithFrame:CGRectMake(250, (i*30)+5, 190, 22)];
        lblprice.text=[NSString stringWithFormat:@"$%@",[[arrMultiItems objectAtIndex:i] valueForKey:@"price"]];
        lblprice.font=[UIFont boldSystemFontOfSize:18];
        lblprice.tag=111222333;
        lblprice.backgroundColor=[UIColor clearColor];
        lblprice.textColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f];
        [popupscrollview addSubview:lblprice];
        [lblprice release];
        
        UIButton *indexButton=[UIButton buttonWithType:UIButtonTypeCustom];
        indexButton.tag=i;
        indexButton.frame=CGRectMake(25, (i*30), 290, 30);
        [indexButton addTarget:self action:@selector(Button_Popview:) forControlEvents:UIControlEventTouchUpInside];
        [popupscrollview addSubview:indexButton];
        
        UIView *scrollendlineview=[[UIView alloc]initWithFrame:CGRectMake(0,(i*30)+29, 320, 1)];
        scrollendlineview.backgroundColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f];
        [popupscrollview addSubview:scrollendlineview];
        [scrollendlineview release];
        totalPrice+=[[[arrMultiItems objectAtIndex:i] valueForKey:@"price"] floatValue];
    }
    
    ttlPrice=totalPrice;
    [popupscrollview setContentSize:CGSizeMake(320,[arrMultiItems count]*30)];
    UIView *scrollendlineview=[[UIView alloc]initWithFrame:CGRectMake(0, imgViewPhoto.frame.origin.y+imgViewPhoto.frame.size.height+2, 320, 1.5)];
    scrollendlineview.backgroundColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f];
    [popupView addSubview:scrollendlineview];
    [scrollendlineview release];
    UILabel *lblTip = [[UILabel alloc]initWithFrame:CGRectMake(8, popupscrollview.frame.origin.y+popupscrollview.frame.size.height+15, 30, 30)];
    lblTip.font = [UIFont boldSystemFontOfSize:12];
    lblTip.text = @"Tip:";
    lblTip.backgroundColor = [UIColor clearColor];
    lblTip.textColor = [UIColor whiteColor] ;
    lblTip.textAlignment = NSTextAlignmentLeft;
    [popupView addSubview:lblTip];
    [lblTip release];
    
    UIButton *btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn10.frame = CGRectMake(37,popupscrollview.frame.origin.y+popupscrollview.frame.size.height+20,23,23);
    btn10.tag = 10;
    [btn10 setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
    [btn10 setBackgroundImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateSelected];
    [btn10 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:btn10];
    
    
    UILabel *lbl10 = [[UILabel alloc]initWithFrame:CGRectMake(60, popupscrollview.frame.origin.y+popupscrollview.frame.size.height+15, 30, 30)];
    lbl10.font = [UIFont boldSystemFontOfSize:12];
    lbl10.text = @"10%";
    lbl10.backgroundColor = [UIColor clearColor];
    lbl10.textColor = [UIColor whiteColor] ;
    lbl10.textAlignment = NSTextAlignmentCenter;
    [popupView addSubview:lbl10];
    [lbl10 release];
    
    UIButton *btn20 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn20.frame = CGRectMake(90,popupscrollview.frame.origin.y+popupscrollview.frame.size.height+20,23,23);
    btn20.tag = 15;
    [btn20 setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
    [btn20 setBackgroundImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateSelected];

    [btn20 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:btn20];
    
    UILabel *lbl15 = [[UILabel alloc]initWithFrame:CGRectMake(118, popupscrollview.frame.origin.y+popupscrollview.frame.size.height+15, 30, 30)];
    lbl15.font = [UIFont boldSystemFontOfSize:12];
    lbl15.text = @"15%";
    lbl15.backgroundColor = [UIColor clearColor];
    lbl15.textColor = [UIColor whiteColor] ;
    lbl15.textAlignment = NSTextAlignmentCenter;
    [popupView addSubview:lbl15];
    [lbl15 release];
    
    UIButton *btn30 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn30.frame = CGRectMake(148,popupscrollview.frame.origin.y+popupscrollview.frame.size.height+20,23,23);
    [btn30 setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
    [btn30 setBackgroundImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateSelected];

    btn30.tag = 20;
    [btn30 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:btn30];
    btn30.selected=YES;
    btnValue=20;
    
    UILabel *lbl20 = [[UILabel alloc]initWithFrame:CGRectMake(180, popupscrollview.frame.origin.y+popupscrollview.frame.size.height+15, 30, 30)];
    lbl20.font = [UIFont boldSystemFontOfSize:12];
    lbl20.text = @"20%";
    lbl20.backgroundColor = [UIColor clearColor];
    lbl20.textColor = [UIColor whiteColor] ;
    lbl20.textAlignment = NSTextAlignmentCenter;
    [popupView addSubview:lbl20];
    [lbl20 release];
    
    UIView *lineview2=[[UIView alloc]initWithFrame:CGRectMake(0, lbl20.frame.origin.y+30, 320, 1.5)];
    lineview2.backgroundColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f];
    [popupView addSubview:lineview2];
    [lineview2 release];
    
    float taxPrice=[[NSUserDefaults standardUserDefaults] floatForKey:@"percentTAX"];
    
    UILabel *lblTax = [[UILabel alloc]initWithFrame:CGRectMake(8, lineview2.frame.origin.y+lineview2.frame.size.height+15, 175, 30)];
    lblTax.font = [UIFont systemFontOfSize:12];
    lblTax.text = [NSString stringWithFormat:@"Tax:$%.2f",taxPrice];
    lblTax.backgroundColor = [UIColor clearColor];
    lblTax.textColor = [UIColor whiteColor] ;
    lblTax.textAlignment = NSTextAlignmentLeft;
    lblTax.tag=2228;
    [popupView addSubview:lblTax];
    [lblTax release];
    
    UILabel *lblTotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(195, lineview2.frame.origin.y+lineview2.frame.size.height+15, 150, 30)];
    lblTotalPrice.font = [UIFont systemFontOfSize:12];
    lblTotalPrice.text = [NSString stringWithFormat:@"Total:$%@",[NSString stringWithFormat:@"%.2f",totalPrice]];
    lblTotalPrice.backgroundColor = [UIColor clearColor];
    lblTotalPrice.textColor = [UIColor whiteColor] ;
    lblTotalPrice.textAlignment = NSTextAlignmentLeft;
    lblTotalPrice.tag=2229;
    [popupView addSubview:lblTotalPrice];
    [lblTotalPrice release];
    
    UIButton *btnaddmore = [UIButton buttonWithType:UIButtonTypeCustom];
    btnaddmore.frame = CGRectMake(0,popupView.frame.size.height-41,160,40);
    [btnaddmore setTitle:@"Add more items" forState:UIControlStateNormal];
    btnaddmore.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    btnaddmore.titleLabel.textColor = [UIColor whiteColor];
    btnaddmore.backgroundColor=[UIColor colorWithRed:92.0/255.0 green:92.0/255.0 blue:104.0/255.0 alpha:1.0];
    btnaddmore.tag=1115;
    [btnaddmore addTarget:self action:@selector(btnOrder_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:btnaddmore];

    
    UIButton *btnOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOrder.frame = CGRectMake(161,popupView.frame.size.height-41,159,40);
    [btnOrder setTitle:@"Place Order" forState:UIControlStateNormal];
    btnOrder.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    btnOrder.titleLabel.textColor = [UIColor whiteColor];
    btnOrder.backgroundColor=[UIColor colorWithRed:92.0/255.0 green:92.0/255.0 blue:104.0/255.0 alpha:1.0];
    btnOrder.tag=1116;
    [btnOrder addTarget:self action:@selector(btnOrder_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
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
    NSDictionary *dicttemp=[arrMultiItemOrders objectAtIndex:sender.tag];
    CustomDrinkViewController *obj=[[CustomDrinkViewController alloc]initWithNibName:@"CustomDrinkViewController" bundle:nil];
    obj.viewtype=[[dicttemp valueForKey:@"Viewtype"] integerValue];
    obj.arrIndex=sender.tag;
    obj.isEdit=YES;
    if ([[dicttemp valueForKey:@"Viewtype"] integerValue]==2)
        obj.dictitemdetails=[dicttemp valueForKey:@"DictInfo"];
    else
        obj.dictitemdetails=[arrMultiItemOrders objectAtIndex:sender.tag];
    
    [self.navigationController pushViewController:obj animated:YES];
    [arrMultiItemOrders release];
}

-(void)Btn_Closepopup:(UIButton*)sender
{
    UIView *Backgroundview=(UIView*)[self.view viewWithTag:2221];
    [Backgroundview removeFromSuperview];
    
    UIButton *drinkBtn=(UIButton*)[self.view viewWithTag:1117];
    [drinkBtn removeFromSuperview];
    UIButton *checkinBtn=(UIButton*)[self.view viewWithTag:3334];
    [checkinBtn setImage:[UIImage imageNamed:@"tickmark_select"] forState:UIControlStateNormal];
    checkinBtn.hidden=NO;
}
#pragma mark----------Parsing the Locumenu Data
-(void)modifyData
{
    [arrMenu removeAllObjects];
    id results=[[NSUserDefaults standardUserDefaults]objectForKey:[dictVenue objectForKey:@"venueId"]];
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
                        [arrSubContent addObject:dictContent];
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
                    [sectionDict setObject:[NSString stringWithFormat:@"%@",[dicmainsections valueForKey:@"menu_name"]] forKey:@"section_name"];
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
    
    NSLog(@"arrcoctails %@",arrCocktailsSection);
    
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
                    [arrSubContent addObject:dictContent];
                }
                
                [sectionDict setObject:arrSubContent forKey:@"contents"];
                [arrFavorites addObject:sectionDict];
                [sectionDict release];
                [arrSubContent release];
            }
        }
    }
    
    NSLog(@"arrfav %@",arrFavorites);
}
-(void)getPastorderAsynchronously{
    
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/order/getPastOrders",KServerURL];
    
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
             [arrPastOrders removeAllObjects];
             [arrPastOrders addObjectsFromArray:[result objectForKey:@"pastOrders"]];
             NSLog(@"arrPastOrders%@",arrPastOrders);
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
                     [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
                     [self.sharedController getMenuListWithVenueID:[dictVenue objectForKey:@"venueId"] delegate:self];
                 }
                 else
                 {
                    [self modifyData];
                     
                    isGettingIngradients=YES;
                
                    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
                    [self.sharedController getIngredientsListWithVenueId:[dictVenue objectForKey:@"venueId"] delegate:self];
                     
                     
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
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"percentTAX"];

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
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 320)];
    scrollView.tag=987;
    scrollView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:scrollView];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568)
    {
        scrollView.frame=CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+3, 320, 320+88);
    }
    
    NSInteger intContentSizeHeight=0;
    NSInteger intHeight=0;
    //Loop for bundled orders to show on UI
    for (int i=0; i<[arrBundledOrders count]; i++)
    {
        NSArray *arrBundledOrdersObject=[arrBundledOrders objectAtIndex:i];
        NSDictionary *dict=[arrBundledOrdersObject objectAtIndex:0];
        
        int intHeightForOfferedDrinks=0;
        
        if([[dict objectForKey:@"orderStatus"] integerValue]==9&&[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]==[[dict objectForKey:@"recieverBartsyId"] doubleValue])
        {
            intHeightForOfferedDrinks=35;
        }
        
        UIView *viewBg=[self createViewWithFrame:CGRectMake(0, intContentSizeHeight, 320, 150+[arrBundledOrdersObject count]*20 + intHeightForOfferedDrinks) tag:0];
        viewBg.backgroundColor=[self getTheColorForOrderStatus:[[dict objectForKey:@"orderStatus"] integerValue]];
        [scrollView addSubview:viewBg];
        
        UIImageView *statusImg=[self createImageViewWithImage:[UIImage imageNamed:@"exclametory"] frame:CGRectMake(10, 5, 20, 20) tag:0];
        [viewBg addSubview:statusImg];
        
        UILabel *lblOrderStatus=[self createLabelWithTitle:@"" frame:CGRectMake(40, 0, 240, 30) tag:0 font:[UIFont systemFontOfSize:12] color:[UIColor blackColor] numberOfLines:3];
        lblOrderStatus.text = [self getTheStatusMessageForOrder:dict];
        lblOrderStatus.adjustsFontSizeToFitWidth=YES;
        lblOrderStatus.textAlignment = NSTextAlignmentLeft;
        [viewBg addSubview:lblOrderStatus];
        
        if([[dict objectForKey:@"orderStatus"] integerValue]==1||[[dict objectForKey:@"orderStatus"] integerValue]==4||[[dict objectForKey:@"orderStatus"] integerValue]==5||[[dict objectForKey:@"orderStatus"] integerValue]==7||[[dict objectForKey:@"orderStatus"] integerValue]==8)
        {
            UIButton *btnDismiss=[self createUIButtonWithTitle:@"Dismiss" image:nil frame:CGRectMake(275, 1, 44, 33) tag:i selector:@selector(btnDismiss_TouchUpInside:) target:self];
            btnDismiss.titleLabel.font=[UIFont systemFontOfSize:10];
            btnDismiss.backgroundColor=[UIColor blackColor];
            [viewBg addSubview:btnDismiss];
        }
       
        
        UIView *viewBg2=[self createViewWithFrame:CGRectMake(0, 35, viewBg.bounds.size.width, 140+[arrBundledOrdersObject count]*20) tag:0];
        viewBg2.backgroundColor=[UIColor blackColor];
        [viewBg addSubview:viewBg2];
        
        NSURL *urlPhoto=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@",KServerURL,[[NSUserDefaults standardUserDefaults]objectForKey:@"ImagePath"],[dict objectForKey:@"recieverBartsyId"]]];
        UIImageView *imgViewPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(5,5,60,65)];
        [imgViewPhoto setImageWithURL:urlPhoto];
        [viewBg2 addSubview:imgViewPhoto];
        [imgViewPhoto release];
        
        UILabel *lblOrderTO = [[UILabel alloc]initWithFrame:CGRectMake(69, 2, 180, 23)];
        lblOrderTO.font = [UIFont systemFontOfSize:18];
        lblOrderTO.text = [NSString stringWithFormat:@"Pickup Code:%@",[dict objectForKey:@"userSessionCode"]];
        lblOrderTO.adjustsFontSizeToFitWidth=YES;
        lblOrderTO.backgroundColor = [UIColor clearColor];
        lblOrderTO.textColor = [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] ;
        lblOrderTO.textAlignment = NSTextAlignmentLeft;
        [viewBg2 addSubview:lblOrderTO];
        [lblOrderTO release];
        
        UILabel *lblOrderId = [[UILabel alloc]initWithFrame:CGRectMake(69, 20, 180, 23)];
        lblOrderId.font = [UIFont systemFontOfSize:15];
        lblOrderId.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"orderId"]];
        lblOrderId.adjustsFontSizeToFitWidth=YES;
        lblOrderId.backgroundColor = [UIColor clearColor];
        lblOrderId.textColor = [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] ;
        lblOrderId.textAlignment = NSTextAlignmentLeft;
        [viewBg2 addSubview:lblOrderId];
        [lblOrderId release];
        
        UILabel *lblCode = [[UILabel alloc]initWithFrame:CGRectMake(69, lblOrderId.frame.origin.y+lblOrderId.bounds.size.height, 200, 16)];
        lblCode.font = [UIFont systemFontOfSize:14];
        lblCode.text = [NSString stringWithFormat:@"For: %@",[dict objectForKey:@"recipientNickname"]];
        lblCode.adjustsFontSizeToFitWidth=YES;
        lblCode.backgroundColor = [UIColor clearColor];
        lblCode.textColor = [UIColor colorWithRed:191.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0] ;
        lblCode.textAlignment = NSTextAlignmentLeft;
        [viewBg2 addSubview:lblCode];
        [lblCode release];

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
        UILabel *lblplacedtime = [[UILabel alloc]initWithFrame:CGRectMake(69, lblCode.frame.origin.y+lblCode.bounds.size.height, 180, 15)];
        lblplacedtime.font = [UIFont systemFontOfSize:10];
        lblplacedtime.text = [NSString stringWithFormat:@"Placed: %d mins ago",minutes];
        lblplacedtime.adjustsFontSizeToFitWidth=YES;
        lblplacedtime.backgroundColor = [UIColor clearColor];
        lblplacedtime.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
        lblplacedtime.textAlignment = NSTextAlignmentLeft;
        [viewBg2 addSubview:lblplacedtime];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: lblplacedtime.attributedText];
        [text addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:0.98f green:0.223f blue:0.709f alpha:1.0] range: NSMakeRange(7, minlength.length+10)];
        [lblplacedtime setAttributedText: text];
        [text release];
        [lblplacedtime release];
        
        UILabel *lblexpired = [[UILabel alloc]initWithFrame:CGRectMake(69, lblplacedtime.frame.origin.y+lblplacedtime.bounds.size.height, 180, 15)];
        lblexpired.font = [UIFont systemFontOfSize:10];
        lblexpired.text = [NSString stringWithFormat:@"Expires: %@",@"15 min"];
        lblexpired.adjustsFontSizeToFitWidth=YES;
        lblexpired.backgroundColor = [UIColor clearColor];
        lblexpired.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
        lblexpired.textAlignment = NSTextAlignmentLeft;
        [viewBg2 addSubview:lblexpired];
        NSMutableAttributedString *attribstrg = [[NSMutableAttributedString alloc] initWithAttributedString: lblexpired.attributedText];
        [attribstrg addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:0.98f green:0.223f blue:0.709f alpha:1.0] range: NSMakeRange(8, 7)];
        [lblexpired setAttributedText: attribstrg];
        [attribstrg release];
        [lblexpired release];
       /* UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(61, 40, 200, 15)];
        lblName.font = [UIFont boldSystemFontOfSize:12];
        lblName.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"recipientNickname"]];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.textColor = [UIColor whiteColor] ;
        lblName.textAlignment = NSTextAlignmentLeft;
        [viewBg2 addSubview:lblName];
        [lblName release];*/
        
        if([[dict objectForKey:@"senderBartsyId"] doubleValue]!=[[dict objectForKey:@"recieverBartsyId"] doubleValue])
        {
            UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(60, 55, 210, 15)];
            lblName.font = [UIFont systemFontOfSize:12];
            lblName.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"senderNickname"]];
            lblName.backgroundColor = [UIColor clearColor];
            lblName.textColor = [UIColor colorWithRed:191.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0] ;
            lblName.textAlignment = NSTextAlignmentRight;
            [viewBg2 addSubview:lblName];
            [lblName release];
            
            NSURL *urlPhoto=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@",KServerURL,[[NSUserDefaults standardUserDefaults]objectForKey:@"ImagePath"],[dict objectForKey:@"senderBartsyId"]]];
            UIImageView *imgViewPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(270,30,40,40)];
            [imgViewPhoto setImageWithURL:urlPhoto];
            [viewBg2 addSubview:imgViewPhoto];
            [imgViewPhoto release];
        }
        
        UIView *viewLine=[self createViewWithFrame:CGRectMake(5, 111, 310, 1) tag:0];
        viewLine.backgroundColor=[UIColor colorWithRed:39.0/255 green:39.0/255 blue:39.0/255 alpha:1.0];
        [viewBg2 addSubview:viewLine];

        float floatPrice=0;
        float floatTotalPrice=0;
        float floatTaxFee=0;
        float floattipvalue=0;
        intHeight=72;
        
        for (int j=0; j<[[dict objectForKey:@"itemsList"] count]; j++)
        {
            NSDictionary *dictTempOrder=[[dict objectForKey:@"itemsList"] objectAtIndex:j];
            
            UILabel *lblDescription = [[UILabel alloc]initWithFrame:CGRectMake(5, intHeight+5+(j*15)+40, 242, 15)];
            lblDescription.font = [UIFont boldSystemFontOfSize:12];
            lblDescription.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"itemName"]];
            lblDescription.numberOfLines = 1;
            lblDescription.backgroundColor = [UIColor clearColor];
            lblDescription.textColor = [UIColor colorWithRed:191.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0] ;
            lblDescription.textAlignment = NSTextAlignmentLeft;
            [viewBg2 addSubview:lblDescription];
            
            
            UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(265, intHeight+5+(j*15)+40, 45, 15)];
            lblPrice.font = [UIFont systemFontOfSize:12];
            lblPrice.text = [NSString stringWithFormat:@"$%.2f",[[dictTempOrder objectForKey:@"basePrice"] floatValue]];
            lblPrice.numberOfLines = 1;
            lblPrice.backgroundColor = [UIColor clearColor];
            lblPrice.textColor = [UIColor colorWithRed:32.0/255 green:188.0/255 blue:226.0/255 alpha:1.0] ;
            lblPrice.textAlignment = NSTextAlignmentRight;
            [viewBg2 addSubview:lblPrice];
            
            floatTotalPrice=[[dict objectForKey:@"totalPrice"]floatValue];
            floatPrice=[[dict objectForKey:@"basePrice"] integerValue];
            if([[dict objectForKey:@"senderBartsyId"]doubleValue]!=[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]&&[[dictTempOrder objectForKey:@"orderStatus"] integerValue]!=9)
            {
                lblPrice.text=@"-";

            }
            [lblDescription release];
            [lblPrice release];
            
        }
                
        
        UILabel *lblTipFee = [[UILabel alloc]initWithFrame:CGRectMake(5, intHeight+5+([[dict objectForKey:@"itemsList"] count]*15)+45, 120, 15)];
        lblTipFee.font = [UIFont boldSystemFontOfSize:11];
        floattipvalue= ([[dict objectForKey:@"basePrice"] floatValue]*[[dict objectForKey:@"tipPercentage"] floatValue])/100;
        if(floattipvalue>0.01)
        {
            lblTipFee.text = [NSString stringWithFormat:@"Tip: $%.2f",floattipvalue];
        }
        else
            lblTipFee.text = [NSString stringWithFormat:@"Tip: -"];
        lblTipFee.tag = 12347890;
        lblTipFee.backgroundColor = [UIColor clearColor];
        lblTipFee.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
        lblTipFee.textAlignment = NSTextAlignmentLeft;
        [viewBg2 addSubview:lblTipFee];
        NSMutableAttributedString *attribstrgTIP = [[NSMutableAttributedString alloc] initWithAttributedString: lblTipFee.attributedText];
        [attribstrgTIP addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(lblTipFee.text.length-sizeof(floattipvalue)-1,sizeof(floattipvalue)+1 )];
        [lblTipFee setAttributedText: attribstrgTIP];
        [attribstrgTIP release];
        [lblTipFee release];
        
        UILabel *lblTaxFee = [[UILabel alloc]initWithFrame:CGRectMake(lblTipFee.bounds.origin.x+60, intHeight+5+([[dict objectForKey:@"itemsList"] count]*15)+45, 150, 15)];
        lblTaxFee.font = [UIFont boldSystemFontOfSize:11];
        floatTaxFee=floatTotalPrice-(floattipvalue+floatPrice);
        if(floatTaxFee>0.01)
        {
            lblTaxFee.text = [NSString stringWithFormat:@"Tax: $%.2f",floatTaxFee];
        }
        else
            lblTaxFee.text = [NSString stringWithFormat:@"Tax: -"];
        lblTaxFee.tag = 12347890;
        lblTaxFee.backgroundColor = [UIColor clearColor];
        lblTaxFee.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
        lblTaxFee.textAlignment = NSTextAlignmentLeft;
        [viewBg2 addSubview:lblTaxFee];
        NSMutableAttributedString *attribstrgTAX = [[NSMutableAttributedString alloc] initWithAttributedString: lblTaxFee.attributedText];
        [attribstrgTAX addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(lblTaxFee.text.length-sizeof(floatTaxFee)-1,sizeof(floatTaxFee)+1 )];
        [lblTaxFee setAttributedText: attribstrgTAX];
        [attribstrgTAX release];
        [lblTaxFee release];
        
        NSString *ttpricelenght=[NSString stringWithFormat:@"%.2f",floatTotalPrice];
       
        UILabel *lblTotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(160,intHeight+5+([[dict objectForKey:@"itemsList"] count]*15)+45, 153, 15)];
        lblTotalPrice.font = [UIFont boldSystemFontOfSize:11];
        if(floatTotalPrice>0.01)
            lblTotalPrice.text = [NSString stringWithFormat:@"Total:$%.2f",floatTotalPrice];
        else
            lblTotalPrice.text = [NSString stringWithFormat:@"Total:-"];
        lblTotalPrice.tag = 12347890;
        lblTotalPrice.backgroundColor = [UIColor clearColor];
        lblTotalPrice.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0] ;
        lblTotalPrice.textAlignment = NSTextAlignmentRight;
        [viewBg2 addSubview:lblTotalPrice];
        NSMutableAttributedString *attribstrgTP = [[NSMutableAttributedString alloc] initWithAttributedString: lblTotalPrice.attributedText];
        [attribstrgTP addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:32.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0] range: NSMakeRange(6,ttpricelenght.length+1 )];
        [lblTotalPrice setAttributedText: attribstrgTP];
        [attribstrgTP release];
        [lblTotalPrice release];
        
        
        if([[dict objectForKey:@"orderStatus"] integerValue]==9&&[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]==[[dict objectForKey:@"recieverBartsyId"] doubleValue])
        {
            UIButton *btnReject=[self createUIButtonWithTitle:@"Reject" image:nil frame:CGRectMake(2, 30+87+[[dict objectForKey:@"itemsList"] count]*20+42, 120, 30) tag:i selector:@selector(btnReject_TouchUpInside:) target:self];
            btnReject.titleLabel.font=[UIFont systemFontOfSize:10];
            btnReject.backgroundColor=[UIColor grayColor];
            [viewBg addSubview:btnReject];
            
            UIButton *btnAccept=[self createUIButtonWithTitle:@"Accept" image:nil frame:CGRectMake(125, 30+87+[[dict objectForKey:@"itemsList"] count]*20+42, 192, 30) tag:i selector:@selector(btnAccept_TouchUpInside:) target:self];
            btnAccept.titleLabel.font=[UIFont systemFontOfSize:10];
            btnAccept.backgroundColor=[UIColor grayColor];
            [viewBg addSubview:btnAccept];
        }
        
        intContentSizeHeight+=123+[[dict objectForKey:@"itemsList"] count]*20 + intHeightForOfferedDrinks+50;
    }
    
    if (arrBundledOrders.count==0) {
        
        UILabel *lblItemName = [self createLabelWithTitle:@"No orders\nGo to menu tab to place an order" frame:CGRectMake(30, 50, 250,50) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:5];
        lblItemName.backgroundColor=[UIColor clearColor];
        lblItemName.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:lblItemName];
    }
    scrollView.contentSize=CGSizeMake(320, intContentSizeHeight+10);
    [scrollView release];
}

-(void)btnDismiss_TouchUpInside:(UIButton*)sender
{
    self.sharedController=[SharedController sharedController];
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate checkNetworkStatus:nil];
    if(appDelegate.internetActive)
    {
        NSArray *arrBundledOrdersObject=[arrBundledOrders objectAtIndex:sender.tag];
        NSMutableArray *arrOrderIds=[[NSMutableArray alloc]init];
        for (int i=0; i<[arrBundledOrdersObject count]; i++)
        {
            NSDictionary *dictOrder=[[NSDictionary alloc]initWithObjectsAndKeys:[[arrBundledOrdersObject objectAtIndex:i] objectForKey:@"orderId"],@"orderId",@"10",@"orderStatus",@"",@"errorReason", nil];
            [arrOrderIds addObject:dictOrder];
        }
        
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

-(void)btnReject_TouchUpInside:(UIButton*)sender
{
    self.sharedController=[SharedController sharedController];
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate checkNetworkStatus:nil];
    if(appDelegate.internetActive)
    {
        NSArray *arrBundledOrdersObject=[arrBundledOrders objectAtIndex:sender.tag];
        for (int i=0; i<[arrBundledOrdersObject count]; i++)
        {
            NSDictionary *dictOrder=[arrBundledOrdersObject objectAtIndex:i];
            [self updateOrderStatusForaOfferedDrinkWithStatus:@"8" withOrderId:[dictOrder objectForKey:@"orderId"]];
        }
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getOpenOrders) userInfo:nil repeats:NO];
    }
    else
    {
        [self hideProgressView:nil];
        [self createAlertViewWithTitle:@"NetWorkStatus" message:@"Internet Connection Required" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
    }

}

-(void)btnAccept_TouchUpInside:(UIButton*)sender
{
    self.sharedController=[SharedController sharedController];
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate checkNetworkStatus:nil];
    if(appDelegate.internetActive)
    {
        NSArray *arrBundledOrdersObject=[arrBundledOrders objectAtIndex:sender.tag];
        for (int i=0; i<[arrBundledOrdersObject count]; i++)
        {
            NSDictionary *dictOrder=[arrBundledOrdersObject objectAtIndex:i];
            [self updateOrderStatusForaOfferedDrinkWithStatus:@"0" withOrderId:[dictOrder objectForKey:@"orderId"]];
        }
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getOpenOrders) userInfo:nil repeats:NO];
    }
    else
    {
        [self hideProgressView:nil];
        [self createAlertViewWithTitle:@"NetWorkStatus" message:@"Internet Connection Required" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(isSelectedForDrinks)
        if (section==1) {
            if ([arrFavorites count]==0)
                return 0;
            else
                return 54;
        }else if (section==0){
            if ([arrPastOrders count]==0)
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
        
        UILabel *headerTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 7, 280, 30)];
        [headerTitle setBackgroundColor:[UIColor clearColor]];
        [headerTitle setFont:[UIFont systemFontOfSize:16]];
        [headerTitle setTextColor:[UIColor colorWithRed:191.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0]];
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
        if (section==0) {
            NSMutableDictionary *dict=[ArrMenuSections objectAtIndex:section];
            BOOL isSelected=!([[dict objectForKey:@"Arrow"] integerValue]);

            if (isSelected) 
                return 0;
            else
                return [arrPastOrders count];
        }else if (section==1){
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
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isSelectedForDrinks)
        return 80;
    else if(isSelectedForPeople)
        return 75;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    UITableViewCell *cell;
    
    if(isSelectedForDrinks==YES)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage            imageNamed:@"fathers_office-bg.png"]];

        UIImageView *drinkImg=[[UIImageView alloc]initWithFrame:CGRectMake(5,13,13.5, 13.5)];
        drinkImg.image=[UIImage imageNamed:@"drink"];
        [cell.contentView addSubview:drinkImg];
        [drinkImg release];
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(25,0, 270, 40)];
        if (indexPath.section==0)
        {
            if ([[arrPastOrders objectAtIndex:indexPath.row] valueForKey:@"itemsList"]){
                NSArray *multiorderArray=[[arrPastOrders objectAtIndex:indexPath.row] valueForKey:@"itemsList"];
                NSMutableString *multilblname = [NSMutableString new];
                for (NSDictionary *tempdic in multiorderArray) {
                    [multilblname appendFormat:@"%@,", [tempdic valueForKey:@"itemName"]];
                }
                lblName.numberOfLines=2;
                lblName.text=multilblname;
                [multilblname release];
            }else
                lblName.text=[[arrPastOrders objectAtIndex:indexPath.row] valueForKey:@"itemName"];
        }
        else if (indexPath.section==1)
        {
             NSArray *arrFavTemp=[[arrFavorites objectAtIndex:indexPath.row] valueForKey:@"contents"];
            NSDictionary *dictFav=[arrFavTemp objectAtIndex:0];
            lblName.text=[dictFav valueForKey:@"name"];
        }
        else if (indexPath.section>1&&indexPath.section<2+[arrCustomDrinks count])
        {
            
            NSArray *tempArray=[[arrCustomDrinks objectAtIndex:indexPath.section-2] valueForKey:@"contents"];
            lblName.text=[[tempArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        }else if(indexPath.section>1+[arrCustomDrinks count]&&indexPath.section<2+[arrCustomDrinks count]+[arrMenu count]){
            
            
            id object=[arrMenu objectAtIndex:indexPath.section-([arrCustomDrinks count]+2)];
            if(indexPath.section==2&&[object isKindOfClass:[NSArray class]])
            {
                NSDictionary *dict=[object objectAtIndex:indexPath.row];
                lblName.text=[dict objectForKey:@"name"];
            }
            else
            {
                NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
                NSDictionary *dict=[arrContents objectAtIndex:indexPath.row];
                lblName.text=[dict objectForKey:@"name"];
            }

        }else if (indexPath.section>1+[arrCustomDrinks count]+[arrMenu count]&&indexPath.section<2+[arrCustomDrinks count]+[arrMenu count]+[arrCocktailsSection count]){
            
            NSArray *tempArray=[[arrCocktailsSection objectAtIndex:indexPath.section-([arrCustomDrinks count]+2+[arrMenu count])] valueForKey:@"contents"];
            lblName.text=[[tempArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        }
        
        
        lblName.font=[UIFont systemFontOfSize:14];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lblName];
        [lblName release];
        
        
        UILabel *lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(5, 30, 255, 50)];
        lblDescription.numberOfLines=3;
        if(indexPath.section==0)
        {
            if (![[[arrPastOrders objectAtIndex:indexPath.row] valueForKey:@"description"] isKindOfClass:[NSNull class]]) {
                lblDescription.text=[[arrPastOrders objectAtIndex:indexPath.row] valueForKey:@"description"];
            }
            
        }
        else if(indexPath.section==1)
        {
            NSArray *arrFavTemp=[[arrFavorites objectAtIndex:indexPath.row] valueForKey:@"contents"];
            NSDictionary *dictFav=[arrFavTemp objectAtIndex:0];
            if ([dictFav valueForKey:@"description"])
            
                lblDescription.text=[dictFav valueForKey:@"description"];
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
        lblDescription.backgroundColor=[UIColor clearColor];
        lblDescription.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lblDescription];
        [lblDescription release];
        
        UILabel *lblPrice=[[UILabel alloc]initWithFrame:CGRectMake(270, 20, 50, 25)];
        if(indexPath.section==0)
        {
            lblPrice.text=[[arrPastOrders objectAtIndex:indexPath.row] valueForKey:@"totalPrice"];
        }else if (indexPath.section==1){
            
            NSArray *arrFavTemp=[[arrFavorites objectAtIndex:indexPath.row] valueForKey:@"contents"];
            NSDictionary *dictFav=[arrFavTemp objectAtIndex:0];
            lblPrice.text=[dictFav valueForKey:@"price"];

        }
        else if(indexPath.section>1+[arrCustomDrinks count]&&indexPath.section<2+[arrCustomDrinks count]+[arrMenu count])
        {
            id object=[arrMenu objectAtIndex:indexPath.section-([arrCustomDrinks count]+2)];
            NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
            NSDictionary *dict=[arrContents objectAtIndex:indexPath.row];
            lblPrice.text=[dict objectForKey:@"price"];
        }else if(indexPath.section>1&&indexPath.section<2+[arrCustomDrinks count]){
            NSArray *tempArray=[[arrCustomDrinks objectAtIndex:indexPath.section-2] valueForKey:@"contents"];
            lblPrice.text=[NSString stringWithFormat:@"%d",[[[tempArray objectAtIndex:indexPath.row] valueForKey:@"price"] integerValue]];
        }else if (indexPath.section>1+[arrCustomDrinks count]+[arrMenu count]&&indexPath.section<2+[arrCustomDrinks count]+[arrMenu count]+[arrCocktailsSection count]){
            
            NSArray *tempArray=[[arrCocktailsSection objectAtIndex:indexPath.section-([arrCustomDrinks count]+2+[arrMenu count])] valueForKey:@"contents"];
            lblPrice.text=[NSString stringWithFormat:@"%d",[[[tempArray objectAtIndex:indexPath.row] valueForKey:@"price"] integerValue]];
        }
        
        lblPrice.font=[UIFont systemFontOfSize:22];
        lblPrice.textColor=[UIColor colorWithRed:35.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0];
        lblPrice.adjustsFontSizeToFitWidth=YES;
        lblPrice.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lblPrice];
        [lblPrice release];
        
        /*UILabel *lblDollars=[[UILabel alloc]initWithFrame:CGRectMake(270, 45, 50, 10)];
        lblDollars.text=@"dollars";
        lblDollars.font=[UIFont systemFontOfSize:10];
        lblDollars.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        lblDollars.adjustsFontSizeToFitWidth=YES;
        lblDollars.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lblDollars];
        [lblDollars release];*/

    }
    else if(isSelectedForPeople)
    {
        cell =[[PeopleCustomCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage            imageNamed:@"fathers_office-bg.png"]];
        NSString *strBartsyId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]];

        NSDictionary *dictPeople=[arrPeople objectAtIndex:indexPath.row];
        NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictPeople objectForKey:@"userImagePath"]];
      
        UIImageView *imageForPeople = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 54, 54)];
        [imageForPeople setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [imageForPeople.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        [imageForPeople.layer setShadowOffset:CGSizeMake(0, 1)];
        [imageForPeople.layer setShadowRadius:3.0];
        [imageForPeople.layer setShadowOpacity:0.8];
        [cell.contentView addSubview:imageForPeople];
        [imageForPeople release];

        UILabel *lblForPeopleName = [[UILabel alloc]initWithFrame:CGRectMake(75, -2, 220, 35)];
        lblForPeopleName.text = [dictPeople objectForKey:@"nickName"];
        lblForPeopleName.font = [UIFont boldSystemFontOfSize:16];
        lblForPeopleName.backgroundColor = [UIColor clearColor];
        lblForPeopleName.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
        [cell.contentView addSubview:lblForPeopleName];
        [lblForPeopleName release];

        UIImageView *imgTickMark = [[UIImageView alloc] initWithFrame:CGRectMake(75, 30, 15, 15)];
        imgTickMark.image=[UIImage imageNamed:@"tickmark.png"];
        [cell.contentView addSubview:imgTickMark];
        [imgTickMark release];
        
        UIImageView *imgForRightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 28, 10, 15)];
        imgForRightArrow.image=[UIImage imageNamed:@"right-arrow.png"];
        [cell.contentView addSubview:imgForRightArrow];
        [imgForRightArrow release];

        UILabel *lblForCheckIn = [[UILabel alloc]initWithFrame:CGRectMake(93, 20, 100, 35)];
        lblForCheckIn.text = @"Checked In";
        lblForCheckIn.font = [UIFont systemFontOfSize:11];
        lblForCheckIn.backgroundColor = [UIColor clearColor];
        lblForCheckIn.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
        [cell.contentView addSubview:lblForCheckIn];
        [lblForCheckIn release];

        UILabel *lblForPeopleGender = [[UILabel alloc]initWithFrame:CGRectMake(75, 40, 220, 35)];
        lblForPeopleGender.text = [dictPeople objectForKey:@"gender"];
        lblForPeopleGender.font = [UIFont systemFontOfSize:12];
        lblForPeopleGender.backgroundColor = [UIColor clearColor];
        lblForPeopleGender.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
        [cell.contentView addSubview:lblForPeopleGender];
        [lblForPeopleGender release];

//        cell.textLabel.text=[dictPeople objectForKey:@"nickName"];
//        cell.detailTextLabel.text=[dictPeople objectForKey:@"gender"];
        
        if ([strBartsyId doubleValue] != [[dictPeople objectForKey:@"bartsyId"] doubleValue])
        {
            if ([[dictPeople objectForKey:@"hasMessages"] isEqualToString:@"New"]) {
                UIButton *btnChat=[self createUIButtonWithTitle:nil image:[UIImage imageNamed:@"mail.png"] frame:CGRectMake(250, 10, 30, 20) tag:indexPath.row selector:@selector(btnChat_TouchUpInside:) target:self];
                [cell.contentView addSubview:btnChat];
               
            }else{
                UIButton *btnChat=[self createUIButtonWithTitle:nil image:[UIImage imageNamed:@"mail_gray.png"] frame:CGRectMake(250, 10, 30, 20) tag:indexPath.row selector:@selector(btnChat_TouchUpInside:) target:self];
    
                [cell.contentView addSubview:btnChat];
            }
            
        }

        //UILabel *lbl
    }
    else if (isSelectedForPastOrders == YES)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage            imageNamed:@"fathers_office-bg.png"]];
        
        if ([arrPastOrders count])
        {
            NSDictionary *dictForOrder = [arrPastOrders objectAtIndex:indexPath.row];
            
            UILabel *lblItemName = [self createLabelWithTitle:[dictForOrder objectForKey:@"itemName"] frame:CGRectMake(10, 3, 250, 15) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
            lblItemName.backgroundColor=[UIColor clearColor];
            lblItemName.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblItemName];
            
            UILabel *lbldescription;
            if ([[dictForOrder objectForKey:@"description"] isKindOfClass:[NSNull class]])
                lbldescription = [self createLabelWithTitle:@"" frame:CGRectMake(10, 20,250, 35) tag:0 font:[UIFont systemFontOfSize:15] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:2];
            else
                lbldescription = [self createLabelWithTitle:[dictForOrder objectForKey:@"description"] frame:CGRectMake(10, 20,250, 35) tag:0 font:[UIFont systemFontOfSize:15] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:2];
            
            lbldescription.backgroundColor=[UIColor clearColor];
            lbldescription.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lbldescription];
            
            
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
            
            NSString *strDate1 = [NSString stringWithFormat:@"Placed at: %@%i:%@%i:%@%i %@ on %@ %i,%i",(comps.hour<10? @"0" : @""),comps.hour,(comps.minute<10? @"0":@""),comps.minute,(comps.second<10? @"0":@""),comps.second,[arrDateComps objectAtIndex:0],[arrDateComps objectAtIndex:4],comps.day,comps.year];
            
            
            UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 280, 15)];
            lblTime.font = [UIFont systemFontOfSize:14];
            lblTime.text = strDate1;
            lblTime.tag = 1234234567;
            lblTime.backgroundColor = [UIColor clearColor];
            lblTime.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
            lblTime.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblTime];
            [lblTime release];
            
            UILabel *lblSender = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 280, 15)];
            lblSender.font = [UIFont systemFontOfSize:14];
            lblSender.text = [NSString stringWithFormat:@"Sender : %@",[dictForOrder objectForKey:@"senderNickname"]];
            lblSender.tag = 1234234567;
            lblSender.backgroundColor = [UIColor clearColor];
            lblSender.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
            lblSender.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblSender];
            [lblSender release];
            
            UILabel *lblRecepient = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 280, 20)];
            lblRecepient.font = [UIFont systemFontOfSize:14];
            lblRecepient.text = [NSString stringWithFormat:@"Recipient : %@",[dictForOrder objectForKey:@"recipientNickname"]];
            lblRecepient.tag = 1234234567;
            lblRecepient.backgroundColor = [UIColor clearColor];
            lblRecepient.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
            lblRecepient.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblRecepient];
            [lblRecepient release];
            
            
            if([[[arrPastOrders objectAtIndex:indexPath.row] objectForKey:@"senderBartsyId"]doubleValue]==[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]&&[[arrPastOrders objectAtIndex:indexPath.row] objectForKey:@"lastState"]!=(id)[NSNull null]&&[[[arrPastOrders objectAtIndex:indexPath.row] objectForKey:@"lastState"] integerValue]!=1)
            {
                NSString *stringFortotalPrice = [NSString stringWithFormat:@"$%.2f",[[dictForOrder objectForKey:@"totalPrice"] floatValue]];
                
                UILabel *lblTotalPrice = [self createLabelWithTitle:stringFortotalPrice frame:CGRectMake(270, 2, 200, 15) tag:0 font:[UIFont boldSystemFontOfSize:11] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
                lblTotalPrice.backgroundColor=[UIColor clearColor];
                lblTotalPrice.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:lblTotalPrice];
            }
            
            UILabel *lblOrderId = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, 280, 20)];
            lblOrderId.font = [UIFont systemFontOfSize:14];
            lblOrderId.text = [NSString stringWithFormat:@"OrderId : %@",[dictForOrder objectForKey:@"orderId"]];
            lblOrderId.backgroundColor = [UIColor clearColor];
            lblOrderId.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
            lblOrderId.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblOrderId];
            [lblOrderId release];
            
        }
        else
        {
            UILabel *lblItemName = [self createLabelWithTitle:@"No past orders\nGo to menu tab to place an order" frame:CGRectMake(30, 50, 250,50) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:5];
            lblItemName.backgroundColor=[UIColor clearColor];
            lblItemName.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:lblItemName];
        }
    }

    else
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewFooter=[[UIView alloc]init];
    return viewFooter;
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
        if ( (indexPath.section==0 || indexPath.section==1)) {
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
        
        NSMutableArray *arrMultiItemOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"multiitemorders"]];

        id object=[arrMenu objectAtIndex:indexPath.section-(2+[arrCustomDrinks count])];
        NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];

        NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:[arrContents objectAtIndex:indexPath.row]];
        [dictItem setObject:@"" forKey:@"specialInstructions"];
        [dictItem setObject:@"Menu" forKey:@"ItemType"];
        [dictItem setObject:[NSNumber numberWithInt:1] forKey:@"Viewtype"];

        [arrMultiItemOrders addObject:dictItem];
        
        [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [arrMultiItemOrders release];
        [dictItem release];
        [arrContents release];
        [self showMultiItemOrderUI];


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
        
        NSMutableArray *arrMultiItemOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"multiitemorders"]];
        
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
        [self showMultiItemOrderUI];

        
       /* NSArray *tempArray=[[arrCocktailsSection objectAtIndex:indexPath.section-([arrCustomDrinks count]+2+[arrMenu count])] valueForKey:@"contents"];
        //id object=[arrCustomDrinks objectAtIndex:indexPath.section-2];
       // NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
        
        CustomDrinkViewController *obj=[[CustomDrinkViewController alloc]initWithNibName:@"CustomDrinkViewController" bundle:nil];
        obj.viewtype=3;
        NSLog(@"%@",[tempArray objectAtIndex:indexPath.row]);
        obj.dictitemdetails=[tempArray objectAtIndex:indexPath.row];
        obj.dictCustomDrinks=[NSDictionary dictionaryWithDictionary:dictMainCustomDrinks];
        [self.navigationController pushViewController:obj animated:YES];*/
        
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
    dictPeopleSelectedForDrink=[[NSDictionary alloc]initWithDictionary:notification.object];
    UIImageView *imgView=(UIImageView*)[self.view viewWithTag:143225];
    NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictPeopleSelectedForDrink objectForKey:@"userImagePath"]];
    NSLog(@"URL is %@",strURL);
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
