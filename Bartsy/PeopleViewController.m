//
//  PeopleViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 14/06/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "PeopleViewController.h"
#import "Constants.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"

@interface PeopleViewController ()

@end

@implementation PeopleViewController
@synthesize arrPeople;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
     
    
    self.title=@"People";
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    arrPeople=[[NSMutableArray alloc]initWithArray:appDelegate.arrPeople];
   // [arrPeople addObjectsFromArray:appDelegate.arrPeople];
    [arrPeople setValue:@"NO" forKey:@"Checked"];

        
    UIBarButtonItem *btnSave=[[UIBarButtonItem alloc]initWithTitle:@"Continue" style:UIBarButtonItemStylePlain target:self action:@selector(btnSave_TouchUpInside)];
    self.navigationItem.rightBarButtonItem=btnSave;
    
    
//    UIBarButtonItem *btnBack=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(btnCancel_TouchUpInside)];
//    self.navigationItem.backBarButtonItem=btnBack;

    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reloadTable) userInfo:nil repeats:NO];
}

-(void)reloadTable
{
    [self.tableView reloadData];
}

-(void)btnCancel_TouchUpInside
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)btnSave_TouchUpInside
{
    
    NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:arrPeople];
    [arrTemp filterUsingPredicate:[NSPredicate predicateWithFormat:@"Checked==1"]];
    if([arrTemp count])
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PeopleSelected" object:[arrTemp objectAtIndex:0]];
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please select one of the people" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrPeople count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}

    // Configure the cell...
    NSDictionary *dictPeople=[arrPeople objectAtIndex:indexPath.row];
    
    NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictPeople objectForKey:@"userImagePath"]];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [[cell.imageView layer] setShadowOffset:CGSizeMake(0, 1)];
    [[cell.imageView layer] setShadowColor:[[UIColor whiteColor] CGColor]];
    [[cell.imageView layer] setShadowRadius:3.0];
    [[cell.imageView layer] setShadowOpacity:0.8];
    
    cell.textLabel.text=[dictPeople objectForKey:@"nickName"];
    cell.detailTextLabel.text=[dictPeople objectForKey:@"gender"];
    
    if([[dictPeople objectForKey:@"Checked"] integerValue])
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dictPeople=[[NSMutableDictionary alloc]initWithDictionary:[arrPeople objectAtIndex:indexPath.row]];
    [arrPeople setValue:@"NO" forKey:@"Checked"];
    [dictPeople setValue:[NSNumber numberWithBool:![[dictPeople objectForKey:@"Checked"] boolValue]] forKey:@"Checked"];
    
    [arrPeople replaceObjectAtIndex:indexPath.row withObject:dictPeople];
    
    
    
    [tableView reloadData];
}

@end



