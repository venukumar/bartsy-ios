//
//  CustomDrinkViewController.m
//  Bartsy
//
//  Created by Techvedika on 7/24/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "CustomDrinkViewController.h"

@interface CustomDrinkViewController ()

@end

@implementation CustomDrinkViewController

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
    
    UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [self.view addSubview:imgViewForTop];
    [imgViewForTop release];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(5, 0, 50, 40);
    [btnBack addTarget:self action:@selector(btnBack_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    UIImageView *imgViewBack = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 12, 20)];
    imgViewBack.image = [UIImage imageNamed:@"arrow-left.png"];
    [btnBack addSubview:imgViewBack];
    [imgViewBack release];
}

-(void)btnBack_TouchUpInside
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
