//
//  NotificationsViewController.m
//  Bartsy
//
//  Created by Techvedika on 6/20/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "NotificationsViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
@interface NotificationsViewController ()

@end

@implementation NotificationsViewController
@synthesize arrayForNotifications;
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
    //self.title = @"Notifications";
    self.navigationController.navigationBarHidden = YES;
    self.sharedController=[SharedController sharedController];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    arrayForNotifications = [[NSMutableArray alloc] init];
        
    UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [self.view addSubview:imgViewForTop];
    [imgViewForTop release];
    
    UILabel *lblMsg=[self createLabelWithTitle:@"Notifications" frame:CGRectMake(0, 0, 320, 44) tag:0 font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] numberOfLines:1];
    lblMsg.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblMsg];
   /* UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(100.25, 13.25, 119.5, 23.5)];
    imgLogo.image=[UIImage imageNamed:@"logo_Header.png"];
    [self.view addSubview:imgLogo];
    [imgLogo release];*/
    
   /* UIButton *btnSearch = [self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"search_icon.png"] frame:CGRectMake(10, 14.5, 22, 21) tag:0 selector:@selector(btnSearch_TouchUpInside:) target:self];
    [self.view addSubview:btnSearch];*/

    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 367)];
    if (IS_IPHONE_5)
    {
        tblView.frame = CGRectMake(0, 44, 320, 455);
    }
    tblView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    tblView.backgroundColor = [UIColor blackColor];
    tblView.dataSource=self;
    tblView.delegate=self;
    tblView.tag=111;
    [self.view addSubview:tblView];

	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{

        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController getNotificationsWithDelegate:self];
    
}
-(void)btnSearch_TouchUpInside:(UIButton*)sender
{
    
}
#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if ([arrayForNotifications count]) {
        
        return [arrayForNotifications count];
    }
    else
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage            imageNamed:@"fathers_office-bg.png"]];
    
    if ([arrayForNotifications count])
    {
        if ([[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"bartsyId"]) {
            
            UILabel *lblnewmsg = [self createLabelWithTitle:[NSString stringWithFormat:@"You got a message from %@",[[arrayForNotifications objectAtIndex:indexPath.row] valueForKey:@"nickName"]] frame:CGRectMake(71, 15, 250, 20) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
            lblnewmsg.backgroundColor=[UIColor clearColor];
            lblnewmsg.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblnewmsg];
            
            NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"userImagePath"]];
            
            UIImageView *imageForPeople = [[UIImageView alloc]initWithFrame:CGRectMake(5, 18, 60, 60)];
            [imageForPeople setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [imageForPeople.layer setShadowColor:[[UIColor whiteColor] CGColor]];
            [imageForPeople.layer setShadowOffset:CGSizeMake(0, 1)];
            [imageForPeople.layer setShadowRadius:3.0];
            [imageForPeople.layer setShadowOpacity:0.8];
            [cell.contentView addSubview:imageForPeople];
            [imageForPeople release];

        }else if ([[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"checkin"]||[[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"checkout"]||[[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"orderType"]isEqualToString:@"self"])
        {
            NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"venueImage"]];
            
            UIImageView *imageForPeople = [[UIImageView alloc]initWithFrame:CGRectMake(5, 18, 60, 60)];
            [imageForPeople setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [imageForPeople.layer setShadowColor:[[UIColor whiteColor] CGColor]];
            [imageForPeople.layer setShadowOffset:CGSizeMake(0, 1)];
            [imageForPeople.layer setShadowRadius:3.0];
            [imageForPeople.layer setShadowOpacity:0.8];
            [cell.contentView addSubview:imageForPeople];
            [imageForPeople release];

            UILabel *lblVenueName = [self createLabelWithTitle:[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"venueName"] frame:CGRectMake(71, 5, 250, 20) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor grayColor] numberOfLines:1];
            lblVenueName.backgroundColor=[UIColor clearColor];
            lblVenueName.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblVenueName];
            //[lblVenueName release];
            
            UILabel *lblItemName = [self createLabelWithTitle:[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"message"] frame:CGRectMake(71,25,250,40) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:2];
            lblItemName.backgroundColor=[UIColor clearColor];
            lblItemName.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblItemName];
            //[lblItemName release];
            
            UILabel *lblDate = [self createLabelWithTitle:[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"createdTime"] frame:CGRectMake(71,65,250,20) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
            lblDate.backgroundColor=[UIColor clearColor];
            lblDate.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblDate];
            //[lblDate release];
            
        }
        else if([[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"orderType"]isEqualToString:@"offer"])
        {
            NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"venueImage"]];
            
            UIImageView *imageForPeople = [[UIImageView alloc]initWithFrame:CGRectMake(5, 18, 60, 60)];
            [imageForPeople setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [imageForPeople.layer setShadowColor:[[UIColor whiteColor] CGColor]];
            [imageForPeople.layer setShadowOffset:CGSizeMake(0, 1)];
            [imageForPeople.layer setShadowRadius:3.0];
            [imageForPeople.layer setShadowOpacity:0.8];
            [cell.contentView addSubview:imageForPeople];
            [imageForPeople release];

            UILabel *lblVenueName = [self createLabelWithTitle:[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"venueName"] frame:CGRectMake(71, 5, 200, 20) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
            //lblVenueName.text=@"VenueName";
            lblVenueName.backgroundColor=[UIColor clearColor];
            lblVenueName.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblVenueName];
            //[lblVenueName release];
            
            UILabel *lblItemName = [self createLabelWithTitle:[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"message"] frame:CGRectMake(71,25,200,40) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:2];
            lblItemName.backgroundColor=[UIColor clearColor];
            lblItemName.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblItemName];
            //[lblItemName release];
            
            UILabel *lblDate = [self createLabelWithTitle:[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"createdTime"] frame:CGRectMake(71,65,200,20) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
            lblDate.backgroundColor=[UIColor clearColor];
            lblDate.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblDate];
            //[lblDate release];
            
            NSString *strURL1=[NSString stringWithFormat:@"%@/%@",KServerURL,[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"recieverImage"]];

            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 18, 60, 60)];
            [imgView setImageWithURL:[NSURL URLWithString:[strURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [[imgView layer] setShadowOffset:CGSizeMake(0, 1)];
            [[imgView layer] setShadowColor:[[UIColor whiteColor] CGColor]];
            [[imgView layer] setShadowRadius:3.0];
            [[imgView layer] setShadowOpacity:0.8];
            [cell.contentView addSubview:imgView];
        }
    }
    else
    {
        cell.textLabel.text=@"No Notifications";
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    }
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]==nil)
        return;
        
    if ([[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"bartsyId"]) {
        
       appDelegate.isComingForPeople=YES;
        
        if(appDelegate.tabBar.selectedIndex==0)
        {
            [appDelegate.delegateForCurrentViewController viewWillAppear:YES];
        }
        else
        {
            [appDelegate.tabBar setSelectedIndex:0];
            [appDelegate.delegateForCurrentViewController viewWillAppear:YES];
        }
        


    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 100;
}
-(void)reloadTable
{
    UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
    [tblView reloadData];
}
#pragma mark- Shared controller delegates

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    [self hideProgressView:nil];
    
    if ([[result objectForKey:@"errorCode"] integerValue]!=0)
    {
        [self createAlertViewWithTitle:@"Error" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];

    }
    else if ([[result objectForKey:@"notifications"] count])
    {
        [arrayForNotifications removeAllObjects];
        [arrayForNotifications addObjectsFromArray:[result objectForKey:@"notifications"]];
           // NSLog(@"people array %@",appDelegate.arrPeople);
        int i=0;
        for (NSDictionary *dic in appDelegate.arrPeople) {
        
            if ([[dic valueForKey:@"hasMessages"] isEqualToString:@"New"]) {
                
                    [arrayForNotifications insertObject:dic atIndex:i];
                    i++;
            }
        }
            
        NSLog(@"notifications is %@",arrayForNotifications);
        UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
        [tblView reloadData];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reloadTable) userInfo:nil repeats:NO];
    }
}
-(void)controllerDidFailLoadingWithError:(NSError*)error;
{
    [self hideProgressView:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
