//
//  HomeViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 01/05/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "HomeViewController.h"

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    id object=[arrMenu objectAtIndex:indexPath.section];
    if(indexPath.section==0&&[object isKindOfClass:[NSArray class]])
    {
        NSDictionary *dict=[object objectAtIndex:indexPath.row];
        cell.textLabel.text=[dict objectForKey:@"name"];
    }
    else
    {
        NSArray *arrContents=[[NSArray alloc]initWithArray:[object objectForKey:@"contents"]];
        NSDictionary *dict=[arrContents objectAtIndex:indexPath.row];
        cell.textLabel.text=[dict objectForKey:@"name"];
    }
    
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
