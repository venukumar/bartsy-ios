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
    self.navigationController.navigationBarHidden=NO;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.trackedViewName = @"Drinks Screen";

    self.navigationController.navigationBarHidden=NO;
    // self.navigationItem.leftBarButtonItem=nil;
    //self.navigationItem.hidesBackButton=YES;
    
    self.title=[dictVenue objectForKey:@"venueName"];
    
    UIBarButtonItem *btnLogOut=[[UIBarButtonItem alloc]initWithTitle:@"Check out" style:UIBarButtonItemStylePlain target:self action:@selector(backLogOut_TouchUpInside)];
    self.navigationItem.rightBarButtonItem=btnLogOut;
    
   
    // Do any additional setup after loading the view, typically from a nib.
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.delegateForCurrentViewController=self;
    
    arrMenu=[[NSMutableArray alloc]init];
    arrOrders=[[NSMutableArray alloc]init];
    arrPeople=[[NSMutableArray alloc]init];
    arrBundledOrders=[[NSMutableArray alloc]init];
    arrPastOrders=[[NSMutableArray alloc]init];
    arrOrdersTimedOut=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"OrdersTimedOut"]];
    arrStatus=[[NSArray alloc]initWithObjects:@"Accepted",@"Ready for pickup",@"Order is picked up",@"Order is picked up", nil];
    arrOrdersOffered=[[NSMutableArray alloc]init];
    
    NSString *strOrder=[NSString stringWithFormat:@"ORDERS (%i)",appDelegate.intOrderCount];
    NSString *strPeopleCount=[NSString stringWithFormat:@"PEOPLE (%i)",appDelegate.intPeopleCount];

    UISegmentedControl *segmentControl=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"DRINKS",strPeopleCount,strOrder,@"PAST ORDERS", nil]];
    segmentControl.frame=CGRectMake(0, 1, 320, 40);
    UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    [segmentControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    segmentControl.segmentedControlStyle=UISegmentedControlStyleBar;
    segmentControl.selectedSegmentIndex=0;
    segmentControl.tag=1111;
    [segmentControl addTarget:self action:@selector(segmentControl_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
    
    self.sharedController=[SharedController sharedController];
    
    isSelectedForDrinks=YES;
    
    
    if(appDelegate.isComingForOrders==YES)
    {
        appDelegate.isComingForOrders=NO;
        [arrOrdersTimedOut removeAllObjects];
        [arrOrdersTimedOut addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"OrdersTimedOut"]];
        [segmentControl setSelectedSegmentIndex:2];
        [self segmentControl_ValueChanged:segmentControl];
        
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:[dictVenue objectForKey:@"venueId"]]count]==0)
        {
            [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
            [self.sharedController getMenuListWithVenueID:[dictVenue objectForKey:@"venueId"] delegate:self];
        }
        else
        {
            [self modifyData];
        }
    }
    
    
    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, 320, 373)];
    tblView.dataSource=self;
    tblView.delegate=self;
    tblView.tag=111;
    [self.view addSubview:tblView];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568)
    {
        tblView.frame=CGRectMake(0, 40, 320, 373+90);
    }
    
    [tblView release];
    
    //optional pre init, so the ZooZ screen will upload immediatly, you can skip this call
    //    ZooZ * zooz = [ZooZ sharedInstance];
    //    [zooz preInitialize:@"c7659586-f78a-4876-b317-1b617ec8ab40" isSandboxEnv:IS_SANDBOX];
    [self getPeopleList];
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
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        tblView.hidden=NO;
        isSelectedForDrinks=NO;
        [tblView reloadData];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Date" ascending:NO];
        [arrOrders sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSString *strOrder=[NSString stringWithFormat:@"ORDERS (%i)",[arrOrders count]];
        
        [segmentControl setTitle:strOrder forSegmentAtIndex:2];
        
    }
    appDelegate.isComingForOrders=NO;
}

-(void)reloadDataPeopleAndOrderCount
{
    UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
    NSString *strOrder=[NSString stringWithFormat:@"ORDERS (%i)",appDelegate.intOrderCount];
    
    [segmentControl setTitle:strOrder forSegmentAtIndex:2];
    
    NSString *strPeopleCount=[NSString stringWithFormat:@"PEOPLE (%i)",appDelegate.intPeopleCount];
    
    [segmentControl setTitle:strPeopleCount forSegmentAtIndex:1];
}

-(void)segmentControl_ValueChanged:(UISegmentedControl*)segmentControl
{
    UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
    if(segmentControl.selectedSegmentIndex==0)
    {
        isSelectedForDrinks=YES;
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
       
        tblView.hidden=NO;
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
        
        NSString *strOrder=[NSString stringWithFormat:@"ORDERS (%i)",intOrdersCount];
        
        [segmentControl setTitle:strOrder forSegmentAtIndex:2];
        

        
        [tblView reloadData];
        
        self.sharedController=[SharedController sharedController];
        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController getUserOrdersWithBartsyId:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] delegate:self];
    }
    else if(segmentControl.selectedSegmentIndex==3)
    {
        isRequestForGettingsOrders=NO;
        isRequestForPeople=NO;
        isRequestForOrder=NO;
        isRequestForGettingsPastOrders = YES;
        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController getPastOrderWithVenueWithId:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] bartsyId:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] date:nil delegate:self];

    }
}

