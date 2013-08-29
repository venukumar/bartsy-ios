//
//  VenueRewardsView.m
//  Bartsy
//
//  Created by Techvedika on 8/29/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "VenueRewardsView.h"

@interface VenueRewardsView ()

@end

@implementation VenueRewardsView
@synthesize dictVenueInfo;
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
    // Do any additional setup after loading the view from its nib.
    NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictVenueInfo objectForKey:@"venueImage"]];
    [VenueImg setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    VenueName.text=[dictVenueInfo valueForKey:@"venueName"];
    if ([[dictVenueInfo valueForKey:@"address"] length]) {
        Venueaddress.text=[NSString stringWithFormat:@"%@ address",[dictVenueInfo valueForKey:@"address"]];
    }else
        Venueaddress.text=@"";
    
    Venuerewards.text=[NSString stringWithFormat:@"%d points",[[dictVenueInfo valueForKey:@"rewards"] integerValue]];
    NSLog(@"%@",dictVenueInfo);
    
    self.sharedController=[SharedController sharedController];
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    [sharedController GetVenueRewards:[NSString stringWithFormat:@"%@",[dictVenueInfo objectForKey:@"venueId"]] bydelegate:self];
    arrRewards=[[NSMutableArray alloc]init];
    
    if (IS_IPHONE_5) {
        
        
    }
}

-(IBAction)btnBack_TouchUpInside
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark------------TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return [arrRewards count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
   VenueRewardCell *cell= [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[[VenueRewardCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                        reuseIdentifier:MyIdentifier] autorelease];
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
        bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fathers_office-bg.png"]];
        cell.backgroundView = bg;
        [bg release];
    }
    NSDictionary *dictDetails=[arrRewards objectAtIndex:indexPath.row];
    cell.lblpoints.text=[NSString stringWithFormat:@"%d",[[dictDetails valueForKey:@"points"] integerValue]];
    cell.lblpoints.font=[UIFont fontWithName:@"MuseoSans-300" size:15.0];
    if ([[dictDetails valueForKey:@"type"] isEqualToString:@"Text"]) {
        cell.lblpointsDescription.text=[dictDetails valueForKey:@"text"];
    }else{
        cell.lblpointsDescription.text=[dictDetails valueForKey:@"type"];
    }
    cell.lblpointsDescription.font=[UIFont fontWithName:@"MuseoSans-300" size:15.0];
   
        
    return cell;
}

#pragma mark-----------Sharedcontroller Delegate
-(void)controllerDidFinishLoadingWithResult:(id)result{
    
    [self hideProgressView:nil];
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        if ([[result valueForKey:@"errorCode"] integerValue]==0) {
            
            [arrRewards removeAllObjects];
            NSArray  *resultarray=[result valueForKey:@"rewardsTypes"];
            
            for (NSDictionary *dic in resultarray) {
                NSLog(@"rewards:%@",dic);
                [arrRewards addObject:dic];
                
            }
            [venueTable reloadData];
        }
    else{
            
            [self createAlertViewWithTitle:@"" message:[result valueForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
        }
        
    }else if ([result isKindOfClass:[NSArray class]]){
        
        
        NSLog(@"Array %@",result);
        
    }
    
}
-(void)controllerDidFailLoadingWithError:(NSError*)error{
    
    [self hideProgressView:nil];
    
    [self createAlertViewWithTitle:@"" message:[error localizedDescription] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
