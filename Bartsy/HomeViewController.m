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
@synthesize dictVenue;

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
    
   
    // Do any additional setup after loading the view, typically from a nib.
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.delegateForCurrentViewController=self;
    
    arrMenu=[[NSMutableArray alloc]init];
    arrOrders=[[NSMutableArray alloc]init];
    arrPeople=[[NSMutableArray alloc]init];
    arrBundledOrders=[[NSMutableArray alloc]init];
    arrPastOrders=[[NSMutableArray alloc]init];
    arrStatus=[[NSArray alloc]initWithObjects:@"Accepted",@"Ready for pickup",@"Order is picked up",@"Order is picked up", nil];
    
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
    
}


-(void)reloadData
{
    UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
    
    if(appDelegate.isComingForOrders==YES)
    {
        appDelegate.isComingForOrders=NO;
        [segmentControl setSelectedSegmentIndex:2];
        [self segmentControl_ValueChanged:segmentControl];
    }
    else if(segmentControl.selectedSegmentIndex==2)
    {
        [arrOrders removeAllObjects];
        [arrOrders addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"Orders"]];
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
    [self createProgressViewToParentView:self.view withTitle:@"Sending Order details to Bartender..."];
    NSString *strBasePrice=[NSString stringWithFormat:@"%f",[[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]];
    
    NSString *strTip;
    if(btnValue!=40)
        strTip=[NSString stringWithFormat:@"%i",btnValue];
    else
    {
        UITextField *txtFld=(UITextField*)[self.view viewWithTag:500];
        strTip=[NSString stringWithFormat:@"%i",[txtFld.text integerValue]];
    }
    
    
    float subTotal=([[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]*(([strTip floatValue]+8)))/100;
    float totalPrice=[[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]+subTotal;
    
    NSString *strTotalPrice1=[NSString stringWithFormat:@"%.2f",totalPrice];
    
    NSString *strBartsyId=@"2342352565346";
    
    
    [self.sharedController createOrderWithOrderStatus:@"New" basePrice:strBasePrice totalPrice:strTotalPrice1 tipPercentage:strTip itemName:[dictSelectedToMakeOrder objectForKey:@"name"] produceId:[dictSelectedToMakeOrder objectForKey:@"id"] description:[dictSelectedToMakeOrder objectForKey:@"description"] receiverBartsyId:strBartsyId delegate:self];
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
    }
    else if(isRequestForPeople==YES)
    {
        isSelectedForDrinks=NO;
        isSelectedForPeople=YES;
        [arrPeople removeAllObjects];
        [arrPeople addObjectsFromArray:[result objectForKey:@"checkedInUsers"]];
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        [tblView reloadData];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reloadTable) userInfo:nil repeats:NO];
        
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
        NSLog(@"past orders is %@",arrPastOrders);
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        [tblView reloadData];

    }
    else if(isRequestForGettingsOrders==YES)
    {
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
            }
            
        }
         
        
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
        
        UISegmentedControl *segmentControl=(UISegmentedControl*)[self.view viewWithTag:1111];
        NSString *strOrder=[NSString stringWithFormat:@"ORDERS (%i)",[arrOrders count]];
        [segmentControl setTitle:strOrder forSegmentAtIndex:2];
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
        if([arrBundledOrders count])
        {
            return [arrBundledOrders count];
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
        return [arrPastOrders count];
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
        return 65;
    }
    else
    {
        if([arrBundledOrders count])
        {
            return [[arrBundledOrders objectAtIndex:indexPath.section] count]*70+170;
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
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    if(isSelectedForDrinks==YES)
    {
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
        [cell setUserInteractionEnabled:NO];
        
        NSDictionary *dictPeople=[arrPeople objectAtIndex:indexPath.section];
        
        NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictPeople objectForKey:@"userImagePath"]];
        [cell.imageView setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [[cell.imageView layer] setShadowOffset:CGSizeMake(0, 1)];
        [[cell.imageView layer] setShadowColor:[[UIColor whiteColor] CGColor]];
        [[cell.imageView layer] setShadowRadius:3.0];
        [[cell.imageView layer] setShadowOpacity:0.8];
        
        cell.textLabel.text=[dictPeople objectForKey:@"nickName"];
        cell.detailTextLabel.text=[dictPeople objectForKey:@"gender"];
    }
    else if (isSelectedForPastOrders == YES)
    {
        UILabel *lblItemName = [self createLabelWithTitle:[[arrPastOrders objectAtIndex:indexPath.row] objectForKey:@"itemName"] frame:CGRectMake(10, 0, 250, 40) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor blackColor] numberOfLines:1];
        lblItemName.backgroundColor=[UIColor clearColor];
        lblItemName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblItemName];
        
        UILabel *lbldescription = [self createLabelWithTitle:[[arrPastOrders objectAtIndex:indexPath.row] objectForKey:@"description"] frame:CGRectMake(10, 25, 250, 40) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor grayColor] numberOfLines:1];
        lbldescription.backgroundColor=[UIColor clearColor];
        lbldescription.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbldescription];
        NSString *stringFortotalPrice = [NSString stringWithFormat:@"%.2f",[[[arrPastOrders objectAtIndex:indexPath.row] objectForKey:@"totalPrice"] floatValue]];
        
        UILabel *lblTotalPrice = [self createLabelWithTitle:stringFortotalPrice frame:CGRectMake(270, -5, 200, 40) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor blackColor] numberOfLines:1];
        lblTotalPrice.backgroundColor=[UIColor clearColor];
        lblTotalPrice.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblTotalPrice];
    }
    else
    {
        if([arrBundledOrders count])
        {
            NSDictionary *dict=[[arrBundledOrders objectAtIndex:indexPath.section] lastObject];
            //cell.textLabel.text=[dict objectForKey:@"itemName"];
            [cell setUserInteractionEnabled:NO];
            
            UIView *viewBorder = [[UIView alloc]initWithFrame:CGRectMake(9, 5, 300, [[arrBundledOrders objectAtIndex:indexPath.section] count]*70+160)];
            viewBorder.backgroundColor = [UIColor clearColor];
            viewBorder.layer.borderWidth = 1;
            viewBorder.layer.cornerRadius = 6;
            viewBorder.layer.borderColor = [UIColor grayColor].CGColor;
            viewBorder.layer.backgroundColor=[UIColor whiteColor].CGColor;
            viewBorder.tag = 101;
            [cell.contentView addSubview:viewBorder];
            [viewBorder release];
            
            UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(5, 10, 290, 43)];
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
            
            UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 7, 280, 30)];
            lblTitle.font = [UIFont boldSystemFontOfSize:15];
            if([[dict objectForKey:@"orderStatus"] isEqualToString:@"0"])
                lblTitle.text = [NSString stringWithFormat:@"Waiting for bartender to accept (%i)",[[dict objectForKey:@"orderId"] integerValue]];
            else
                lblTitle.text = [NSString stringWithFormat:@"%@ with number %i",[arrStatus objectAtIndex:[[dict objectForKey:@"orderStatus"] integerValue]-2],[[dict objectForKey:@"orderId"] integerValue]];
            
            lblTitle.tag = 1234;
            lblTitle.backgroundColor = [UIColor clearColor];
            lblTitle.textColor = [UIColor whiteColor] ;
            lblTitle.textAlignment = NSTextAlignmentCenter;
            lblTitle.adjustsFontSizeToFitWidth=YES;
            [viewHeader addSubview:lblTitle];
            [lblTitle release];
            
            UIView *viewDate = [[UIView alloc]initWithFrame:CGRectMake(5, 66, 290, 30)];
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
            
            NSArray *arrDateComps=[newDateString componentsSeparatedByString:@" "];
            NSLog(@"newDateString %@", newDateString);
            
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
            
            /*
            UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(7, 33, 280, 30)];
            lblPrice.font = [UIFont systemFontOfSize:14];
            lblPrice.text = [NSString stringWithFormat:@"Price: $%@",[dict objectForKey:@"totalPrice"]];
            lblPrice.tag = 12347890;
            lblPrice.backgroundColor = [UIColor clearColor];
            lblTime.textColor = [UIColor blackColor] ;
            lblPrice.textAlignment = NSTextAlignmentLeft;
            [viewPrice addSubview:lblPrice];
            [lblPrice release];
            */
            
            UIView *viewDescription = [[UIView alloc]initWithFrame:CGRectMake(5, 111, 290, [[arrBundledOrders objectAtIndex:indexPath.section] count]*70)];
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
                NSDictionary *dictTemp=[arrSubSectionOrders objectAtIndex:i];
                
                floatPrice+=[[dictTemp objectForKey:@"basePrice"] floatValue];
                floatTotalPrice+=[[dictTemp objectForKey:@"totalPrice"]floatValue];
                floatTipTaxFee+=[[dictTemp objectForKey:@"totalPrice"]floatValue]-[[dictTemp objectForKey:@"basePrice"]floatValue];
                
                UILabel *lblDescription1 = [[UILabel alloc]initWithFrame:CGRectMake(7, 1+(i*70), 242, 20)];
                lblDescription1.font = [UIFont boldSystemFontOfSize:14];
                lblDescription1.text = [NSString stringWithFormat:@"%@",[dictTemp objectForKey:@"itemName"]];
                lblDescription1.tag = 1234234567;
                lblDescription1.numberOfLines = 1;
                lblDescription1.backgroundColor = [UIColor clearColor];
                lblDescription1.textColor = [UIColor blackColor] ;
                lblDescription1.textAlignment = NSTextAlignmentLeft;
                [viewDescription addSubview:lblDescription1];
                [lblDescription1 release];
                
                UILabel *lblDescription2 = [[UILabel alloc]initWithFrame:CGRectMake(7, 21+(i*70), 245, 40)];
                lblDescription2.font = [UIFont systemFontOfSize:14];
                lblDescription2.text = [NSString stringWithFormat:@"%@",[dictTemp objectForKey:@"description"]];
                lblDescription2.numberOfLines = 2;
                lblDescription2.tag = 12347890;
                lblDescription2.backgroundColor = [UIColor clearColor];
                lblDescription2.textColor = [UIColor blackColor] ;
                lblDescription2.textAlignment = NSTextAlignmentLeft;
                [viewDescription addSubview:lblDescription2];
                [lblDescription2 release];
                
                UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(248, 1+(i*70), 42, 20)];
                lblPrice.font = [UIFont systemFontOfSize:12];
                lblPrice.text = [NSString stringWithFormat:@"$%.2f",[[dictTemp objectForKey:@"basePrice"] floatValue]];
                lblPrice.numberOfLines = 1;
                lblPrice.backgroundColor = [UIColor clearColor];
                lblPrice.textColor = [UIColor blackColor] ;
                lblPrice.textAlignment = NSTextAlignmentLeft;
                [viewDescription addSubview:lblPrice];
                [lblPrice release];

            }
            
            UIView *viewPrice = [[UIView alloc]initWithFrame:CGRectMake(5, 111+[[arrBundledOrders objectAtIndex:indexPath.section] count]*70+15, 290, 30)];
            viewPrice.backgroundColor = [UIColor whiteColor];
            viewPrice.layer.borderWidth = 1;
            viewPrice.layer.borderColor = [UIColor grayColor].CGColor;
            viewPrice.layer.cornerRadius = 6;
            viewPrice.tag = 12;
            [viewBorder addSubview:viewPrice];
            
            
            UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, 82, 30)];
            lblPrice.font = [UIFont systemFontOfSize:11];
            lblPrice.text = [NSString stringWithFormat:@"Price: $%.2f",floatPrice];
            lblPrice.tag = 12347890;
            lblPrice.backgroundColor = [UIColor clearColor];
            lblPrice.textColor = [UIColor blackColor] ;
            lblPrice.textAlignment = NSTextAlignmentLeft;
            [viewPrice addSubview:lblPrice];
            [lblPrice release];
            
            UILabel *lblTipTaxFee = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 130, 30)];
            lblTipTaxFee.font = [UIFont systemFontOfSize:11];
            lblTipTaxFee.text = [NSString stringWithFormat:@"Tip,tax and fees: $%.2f",floatTipTaxFee];
            lblTipTaxFee.tag = 12347890;
            lblTipTaxFee.backgroundColor = [UIColor clearColor];
            lblTipTaxFee.textColor = [UIColor blackColor] ;
            lblTipTaxFee.textAlignment = NSTextAlignmentLeft;
            [viewPrice addSubview:lblTipTaxFee];
            [lblTipTaxFee release];
            
            UILabel *lblTotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(215, 0, 100, 30)];
            lblTotalPrice.font = [UIFont systemFontOfSize:11];
            lblTotalPrice.text = [NSString stringWithFormat:@"Total: $%.2f",floatTotalPrice];
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
            cell.textLabel.text=@"No open orders\nGo to the drinks tab to place some\nGo to menu for Past Orders...";
            cell.textLabel.numberOfLines=5;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(isSelectedForDrinks)
    {
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
        
        UIView *viewA=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        viewA.backgroundColor=[UIColor clearColor];
        viewA.tag=222;
        [self.view addSubview:viewA];
        
        UIView *viewB=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        viewB.backgroundColor=[UIColor blackColor];
        viewB.layer.opacity=0.6;
        viewB.tag=333;
        [viewA addSubview:viewB];
        
        UIView *viewC = [[UIView alloc]initWithFrame:CGRectMake(12, 50, 295, 328)];
        viewC.layer.cornerRadius = 2;
        viewC.layer.borderWidth = 2;
        viewC.backgroundColor = [UIColor redColor];
        viewC.layer.borderColor = [UIColor redColor].CGColor;
        viewC.layer.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
        viewC.tag=444;
        [viewB addSubview:viewC];
        
        UIView *viewHeaderPhoto = [[UIView alloc]initWithFrame:CGRectMake(11, 5, 268, 60)];
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
        
        
        UIImageView *imgViewPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(10,5,50,50)];
        NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictTemp objectForKey:@"userImagePath"]];
        NSLog(@"URL is %@",strURL);
        [imgViewPhoto setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]]]];
        imgViewPhoto.tag=143225;
        //[imgViewPhoto setImageWithURL:[NSURL URLWithString:strURL]];
        [viewHeaderPhoto addSubview:imgViewPhoto];
        [imgViewPhoto release];
        
        
        UIButton *btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPhoto.frame = CGRectMake(10,5,105,50);
        [btnPhoto addTarget:self action:@selector(btnPhoto_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        btnPhoto.backgroundColor=[UIColor clearColor];
        [viewHeaderPhoto addSubview:btnPhoto];
        
        [viewHeaderPhoto release];

        
        UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(11, 70, 268, 45)];
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
        
        UIView *viewDetail = [[UIView alloc]initWithFrame:CGRectMake(11, 123, 200, 100)];
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
        
        UITextView *txtViewNotes = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, 185, 50)];
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
        [viewDetail addSubview:btnCustomise];
        
        UIView *viewPrice = [[UIView alloc]initWithFrame:CGRectMake(216, 123, 63, 100)];
        viewPrice.backgroundColor = [UIColor whiteColor];
        viewPrice.layer.borderWidth = 1;
        viewPrice.layer.borderColor = [UIColor grayColor].CGColor;
        viewPrice.layer.cornerRadius = 6;
        viewPrice.tag = 888;
        [viewC addSubview:viewPrice];
        [viewPrice release];
        
        UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 63, 30)];
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
        
        UIView *viewTip = [[UIView alloc]initWithFrame:CGRectMake(11, 231, 268, 45)];
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
        [btn10 setBackgroundImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
        [btn10 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [viewTip addSubview:btn10];
        
        btnValue=btn10.tag;
        
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
        
        UILabel *lbl15 = [[UILabel alloc]initWithFrame:CGRectMake(113, 7, 30, 30)];
        lbl15.font = [UIFont boldSystemFontOfSize:12];
        lbl15.text = @"15%";
        lbl15.backgroundColor = [UIColor clearColor];
        lbl15.textColor = [UIColor blackColor] ;
        lbl15.textAlignment = NSTextAlignmentCenter;
        [viewTip addSubview:lbl15];
        [lbl15 release];
        
        UIButton *btn30 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn30.frame = CGRectMake(143,10,23,23);
        [btn30 setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
        btn30.tag = 20;
        [btn30 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [viewTip addSubview:btn30];
        
        UILabel *lbl20 = [[UILabel alloc]initWithFrame:CGRectMake(170, 7, 30, 30)];
        lbl20.font = [UIFont boldSystemFontOfSize:12];
        lbl20.text = @"20%";
        lbl20.backgroundColor = [UIColor clearColor];
        lbl20.textColor = [UIColor blackColor] ;
        lbl20.textAlignment = NSTextAlignmentCenter;
        [viewTip addSubview:lbl20];
        [lbl20 release];
        
        UIButton *btn40 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn40.frame = CGRectMake(200,10,23,23);
        [btn40 setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
        btn40.tag = 40;
        [btn40 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [viewTip addSubview:btn40];
        
        UITextField *txtFieldTip = [[UITextField alloc] initWithFrame:CGRectMake(223,7, 40, 30)];
        [txtFieldTip setBackground:[UIImage imageNamed:@"txt-box1.png"]];
        txtFieldTip.delegate = self;
        txtFieldTip.tag = 500;
        txtFieldTip.font = [UIFont boldSystemFontOfSize:12];
        txtFieldTip.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtFieldTip.textAlignment = NSTextAlignmentCenter;
        txtFieldTip.autocorrectionType = UITextAutocorrectionTypeNo;
        [viewTip addSubview:txtFieldTip];
        [txtFieldTip release];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame = CGRectMake(148,287,120,30);
        btnCancel.titleLabel.textColor = [UIColor whiteColor];
        [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        btnCancel.backgroundColor=[UIColor blackColor];
        [btnCancel addTarget:self action:@selector(btnCancel_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [viewC addSubview:btnCancel];
        
        UIButton *btnOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        btnOrder.frame = CGRectMake(20,287,115,30);
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
    // Navigation logic may go here. Create and push another view controller.
}

-(void)btnPhoto_TouchUpInside
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
    float subTotal=([[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]*(([strTip floatValue]+8)))/100;
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
