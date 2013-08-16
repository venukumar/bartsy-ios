//
//  RootViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 11/07/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "RootViewController.h"
#import "VenueListViewController.h"
#import "RewardsViewController.h"
#import "NotificationsViewController.h"
#import "AccountInfoViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

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
    
    appDelegate.tabBar=[[UITabBarController alloc]init];
    appDelegate.tabBar.delegate=self;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, -20, 320, 600)];
    self.navigationController.navigationBarHidden=YES;

    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    VenueListViewController *view1 = [[VenueListViewController alloc] init];
    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:view1];
    [viewControllers addObject:nav1];
    [view1 release];
    [nav1 release];
    
    RewardsViewController *view2 = [[RewardsViewController alloc] init];
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:view2];
    [viewControllers addObject:nav2];
    [view2 release];
    [nav2 release];
    
    NotificationsViewController *view3 = [[NotificationsViewController alloc] init];
    UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:  view3];
    [viewControllers addObject:nav3];
    [view3 release];
    [nav3 release];
    
    AccountInfoViewController *view4 = [[AccountInfoViewController alloc] init];
    UINavigationController *nav4=[[UINavigationController alloc]initWithRootViewController:  view4];
    [viewControllers addObject:nav4];
    [view4 release];
    [nav4 release];

    
    //UIImage* tabBarBackground = [UIImage imageNamed:@"footer_bar.png"];
    //[[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance]setSelectionIndicatorImage:[UIImage imageNamed:@"button_hover.png"]];
    
    [appDelegate.tabBar setViewControllers:viewControllers];
    [viewControllers release];
    
    appDelegate.tabBar.tabBarController.view.frame=CGRectMake(0, 0, 320, 480);
    [view addSubview:appDelegate.tabBar.view];
    
    [self.view addSubview:view];

    
    UIImageView *imgView1=[[UIImageView alloc]initWithFrame:CGRectMake(25, 12, 29.5, 25.5)];
    imgView1.image=[UIImage imageNamed:@"home_icon.png"];
    [appDelegate.tabBar.tabBar addSubview:imgView1];
    [imgView1 release];
    
    UIImageView *imgView2=[[UIImageView alloc]initWithFrame:CGRectMake(107, 12, 26.5, 25)];
    imgView2.image=[UIImage imageNamed:@"star_icon.png"];
    [appDelegate.tabBar.tabBar addSubview:imgView2];
    [imgView2 release];
    
    UIImageView *imgView3=[[UIImageView alloc]initWithFrame:CGRectMake(184, 13, 31, 23.5)];
    imgView3.image=[UIImage imageNamed:@"chat_icon.png"];
    [appDelegate.tabBar.tabBar addSubview:imgView3];
    [imgView3 release];
    
    UIImageView *imgView4=[[UIImageView alloc]initWithFrame:CGRectMake(265, 14, 30, 21.5)];
    imgView4.image=[UIImage imageNamed:@"user_icon.png"];
    [appDelegate.tabBar.tabBar addSubview:imgView4];
    [imgView4 release];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logOut) name:@"logOut" object:nil];
    
}

-(void)logOut
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
