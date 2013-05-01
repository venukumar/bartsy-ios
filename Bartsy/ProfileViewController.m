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
@interface ProfileViewController ()
{
    NSDictionary *dictResult;
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
    [self.view addSubview:imgViewProfilePicture];
    
    
    UIButton *btnCancel=[self createUIButtonWithTitle:@"Cancel" image:nil frame:CGRectMake(10, 350, 100, 40) tag:0 selector:@selector(btnCancel_TouchUpInside) target:self];
    btnCancel.backgroundColor=[UIColor darkGrayColor];
    [self.view addSubview:btnCancel];

    UIButton *btnContinue=[self createUIButtonWithTitle:@"Save&Continue" image:nil frame:CGRectMake(150, 350, 150, 40) tag:0 selector:@selector(btnContinue_TouchUpInside) target:self];
    btnContinue.backgroundColor=[UIColor darkGrayColor];
    [self.view addSubview:btnContinue];

}

-(void)btnCancel_TouchUpInside
{
    [appDelegate.session closeAndClearTokenInformation];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)btnContinue_TouchUpInside
{
    [self saveProfileData:dictResult];
    HomeViewController *obj=[[HomeViewController alloc]init];
    [self.navigationController pushViewController:obj animated:YES];
    [obj release];
}

-(void)saveProfileData:(NSDictionary*)dict
{
    NSManagedObjectContext *context=[appDelegate managedObjectContext];
    
    NSManagedObject *mngObjProfile=[NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context];
    [mngObjProfile setValue:[dict objectForKey:@"name"] forKey:@"name"];
    
    NSString *strURL=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[dict objectForKey:@"id"]];
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSData *dataPhoto=[NSData dataWithContentsOfURL:url];
    [mngObjProfile setValue:dataPhoto forKey:@"photo"];
    
    [context save:nil];
}

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    [self hideProgressView:nil];
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
