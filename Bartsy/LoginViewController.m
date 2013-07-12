//
//  LoginViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 26/04/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "AgreementViewController.h"
#import "WelcomeViewController.h"
#import "RootViewController.h"
@interface LoginViewController ()

- (void)updateView;

@end

@implementation LoginViewController

GPPSignIn *signIn;

static NSString * const kClientId =@"1066724567663.apps.googleusercontent.com"; //@"699931169234-9vjbmi0eqd3juqjdpr1vishsegqr5sv9.apps.googleusercontent.com";

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
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    appDelegate.isLoginForFB=NO;
    
    self.trackedViewName = @"Login Screen";
    
    signIn= [GPPSignIn sharedInstance];
    
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,@"https://www.googleapis.com/auth/userinfo.email" ,
                     nil];
    signIn.delegate = self;
    signIn.shouldFetchGoogleUserID=YES;
    signIn.shouldFetchGoogleUserEmail =YES;
    
    //[signIn trySilentAuthentication];
    
    
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor blackColor];
    
    if(appDelegate.isCmgForWelcomeScreen==NO)
        [self updateView];
    
    if (!appDelegate.session.isOpen&&appDelegate.isCmgForWelcomeScreen==NO)
    {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];//WithPermissions:[NSArray arrayWithObjects:@"publish_stream", @"publish_actions",@"user_checkins",@"friends_checkins",@"user_photos",nil]];
        
        //        appDelegate.session = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObjects:@"publish_stream", @"publish_actions", nil]];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded)
        {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }
    
    //New UI Design
    
    UIImageView *imgBg = [[UIImageView alloc] init];
    if (IS_IPHONE_5)
    {
        imgBg.frame = CGRectMake(0, 0, 320, 568);
    }
    else
    {
        imgBg.frame = CGRectMake(0, 0, 320, 460);
    }
    imgBg.image=[UIImage imageNamed:@"bg.png"];
    [self.view addSubview:imgBg];
    [imgBg release];

    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(42, 35, 239, 47)];
    imgLogo.image=[UIImage imageNamed:@"logo.png"];
    [self.view addSubview:imgLogo];
    [imgLogo release];

    UILabel *lblHeader = [self createLabelWithTitle:@"Check In.Order.Pick up.Socialize" frame:CGRectMake(32, 82, 250, 40) tag:0 font:[UIFont systemFontOfSize:15] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
    lblHeader.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblHeader];

    UILabel *lblSide = [self createLabelWithTitle:@"Create an Account" frame:CGRectMake(30, 140, 250, 40) tag:0 font:[UIFont systemFontOfSize:11] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
    lblSide.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:lblSide];

    UIButton *btnfb = [self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"f-sign.png"] frame:CGRectMake(25, 175, 275, 43) tag:0 selector:@selector(btnFBLogin) target:self];
    [self.view addSubview:btnfb];

    GPPSignInButton *btnGoogle=[[GPPSignInButton alloc]initWithFrame:CGRectMake(25, 225, 275, 43)];
    [btnGoogle setImage:[UIImage imageNamed:@"g+-sign.png"] forState:UIControlStateNormal];
    [btnGoogle setImage:[UIImage imageNamed:@"g+-sign.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnGoogle];
    
    UIButton *btnEmail = [self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"mail-signup.png"] frame:CGRectMake(25, 280, 275, 43) tag:0 selector:@selector(btnEmail) target:self];
    [self.view addSubview:btnEmail];
    
    UILabel *lblAccount = [self createLabelWithTitle:@"Already have an account?" frame:CGRectMake(25, 330, 320, 25) tag:0 font:[UIFont systemFontOfSize:12] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
    lblAccount.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:lblAccount];
    
    UIButton *btnLogIn = [self createUIButtonWithTitle:@"Log In" image:nil frame:CGRectMake(22, 340, 140, 50) tag:0 selector:@selector(btnLogin) target:self];
    btnLogIn.titleLabel.font = [UIFont systemFontOfSize:13];
    btnLogIn.titleLabel.textAlignment = NSTextAlignmentLeft;
    btnLogIn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    btnLogIn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:btnLogIn];

    if (IS_IPHONE_5)
    {
        UILabel *lblCopyRight1 = [self createLabelWithTitle:@"By joining Bartsy you agree to the " frame:CGRectMake(0, 485, 320, 25) tag:0 font:[UIFont systemFontOfSize:11] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
        lblCopyRight1.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lblCopyRight1];
        
        UILabel *lblCopyRight21 = [self createLabelWithTitle:@"Terms of Service" frame:CGRectMake(72, 500, 90, 25) tag:0 font:[UIFont boldSystemFontOfSize:10.5] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
        lblCopyRight21.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:lblCopyRight21];
        UIButton *termsBtn=[self createUIButtonWithTitle:@"" image:nil frame:lblCopyRight21.bounds tag:001 selector:@selector(Button_Action:) target:self];
        [self.view addSubview:termsBtn];
        
        UILabel *lblCopyRight22 = [self createLabelWithTitle:@"and" frame:CGRectMake(159.5, 500, 50, 25) tag:0 font:[UIFont systemFontOfSize:11] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
        lblCopyRight22.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:lblCopyRight22];
        
        UILabel *lblCopyRight23 = [self createLabelWithTitle:@"Privacy Policy" frame:CGRectMake(180, 500, 200, 25) tag:0 font:[UIFont boldSystemFontOfSize:10.5] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
        lblCopyRight23.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:lblCopyRight23];
        UIButton *policyBtn=[self createUIButtonWithTitle:@"" image:nil frame:lblCopyRight23.bounds tag:002 selector:@selector(Button_Action:) target:self];
        [self.view addSubview:policyBtn];
        UILabel *lblCopyRight2 = [self createLabelWithTitle:[NSString stringWithFormat:@"\u00A9 Vendsy,Inc.All rights reserved."] frame:CGRectMake(0, 520, 320, 25) tag:0 font:[UIFont systemFontOfSize:10] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
        lblCopyRight2.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lblCopyRight2];
    }
    else
    {
        UILabel *lblCopyRight1 = [self createLabelWithTitle:@"By joining Bartsy you agree to the " frame:CGRectMake(0, 400, 320, 25) tag:0 font:[UIFont systemFontOfSize:11] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
        lblCopyRight1.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lblCopyRight1];
        
        UILabel *lblCopyRight21 = [self createLabelWithTitle:@"Terms of Service" frame:CGRectMake(72, 415, 90, 25) tag:0 font:[UIFont boldSystemFontOfSize:10.5] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
        lblCopyRight21.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:lblCopyRight21];
        UIButton *termsBtn=[self createUIButtonWithTitle:@"" image:nil frame:lblCopyRight21.bounds tag:001 selector:@selector(Button_Action:) target:self];
        [self.view addSubview:termsBtn];
        
        UILabel *lblCopyRight22 = [self createLabelWithTitle:@"and" frame:CGRectMake(159.5, 415, 50, 25) tag:0 font:[UIFont systemFontOfSize:11] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
        lblCopyRight22.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:lblCopyRight22];
        
        UILabel *lblCopyRight23 = [self createLabelWithTitle:@"Privacy Policy" frame:CGRectMake(180, 415, 200, 25) tag:0 font:[UIFont boldSystemFontOfSize:10.5] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
        lblCopyRight23.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:lblCopyRight23];
        UIButton *policyBtn=[self createUIButtonWithTitle:@"" image:nil frame:lblCopyRight23.bounds tag:002 selector:@selector(Button_Action:) target:self];
        [self.view addSubview:policyBtn];
        
        
        UILabel *lblCopyRight2 = [self createLabelWithTitle:[NSString stringWithFormat:@"\u00A9 Vendsy,Inc..All rights reserved."] frame:CGRectMake(0, 435, 320, 25) tag:0 font:[UIFont systemFontOfSize:10] color:[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] numberOfLines:1];
        lblCopyRight2.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lblCopyRight2];
  
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.delegateForCurrentViewController=self;
    
    [[GPPSignIn sharedInstance] signOut];
    
    if(appDelegate.isCmgForWelcomeScreen==YES)
    {
        appDelegate.isCmgForWelcomeScreen=NO;
        RootViewController *homeObj = [[RootViewController alloc] init];
        [self.navigationController pushViewController:homeObj animated:YES];
        [homeObj release];
    }
    
    self.navigationController.navigationBarHidden=YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"isNDAAccepted"]==nil)
    {
        AgreementViewController *obj=[[AgreementViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:obj];
        [self presentViewController:nav animated:YES completion:nil];
        [obj release];
    }
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Status Error %@",error);
        return;
    }    
    
    [self hideProgressView:nil];
    appDelegate.isLoginForFB=NO;
    ProfileViewController *profileScreen=[[ProfileViewController alloc]init];
    profileScreen.isCmgFromGetStarted=NO;
    profileScreen.auth=auth;
    [self.navigationController pushViewController:profileScreen animated:YES];
    [profileScreen release];
}
-(void)btnEmail
{
    appDelegate.isLoginForFB=NO;
    ProfileViewController *profileScreen=[[ProfileViewController alloc]init];
    profileScreen.isCmgFromGetStarted=YES;
    [self.navigationController pushViewController:profileScreen animated:YES];
    [profileScreen release];

}
-(void)btnLogin
{
    appDelegate.isLoginForFB=NO;
    ProfileViewController *profileScreen=[[ProfileViewController alloc]init];
    [self.navigationController pushViewController:profileScreen animated:YES];
    [profileScreen release];

}
// FBSample logic
// handler for button click, logs sessions in or out
- (void)btnFBLogin
{
    // get the app delegate so that we can access the session property
    
    appDelegate.isLoginForFB=YES;
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen)
    {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    }
    else
    {
        [self createProgressViewToParentView:self.view withTitle:@"Connecting to Facebook..."];
        if (appDelegate.session.state != FBSessionStateCreated)
        {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error)
         {
             // and here we make sure to update our UX according to the new session state
             [self updateView];
             [self hideProgressView:nil];
             
         }];
    }
}

#pragma mark-------------Button Actions

-(void)Button_Action:(UIButton*)sender{
    
    if (sender.tag==001) {
        
        
    }else if (sender.tag==002){
        
        
    }
}

// FBSample logic
// main helper method to update the UI to reflect the current state of the session.
- (void)updateView {
    // get the app delegate, so that we can reference the session property
    
    //UIButton *btnFb=(UIButton*)[self.view viewWithTag:111];
    if (appDelegate.session.isOpen)
    {
        // [btnFb setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
        [[NSUserDefaults standardUserDefaults]setObject:appDelegate.session.accessTokenData.accessToken forKey:@"AccessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        appDelegate.isLoginForFB=YES;
        ProfileViewController *profileScreen=[[ProfileViewController alloc]init];
        [self.navigationController pushViewController:profileScreen animated:YES];
        [profileScreen release];
    }
    else
    {
        // login-needed account UI is shown whenever the session is closed
        //[btnFb setTitle:@"Log in" forState:UIControlStateNormal];
        //[btnFb setText:@"Login to create a link to fetch account data"];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
