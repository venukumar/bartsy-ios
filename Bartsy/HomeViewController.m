//
//  HomeViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 01/05/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

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
    self.sharedController=[SharedController sharedController];
    
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    [self.sharedController getMenuListWithDelegate:self];
}

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    
    [self hideProgressView:nil];
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
