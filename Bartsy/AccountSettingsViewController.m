//
//  AccountSettingsViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 7/10/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "AccountSettingsViewController.h"
#import "Constants.h"

@interface AccountSettingsViewController ()

@end

@implementation AccountSettingsViewController

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
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    self.view.backgroundColor=[UIColor colorWithRed:0.09 green:0.09 blue:0.098 alpha:1.0];
    
    arySettings = [[NSMutableArray alloc]initWithObjects:@"Edit Profile",@"Privacy",@"Share Settings",@"Push Notifications",@"Log Out", nil];
    aryMsg = [[NSMutableArray alloc]initWithObjects:@"About",@"Privacy Policy",@"Terms of Service", nil];
    
    UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [self.view addSubview:imgViewForTop];
    [imgViewForTop release];
    
    UILabel *lblMsg=[self createLabelWithTitle:@"Account Settings" frame:CGRectMake(0, 0, 320, 44) tag:0 font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] numberOfLines:1];
    lblMsg.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblMsg];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(10, 0, 50, 40);
    [btnBack addTarget:self action:@selector(btnBack_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    UIImageView *imgViewBack = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 12, 20)];
    imgViewBack.image = [UIImage imageNamed:@"arrow-left"];
    [btnBack addSubview:imgViewBack];
    [imgViewBack release];

    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44,320,400) style:UITableViewStyleGrouped];
    
    if (IS_IPHONE_5) {
        tableView.frame = CGRectMake(0,44,320,364+100);
    }
    else
    {
        tableView.frame = CGRectMake(0,44,320,364);
    }
    tableView.tag=111;
    tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    tableView.backgroundColor = nil;
    tableView.backgroundView = nil;
	tableView.delegate=self;
	tableView.dataSource=self;
    tableView.backgroundColor=[UIColor colorWithRed:0.09 green:0.09 blue:0.098 alpha:1.0];
	[self.view addSubview:tableView];
    [tableView release];
}

-(void)btnBack_TouchUpInside
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-------------TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return [arySettings count];
    }
    else
        
        return [aryMsg count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *lblItemName;
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fathers_office-bg.png"]];
    cell.backgroundView = bg;
    [bg release];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    if(indexPath.section == 1 && indexPath.row == 4)
//    {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    else
//    {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
    
    //cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bar-bg.png"]];
    
//    UIImageView *imageViewBg = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 345, 58)] autorelease];
//    imageViewBg.backgroundColor = [UIColor clearColor];
//    imageViewBg.opaque = NO;
//    imageViewBg.image = [UIImage imageNamed:@"bar-bg.png"];
//    cell.backgroundView = imageViewBg;
    
    if(indexPath.section == 0)
    {
        lblItemName = [self createLabelWithTitle:@"Payment Information" frame:CGRectMake(10, 8, 250, 25) tag:0 font:[UIFont systemFontOfSize:15] color:[UIColor colorWithRed:192 green:188 blue:189 alpha:1.0] numberOfLines:1];
        lblItemName.backgroundColor=[UIColor clearColor];
        lblItemName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblItemName];
    }
    else if(indexPath.section == 1 )
    {
        lblItemName = [self createLabelWithTitle:[arySettings objectAtIndex:indexPath.row] frame:CGRectMake(10, 8, 250, 25) tag:0 font:[UIFont systemFontOfSize:15] color:[UIColor colorWithRed:192 green:188 blue:189 alpha:1.0] numberOfLines:1];
        lblItemName.backgroundColor=[UIColor clearColor];
        lblItemName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblItemName];
    }
    else if(indexPath.section == 2)
    {
        lblItemName = [self createLabelWithTitle:[aryMsg objectAtIndex:indexPath.row] frame:CGRectMake(10, 8, 250, 25) tag:0 font:[UIFont systemFontOfSize:15] color:[UIColor colorWithRed:192 green:188 blue:189 alpha:1.0] numberOfLines:1];
        lblItemName.backgroundColor=[UIColor clearColor];
        lblItemName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblItemName];
    }
    
    UIImageView *imgViewArrow=[[UIImageView alloc] initWithFrame:CGRectMake(268, 13, 13, 20)];
    UIImage *imgArrow = [UIImage imageNamed:@"listarrow.png"];
    imgViewArrow.image=imgArrow;
    [cell.contentView addSubview:imgViewArrow];
    [imgViewArrow release];

    return cell;
}

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView1 deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
      
        if (indexPath.row==0) {
            
            appDelegate.isLoginForFB=NO;
            ProfileViewController *profileScreen=[[ProfileViewController alloc]init];
            profileScreen.isCmgFromGetStarted=NO;
            profileScreen.isCmgForEditProfile=YES;
            [self.navigationController pushViewController:profileScreen animated:YES];
            [profileScreen release];
        }else if (indexPath.row==4){
            
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
    }else if (indexPath.section==2) {
        
        if (indexPath.row==1) {
            WebViewController *obj=[[WebViewController alloc]init];
            obj.viewtype=2;
            obj.strTitle=[NSString stringWithFormat:@"%@",[aryMsg objectAtIndex:indexPath.row]];
            obj.strHTMLPath=[NSString stringWithFormat:@"%i",3];
            [self.navigationController pushViewController:obj animated:YES];
            [obj release];
        }else if (indexPath.row==2){
            WebViewController *obj=[[WebViewController alloc]init];
            obj.viewtype=2;
            obj.strTitle=[NSString stringWithFormat:@"%@",[aryMsg objectAtIndex:indexPath.row]];
            obj.strHTMLPath=[NSString stringWithFormat:@"%i",4];
            [self.navigationController pushViewController:obj animated:YES];
            [obj release];
        }
        

    }
}

#pragma mark---------------AlertView Delegate
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
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"logOut" object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
