//
//  WelcomeViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 15/05/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "WelcomeViewController.h"
#import "VenueListViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.delegateForCurrentViewController=self;
    
    self.navigationController.navigationBarHidden=YES;
    
    UIImageView *imgViewBox=(UIImageView*)[self.view viewWithTag:143];
    UIButton *btnClose=(UIButton*)[self.view viewWithTag:1111];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]==nil)
    {
        imgViewBox.hidden=YES;
        btnClose.hidden=YES;
    }
    else
    {
        NSDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"VenueDetails"];
        imgViewBox.hidden=NO;
        UILabel *lblCheckIn=(UILabel*)[self.view viewWithTag:225];
        lblCheckIn.text=[NSString stringWithFormat:@"Checked in at: %@\nClick to order drinks and see who's here",[dict objectForKey:@"venueName"]];
        
        btnClose.hidden=NO;
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.trackedViewName = @"Welcome Screen";

    self.view.backgroundColor=[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
    
    UIImageView *imgViewWelcome=[self createImageViewWithImage:[UIImage imageNamed:@"welcomebartsy.png"] frame:CGRectMake(60, 15, 200, 30) tag:0];
    [self.view addSubview:imgViewWelcome];
    //[imgViewWelcome release];
    
    UIImageView *imgViewCheckInBox1=[self createImageViewWithImage:[UIImage imageNamed:@"box.png"] frame:CGRectMake(5, 60, 310, 44) tag:143];
    [self.view addSubview:imgViewCheckInBox1];
    
    UIImageView *imgViewLine1=[self createImageViewWithImage:[UIImage imageNamed:@""] frame:CGRectMake(270, 3, 1, 37) tag:0];
    imgViewLine1.backgroundColor=[UIColor redColor];
    [imgViewCheckInBox1 addSubview:imgViewLine1];
    
    UIImageView *imgViewCheckInLogo1=[self createImageViewWithImage:[UIImage imageNamed:@"ic_checked_in.png"] frame:CGRectMake(10, 3, 40, 35) tag:0];
    [imgViewCheckInBox1 addSubview:imgViewCheckInLogo1];
    
    UIButton *btnClose1=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"close.png"] frame:CGRectMake(278, 67, 30, 30) tag:1111 selector:@selector(btnClose_TouchUpInside:) target:self];
    [self.view addSubview:btnClose1];
    
    UILabel *lblCheckin=[self createLabelWithTitle:@"CheckIn...." frame:CGRectMake(55, 0, 215, 40) tag:225 font:[UIFont systemFontOfSize:12] color:[UIColor blackColor] numberOfLines:2];
    lblCheckin.userInteractionEnabled=YES;
    [imgViewCheckInBox1 addSubview:lblCheckin];
    
    UIButton *btnVenue=[self createUIButtonWithTitle:@"" image:nil frame:CGRectMake(5, 60, 260, 40) tag:0 selector:@selector(btnCheckIn_TouchUpInside) target:self];
    [self.view addSubview:btnVenue];
    
    UIImageView *imgViewCheckInBox2=[self createImageViewWithImage:[UIImage imageNamed:@"box.png"] frame:CGRectMake(5, 110, 310, 44) tag:0];
    [self.view addSubview:imgViewCheckInBox2];
    
    UIImageView *imgViewLine2=[self createImageViewWithImage:[UIImage imageNamed:@""] frame:CGRectMake(270, 3, 1, 37) tag:0];
    imgViewLine2.backgroundColor=[UIColor redColor];
    [imgViewCheckInBox2 addSubview:imgViewLine2];
    
    UIImageView *imgViewCheckInLogo2=[self createImageViewWithImage:[UIImage imageNamed:@"account.png"] frame:CGRectMake(10, 4, 40, 35) tag:0];
    [imgViewCheckInBox2 addSubview:imgViewCheckInLogo2];
    
    UIButton *btnClose2=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"close.png"] frame:CGRectMake(278, 117, 30, 30) tag:2222 selector:@selector(btnClose_TouchUpInside:) target:self];
    [self.view addSubview:btnClose2];
    
    UILabel *lblAccount=[self createLabelWithTitle:@"Setup your account..." frame:CGRectMake(55, 0, 200, 40) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:1];
    [imgViewCheckInBox2 addSubview:lblAccount];
    
    UIImageView *imgViewCheckInBox3=[self createImageViewWithImage:[UIImage imageNamed:@"box.png"] frame:CGRectMake(5, 160, 310, 44) tag:0];
    [self.view addSubview:imgViewCheckInBox3];
    
    UIImageView *imgViewLine3=[self createImageViewWithImage:[UIImage imageNamed:@""] frame:CGRectMake(270, 3, 1, 37) tag:0];
    imgViewLine3.backgroundColor=[UIColor redColor];
    [imgViewCheckInBox3 addSubview:imgViewLine3];
    
    UIImageView *imgViewCheckInLogo3=[self createImageViewWithImage:[UIImage imageNamed:@"creditcard.png"] frame:CGRectMake(10, 4, 40, 35) tag:0];
    [imgViewCheckInBox3 addSubview:imgViewCheckInLogo3];
    
    UIButton *btnClose3=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"close.png"] frame:CGRectMake(278, 167, 30, 30) tag:3333 selector:@selector(btnClose_TouchUpInside:) target:self];
    [self.view addSubview:btnClose3];
    
    UILabel *lblCreditCard=[self createLabelWithTitle:@"Setup your credit card..." frame:CGRectMake(55, 0, 200, 40) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:1];
    [imgViewCheckInBox3 addSubview:lblCreditCard];
    
    
    UIButton *btnNearBy=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"pic1.png"] frame:CGRectMake(10, 210, 140, 85) tag:222 selector:@selector(btn_TouchUpInside:) target:self];
    [self.view addSubview:btnNearBy];
    
    UIButton *btnNotifications=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"pic2.png"] frame:CGRectMake(10, 302, 140, 85) tag:333 selector:@selector(btn_TouchUpInside:) target:self];
    [self.view addSubview:btnNotifications];
    
    UIButton *btnMyRewards=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"pic4.png"] frame:CGRectMake(170, 210, 140, 85) tag:444 selector:@selector(btn_TouchUpInside:) target:self];
    [self.view addSubview:btnMyRewards];
    
    UIButton *btnProfile=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"pic3.png"] frame:CGRectMake(170, 302, 140, 85) tag:555 selector:@selector(btn_TouchUpInside:) target:self];
    [self.view addSubview:btnProfile];
    
    
    UIImageView *imgViewCheckInBox4=[self createImageViewWithImage:[UIImage imageNamed:@"box.png"] frame:CGRectMake(5, 390, 310, 44) tag:0];
    [self.view addSubview:imgViewCheckInBox4];
    
    UIImageView *imgViewCheckInLogo4=[self createImageViewWithImage:[UIImage imageNamed:@"smile.png"] frame:CGRectMake(10, 4, 40, 35) tag:0];
    [imgViewCheckInBox4 addSubview:imgViewCheckInLogo4];
    
    UILabel *lblComment=[self createLabelWithTitle:@"Send us praise,comments or suggestions" frame:CGRectMake(55, 0, 280, 40) tag:0 font:[UIFont systemFontOfSize:13] color:[UIColor blackColor] numberOfLines:1];
    [imgViewCheckInBox4 addSubview:lblComment];
    
    
    UILabel *lblCopyRight=[self createLabelWithTitle:@"Bartsy is Copyright (C) Vendsy,Inc. All rights reserved." frame:CGRectMake(0, 435, 320, 25) tag:0 font:[UIFont systemFontOfSize:11] color:[UIColor blackColor] numberOfLines:1];
    lblCopyRight.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblCopyRight];
}


