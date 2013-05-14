//
//  VenueListViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 14/05/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "VenueListViewController.h"
#import "HomeViewController.h"

@interface VenueListViewController ()

@end

@implementation VenueListViewController

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
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    self.title=@"Bartsy Service Stations";
    
    arrVenueList=[[NSMutableArray alloc]init];
    
    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 416)];
    tblView.dataSource=self;
    tblView.delegate=self;
    tblView.tag=111;
    [self.view addSubview:tblView];
    [tblView release];
    
    self.sharedController=[SharedController sharedController];
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    [self.sharedController getVenueListWithDelegate:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrVenueList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=[arrVenueList objectAtIndex:indexPath.row];
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
    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, 150, 20)];
    lblName.text=[dict objectForKey:@"venueName"];
    lblName.font=[UIFont boldSystemFontOfSize:14];
    [cell.contentView addSubview:lblName];
    [lblName release];
    
    
    UILabel *lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(80, 30, 150, 50)];
    lblDescription.numberOfLines=2;
    lblDescription.text=[dict objectForKey:@"address"];
    lblDescription.font=[UIFont systemFontOfSize:12];
    [cell.contentView addSubview:lblDescription];
    [lblDescription release];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeViewController *obj=[[HomeViewController alloc]init];
    obj.dictVenue=[arrVenueList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:obj animated:YES];
    [obj release];
}

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    [self hideProgressView:nil];
    [arrVenueList removeAllObjects];
    [arrVenueList addObjectsFromArray:result];
    
    UITableView *tblView=(UITableView*)[self.view viewWithTag:111];
    [tblView reloadData];
    
}


-(void)controllerDidFailLoadingWithError:(NSError*)error
{
    [self hideProgressView:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
