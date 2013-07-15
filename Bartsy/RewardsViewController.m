//
//  RewardsViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 11/07/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "RewardsViewController.h"

@interface RewardsViewController ()

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
    
    self.navigationController.navigationBarHidden=YES;
    
    self.view.backgroundColor=[UIColor colorWithRed:0.09 green:0.09 blue:0.098 alpha:1.0];
    UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [self.view addSubview:imgViewForTop];
    [imgViewForTop release];
    
    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(100.25, 13.25, 119.5, 23.5)];
    imgLogo.image=[UIImage imageNamed:@"logo_Header.png"];
    [self.view addSubview:imgLogo];
    [imgLogo release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
