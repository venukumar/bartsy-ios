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
    self.title = @"Notifications";
    self.navigationController.navigationBarHidden=NO;
    self.sharedController=[SharedController sharedController];
    
    arrayForNotifications = [[NSMutableArray alloc] init];
    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 415)];
    tblView.dataSource=self;
    tblView.delegate=self;
    tblView.tag=111;
    [self.view addSubview:tblView];

	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.sharedController getNotificationsWithDelegate:self];
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
        if ([[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"checkin"]||[[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"checkout"])
        {
            NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"userImage"]];
            
            [cell.imageView setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [[cell.imageView layer] setShadowOffset:CGSizeMake(0, 1)];
            [[cell.imageView layer] setShadowColor:[[UIColor whiteColor] CGColor]];
            [[cell.imageView layer] setShadowRadius:3.0];
            [[cell.imageView layer] setShadowOpacity:0.8];
            
            UILabel *lblItemName = [self createLabelWithTitle:[[arrayForNotifications objectAtIndex:indexPath.row] objectForKey:@"message"] frame:CGRectMake(61, 0, 290, 40) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor blackColor] numberOfLines:2];
            lblItemName.backgroundColor=[UIColor clearColor];
            lblItemName.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblItemName];
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
    return 60;
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
