//
//  LoginViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 26/04/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

- (void)updateView;

@end

@implementation LoginViewController

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
    self.view.backgroundColor=[UIColor darkGrayColor];
    
    UIButton *btnFb=[self createUIButtonWithTitle:@"Login" image:nil frame:CGRectMake(110, 100, 100, 40) tag:111 selector:@selector(buttonClickHandler:) target:self];
    //[self.view addSubview:btnFb];
    
    
    [self updateView];
    
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
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

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    

    UIScrollView *scrollView=[[UIScrollView alloc]init];
    if (screenBounds.size.height == 568)
    {
        scrollView.frame=CGRectMake(0, 0, 320, 568);
    }
    else
    {
        scrollView.frame=CGRectMake(0, 0, 320, 460);
    }
    scrollView.contentSize = CGSizeMake(640, scrollView.frame.size.height);
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    scrollView.delegate=self; 
    scrollView.tag=111;
    scrollView.scrollEnabled=YES;
    
    UILabel *lblHeader=[self createLabelWithTitle:@"Bartsy is your one stop to nightlife!" frame:CGRectMake(0, 0, 320, 40) tag:0 font:[UIFont boldSystemFontOfSize:18] color:[UIColor whiteColor] numberOfLines:1];
    lblHeader.textAlignment=NSTextAlignmentCenter;
    [scrollView addSubview:lblHeader];
    
    UIButton *btnMap=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"mapicon.png"] frame:CGRectMake(20, 45, 120, 120) tag:0 selector:@selector(buttonMap_TouchUpInside) target:self];
    [scrollView addSubview:btnMap];
    
    UILabel *lblMapText=[self createLabelWithTitle:@"See how busy Bartsy bars are and see who's there for unlocked bars" frame:CGRectMake(10, 165, 140, 50) tag:0 font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] numberOfLines:3];
    lblMapText.textAlignment=NSTextAlignmentCenter;
    [scrollView addSubview:lblMapText];

    
    UIButton *btnDrinks=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"drinks.png"] frame:CGRectMake(180, 45, 120, 120) tag:0 selector:@selector(buttonDrinks_TouchUpInside) target:self];
    [scrollView addSubview:btnDrinks];
    
    UILabel *lblDrinksText=[self createLabelWithTitle:@"Order drink for yourself, your friends or other singles at the bar" frame:CGRectMake(170, 165, 140, 50) tag:0 font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] numberOfLines:3];
    lblDrinksText.textAlignment=NSTextAlignmentCenter;
    [scrollView addSubview:lblDrinksText];
    
    UIButton *btnCreditCard=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"no_cards.png"] frame:CGRectMake(20, 230, 120, 120) tag:0 selector:@selector(btnCreditCard_TouchUpInside) target:self];
    [scrollView addSubview:btnCreditCard];
    
    UILabel *lblCreditCardText=[self createLabelWithTitle:@"Pay direclty within the app, never risking your credit card" frame:CGRectMake(10, 350, 140, 50) tag:0 font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] numberOfLines:3];
    lblCreditCardText.textAlignment=NSTextAlignmentCenter;
    [scrollView addSubview:lblCreditCardText];
    
    
    
    UIButton *btnLoyalityCard=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"loyalty_card.png"] frame:CGRectMake(180, 230, 120, 120) tag:0 selector:@selector(btnLoyalityCard_TouchUpInside) target:self];
    [scrollView addSubview:btnLoyalityCard];
    
    UILabel *lblLoyalityCardText=[self createLabelWithTitle:@"Build loyalty and reap rewards like skipping the outside line priviledges, free drinks, etc." frame:CGRectMake(170, 350, 140, 60) tag:0 font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] numberOfLines:4];
    lblLoyalityCardText.textAlignment=NSTextAlignmentCenter;
    [scrollView addSubview:lblLoyalityCardText];
    
    UIPageControl *pgControl=[[UIPageControl alloc] init];
    pgControl.numberOfPages=2;
    [pgControl addTarget:self action:@selector(pgControl_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    if (screenBounds.size.height == 568)
    {
        pgControl.frame=CGRectMake(125, 500, 60, 30);
    }
    else
    {
        pgControl.frame=CGRectMake(125, 405, 60, 30);
    }
    [self.view addSubview:pgControl];
    pgControl.tag=222;
    [pgControl release];

    UILabel *lblCopyRight=[self createLabelWithTitle:@"Bartsy is Copyright (C) Vendsy,Inc. All rights reserved." frame:CGRectMake(0, 435, 320, 25) tag:0 font:[UIFont systemFontOfSize:10] color:[UIColor whiteColor] numberOfLines:1];
    lblCopyRight.textAlignment=NSTextAlignmentCenter;
    [scrollView addSubview:lblCopyRight];
    
    UIButton *btnRefresh=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"arrow.png"] frame:CGRectMake(285, 415, 30, 40) tag:0 selector:@selector(btnRefresh_TouchUpInside) target:self];
    [scrollView addSubview:btnRefresh];
}


-(void)buttonMap_TouchUpInside
{
    
}

-(void)buttonDrinks_TouchUpInside
{
    
}

-(void)btnCreditCard_TouchUpInside
{
    
}

-(void)btnLoyalityCard_TouchUpInside
{
    
}

-(void)btnRefresh_TouchUpInside
{
    
}


-(void)pgControl_ValueChanged:(UIPageControl*)pageControl
{
    int intCurrentPage=pageControl.currentPage;    
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:111];
    [scrollView setContentOffset:CGPointMake(intCurrentPage*320, 0) animated:YES];
}

- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
	CGPoint offset = aScrollView.contentOffset;
    UIPageControl *pgControl=(UIPageControl*)[self.view viewWithTag:222];
	pgControl.currentPage = offset.x / 320.0f;
}




// FBSample logic
// main helper method to update the UI to reflect the current state of the session.
- (void)updateView {
    // get the app delegate, so that we can reference the session property

    UIButton *btnFb=(UIButton*)[self.view viewWithTag:111];
    if (appDelegate.session.isOpen)
    {
        // valid account UI is shown whenever the session is open
        [btnFb setTitle:@"Log out" forState:UIControlStateNormal];
       // [btnFb setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
                                     // appDelegate.session.accessTokenData.accessToken]];
    } else
    {
        // login-needed account UI is shown whenever the session is closed
        [btnFb setTitle:@"Log in" forState:UIControlStateNormal];
        //[btnFb setText:@"Login to create a link to fetch account data"];
    }
}

// FBSample logic
// handler for button click, logs sessions in or out
- (IBAction)buttonClickHandler:(id)sender {
    // get the app delegate so that we can access the session property
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else
    {
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
         }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
