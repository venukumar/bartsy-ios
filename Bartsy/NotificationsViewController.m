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
    self.navigationController.navigationBarHidden=NO;
    self.sharedController=[SharedController sharedController];
    
    arrayForNotifications = [[NSMutableArray alloc] init];
    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 415)];
    if (IS_IPHONE_5)
    {
        tblView.frame = CGRectMake(0, 0, 320, 495);
    }
    tblView.dataSource=self;
    tblView.delegate=self;
    tblView.tag=111;
    [self.view addSubview:tblView];

	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]!=nil)
    {
        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        [self.sharedController getNotificationsWithDelegate:self];
    }
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
    
    if ([arrayForNotifications count])
    {
        if ([[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"checkin"]||[[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"checkout"]||[[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"orderType"]isEqualToString:@"self"])
        {
            NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"venueImage"]];
            
            [cell.imageView setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [[cell.imageView layer] setShadowOffset:CGSizeMake(0, 1)];
            [[cell.imageView layer] setShadowColor:[[UIColor whiteColor] CGColor]];
            [[cell.imageView layer] setShadowRadius:3.0];
            [[cell.imageView layer] setShadowOpacity:0.8];
            
            UILabel *lblVenueName = [self createLabelWithTitle:[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"venueName"] frame:CGRectMake(61, 5, 250, 20) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor grayColor] numberOfLines:1];
            lblVenueName.backgroundColor=[UIColor clearColor];
            lblVenueName.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblVenueName];
            //[lblVenueName release];
            
            UILabel *lblItemName = [self createLabelWithTitle:[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"message"] frame:CGRectMake(61,25,250,40) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor blackColor] numberOfLines:2];
            lblItemName.backgroundColor=[UIColor clearColor];
            lblItemName.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblItemName];
            //[lblItemName release];
            
            
            UILabel *lblDate = [self createLabelWithTitle:[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"createdTime"] frame:CGRectMake(61,65,250,20) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor blackColor] numberOfLines:1];
            lblDate.backgroundColor=[UIColor clearColor];
            lblDate.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblDate];
            //[lblDate release];
            
            
        }
        else if([[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"orderType"]isEqualToString:@"offer"])
        {
            NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"venueImage"]];
            
            [cell.imageView setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [[cell.imageView layer] setShadowOffset:CGSizeMake(0, 1)];
            [[cell.imageView layer] setShadowColor:[[UIColor whiteColor] CGColor]];
            [[cell.imageView layer] setShadowRadius:3.0];
            [[cell.imageView layer] setShadowOpacity:0.8];
            
            UILabel *lblVenueName = [self createLabelWithTitle:[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"venueName"] frame:CGRectMake(61, 5, 200, 20) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor grayColor] numberOfLines:1];
            lblVenueName.text=@"VenueName";
            lblVenueName.backgroundColor=[UIColor clearColor];
            lblVenueName.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblVenueName];
            //[lblVenueName release];
            
            UILabel *lblItemName = [self createLabelWithTitle:[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"message"] frame:CGRectMake(61,25,200,40) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor blackColor] numberOfLines:2];
            lblItemName.backgroundColor=[UIColor clearColor];
            lblItemName.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblItemName];
            //[lblItemName release];
            
            UILabel *lblDate = [self createLabelWithTitle:[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"createdTime"] frame:CGRectMake(61,65,200,20) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor blackColor] numberOfLines:1];
            lblDate.backgroundColor=[UIColor clearColor];
            lblDate.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblDate];
            //[lblDate release];
            
            NSString *strURL1=[NSString stringWithFormat:@"%@/%@",KServerURL,[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"recieverImage"]];

            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 0, 60, 60)];
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
    }
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        [arrayForNotifications addObjectsFromArray:[result objectForKey:@"notifications"]];
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
