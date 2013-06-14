//
//  PastOrdersViewController.m
//  Bartsy
//
//  Created by Techvedika on 6/12/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "PastOrdersViewController.h"
@interface PastOrdersViewController ()

@end

@implementation PastOrdersViewController
@synthesize arrayForPastOrders;
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
    self.title = @"My Orders";
    self.navigationController.navigationBarHidden=NO;
    self.sharedController=[SharedController sharedController];
    
    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 415)];
    tblView.dataSource=self;
    tblView.delegate=self;
    tblView.tag=111;
    [self.view addSubview:tblView];

	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.delegateForCurrentViewController=self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [arrayForPastOrders count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  
//    cell.textLabel.text = [[arrayForPastOrders objectAtIndex:indexPath.row] objectForKey:@"itemName"];
//    cell.textLabel.text = @"dgjdflgjfl;dkgdlf;kg;dflkg;dfkgf;dkgdf;kg;dfkg;dfkg;dfkgdfjglkdjfgljdfkgldfjg";
//    cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
//    cell.textLabel.frame = CGRectMake(5, 0, 260, 40);
//    cell.detailTextLabel.text = [[arrayForPastOrders objectAtIndex:indexPath.row] objectForKey:@"description"];
//    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:11];
    
    UILabel *lblItemName = [self createLabelWithTitle:[[arrayForPastOrders objectAtIndex:indexPath.row] objectForKey:@"itemName"] frame:CGRectMake(10, 0, 250, 40) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor blackColor] numberOfLines:1];
    lblItemName.backgroundColor=[UIColor clearColor];
    lblItemName.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:lblItemName];
    
    UILabel *lbldescription = [self createLabelWithTitle:[[arrayForPastOrders objectAtIndex:indexPath.row] objectForKey:@"description"] frame:CGRectMake(10, 25, 250, 40) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor grayColor] numberOfLines:1];
    lbldescription.backgroundColor=[UIColor clearColor];
    lbldescription.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:lbldescription];


    NSString *stringFortotalPrice = [NSString stringWithFormat:@"%.2f",[[[arrayForPastOrders objectAtIndex:indexPath.row] objectForKey:@"totalPrice"] floatValue]];
    
    UILabel *lblTotalPrice = [self createLabelWithTitle:stringFortotalPrice frame:CGRectMake(270, 0, 200, 40) tag:0 font:[UIFont boldSystemFontOfSize:11] color:[UIColor blackColor] numberOfLines:1];
    lblTotalPrice.backgroundColor=[UIColor clearColor];
    lblTotalPrice.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:lblTotalPrice];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 65;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end