//
//  HomeViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 01/05/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "HomeViewController.h"
#define IS_SANDBOX YES

@interface HomeViewController ()
{
    NSMutableArray *arrMenu;
}

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    arrMenu=[[NSMutableArray alloc]init];
    
    self.sharedController=[SharedController sharedController];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"MenuList"]count]==0)
    {
        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController getMenuListWithDelegate:self];
    }
    else
    {
        [self modifyData];
    }
    
    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    tblView.dataSource=self;
    tblView.delegate=self;
    tblView.tag=111;
    [self.view addSubview:tblView];
    [tblView release];
    
    //optional pre init, so the ZooZ screen will upload immediatly, you can skip this call
    ZooZ * zooz = [ZooZ sharedInstance];
    [zooz preInitialize:@"c7659586-f78a-4876-b317-1b617ec8ab40" isSandboxEnv:IS_SANDBOX];
    
}

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"MenuList"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [arrMenu addObjectsFromArray:result];
    [self hideProgressView:nil];
    
    [self modifyData];    

}

-(void)controllerDidFailLoadingWithError:(NSError*)error
{
    [self hideProgressView:nil];
    
}

-(void)modifyData
{
    NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
    NSMutableArray *arrContents=[[NSMutableArray alloc]init];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"MenuList"])
    {
        [arrMenu removeAllObjects];
        [arrMenu addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"MenuList"]];
    }
    
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
            
            [arrTemp insertObject:arrContents atIndex:0];
        }
    }
    
    for (int i=0; i<[arrMenu count]; i++)
    {
        NSDictionary *dict=[arrMenu objectAtIndex:i];
        if([[dict objectForKey:@"section_name"] length]!=0)
        {
            NSMutableArray *arrSubsections=[dict objectForKey:@"subsections"];
            
            for (int j=0; j<[arrSubsections count]; j++)
            {
                NSMutableDictionary *dictSubsection=[[NSMutableDictionary alloc]initWithDictionary:[arrSubsections objectAtIndex:j]];
                [dictSubsection setObject:[dict objectForKey:@"section_name"] forKey:@"section_name"];
                [dictSubsection setObject:@"0" forKey:@"Arrow"];
                [arrTemp addObject:dictSubsection];
                [dictSubsection release];
            }
        }
    }
    
    [arrMenu removeAllObjects];
    [arrMenu addObjectsFromArray:arrTemp];
    [arrTemp release];
    
    UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
    [tblView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [arrMenu count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0&&[[arrMenu objectAtIndex:section] isKindOfClass:[NSArray class]])
    {
        return 0;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id object=[arrMenu objectAtIndex:section];

    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIImageView *headerBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sectionBg.png"]];
    [headerView addSubview:headerBg];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 7, 600, 44);
    button.tag=section +1;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if([[object objectForKey:@"Arrow"] integerValue]==0)
    {
        [button setImage:[UIImage imageNamed:@"disclosure.png"] forState:UIControlStateNormal];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"shrink.png"] forState:UIControlStateNormal];
    }
    [headerView addSubview:button];
    
    UILabel *headerTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 7, 300, 30)];
    [headerTitle setBackgroundColor:[UIColor clearColor]];
    [headerTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [headerTitle setTextColor:[UIColor blackColor]];
    if(section==0&&[object isKindOfClass:[NSArray class]])
    {
        headerTitle.text= @"";
    }
    else
        headerTitle.text= [NSString stringWithFormat:@"%@->%@",[object objectForKey:@"section_name"],[object objectForKey:@"subsection_name"]];
    
    [headerView addSubview:headerTitle];
    
    return headerView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id object=[arrMenu objectAtIndex:section];
    if(section==0&&[object isKindOfClass:[NSArray class]])
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    UIImageView *imgViewDrink=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 70, 70)];
    imgViewDrink.image=[UIImage imageNamed:@"drinks.png"];
    [[imgViewDrink layer] setShadowOffset:CGSizeMake(0, 1)];
    [[imgViewDrink layer] setShadowColor:[[UIColor grayColor] CGColor]];
    [[imgViewDrink layer] setShadowRadius:3.0];
    [[imgViewDrink layer] setShadowOpacity:0.8];
    [cell.contentView addSubview:imgViewDrink];
    [imgViewDrink release];
    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, 220, 20)];    
    id object=[arrMenu objectAtIndex:indexPath.section];
    if(indexPath.section==0&&[object isKindOfClass:[NSArray class]])
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
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Navigation logic may go here. Create and push another view controller.
    UIView *viewA=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    viewA.backgroundColor=[UIColor clearColor];
    viewA.tag=222;
    [self.view addSubview:viewA];
    
    UIView *viewB=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    viewB.backgroundColor=[UIColor blackColor];
    viewB.layer.opacity=0.4;
    viewB.tag=333;
    [viewA addSubview:viewB];
    
    UIView *viewC=[[UIView alloc]initWithFrame:CGRectMake(20, 80, 280, 300)];
    viewC.layer.cornerRadius=2;
    viewC.layer.borderWidth=2;
    viewC.layer.borderColor=[UIColor redColor].CGColor;
    viewC.tag=444;
    
    
    [viewB addSubview:viewC];
    
    [self orderTheDrink];
    
}