-(void)btnOrder_TouchUpInside
{
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
    
    
    float subTotal=([[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]*(([strTip floatValue]+9)))/100;
    float totalPrice=[[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]+subTotal;
    
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
}


-(void)btnTip_TouchUpInside:(id)sender
{
    if(btnValue!=0)
    {
        UIButton *btn=(UIButton*)[self.view viewWithTag:btnValue];
        [btn setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
    }
    btnValue=[sender tag];
    [sender setBackgroundImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
    
    if(btnValue==40)
    {
        UITextField *txtFld=(UITextField*)[self.view viewWithTag:500];
        [txtFld becomeFirstResponder];
    }
}

-(void)btnCancel_TouchUpInside
{
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
        [self createAlertViewWithTitle:@"Error" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
    }
    else if(isRequestForOrder==NO&&isRequestForPeople==NO&&isRequestForGettingsOrders==NO&&isRequestForGettingsPastOrders == NO)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[result objectForKey:@"menu"] forKey:[dictVenue objectForKey:@"venueId"]];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [arrMenu addObjectsFromArray:result];
        [self hideProgressView:nil];
        
        [self modifyData];
    }
    else if(isRequestForOrder==YES)
    {
        isRequestForOrder=NO;
        
//        UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
//        segmentControl.selectedSegmentIndex=2;
//        [self segmentControl_ValueChanged:segmentControl];
        
        UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
        NSString *strOrder=[NSString stringWithFormat:@"ORDERS (%i)",[[result objectForKey:@"orderCount"] integerValue]];
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
        NSString *strOrder=[NSString stringWithFormat:@"PEOPLE (%i)",[arrPeople count]];
        
        [segmentControl setTitle:strOrder forSegmentAtIndex:1];
    }
    else if (isRequestForGettingsPastOrders == YES)
    {
        isSelectedForPastOrders = YES;
        isSelectedForDrinks=NO;
        isSelectedForPeople=NO;
        [arrPastOrders removeAllObjects];
        [arrPastOrders addObjectsFromArray:[result objectForKey:@"pastOrders"]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderStatus == [c]'1' OR orderStatus == [c]'4' OR orderStatus == [c]'5' OR orderStatus == [c]'6' OR orderStatus == [c]'7' OR orderStatus == [c]'8'"];
        [arrPastOrders filterUsingPredicate:predicate];
        NSLog(@"past orders is %@",arrPastOrders);
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
            if(![[dictOrder objectForKey:@"orderStatus"] isEqualToString:@"5"])
            {
                NSDateFormatter *dateFormatter = [NSDateFormatter new];
                dateFormatter.dateFormat       = @"dd MM yyyy HH:mm:ss zzz";
                NSDate *date    = [dateFormatter dateFromString:[dictOrder objectForKey:@"orderTime"]];
                [dictOrder setObject:date forKey:@"Date"];
                [arrOrders addObject:dictOrder];
            }
            [dictOrder release];
        }
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Date" ascending:NO];
        [arrOrders sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        [arrBundledOrders removeAllObjects];
        for (int i=0; i<=3&&[arrOrders count]; i++)
        {
            if(i==0||i==2||i==3)
            {

            NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:arrOrders];
            
            NSString *strPred;
            if(i==0)
            strPred=[NSString stringWithFormat:@"orderStatus == [c]'0'"];
            else if(i==2)
            strPred=[NSString stringWithFormat:@"orderStatus == [c]'2'"];
            else
            strPred=[NSString stringWithFormat:@"orderStatus == [c]'3'"];
   
            [arrTemp filterUsingPredicate:[NSPredicate predicateWithFormat:strPred]];
            
                if([arrTemp count])
                [arrBundledOrders addObject:arrTemp];
                
                [arrTemp release];
            }
            
            /*
            if(i==3)
            {
                [arrOrdersOffered removeAllObjects];
                
                NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:arrOrders];
                NSString *strPred;
                strPred=[NSString stringWithFormat:@"orderStatus == [c]'9'"];
                [arrTemp filterUsingPredicate:[NSPredicate predicateWithFormat:strPred]];
                if([arrTemp count])
                    [arrOrdersOffered addObject:arrTemp];
                
                [arrTemp release];
            }
             */
        }
         
        [[NSUserDefaults standardUserDefaults]setObject:arrBundledOrders forKey:@"Orders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSLog(@"Orders %@",arrBundledOrders);
        
        if([arrOrders count])
            [appDelegate startTimerToCheckOrderStatusUpdate];
        else
            [appDelegate stopTimerForOrderStatusUpdate];
        
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        [tblView reloadData];
        
        UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
        NSString *strOrder=[NSString stringWithFormat:@"ORDERS (%i)",[arrOrders count]];
        [segmentControl setTitle:strOrder forSegmentAtIndex:2];
        appDelegate.intOrderCount=[arrOrders count];
        
    }
}

-(void)reloadTable
{
    UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
    [tblView reloadData];
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
        NSString *strOrder=[NSString stringWithFormat:@"PEOPLE (%i)",[arrPeople count]];
        [segmentControl setTitle:strOrder forSegmentAtIndex:1];
    }
    else if(isRequestForGettingsOrders==YES)
    {
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        [tblView reloadData];
        
//        UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
//        NSString *strOrder=[NSString stringWithFormat:@"ORDERS (%i)",[arrOrders count]];
//        [segmentControl setTitle:strOrder forSegmentAtIndex:2];
    }

    
}

-(void)modifyData
{
    NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
    NSMutableArray *arrContents=[[NSMutableArray alloc]init];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:[dictVenue objectForKey:@"venueId"]])
    {
        [arrMenu removeAllObjects];
        [arrMenu addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:[dictVenue objectForKey:@"venueId"]]];
    }
    
    //Drinks without category name
    for (int i=0; i<[arrMenu count]; i++)
    {
        NSDictionary *dict=[arrMenu objectAtIndex:i];
        if([[dict objectForKey:@"section_name"] length]==0)
        {
            NSMutableArray *arrSubsections=[dict objectForKey:@"subsections"];
            
            for (int j=0; j<[arrSubsections count]; j++)
            {
                NSDictionary *dictSubsection=[arrSubsections objectAtIndex:j];
                [arrContents addObjectsFromArray:[dictSubsection objectForKey:@"contents"]];
            }
            NSPredicate *predicateName = [NSPredicate predicateWithFormat:@"price!=nil AND price!=''"];
            [arrContents filterUsingPredicate:predicateName];

            NSArray *tempArray = [[NSArray alloc] initWithArray:arrContents];
            for (int i = 0; i<[tempArray count]; i++)
            {
                NSMutableDictionary *contentDict = [tempArray objectAtIndex:i];
                NSNumber *priceNumber = [NSNumber numberWithFloat:[[contentDict valueForKey:@"price"] floatValue]];
                if ([priceNumber isEqualToNumber:[NSNumber numberWithFloat:0.00000]])
                {
                    [arrContents removeObject:contentDict];
                }
            }
            
            [arrTemp insertObject:arrContents atIndex:0];
        }
    }
    
    //Making the first drinks array as a dictionary instead of array
    if([arrTemp count])
    {
        [arrTemp removeAllObjects];
        NSMutableDictionary *dictFirstItem=[[NSMutableDictionary alloc]initWithObjectsAndKeys:arrContents,@"contents",@"Various Items",@"section_name",@"0",@"Arrow", nil];
        [arrTemp addObject:dictFirstItem];
        [dictFirstItem release];
    }
    
    //Drinks with category name
    for (int i=0; i<[arrMenu count]; i++)
    {
        NSDictionary *dict=[arrMenu objectAtIndex:i];
        if([[dict objectForKey:@"section_name"] length]!=0)
        {
            NSMutableArray *arrSubsections=[dict objectForKey:@"subsections"];
            
            for (int j=0; j<[arrSubsections count]; j++)
            {
                NSMutableDictionary *dictSubsection=[[NSMutableDictionary alloc]initWithDictionary:[arrSubsections objectAtIndex:j]];
                NSMutableArray *arrContents2=[[NSMutableArray alloc]initWithArray:[dictSubsection objectForKey:@"contents"]];
                NSPredicate *predicateName = [NSPredicate predicateWithFormat:@"price!=nil AND price!=''"];
                //NSPredicate *predicateName = [NSPredicate predicateWithFormat:@"price!=nil AND price!='' AND price CONTAINS[cd] %@",@"."];
                [arrContents2 filterUsingPredicate:predicateName];
                NSArray *tempArray = [[NSArray alloc] initWithArray:arrContents2];
                for (int i = 0; i<[tempArray count]; i++)
                {
                    NSMutableDictionary *contentDict = [tempArray objectAtIndex:i];
                    NSNumber *priceNumber = [NSNumber numberWithFloat:[[contentDict valueForKey:@"price"] floatValue]];
                    if ([priceNumber isEqualToNumber:[NSNumber numberWithFloat:0.00000]])
                    {
                        [arrContents2 removeObject:contentDict];
                    }
                }
                [dictSubsection setObject:arrContents2 forKey:@"contents"];
                [dictSubsection setObject:[dict objectForKey:@"section_name"] forKey:@"section_name"];
                [dictSubsection setObject:@"0" forKey:@"Arrow"];
                if([arrContents2 count])
                    [arrTemp addObject:dictSubsection];
                [dictSubsection release];
                [tempArray release];
            }
        }
    }
    
    [arrMenu removeAllObjects];
    [arrMenu addObjectsFromArray:arrTemp];
    [arrTemp release];
    
    UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
    [tblView reloadData];
}

