//
//  UserProfileViewController.m
//  Bartsy
//
//  Created by Techvedika on 8/22/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

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
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    self.sharedController=[SharedController sharedController];
    [sharedController getUserProfileWithBartsyId:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] delegate:self];
}

-(void)controllerDidFinishLoadingWithResult:(id)result{
   
    [self hideProgressView:nil];
        SDImageCache *sharedSDImageCache=[SDImageCache sharedImageCache];
        [sharedSDImageCache clearMemory];
        [sharedSDImageCache clearDisk];
        [sharedSDImageCache cleanDisk];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            if ([[result valueForKey:@"errorCode"] integerValue]==0) {
                
                NSLog(@"Dictionary %@  \n URL is %@",result,[NSString stringWithFormat:@"%@/%@",KServerURL,[result valueForKey:@"userImage"]]);
                                
                [ProfileImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KServerURL,[result valueForKey:@"userImage"]]]];

                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                NSDate *birthdate=[dateFormatter dateFromString:[result valueForKey:@"dateofbirth"]];
                NSDate* now = [NSDate date];
                NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                                   components:NSYearCalendarUnit
                                                   fromDate:birthdate
                                                   toDate:now
                                                   options:0];
                NSInteger age = [ageComponents year];
                
                
                NSMutableString *strdetails=[[NSMutableString alloc]init];
                [strdetails appendFormat:@"%d",age];
                if ([result valueForKey:@"gender"] && [[result valueForKey:@"gender"] length]) {
                    [strdetails appendFormat:@"/%@",[result valueForKey:@"gender"]];
                }
                
                if ([result valueForKey:@"orientation"] && [[result valueForKey:@"orientation"] length]) {
                    [strdetails appendFormat:@"/%@",[result valueForKey:@"orientation"]];
                }
                lbldetails.text=strdetails;
                if ([result valueForKey:@"status"]) {
                  lblStatus.text = [result valueForKey:@"status"];
                }
                Description.text=[result valueForKey:@"description"];
                [strdetails release];
            }else{
                
                [self createAlertViewWithTitle:@"Error" message:[result valueForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
            }
            
        }
}
    
-(void)controllerDidFailLoadingWithError:(NSError*)error{
    
    [self hideProgressView:nil];
    
    [self createAlertViewWithTitle:@"Error" message:[error localizedDescription] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
