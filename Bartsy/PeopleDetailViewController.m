//
//  PeopleDetailViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 24/06/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "PeopleDetailViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"

@interface PeopleDetailViewController ()

@end

@implementation PeopleDetailViewController
@synthesize dictPeople;

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
    
    
    self.title=[dictPeople objectForKey:@"nickName"];
    
    UIImageView *imgViewProfilePicture=(UIImageView*)[self.view viewWithTag:111];
    
    NSURL *urlReceiver=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Bartsy/userImages/%@",KServerURL,[dictPeople objectForKey:@"bartsyId"]]];
    [imgViewProfilePicture setImageWithURL:urlReceiver];
    [[imgViewProfilePicture layer] setShadowOffset:CGSizeMake(0, 1)];
    [[imgViewProfilePicture layer] setShadowColor:[[UIColor redColor] CGColor]];
    [[imgViewProfilePicture layer] setShadowRadius:3.0];
    [[imgViewProfilePicture layer] setShadowOpacity:0.8];
    
    UIView *viewBg=(UIView*)[self.view viewWithTag:143225];
    UILabel *lblAgeGenderOrientationStatus=(UILabel*)[viewBg viewWithTag:222];
    lblAgeGenderOrientationStatus.textColor=[UIColor blackColor];
    NSMutableString *str=[[NSMutableString alloc]init];
    if([[dictPeople objectForKey:@"dateOfBirth"] length])
    {
        /*
        NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"MM/DD/YYYY"];
        NSDate *dateDOB=[dateFormater dateFromString:[dictPeople objectForKey:@"dateOfBirth"]];
        
        NSDate *currentDate=[NSDate date];
         */
        NSString *strDOB=[NSString stringWithFormat:@"%@/",[dictPeople objectForKey:@"dateOfBirth"]];
        [str appendString:strDOB];
    }
    
    if([[dictPeople objectForKey:@"gender"] length])
    {
        NSString *strGender=[NSString stringWithFormat:@"%@/",[dictPeople objectForKey:@"gender"]];
        [str appendString:strGender];
    }
    
    if([[dictPeople objectForKey:@"orientation"] length])
    {
        NSString *strOrientation=[NSString stringWithFormat:@"%@/",[dictPeople objectForKey:@"orientation"]];
        [str appendString:strOrientation];
    }
    if([str length])
    lblAgeGenderOrientationStatus.text=[str substringToIndex:[str length]-1];
    NSLog(@"Text is %@, %@",lblAgeGenderOrientationStatus.text,str);
    
    UILabel *lblAddress=(UILabel*)[viewBg viewWithTag:333];
    lblAddress.textColor=[UIColor blackColor];
    lblAddress.text=@"Address:";//[dictPeople objectForKey:@"address"];
    
    UILabel *lblStatus=(UILabel*)[viewBg viewWithTag:444];
    lblStatus.textColor=[UIColor blackColor];
    lblStatus.text=@"You like each other";
    
    UILabel *lblMessages=(UILabel*)[viewBg viewWithTag:555];
    lblMessages.textColor=[UIColor blackColor];
    lblMessages.text=@"Messages";
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
