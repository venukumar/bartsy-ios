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
    btnBack.frame = CGRectMake(10, 11, 12, 20);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"arrow-left.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBack_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44,320,400) style:UITableViewStyleGrouped];
    
    if (IS_IPHONE_5) {
        tableView.frame = CGRectMake(0,44,320,500);
    }
    else
    {
        tableView.frame = CGRectMake(0,44,320,400);
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
    
    if (indexPath.section==2) {
        
        if (indexPath.row==1) {
            WebViewController *obj=[[WebViewController alloc]init];
            obj.strTitle=[NSString stringWithFormat:@"%@",[aryMsg objectAtIndex:indexPath.row]];
            obj.strHTMLPath=[NSString stringWithFormat:@"%i",3];
            [self.navigationController pushViewController:obj animated:YES];
            [obj release];
        }else if (indexPath.row==2){
            WebViewController *obj=[[WebViewController alloc]init];
            obj.strTitle=[NSString stringWithFormat:@"%@",[aryMsg objectAtIndex:indexPath.row]];
            obj.strHTMLPath=[NSString stringWithFormat:@"%i",4];
            [self.navigationController pushViewController:obj animated:YES];
            [obj release];
        }
        

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