-(void)reloadWelcomeScreen
{
    UIImageView *imgViewBox=(UIImageView*)[self.view viewWithTag:143];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]==nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"Orders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        imgViewBox.hidden=YES;
        UIButton *btnClose=(UIButton*)[self.view viewWithTag:1111];
        btnClose.hidden=YES;
    }
    else
    {
        NSDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"VenueDetails"];
        imgViewBox.hidden=NO;
        UILabel *lblCheckIn=(UILabel*)[self.view viewWithTag:225];
        lblCheckIn.text=[NSString stringWithFormat:@"CheckedIn at %@",[dict objectForKey:@"venueName"]];
        
    }

}

-(void)btnCheckIn_TouchUpInside
{
    HomeViewController *obj=[[HomeViewController alloc]init];
    obj.dictVenue=[[NSUserDefaults standardUserDefaults]objectForKey:@"VenueDetails"];
    [self.navigationController pushViewController:obj animated:YES];
    [obj release];
    
}

// handle method
- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer
{
    
}

-(void)btn_TouchUpInside:(UIButton*)sender
{
    if(sender.tag==222)
    {
        VenueListViewController *obj=[[VenueListViewController alloc]init];
        [self.navigationController pushViewController:obj animated:YES];
        //[obj release];
    }
    else if(sender.tag==555)
    {
        appDelegate.isLoginForFB=NO;
        ProfileViewController *profileScreen=[[ProfileViewController alloc]init];
        profileScreen.isCmgFromGetStarted=NO;
        profileScreen.isCmgForEditProfile=YES;
        [self.navigationController pushViewController:profileScreen animated:YES];
        [profileScreen release];
    }
    else if(sender.tag==444)
    {
        MyRewardsViewController *obj=[[MyRewardsViewController alloc]init];
        [self.navigationController pushViewController:obj animated:YES];
        [obj release];
    }
}

-(void)btnClose_TouchUpInside:(UIButton*)sender
{
    if(sender.tag==1111)
    {
        NSDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"VenueDetails"];
        NSString *strMsg;
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"Orders"]==nil)
        {
            strMsg=[NSString stringWithFormat:@"Do you want to checkout from %@",[dict objectForKey:@"venueName"]];
        }
        else
        {
            strMsg=[NSString stringWithFormat:@"You have open orders placed at %@. If you checkout they will be cancelled and you will still be charged for it.Do you want to checkout from %@",[dict objectForKey:@"venueName"],[dict objectForKey:@"venueName"]];
        }
        [self createAlertViewWithTitle:@"Please Confirm!" message:strMsg cancelBtnTitle:@"No" otherBtnTitle:@"Yes" delegate:self tag:143225];
        
    }
}

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"CheckInVenueId"];
    [self hideProgressView:nil];
    
    UIImageView *imgViewBox=(UIImageView*)[self.view viewWithTag:143];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]==nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"Orders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        imgViewBox.hidden=YES;
        UIButton *btnClose=(UIButton*)[self.view viewWithTag:1111];
        btnClose.hidden=YES;
        [appDelegate stopTimerForHeartBeat];
    }
    else
    {
        NSDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"VenueDetails"];
        imgViewBox.hidden=NO;
        UILabel *lblCheckIn=(UILabel*)[self.view viewWithTag:225];
        lblCheckIn.text=[NSString stringWithFormat:@"CheckedIn at %@",[dict objectForKey:@"venueName"]];
        
    }
    
}


-(void)controllerDidFailLoadingWithError:(NSError*)error
{
    [self hideProgressView:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==143225&&buttonIndex==1)
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.sharedController=[SharedController sharedController];
        [self createProgressViewToParentView:self.view withTitle:@"Checking Out..."];
        [self.sharedController checkOutAtBartsyVenueWithId:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] delegate:self];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
