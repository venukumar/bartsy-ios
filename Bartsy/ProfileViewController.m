//
//  ProfileViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 30/04/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "HomeViewController.h"
#import "WelcomeViewController.h"
@interface ProfileViewController ()
{
    NSDictionary *dictResult;
    BOOL isRequestForSavingProfile;
}
@property (nonatomic,retain)NSDictionary *dictResult;
@end

@implementation ProfileViewController
@synthesize dictResult;
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor blackColor];
    
    UILabel *lblHeader=[self createLabelWithTitle:@"Profile" frame:CGRectMake(0, 0, 320, 40) tag:0 font:[UIFont boldSystemFontOfSize:18] color:[UIColor whiteColor] numberOfLines:1];
    lblHeader.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblHeader];
    
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    self.sharedController=[SharedController sharedController];
    [sharedController gettingUserProfileInformationWithAccessToken:appDelegate.session.accessTokenData.accessToken delegate:self];
    
}

-(void)loadProfileDetails:(NSDictionary*)dict
{
    UILabel *lblName=[self createLabelWithTitle:@"Name:" frame:CGRectMake(10, 50, 80, 30) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor whiteColor] numberOfLines:1];
    lblName.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:lblName];
    
    UILabel *lblNameValue=[self createLabelWithTitle:[dict objectForKey:@"name"] frame:CGRectMake(72, 50, 240, 30) tag:0 font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] numberOfLines:1];
    lblNameValue.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:lblNameValue];
    
    UILabel *lblPicture=[self createLabelWithTitle:@"Picture:" frame:CGRectMake(10, 80, 80, 30) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor whiteColor] numberOfLines:1];
    lblPicture.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:lblPicture];
    
    NSString *strURL=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[dict objectForKey:@"id"]];
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    
    UIImageView *imgViewProfilePicture=[self createImageViewWithImage:nil frame:CGRectMake(72, 80, 60, 60) tag:0];
    [imgViewProfilePicture setImageWithURL:url];
    [url release];
    [[imgViewProfilePicture layer] setShadowOffset:CGSizeMake(0, 1)];
    [[imgViewProfilePicture layer] setShadowColor:[[UIColor whiteColor] CGColor]];
    [[imgViewProfilePicture layer] setShadowRadius:3.0];
    [[imgViewProfilePicture layer] setShadowOpacity:0.8];
    imgViewProfilePicture.tag=111;
    [self.view addSubview:imgViewProfilePicture];
    
    
    UIButton *btnCancel=[self createUIButtonWithTitle:@"Cancel" image:nil frame:CGRectMake(10, 350, 100, 40) tag:0 selector:@selector(btnCancel_TouchUpInside) target:self];
    btnCancel.backgroundColor=[UIColor darkGrayColor];
    [self.view addSubview:btnCancel];
    
    UIButton *btnContinue=[self createUIButtonWithTitle:@"Save&Continue" image:nil frame:CGRectMake(150, 350, 150, 40) tag:0 selector:@selector(btnContinue_TouchUpInside) target:self];
    btnContinue.backgroundColor=[UIColor darkGrayColor];
    [self.view addSubview:btnContinue];
    
    [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(removeLoader) userInfo:nil repeats:NO];
}

-(void)removeLoader
{
    [self hideProgressView:nil];
}

-(void)btnCancel_TouchUpInside
{
    [appDelegate.session closeAndClearTokenInformation];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)btnContinue_TouchUpInside
{
    [self saveProfileData:dictResult];
}

-(void)saveProfileData:(NSDictionary*)dict
{
    isRequestForSavingProfile=YES;
    self.sharedController=[SharedController sharedController];
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    NSString *strId=[NSString stringWithFormat:@"%i",[[dict objectForKey:@"id"] integerValue]];
    UIImageView *imgViewProfilePic=(UIImageView*)[self.view viewWithTag:111];
    
    [sharedController saveProfileInfoWithId:strId name:[dict objectForKey:@"name"] loginType:@"0" gender:[dict objectForKey:@"gender"] userName:[dict objectForKey:@"username"] profileImage:imgViewProfilePic.image delegate:self];
}

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    
    
    if(isRequestForSavingProfile==NO)
    {
        [self loadProfileDetails:result];
        if(dictResult==nil)
        {
            dictResult=[[NSDictionary alloc] initWithDictionary:result];
        }
        else
        {
            [dictResult release];
            dictResult=nil;
            dictResult=[[NSDictionary alloc] initWithDictionary:result];
        }
        
    }
    else if(isRequestForSavingProfile==YES)
    {
        [self hideProgressView:nil];
        isRequestForSavingProfile=NO;
        
        NSManagedObjectContext *context=[appDelegate managedObjectContext];
        
        NSManagedObject *mngObjProfile=[NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context];
        [mngObjProfile setValue:[dictResult objectForKey:@"name"] forKey:@"name"];
        
        //    NSString *strURL=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[dict objectForKey:@"id"]];
        //    NSURL *url=[[NSURL alloc]initWithString:strURL];
        //    NSData *dataPhoto=[NSData dataWithContentsOfURL:url];
        //    [mngObjProfile setValue:dataPhoto forKey:@"photo"];
        [mngObjProfile setValue:[NSNumber numberWithInteger:[[result objectForKey:@"bartsyUserId"] integerValue]] forKey:@"bartsyId"];
        [context save:nil];
        
        [[NSUserDefaults standardUserDefaults]setObject:[result objectForKey:@"bartsyUserId"] forKey:@"bartsyId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if([[result objectForKey:@"userCheckedIn"] integerValue]==0)
        {
            [[NSUserDefaults standardUserDefaults]setObject:[result objectForKey:@"venueId"] forKey:@"CheckInVenueId"];
            NSDictionary *dictVenueDetails=[[NSDictionary alloc]initWithObjectsAndKeys:[result objectForKey:@"venueId"],@"venueId",[result objectForKey:@"venueName"],@"venueName", nil];
            [[NSUserDefaults standardUserDefaults]setObject:dictVenueDetails forKey:@"VenueDetails"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            WelcomeViewController *obj=[[WelcomeViewController alloc]init];
            [self.navigationController pushViewController:obj animated:YES];
            [obj release];
            
        }
        else
        {
            WelcomeViewController *obj=[[WelcomeViewController alloc]init];
            [self.navigationController pushViewController:obj animated:YES];
            [obj release];
        }
        
    }
}

-(void)controllerDidFailLoadingWithError:(NSError*)error
{
    
    [self hideProgressView:nil];
    [self createAlertViewWithTitle:@"Error" message:[error description] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