-(void)getPeopleList
{
    
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/data/checkedInUsersList",KServerURL];
    
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[dictVenue objectForKey:@"venueId"],@"venueId",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"],@"bartsyId",nil];
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];
    
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
            self.sharedController=[SharedController sharedController];
            [self.sharedController checkOutAtBartsyVenueWithId:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] delegate:nil];

        }
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"CheckInVenueId"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"OrdersTimedOut"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"bartsyId"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Table view Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(isSelectedForDrinks)
        return [arrMenu count]+1;
    else if(isSelectedForPeople)
        return [arrPeople count];
    else
    {
        if([arrBundledOrders count]||[arrOrdersTimedOut count])
        {
//            intNoOfSections=[arrBundledOrders count]+([arrOrdersTimedOut count]>=1?1:0);
//            return [arrBundledOrders count]+([arrOrdersTimedOut count]>=1?1:0);
            intNoOfSections=[arrBundledOrders count]+([arrOrdersTimedOut count]>=1?0:0)+([arrOrdersOffered count]>=1?1:0);
            return [arrBundledOrders count]+([arrOrdersTimedOut count]>=1?0:0)+([arrOrdersOffered count]>=1?1:0);
        }
        else
        {
            return 1;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(isSelectedForDrinks)
        return 44;
    else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(isSelectedForDrinks)
    {
        id object;
        if(section!=0)
        object=[arrMenu objectAtIndex:section-1];
        
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIImageView *headerBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sectionBg.png"]];
        [headerView addSubview:headerBg];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 0, 600, 44);
        button.tag=section +1;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if(section==0)
        {
            [button setImage:[UIImage imageNamed:@"disclosure.png"] forState:UIControlStateNormal];   
        }
        else if([[object objectForKey:@"Arrow"] integerValue]==0)
        {
            [button setImage:[UIImage imageNamed:@"disclosure.png"] forState:UIControlStateNormal];
        }
        else
        {
            [button setImage:[UIImage imageNamed:@"shrink.png"] forState:UIControlStateNormal];
        }
        [headerView addSubview:button];
        
        UILabel *headerTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 7, 280, 30)];
        [headerTitle setBackgroundColor:[UIColor clearColor]];
        [headerTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [headerTitle setTextColor:[UIColor blackColor]];
        if(section==0)
        {
            headerTitle.text= @"Custom Drinks";
        }
        else if(section==1&&[[object objectForKey:@"subsection_name"] length]==0)
        {
            headerTitle.text= [object objectForKey:@"section_name"];
        }
        else if([[object objectForKey:@"subsection_name"] length])
        {
            headerTitle.text= [NSString stringWithFormat:@"%@->%@",[object objectForKey:@"section_name"],[object objectForKey:@"subsection_name"]];
        }
        else
        {
            headerTitle.text= [NSString stringWithFormat:@"%@",[object objectForKey:@"section_name"]];
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
        id object;
        if(section!=0)
        object=[arrMenu objectAtIndex:section-1];
        
        if(section==0)
        {
            return 0;
        }
        else if(section==1&&[object isKindOfClass:[NSArray class]])
        {
            return [object count];
        }
        else
        {
            if([[object objectForKey:@"Arrow"] integerValue]==0)
            {
                return 0;
            }
            else
            {
                return [[object objectForKey:@"contents"] count];
            }
        }
    }
    else if(isSelectedForPastOrders == YES)
    {
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
    if(isSelectedForDrinks)
        return 80;
    else if(isSelectedForPeople)
        return 60;
    else if(isSelectedForPastOrders == YES)
    {
        return 100;
    }
    else
    {
        BOOL isOrderTimeoutCell=NO;
        if([arrOrdersTimedOut count]&&indexPath.section==[arrBundledOrders count]+([arrOrdersOffered count]>=1?1:0))
            isOrderTimeoutCell=YES;
        
        if([arrBundledOrders count]-1==indexPath.section&&isOrderTimeoutCell==NO)
        {
            return [[arrBundledOrders objectAtIndex:indexPath.section] count]*70+170+70;
        }
        else if([arrOrdersOffered count]&&isOrderTimeoutCell==NO)
        {
           return [arrOrdersOffered  count]*70+170+70;
        }
        else if(isOrderTimeoutCell)
        {
            return [arrOrdersTimedOut  count]*70+170+70;
        }
        else
        {
            return 100;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    UITableViewCell *cell;
    
    if(isSelectedForDrinks==YES)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        //        UIImageView *imgViewDrink=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 70, 70)];
        //        imgViewDrink.image=[UIImage imageNamed:@"drinks.png"];
        //        [[imgViewDrink layer] setShadowOffset:CGSizeMake(0, 1)];
        //        [[imgViewDrink layer] setShadowColor:[[UIColor grayColor] CGColor]];
        //        [[imgViewDrink layer] setShadowRadius:3.0];
        //        [[imgViewDrink layer] setShadowOpacity:0.8];
        //        [cell.contentView addSubview:imgViewDrink];
        //        [imgViewDrink release];
        
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 295, 20)];
        id object=[arrMenu objectAtIndex:indexPath.section-1];
        if(indexPath.section==1&&[object isKindOfClass:[NSArray class]])
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
        
        lblName.font=[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lblName];
        [lblName release];
        
        
        UILabel *lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(5, 30, 255, 50)];
        lblDescription.numberOfLines=2;
        if(indexPath.section==0&&[object isKindOfClass:[NSArray class]])
        {
            NSDictionary *dict=[object objectAtIndex:indexPath.row];
            lblDescription.text=[dict objectForKey:@"description"];
        }
        else
        {
            NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
            NSDictionary *dict=[arrContents objectAtIndex:indexPath.row];
            lblDescription.text=[dict objectForKey:@"description"];
        }
        
        lblDescription.font=[UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lblDescription];
        [lblDescription release];
        
        UILabel *lblPrice=[[UILabel alloc]initWithFrame:CGRectMake(270, 0, 50, 80)];
        if(indexPath.section==0&&[object isKindOfClass:[NSArray class]])
        {
            NSDictionary *dict=[object objectAtIndex:indexPath.row];
            lblPrice.text=[dict objectForKey:@"price"];
        }
        else
        {
            NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
            NSDictionary *dict=[arrContents objectAtIndex:indexPath.row];
            lblPrice.text=[dict objectForKey:@"price"];
        }
        
        lblPrice.font=[UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:lblPrice];
        [lblPrice release];
    }
    else if(isSelectedForPeople)
    {
        cell =[[PeopleCustomCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];

//        [cell setUserInteractionEnabled:NO];
        NSString *strBartsyId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]];

        NSDictionary *dictPeople=[arrPeople objectAtIndex:indexPath.section];
        
        NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictPeople objectForKey:@"userImagePath"]];
        [cell.imageView setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [[cell.imageView layer] setShadowOffset:CGSizeMake(0, 1)];
        [[cell.imageView layer] setShadowColor:[[UIColor whiteColor] CGColor]];
        [[cell.imageView layer] setShadowRadius:3.0];
        [[cell.imageView layer] setShadowOpacity:0.8];
        
        cell.textLabel.text=[dictPeople objectForKey:@"nickName"];
        cell.detailTextLabel.text=[dictPeople objectForKey:@"gender"];
        
        if ([strBartsyId doubleValue] != [[dictPeople objectForKey:@"bartsyId"] doubleValue])
        {
            UIButton *btnChat=[self createUIButtonWithTitle:nil image:[UIImage imageNamed:@"icon_chat.png"] frame:CGRectMake(280, 5, 32, 32) tag:indexPath.section selector:@selector(btnChat_TouchUpInside:) target:self];
            //[cell.contentView addSubview:btnChat];
        }

        //UILabel *lbl
    }
    else if (isSelectedForPastOrders == YES)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];

        if ([arrPastOrders count])
        {
            UILabel *lblItemName = [self createLabelWithTitle:[[arrPastOrders objectAtIndex:indexPath.row] objectForKey:@"itemName"] frame:CGRectMake(10, 2, 250, 15) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor blackColor] numberOfLines:1];
            lblItemName.backgroundColor=[UIColor clearColor];
            lblItemName.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblItemName];
            
            UILabel *lbldescription = [self createLabelWithTitle:[[arrPastOrders objectAtIndex:indexPath.row] objectForKey:@"description"] frame:CGRectMake(10, 15,250, 45) tag:0 font:[UIFont systemFontOfSize:13] color:[UIColor grayColor] numberOfLines:3];
            lbldescription.backgroundColor=[UIColor clearColor];
            lbldescription.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lbldescription];
            
            
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat       = @"yyyy-MM-dd'T'HH:mm:ssZ";
            NSDate *date    = [dateFormatter dateFromString:[[arrPastOrders objectAtIndex:indexPath.row] objectForKey:@"dateCreated"]];
            
            
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
            lblTime.textColor = [UIColor blackColor] ;
            lblTime.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblTime];
            [lblTime release];
            
            
            UILabel *lblRecepient = [[UILabel alloc]initWithFrame:CGRectMake(10, 75, 280, 15)];
            lblRecepient.font = [UIFont systemFontOfSize:14];
            lblRecepient.text = [NSString stringWithFormat:@"Recipient : %@",[[arrPastOrders objectAtIndex:indexPath.row] objectForKey:@"nickName"]];
            lblRecepient.tag = 1234234567;
            lblRecepient.backgroundColor = [UIColor clearColor];
            lblRecepient.textColor = [UIColor blackColor] ;
            lblRecepient.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblRecepient];
            [lblRecepient release];
            
            
            NSString *stringFortotalPrice = [NSString stringWithFormat:@"$%.2f",[[[arrPastOrders objectAtIndex:indexPath.row] objectForKey:@"totalPrice"] floatValue]];
            
            UILabel *lblTotalPrice = [self createLabelWithTitle:stringFortotalPrice frame:CGRectMake(270, 2, 200, 15) tag:0 font:[UIFont boldSystemFontOfSize:11] color:[UIColor blackColor] numberOfLines:1];
            lblTotalPrice.backgroundColor=[UIColor clearColor];
            lblTotalPrice.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblTotalPrice];
            
        }
        else
        {
            cell.textLabel.text=@"No past orders\nGo to the drinks tab to place some";
            cell.textLabel.numberOfLines=5;
        }
        
    }
    else
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];

        BOOL isOrderTimeoutCell=NO;
        if([arrOrdersTimedOut count]&&indexPath.section==[arrBundledOrders count]+([arrOrdersOffered count]>=1?1:0))
            isOrderTimeoutCell=YES;
        
        if([arrBundledOrders count]&&isOrderTimeoutCell==NO)
        {
            NSDictionary *dict=[[arrBundledOrders objectAtIndex:indexPath.section] lastObject];
            //cell.textLabel.text=[dict objectForKey:@"itemName"];
            //[cell setUserInteractionEnabled:NO];
            
            UIView *viewBorder = [[UIView alloc]initWithFrame:CGRectMake(9, 5, 300, [[arrBundledOrders objectAtIndex:indexPath.section] count]*70+160+70)];
            viewBorder.backgroundColor = [UIColor clearColor];
            viewBorder.layer.borderWidth = 1;
            viewBorder.layer.cornerRadius = 6;
            viewBorder.layer.borderColor = [UIColor grayColor].CGColor;
            viewBorder.layer.backgroundColor=[UIColor whiteColor].CGColor;
            viewBorder.tag = 101;
            [cell.contentView addSubview:viewBorder];
            [viewBorder release];
            
            UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(5, 10, 290, 48+20)];
            if([[dict objectForKey:@"orderStatus"] isEqualToString:@"0"])
                viewHeader.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
            else if ([[dict objectForKey:@"orderStatus"] isEqualToString:@"2"])
                viewHeader.backgroundColor = [UIColor orangeColor];
            else
                viewHeader.backgroundColor = [UIColor greenColor];
            viewHeader.layer.cornerRadius = 6;
            viewHeader.tag = 11;
            [viewBorder addSubview:viewHeader];
            [viewHeader release];
            
            NSURL *urlPhoto=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@",KServerURL,[[NSUserDefaults standardUserDefaults]objectForKey:@"ImagePath"],[dict objectForKey:@"recieverBartsyId"]]];
            UIImageView *imgViewPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(10,15,60,60)];
            [imgViewPhoto setImageWithURL:urlPhoto];
            [viewBorder addSubview:imgViewPhoto];
            [imgViewPhoto release];
            
            
            UILabel *lblOrderId = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 180, 40)];
            lblOrderId.font = [UIFont boldSystemFontOfSize:38];
            lblOrderId.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"orderId"]];
            lblOrderId.backgroundColor = [UIColor clearColor];
            lblOrderId.textColor = [UIColor whiteColor] ;
            lblOrderId.textAlignment = NSTextAlignmentLeft;
            [viewBorder addSubview:lblOrderId];
            [lblOrderId release];
            
            NSMutableArray *arrPeopleTemp=[[NSMutableArray alloc]initWithArray:arrPeople];
            NSPredicate *pred=[NSPredicate predicateWithFormat:@"bartsyId ==[c] %@",[dict objectForKey:@"recieverBartsyId"]];
            [arrPeopleTemp filterUsingPredicate:pred];
            
            if([arrPeopleTemp count])
            {
                UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 200, 28)];
                lblName.font = [UIFont boldSystemFontOfSize:20];
                lblName.text = [NSString stringWithFormat:@"%@",[[arrPeopleTemp objectAtIndex:0] objectForKey:@"nickName"]];
                lblName.backgroundColor = [UIColor clearColor];
                lblName.textColor = [UIColor whiteColor] ;
                lblName.textAlignment = NSTextAlignmentLeft;
                [viewBorder addSubview:lblName];
                [lblName release];
            }
            
            UIView *viewStatus = [[UIView alloc]initWithFrame:CGRectMake(5, 85, 290, 30)];
            viewStatus.backgroundColor = [UIColor whiteColor];
            viewStatus.layer.borderWidth = 1;
            viewStatus.layer.borderColor = [UIColor grayColor].CGColor;
            viewStatus.layer.cornerRadius = 6;
            [viewBorder addSubview:viewStatus];
            [viewStatus release];
            
            UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 280, 30)];
            lblTitle.numberOfLines=2;
            lblTitle.font = [UIFont boldSystemFontOfSize:18];
            if([[dict objectForKey:@"orderStatus"] isEqualToString:@"0"])
                lblTitle.text = [NSString stringWithFormat:@"Waiting for bartender to accept"];
            else
                lblTitle.text = [NSString stringWithFormat:@"%@",[arrStatus objectAtIndex:[[dict objectForKey:@"orderStatus"] integerValue]-2]];
            lblTitle.tag = 1234;
            lblTitle.backgroundColor = [UIColor clearColor];
            lblTitle.textColor = [UIColor blackColor] ;
            lblTitle.textAlignment = NSTextAlignmentCenter;
            lblTitle.adjustsFontSizeToFitWidth=YES;
            [viewStatus addSubview:lblTitle];
            [lblTitle release];
            
            UIView *viewDate = [[UIView alloc]initWithFrame:CGRectMake(5, 66+60, 290, 30)];
            viewDate.backgroundColor = [UIColor whiteColor];
            viewDate.layer.borderWidth = 1;
            viewDate.layer.borderColor = [UIColor grayColor].CGColor;
            viewDate.layer.cornerRadius = 6;
            viewDate.tag = 12;
            [viewBorder addSubview:viewDate];
            [viewDate release];
            
            NSDate *date=[dict objectForKey:@"Date"];
            
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"aa kk:mm 'on' EEEE MMMM d"];
            
            
            NSString *newDateString = [outputFormatter stringFromDate:date];
            
            NSMutableArray *arrDateComps=[[NSMutableArray alloc]initWithArray:[newDateString componentsSeparatedByString:@" "]];
            NSLog(@"newDateString %@", newDateString);
            
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
            
            NSString *strDate=[NSString stringWithFormat:@"Placed at: %@%i:%@%i:%@%i %@ on %@ %i,%i",(comps.hour<10? @"0" : @""),comps.hour,(comps.minute<10? @"0":@""),comps.minute,(comps.second<10? @"0":@""),comps.second,[arrDateComps objectAtIndex:0],[arrDateComps objectAtIndex:4],comps.day,comps.year];
            
            UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(7, 3, 280, 30)];
            lblTime.font = [UIFont systemFontOfSize:14];
            lblTime.text = strDate;
            lblTime.tag = 1234234567;
            lblTime.backgroundColor = [UIColor clearColor];
            lblTime.textColor = [UIColor blackColor] ;
            lblTime.textAlignment = NSTextAlignmentLeft;
            [viewDate addSubview:lblTime];
            [lblTime release];
            
            UIView *viewDescription = [[UIView alloc]initWithFrame:CGRectMake(5, 111+60, 290, [[arrBundledOrders objectAtIndex:indexPath.section] count]*70)];
            viewDescription.backgroundColor = [UIColor whiteColor];
            viewDescription.layer.borderWidth = 1;
            viewDescription.layer.borderColor = [UIColor grayColor].CGColor;
            viewDescription.layer.cornerRadius = 6;
            viewDescription.tag = 13;
            [viewBorder addSubview:viewDescription];
            [viewDescription release];
            
            NSArray *arrSubSectionOrders=[arrBundledOrders objectAtIndex:indexPath.section] ;
            
            float floatPrice=0;
            float floatTotalPrice=0;
            float floatTipTaxFee=0;
            
            for (int i=0; i<[arrSubSectionOrders count]; i++)
            {
                NSDictionary *dictTempOrder=[arrSubSectionOrders objectAtIndex:i];
                
                UILabel *lblDescription1 = [[UILabel alloc]initWithFrame:CGRectMake(7, 1+(i*70), 242, 20)];
                lblDescription1.font = [UIFont boldSystemFontOfSize:14];
                lblDescription1.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"itemName"]];
                lblDescription1.tag = 1234234567;
                lblDescription1.numberOfLines = 1;
                lblDescription1.backgroundColor = [UIColor clearColor];
                lblDescription1.textColor = [UIColor blackColor] ;
                lblDescription1.textAlignment = NSTextAlignmentLeft;
                [viewDescription addSubview:lblDescription1];
                
                
                UILabel *lblDescription2 = [[UILabel alloc]initWithFrame:CGRectMake(7, 21+(i*70), 245, 40)];
                lblDescription2.font = [UIFont systemFontOfSize:14];
                lblDescription2.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"description"]];
                lblDescription2.numberOfLines = 2;
                lblDescription2.tag = 12347890;
                lblDescription2.backgroundColor = [UIColor clearColor];
                lblDescription2.textColor = [UIColor blackColor] ;
                lblDescription2.textAlignment = NSTextAlignmentLeft;
                [viewDescription addSubview:lblDescription2];
                
                
                UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(248, 1+(i*70), 42, 20)];
                lblPrice.font = [UIFont systemFontOfSize:12];
                lblPrice.text = [NSString stringWithFormat:@"$%.2f",[[dictTempOrder objectForKey:@"basePrice"] floatValue]];
                lblPrice.numberOfLines = 1;
                lblPrice.backgroundColor = [UIColor clearColor];
                lblPrice.textColor = [UIColor blackColor] ;
                lblPrice.textAlignment = NSTextAlignmentLeft;
                [viewDescription addSubview:lblPrice];
                
                NSLog(@"ID's %@,%@",[dictTempOrder objectForKey:@"senderBartsyId"],[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]);
                
                if([[dictTempOrder objectForKey:@"senderBartsyId"]isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]])
                {
                    floatPrice+=[[dictTempOrder objectForKey:@"basePrice"] floatValue];
                    floatTotalPrice+=[[dictTempOrder objectForKey:@"totalPrice"]floatValue];
                    floatTipTaxFee+=[[dictTempOrder objectForKey:@"totalPrice"]floatValue]-[[dictTempOrder objectForKey:@"basePrice"]floatValue];
                }
                else
                {
                    lblPrice.text=@"-";
                }
                
                [lblDescription1 release];
                [lblDescription2 release];
                [lblPrice release];
                

            }
            
            UIView *viewPrice = [[UIView alloc]initWithFrame:CGRectMake(5, 111+[[arrBundledOrders objectAtIndex:indexPath.section] count]*70+15+60, 290, 30)];
            viewPrice.backgroundColor = [UIColor whiteColor];
            viewPrice.layer.borderWidth = 1;
            viewPrice.layer.borderColor = [UIColor grayColor].CGColor;
            viewPrice.layer.cornerRadius = 6;
            viewPrice.tag = 12;
            [viewBorder addSubview:viewPrice];
            
            
            UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, 82, 30)];
            lblPrice.font = [UIFont systemFontOfSize:11];
            if(floatPrice>0.01)
            lblPrice.text = [NSString stringWithFormat:@"Price: $%.2f",floatPrice];
            else
            lblPrice.text = [NSString stringWithFormat:@"Price: -"];
            lblPrice.tag = 12347890;
            lblPrice.backgroundColor = [UIColor clearColor];
            lblPrice.textColor = [UIColor blackColor] ;
            lblPrice.textAlignment = NSTextAlignmentLeft;
            [viewPrice addSubview:lblPrice];
            [lblPrice release];
            
            UILabel *lblTipTaxFee = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 130, 30)];
            lblTipTaxFee.font = [UIFont systemFontOfSize:11];
            if(floatTipTaxFee>0.01)
            lblTipTaxFee.text = [NSString stringWithFormat:@"Tip,tax and fees: $%.2f",floatTipTaxFee];
            else
            lblTipTaxFee.text = [NSString stringWithFormat:@"Tip,tax and fees: -"];
            lblTipTaxFee.tag = 12347890;
            lblTipTaxFee.backgroundColor = [UIColor clearColor];
            lblTipTaxFee.textColor = [UIColor blackColor] ;
            lblTipTaxFee.textAlignment = NSTextAlignmentLeft;
            [viewPrice addSubview:lblTipTaxFee];
            [lblTipTaxFee release];
            
            UILabel *lblTotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(215, 0, 100, 30)];
            lblTotalPrice.font = [UIFont systemFontOfSize:11];
            if(floatTotalPrice>0.01)
            lblTotalPrice.text = [NSString stringWithFormat:@"Total: $%.2f",floatTotalPrice];
            else
            lblTotalPrice.text = [NSString stringWithFormat:@"Total: -"];
            lblTotalPrice.tag = 12347890;
            lblTotalPrice.backgroundColor = [UIColor clearColor];
            lblTotalPrice.textColor = [UIColor blackColor] ;
            lblTotalPrice.textAlignment = NSTextAlignmentLeft;
            [viewPrice addSubview:lblTotalPrice];
            [lblTotalPrice release];
            
            [viewPrice release];

            
        }
        else if([arrOrdersOffered count]&&isOrderTimeoutCell==NO)
        {
            //For Drinks Offered
            NSDictionary *dict=[arrOrdersTimedOut  objectAtIndex:0];
            
            UIView *viewBorder = [[UIView alloc]initWithFrame:CGRectMake(9, 5, 300, [arrOrdersOffered count]*70+160+70)];
            viewBorder.backgroundColor = [UIColor clearColor];
            viewBorder.layer.borderWidth = 1;
            viewBorder.layer.cornerRadius = 6;
            viewBorder.layer.borderColor = [UIColor grayColor].CGColor;
            viewBorder.layer.backgroundColor=[UIColor whiteColor].CGColor;
            viewBorder.tag = 101;
            [cell.contentView addSubview:viewBorder];
            [viewBorder release];
            
            UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(5, 10, 290, 48+20)];
            viewHeader.backgroundColor = [UIColor redColor];
            viewHeader.layer.cornerRadius = 6;
            viewHeader.tag = 11;
            [viewBorder addSubview:viewHeader];
            [viewHeader release];
            
            NSURL *urlPhoto=nil;
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] isEqualToString:[dict objectForKey:@"senderBartsyId"]])
                urlPhoto=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Bartsy/userImages/%@",KServerURL,[dict objectForKey:@"recieverBartsyId"]]];
            else
                urlPhoto=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Bartsy/userImages/%@",KServerURL,[dict objectForKey:@"senderBartsyId"]]];
   
            UIImageView *imgViewPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(10,15,60,60)];
            [imgViewPhoto setImageWithURL:urlPhoto];
            [viewBorder addSubview:imgViewPhoto];
            [imgViewPhoto release];
            
            
            UILabel *lblOrderId = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 180, 40)];
            lblOrderId.font = [UIFont boldSystemFontOfSize:38];
            lblOrderId.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"orderId"]];
            lblOrderId.backgroundColor = [UIColor clearColor];
            lblOrderId.textColor = [UIColor whiteColor] ;
            lblOrderId.textAlignment = NSTextAlignmentLeft;
            [viewBorder addSubview:lblOrderId];
            [lblOrderId release];
            
            UIView *viewStatus = [[UIView alloc]initWithFrame:CGRectMake(5, 83, 290, 60)];
            viewStatus.backgroundColor = [UIColor whiteColor];
            viewStatus.layer.borderWidth = 1;
            viewStatus.layer.borderColor = [UIColor grayColor].CGColor;
            viewStatus.layer.cornerRadius = 6;
            [viewBorder addSubview:viewStatus];
            [viewStatus release];
            
            UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 40)];
            lblTitle.numberOfLines=3;
            lblTitle.font = [UIFont boldSystemFontOfSize:12];
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] isEqualToString:[dict objectForKey:@"senderBartsyId"]])
            lblTitle.text=[NSString stringWithFormat:@"waiting for %@ to accept",[dict objectForKey:@"receiverName"]];
            else
            lblTitle.text=[NSString stringWithFormat:@"You have a new drink offer from %@. Click to accept it!",[dict objectForKey:@"senderName"]];
            lblTitle.tag = 1234;
            lblTitle.backgroundColor = [UIColor clearColor];
            lblTitle.textColor = [UIColor blackColor] ;
            lblTitle.textAlignment = NSTextAlignmentCenter;
            lblTitle.adjustsFontSizeToFitWidth=YES;
            [viewStatus addSubview:lblTitle];
            [lblTitle release];
            
            UIButton *btnAccept=[self createUIButtonWithTitle:@"Accept" image:nil frame:CGRectMake(5, 38, 130, 20) tag:123 selector:@selector(btnOrderOffered_TouchUpInside:) target:self];
            btnAccept.titleLabel.font=[UIFont systemFontOfSize:18];
            [btnAccept setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
            btnAccept.backgroundColor=[UIColor grayColor];
            [viewStatus addSubview:btnAccept];
            
            UIButton *btnReject=[self createUIButtonWithTitle:@"Reject" image:nil frame:CGRectMake(140, 38, 130, 20) tag:321 selector:@selector(btnOrderOffered_TouchUpInside:) target:self];
            btnReject.titleLabel.font=[UIFont systemFontOfSize:18];
            [btnReject setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
            btnReject.backgroundColor=[UIColor grayColor];
            [viewStatus addSubview:btnReject];
            
            UIView *viewDate = [[UIView alloc]initWithFrame:CGRectMake(5, 66+60+20, 290, 30)];
            viewDate.backgroundColor = [UIColor whiteColor];
            viewDate.layer.borderWidth = 1;
            viewDate.layer.borderColor = [UIColor grayColor].CGColor;
            viewDate.layer.cornerRadius = 6;
            viewDate.tag = 12;
            [viewBorder addSubview:viewDate];
            [viewDate release];
            
            NSDate *date=[dict objectForKey:@"Time"];
            
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"aa kk:mm 'on' EEEE MMMM d"];
            
            
            NSString *newDateString = [outputFormatter stringFromDate:date];
            
            NSMutableArray *arrDateComps=[[NSMutableArray alloc]initWithArray:[newDateString componentsSeparatedByString:@" "]];
            NSLog(@"newDateString %@", newDateString);
            
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
            
            NSString *strDate=[NSString stringWithFormat:@"Placed at: %@%i:%@%i:%@%i %@ on %@ %i,%i",(comps.hour<10? @"0" : @""),comps.hour,(comps.minute<10? @"0":@""),comps.minute,(comps.second<10? @"0":@""),comps.second,[arrDateComps objectAtIndex:0],[arrDateComps objectAtIndex:4],comps.day,comps.year];
            
            UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(7, 3, 280, 30)];
            lblTime.font = [UIFont systemFontOfSize:14];
            lblTime.text = strDate;
            lblTime.tag = 1234234567;
            lblTime.backgroundColor = [UIColor clearColor];
            lblTime.textColor = [UIColor blackColor] ;
            lblTime.textAlignment = NSTextAlignmentLeft;
            [viewDate addSubview:lblTime];
            [lblTime release];
            
            UIView *viewDescription = [[UIView alloc]initWithFrame:CGRectMake(5, 111+60+10, 290, [arrOrdersOffered count]*70)];
            viewDescription.backgroundColor = [UIColor whiteColor];
            viewDescription.layer.borderWidth = 1;
            viewDescription.layer.borderColor = [UIColor grayColor].CGColor;
            viewDescription.layer.cornerRadius = 6;
            viewDescription.tag = 13;
            [viewBorder addSubview:viewDescription];
            [viewDescription release];
            
            
            float floatPrice=0;
            float floatTotalPrice=0;
            float floatTipTaxFee=0;
            
            for (int i=0; i<[arrOrdersOffered count]; i++)
            {
                NSDictionary *dictTempOrder=[arrOrdersOffered objectAtIndex:i];
                
                
                
                UILabel *lblDescription1 = [[UILabel alloc]initWithFrame:CGRectMake(7, 1+(i*70), 242, 20)];
                lblDescription1.font = [UIFont boldSystemFontOfSize:14];
                lblDescription1.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"name"]];
                lblDescription1.tag = 1234234567;
                lblDescription1.numberOfLines = 1;
                lblDescription1.backgroundColor = [UIColor clearColor];
                lblDescription1.textColor = [UIColor blackColor] ;
                lblDescription1.textAlignment = NSTextAlignmentLeft;
                [viewDescription addSubview:lblDescription1];
                
                
                UILabel *lblDescription2 = [[UILabel alloc]initWithFrame:CGRectMake(7, 21+(i*70), 245, 40)];
                lblDescription2.font = [UIFont systemFontOfSize:14];
                lblDescription2.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"description"]];
                lblDescription2.numberOfLines = 2;
                lblDescription2.tag = 12347890;
                lblDescription2.backgroundColor = [UIColor clearColor];
                lblDescription2.textColor = [UIColor blackColor] ;
                lblDescription2.textAlignment = NSTextAlignmentLeft;
                [viewDescription addSubview:lblDescription2];
                
                
                UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(248, 1+(i*70), 42, 20)];
                lblPrice.font = [UIFont systemFontOfSize:12];
                lblPrice.text = [NSString stringWithFormat:@"$%.2f",[[dictTempOrder objectForKey:@"price"] floatValue]];
                lblPrice.numberOfLines = 1;
                lblPrice.backgroundColor = [UIColor clearColor];
                lblPrice.textColor = [UIColor blackColor] ;
                lblPrice.textAlignment = NSTextAlignmentLeft;
                [viewDescription addSubview:lblPrice];
                
                
                if(0)//[[dictTempOrder objectForKey:@"senderBartsyId"]isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]])
                {
                    floatPrice+=[[dictTempOrder objectForKey:@"price"] floatValue];
                    
                    float subTotal=([[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]*(([[dict objectForKey:@"tipPercentage"] integerValue]+9)))/100;
                    
                    floatTotalPrice+=floatPrice+subTotal;
                    floatTipTaxFee+=subTotal;
                }
                else
                {
                    lblPrice.text=@"-";
                }
                
                [lblDescription1 release];
                [lblDescription2 release];
                [lblPrice release];
                
            }
            
            UIView *viewPrice = [[UIView alloc]initWithFrame:CGRectMake(5, 111+[arrOrdersTimedOut count]*70+15+60+10, 290, 30)];
            viewPrice.backgroundColor = [UIColor whiteColor];
            viewPrice.layer.borderWidth = 1;
            viewPrice.layer.borderColor = [UIColor grayColor].CGColor;
            viewPrice.layer.cornerRadius = 6;
            viewPrice.tag = 12;
            [viewBorder addSubview:viewPrice];
            
            
            UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, 82, 30)];
            lblPrice.font = [UIFont systemFontOfSize:11];
            if(0)//floatPrice>0.01)
                lblPrice.text = [NSString stringWithFormat:@"Price: $%.2f",floatPrice];
            else
                lblPrice.text = [NSString stringWithFormat:@"Price: -"];
            lblPrice.tag = 12347890;
            lblPrice.backgroundColor = [UIColor clearColor];
            lblPrice.textColor = [UIColor blackColor] ;
            lblPrice.textAlignment = NSTextAlignmentLeft;
            [viewPrice addSubview:lblPrice];
            [lblPrice release];
            
            UILabel *lblTipTaxFee = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 130, 30)];
            lblTipTaxFee.font = [UIFont systemFontOfSize:11];
            if(0)//floatTipTaxFee>0.01)
                lblTipTaxFee.text = [NSString stringWithFormat:@"Tip,tax and fees: $%.2f",floatTipTaxFee];
            else
                lblTipTaxFee.text = [NSString stringWithFormat:@"Tip,tax and fees: -"];
            lblTipTaxFee.tag = 12347890;
            lblTipTaxFee.backgroundColor = [UIColor clearColor];
            lblTipTaxFee.textColor = [UIColor blackColor] ;
            lblTipTaxFee.textAlignment = NSTextAlignmentLeft;
            [viewPrice addSubview:lblTipTaxFee];
            [lblTipTaxFee release];
            
            UILabel *lblTotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(215, 0, 100, 30)];
            lblTotalPrice.font = [UIFont systemFontOfSize:11];
            if(0)//floatTotalPrice>0.01)
                lblTotalPrice.text = [NSString stringWithFormat:@"Total: $%.2f",floatTotalPrice];
            else
                lblTotalPrice.text = [NSString stringWithFormat:@"Total: -"];
            lblTotalPrice.tag = 12347890;
            lblTotalPrice.backgroundColor = [UIColor clearColor];
            lblTotalPrice.textColor = [UIColor blackColor] ;
            lblTotalPrice.textAlignment = NSTextAlignmentLeft;
            [viewPrice addSubview:lblTotalPrice];
            [lblTotalPrice release];
            
            [viewPrice release];
        }
        else if(isOrderTimeoutCell)
        {
            NSDictionary *dict=[arrOrdersTimedOut  objectAtIndex:0];
            //cell.textLabel.text=[dict objectForKey:@"itemName"];
            //[cell setUserInteractionEnabled:NO];
            
            UIView *viewBorder = [[UIView alloc]initWithFrame:CGRectMake(9, 5, 300, [arrOrdersTimedOut count]*70+160+70)];
            viewBorder.backgroundColor = [UIColor clearColor];
            viewBorder.layer.borderWidth = 1;
            viewBorder.layer.cornerRadius = 6;
            viewBorder.layer.borderColor = [UIColor grayColor].CGColor;
            viewBorder.layer.backgroundColor=[UIColor whiteColor].CGColor;
            viewBorder.tag = 101;
            [cell.contentView addSubview:viewBorder];
            [viewBorder release];
            
            UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(5, 10, 290, 48+20)];
            viewHeader.backgroundColor = [UIColor redColor];
            viewHeader.layer.cornerRadius = 6;
            viewHeader.tag = 11;
            [viewBorder addSubview:viewHeader];
            [viewHeader release];
            
            NSURL *urlPhoto=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Bartsy/userImages/%@",KServerURL,[dict objectForKey:@"recieverBartsyId"]]];
            UIImageView *imgViewPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(10,15,60,60)];
            [imgViewPhoto setImageWithURL:urlPhoto];
            [viewBorder addSubview:imgViewPhoto];
            [imgViewPhoto release];
            
            
            UILabel *lblOrderId = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 180, 40)];
            lblOrderId.font = [UIFont boldSystemFontOfSize:38];
            lblOrderId.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"orderId"]];
            lblOrderId.backgroundColor = [UIColor clearColor];
            lblOrderId.textColor = [UIColor whiteColor] ;
            lblOrderId.textAlignment = NSTextAlignmentLeft;
            [viewBorder addSubview:lblOrderId];
            [lblOrderId release];
            
            UIView *viewStatus = [[UIView alloc]initWithFrame:CGRectMake(5, 83, 290, 60)];
            viewStatus.backgroundColor = [UIColor whiteColor];
            viewStatus.layer.borderWidth = 1;
            viewStatus.layer.borderColor = [UIColor grayColor].CGColor;
            viewStatus.layer.cornerRadius = 6;
            [viewBorder addSubview:viewStatus];
            [viewStatus release];
            
            UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 40)];
            lblTitle.numberOfLines=3;
            lblTitle.font = [UIFont boldSystemFontOfSize:12];
            lblTitle.text=@"Something is wrong with this order. Please check with your bartender";
            lblTitle.tag = 1234;
            lblTitle.backgroundColor = [UIColor clearColor];
            lblTitle.textColor = [UIColor blackColor] ;
            lblTitle.textAlignment = NSTextAlignmentCenter;
            lblTitle.adjustsFontSizeToFitWidth=YES;
            [viewStatus addSubview:lblTitle];
            [lblTitle release];
            
            UIButton *btnGoToPastOrders=[self createUIButtonWithTitle:@"OK - save order(s) to past orders" image:nil frame:CGRectMake(5, 38, 280, 20) tag:0 selector:@selector(btnGoToPastOrders_TouchUpInside) target:self];
            btnGoToPastOrders.titleLabel.font=[UIFont systemFontOfSize:18];
            [btnGoToPastOrders setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
            btnGoToPastOrders.backgroundColor=[UIColor grayColor];
            [viewStatus addSubview:btnGoToPastOrders];
            
            UIView *viewDate = [[UIView alloc]initWithFrame:CGRectMake(5, 66+60+20, 290, 30)];
            viewDate.backgroundColor = [UIColor whiteColor];
            viewDate.layer.borderWidth = 1;
            viewDate.layer.borderColor = [UIColor grayColor].CGColor;
            viewDate.layer.cornerRadius = 6;
            viewDate.tag = 12;
            [viewBorder addSubview:viewDate];
            [viewDate release];
            
            NSDate *date=[dict objectForKey:@"Time"];
            
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"aa kk:mm 'on' EEEE MMMM d"];
            
            
            NSString *newDateString = [outputFormatter stringFromDate:date];
            
            NSMutableArray *arrDateComps=[[NSMutableArray alloc]initWithArray:[newDateString componentsSeparatedByString:@" "]];
            NSLog(@"newDateString %@", newDateString);
            
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
            
            NSString *strDate=[NSString stringWithFormat:@"Placed at: %@%i:%@%i:%@%i %@ on %@ %i,%i",(comps.hour<10? @"0" : @""),comps.hour,(comps.minute<10? @"0":@""),comps.minute,(comps.second<10? @"0":@""),comps.second,[arrDateComps objectAtIndex:0],[arrDateComps objectAtIndex:4],comps.day,comps.year];
            
            UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(7, 3, 280, 30)];
            lblTime.font = [UIFont systemFontOfSize:14];
            lblTime.text = strDate;
            lblTime.tag = 1234234567;
            lblTime.backgroundColor = [UIColor clearColor];
            lblTime.textColor = [UIColor blackColor] ;
            lblTime.textAlignment = NSTextAlignmentLeft;
            [viewDate addSubview:lblTime];
            [lblTime release];
            
            UIView *viewDescription = [[UIView alloc]initWithFrame:CGRectMake(5, 111+60+10, 290, [arrOrdersTimedOut count]*70)];
            viewDescription.backgroundColor = [UIColor whiteColor];
            viewDescription.layer.borderWidth = 1;
            viewDescription.layer.borderColor = [UIColor grayColor].CGColor;
            viewDescription.layer.cornerRadius = 6;
            viewDescription.tag = 13;
            [viewBorder addSubview:viewDescription];
            [viewDescription release];
            
            
            float floatPrice=0;
            float floatTotalPrice=0;
            float floatTipTaxFee=0;
            
            for (int i=0; i<[arrOrdersTimedOut count]; i++)
            {
                NSDictionary *dictTempOrder=[arrOrdersTimedOut objectAtIndex:i];
                
                
                
                UILabel *lblDescription1 = [[UILabel alloc]initWithFrame:CGRectMake(7, 1+(i*70), 242, 20)];
                lblDescription1.font = [UIFont boldSystemFontOfSize:14];
                lblDescription1.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"name"]];
                lblDescription1.tag = 1234234567;
                lblDescription1.numberOfLines = 1;
                lblDescription1.backgroundColor = [UIColor clearColor];
                lblDescription1.textColor = [UIColor blackColor] ;
                lblDescription1.textAlignment = NSTextAlignmentLeft;
                [viewDescription addSubview:lblDescription1];
                
                
                UILabel *lblDescription2 = [[UILabel alloc]initWithFrame:CGRectMake(7, 21+(i*70), 245, 40)];
                lblDescription2.font = [UIFont systemFontOfSize:14];
                lblDescription2.text = [NSString stringWithFormat:@"%@",[dictTempOrder objectForKey:@"description"]];
                lblDescription2.numberOfLines = 2;
                lblDescription2.tag = 12347890;
                lblDescription2.backgroundColor = [UIColor clearColor];
                lblDescription2.textColor = [UIColor blackColor] ;
                lblDescription2.textAlignment = NSTextAlignmentLeft;
                [viewDescription addSubview:lblDescription2];
                
                
                UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(248, 1+(i*70), 42, 20)];
                lblPrice.font = [UIFont systemFontOfSize:12];
                lblPrice.text = [NSString stringWithFormat:@"$%.2f",[[dictTempOrder objectForKey:@"price"] floatValue]];
                lblPrice.numberOfLines = 1;
                lblPrice.backgroundColor = [UIColor clearColor];
                lblPrice.textColor = [UIColor blackColor] ;
                lblPrice.textAlignment = NSTextAlignmentLeft;
                [viewDescription addSubview:lblPrice];
                
                
                if([[dictTempOrder objectForKey:@"senderBartsyId"]isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]])
                {
                    floatPrice+=[[dictTempOrder objectForKey:@"price"] floatValue];
                    
                    float subTotal=([[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]*(([[dict objectForKey:@"tipPercentage"] integerValue]+9)))/100;
                    
                    floatTotalPrice+=floatPrice+subTotal;
                    floatTipTaxFee+=subTotal;
                }
                else
                {
                    lblPrice.text=@"-";
                }
                
                [lblDescription1 release];
                [lblDescription2 release];
                [lblPrice release];
                
            }
            
            UIView *viewPrice = [[UIView alloc]initWithFrame:CGRectMake(5, 111+[arrOrdersTimedOut count]*70+15+60+10, 290, 30)];
            viewPrice.backgroundColor = [UIColor whiteColor];
            viewPrice.layer.borderWidth = 1;
            viewPrice.layer.borderColor = [UIColor grayColor].CGColor;
            viewPrice.layer.cornerRadius = 6;
            viewPrice.tag = 12;
            [viewBorder addSubview:viewPrice];
            
            
            UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, 82, 30)];
            lblPrice.font = [UIFont systemFontOfSize:11];
            if(floatPrice>0.01)
            lblPrice.text = [NSString stringWithFormat:@"Price: $%.2f",floatPrice];
            else
                lblPrice.text = [NSString stringWithFormat:@"Price: -"];
            lblPrice.tag = 12347890;
            lblPrice.backgroundColor = [UIColor clearColor];
            lblPrice.textColor = [UIColor blackColor] ;
            lblPrice.textAlignment = NSTextAlignmentLeft;
            [viewPrice addSubview:lblPrice];
            [lblPrice release];
            
            UILabel *lblTipTaxFee = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 130, 30)];
            lblTipTaxFee.font = [UIFont systemFontOfSize:11];
            if(floatTipTaxFee>0.01)
            lblTipTaxFee.text = [NSString stringWithFormat:@"Tip,tax and fees: $%.2f",floatTipTaxFee];
            else
            lblTipTaxFee.text = [NSString stringWithFormat:@"Tip,tax and fees: -"];   
            lblTipTaxFee.tag = 12347890;
            lblTipTaxFee.backgroundColor = [UIColor clearColor];
            lblTipTaxFee.textColor = [UIColor blackColor] ;
            lblTipTaxFee.textAlignment = NSTextAlignmentLeft;
            [viewPrice addSubview:lblTipTaxFee];
            [lblTipTaxFee release];
            
            UILabel *lblTotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(215, 0, 100, 30)];
            lblTotalPrice.font = [UIFont systemFontOfSize:11];
            if(floatTotalPrice>0.01)
            lblTotalPrice.text = [NSString stringWithFormat:@"Total: $%.2f",floatTotalPrice];
            else
                lblTotalPrice.text = [NSString stringWithFormat:@"Total: -"];
            lblTotalPrice.tag = 12347890;
            lblTotalPrice.backgroundColor = [UIColor clearColor];
            lblTotalPrice.textColor = [UIColor blackColor] ;
            lblTotalPrice.textAlignment = NSTextAlignmentLeft;
            [viewPrice addSubview:lblTotalPrice];
            [lblTotalPrice release];
            
            [viewPrice release];
        }
        else
        {
            cell.imageView.image=nil;
            [cell.textLabel setNumberOfLines:0];
            cell.textLabel.lineBreakMode =NSLineBreakByWordWrapping;
            cell.textLabel.text=@"No open orders\nGo to the drinks tab to place some\nGo to menu for Past Orders...";
        }
    }
    
    return cell;
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