-(void)buttonClicked:(UIButton*)sender
{
    NSInteger intTag=sender.tag-1;
    NSMutableDictionary *dict=[arrMenu objectAtIndex:intTag];
    BOOL boolArrow=!([[dict objectForKey:@"Arrow"] integerValue]);
    NSString *strArrow=[NSString stringWithFormat:@"%i",boolArrow];
    [dict setObject:strArrow forKey:@"Arrow"];
    [arrMenu replaceObjectAtIndex:intTag withObject:dict];
    UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
    [tblView reloadData];
}

-(void)orderTheDrink
{
    ZooZ * zooz = [ZooZ sharedInstance];
    
    zooz.sandbox = IS_SANDBOX;
    
    zooz.tintColor = [UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
    
    zooz.barButtonTintColor = [UIColor darkGrayColor];
    
    //optional image that will be displayed on the NavigationBar as your logo
    //    zooz.barTitleImage = [UIImage imageNamed:@"MyLogo.png"];
    
    ZooZPaymentRequest * req = [zooz createPaymentRequestWithTotal:12.1 invoiceRefNumber:@"test invoice ref-1234" delegate:self];
    
    /*
     //If you want only to allow regsiter cards and not do payment use this instead of the above:
     ZooZPaymentRequest * req = [zooz createManageFundSourcesRequestWithDelegate:self];
     */
    
    req.currencyCode = @"USD";
    
    req.payerDetails.firstName = @"Some";
    
    req.payerDetails.email = @"test@zooz.com";
    
    req.payerDetails.billingAddress.zipCode=@"01234";
    
    req.requireAddress = YES; //set if to ask for zip code or not from the payer.
    
    ZooZInvoiceItem * item = [ZooZInvoiceItem invoiceItem:12.1 quantity:1 name:@"Drink"];
    item.additionalDetails = @"Had a drink with Bartsy";
    item.itemId = @"refId-12345678"; // optional
    
    [req addItem:item];
    
    req.invoice.additionalDetails = @"Bartsy Drink";
    
    [zooz openPayment:req forAppKey:@"c7659586-f78a-4876-b317-1b617ec8ab40"];
}

- (void)openPaymentRequestFailed:(ZooZPaymentRequest *)request withErrorCode:(int)errorCode andErrorMessage:(NSString *)errorMessage{
	NSLog(@"failed: %@", errorMessage);
    //this is a network / integration failure, not a payment processing failure.
	
}

//Called in the background thread - before user closes the payment dialog
//Do not refresh UI at this callback - see paymentSuccessDialogClosed
- (void)paymentSuccessWithResponse:(ZooZPaymentResponse *)response{
    
	NSLog(@"payment success with payment Id: %@, %@, %@, %f %@", response.transactionDisplayID, response.fundSourceType, response.lastFourDigits, response.paidAmount, response.transactionID);
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
