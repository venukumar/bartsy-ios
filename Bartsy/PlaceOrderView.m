//
//  PlaceOrderView.m
//  Bartsy
//
//  Created by Techvedika on 8/28/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "PlaceOrderView.h"

@interface PlaceOrderView (){
    
    NSMutableDictionary *dictPeopleSelectedForDrink;
}

@end

@implementation PlaceOrderView

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
    dictPeopleSelectedForDrink=[[NSMutableDictionary alloc]init];
    
    NSMutableArray *arrMultiItems=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"multiitemorders"]];
    NSMutableDictionary *dictuserInfo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