-(void)btnOrderOffered_TouchUpInside:(UIButton*)sender
{
    if(sender.tag==321)
        [appDelegate updateOrderStatusForaOfferedDrink:@"8"]; //Rejected the Order
    else
        [appDelegate updateOrderStatusForaOfferedDrink:@"0"]; //Accepted the Order
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(isSelectedForDrinks)
    {
        if(dictPeopleSelectedForDrink!=nil)
        {
            [dictPeopleSelectedForDrink release];
            dictPeopleSelectedForDrink=nil;
        }
        id object=[arrMenu objectAtIndex:indexPath.section-1];
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
        
        for (int i=0; i<[arrPeople count]; i++)
        {
            NSDictionary *dictMember=[arrPeople objectAtIndex:i];
            if([[NSString stringWithFormat:@"%@",[dictMember objectForKey:@"bartsyId"]]isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]]])
            {
                dictTemp=[[NSMutableDictionary alloc] initWithDictionary:dictMember];
                break;
            }
        }
        
        
        UIImageView *imgViewPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(10,10,60,60)];
        NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictTemp objectForKey:@"userImagePath"]];
        NSLog(@"URL is %@",strURL);
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
        [viewC release];
    }
    else if(isSelectedForPeople)
    {
        
        PeopleDetailViewController *obj = [[PeopleDetailViewController alloc] init];
        obj.dictPeople = [arrPeople objectAtIndex:indexPath.section];
        [self.navigationController pushViewController:obj animated:YES];
        [obj release];
    }
    // Navigation logic may go here. Create and push another view controller.
}

-(void)btnPhoto_TouchUpInside
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PeopleSelected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedPeople:) name:@"PeopleSelected" object:nil];
    
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
    UILabel *lblName=(UILabel*)[self.view viewWithTag:111222333];
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
    [self btnOrder_TouchUpInside];
    
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
    NSInteger intTag=sender.tag-2;
    if(intTag>=0)
    {
        NSMutableDictionary *dict=[arrMenu objectAtIndex:intTag];
        BOOL boolArrow=!([[dict objectForKey:@"Arrow"] integerValue]);
        NSString *strArrow=[NSString stringWithFormat:@"%i",boolArrow];
        [dict setObject:strArrow forKey:@"Arrow"];
        [arrMenu replaceObjectAtIndex:intTag withObject:dict];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
