//
//  AccountInfoViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 11/07/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "AccountInfoViewController.h"

@interface AccountInfoViewController (){
    
    UIImageView *profileImg;
    UILabel *profileName;
    UITextView *aboutme;
}

@end

@implementation AccountInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.sharedController=[SharedController sharedController];
    
    //Navigation Bar implementation
    self.view.backgroundColor=[UIColor colorWithRed:0.09 green:0.09 blue:0.098 alpha:1.0];
    UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [self.view addSubview:imgViewForTop];
    [imgViewForTop release];
    
    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(100.25, 13.25, 119.5, 23.5)];
    imgLogo.image=[UIImage imageNamed:@"logo_Header.png"];
    [self.view addSubview:imgLogo];
    [imgLogo release];
    
    //Setting's Button declaration
    UIButton *settingBtn=[self createUIButtonWithTitle:nil image:[UIImage imageNamed:@"settings"] frame:CGRectMake(280,12.5,23, 22.5) tag:401 selector:@selector(Button_Action:) target:self];
    [self.view addSubview:settingBtn];
    
    [self.sharedController getUserProfileWithBartsyId:[[NSUserDefaults standardUserDefaults] valueForKey:@"bartsyId"] delegate:self];
    
    
    profileImg=[[UIImageView alloc]initWithFrame:CGRectMake(20,imgViewForTop.frame.size.height+20,90, 90)];
    profileImg.layer.borderColor=[UIColor whiteColor].CGColor;
    profileImg.image=[UIImage imageNamed:@"logo_Header"];
    //[profileImg setImageWithURL:[NSURL URLWithString:@"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash4/c66.66.828.828/s160x160/481820_455686467802237_684943127_n.jpg"]];
    [self.view addSubview:profileImg];
    
    profileName=[self createLabelWithTitle:@"" frame:CGRectMake(20, profileImg.frame.size.height+profileImg.frame.origin.y+2, 300, 70) tag:0 font:[UIFont systemFontOfSize:30] color:[UIColor colorWithRed:191.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0] numberOfLines:1];
    [self.view addSubview:profileName];
    
    aboutme=[[UITextView alloc]initWithFrame:CGRectMake(12,profileName.frame.size.height+profileName.frame.origin.y, 300, 50)];
    aboutme.backgroundColor=[UIColor clearColor];
    aboutme.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
    aboutme.font=[UIFont systemFontOfSize:14];
    aboutme.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:aboutme];
}

#pragma mark-----------Button Actions

-(void)Button_Action:(UIButton*)sender{
    
    if (sender.tag==401) {
        
        AccountSettingsViewController *obj = [[AccountSettingsViewController alloc]init];
        [self.navigationController pushViewController:obj animated:YES];
        [obj release];
    }
    
}

#pragma mark-----------Sharedcontroller Delegate
-(void)controllerDidFinishLoadingWithResult:(id)result{
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSLog(@"Dictionary %@",result);
        
        [profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KServerURL,[result valueForKey:@"userImage"]]]];
        profileName.text=[result valueForKey:@"nickname"];
        aboutme.text=[result valueForKey:@"description"];
        
        
    }else if ([result isKindOfClass:[NSArray class]]){
        
        NSLog(@"Array %@",result);
    }
    
}
-(void)controllerDidFailLoadingWithError:(NSError*)error{
    
    [self createAlertViewWithTitle:@"Error" message:[error localizedDescription] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
    
}

-(void)dealloc{
    
    [super dealloc];
    [profileImg release];
    [profileName release];
    [aboutme release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
