//
//  RewardsViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 11/07/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "RewardsViewController.h"

@interface RewardsViewController (){
    
    NSMutableArray *rewardsArray;
}

@end

@implementation RewardsViewController

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
    
    self.sharedController=[SharedController sharedController];
    
    self.navigationController.navigationBarHidden=YES;
    
    self.view.backgroundColor=[UIColor colorWithRed:0.09 green:0.09 blue:0.098 alpha:1.0];
    UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [self.view addSubview:imgViewForTop];
    [imgViewForTop release];
    
    UILabel *lblMsg=[self createLabelWithTitle:@"Venues" frame:CGRectMake(0, 0, 320, 44) tag:0 font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] numberOfLines:1];
    lblMsg.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblMsg];
    
    /*UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(100.25, 13.25, 119.5, 23.5)];
    imgLogo.image=[UIImage imageNamed:@"logo_Header.png"];
    [self.view addSubview:imgLogo];
    [imgLogo release];*/
    
    rewardsArray=[[NSMutableArray alloc]init];
    
    UITableView *rewardstbl=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 367) style:UITableViewStylePlain];
    if (IS_IPHONE_5)
    {
        rewardstbl.frame = CGRectMake(0, 44, 320, 455);
    }
    rewardstbl.backgroundColor = [UIColor colorWithRed:0.09 green:0.09 blue:0.098 alpha:1.0];
    [rewardstbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    rewardstbl.dataSource=self;
    rewardstbl.delegate=self;
    rewardstbl.tag=222;
    [self.view addSubview:rewardstbl];

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self.sharedController getUserRewardsbybartsyID:[[NSUserDefaults standardUserDefaults] valueForKey:@"bartsyId"] delegate:self];
}

#pragma mark------------TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([rewardsArray count]) {
        return [rewardsArray count];
    }else
      return  1;
   // return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    RewardsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    if (cell == nil)
    {
        cell = [[[RewardsTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:MyIdentifier] autorelease];
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fathers_office-bg.png"]];
        cell.backgroundView = bg;
        [bg release];
    }
    if ([rewardsArray count]) {
        NSDictionary *dictForrewards=[rewardsArray objectAtIndex:indexPath.row];
        NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictForrewards objectForKey:@"venueImage"]];
       [cell.venueImgview setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        cell.venueName.text=[dictForrewards valueForKey:@"venueName"];
        
        if ([[dictForrewards valueForKey:@"address"] length]==0) {
            cell.venueaddress.text=@"Address unavailable";
        }else{
           cell.venueaddress.text=[dictForrewards valueForKey:@"address"]; 
        }
        cell.venuepoints.text=[NSString stringWithFormat:@"%d points",[[dictForrewards valueForKey:@"rewards"] integerValue]];
    }else{
        
        cell.venueaddress.text=@"\n\n  No reward points available";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark-----------Sharedcontroller Delegate
-(void)controllerDidFinishLoadingWithResult:(id)result{
         
    if ([result isKindOfClass:[NSDictionary class]]) {
            
        if ([[result valueForKey:@"errorCode"] integerValue]==0) {
                
            [rewardsArray removeAllObjects];
            NSArray  *resultarray=[result valueForKey:@"venues"];
            
            for (NSDictionary *dic in resultarray) {
                NSLog(@"rewards:%@",dic);
                [rewardsArray addObject:dic];
                
            }
            UITableView *tblview=(UITableView*)[self.view viewWithTag:222];
            [tblview reloadData];
        }
        else if([[result objectForKey:@"errorCode"] integerValue]==99)
        {
            
            [self createAlertViewWithTitle:@"" message:@"Your account hasn't been verified, please check your email and click on the verification link to enable rewards" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
        }
        else{
            
            [self createAlertViewWithTitle:@"Error" message:[result valueForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
        }
            
    }else if ([result isKindOfClass:[NSArray class]]){
            
            
            NSLog(@"Array %@",result);
            
    }
       
}
-(void)controllerDidFailLoadingWithError:(NSError*)error{
    
    [self createAlertViewWithTitle:@"Error" message:[error localizedDescription] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
