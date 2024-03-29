//
//  PeopleDetailViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 24/06/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "PeopleDetailViewController.h"
#import "MessageListViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"

@interface PeopleDetailViewController ()

@end

@implementation PeopleDetailViewController
@synthesize dictPeople,TypeofView;

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
    [super viewWillAppear:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.delegateForCurrentViewController=self;
    
   // self.view.backgroundColor = [UIColor blackColor];
    
  /*  UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [self.view addSubview:imgViewForTop];
    [imgViewForTop release];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(5, 0, 50, 40);
    [btnBack addTarget:self action:@selector(btnBack_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    UIImageView *imgViewBack = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 12, 20)];
    imgViewBack.image = [UIImage imageNamed:@"arrow-left.png"];
    [btnBack addSubview:imgViewBack];
    [imgViewBack release];

    UIButton *btnTopShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTopShare.frame = CGRectMake(260, 0, 50, 40);
    [btnTopShare addTarget:self action:@selector(btnTopShare_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTopShare];
    
    UIImageView *imgViewTopShare = [[UIImageView alloc] initWithFrame:CGRectMake(18, 12, 25, 20)];
    imgViewTopShare.image = [UIImage imageNamed:@"right-arrow-top.png"];
    [btnTopShare addSubview:imgViewTopShare];
    [imgViewTopShare release];

    NSLog(@"People details is %@",dictPeople);
    UILabel *lblHeader=[self createLabelWithTitle:[dictPeople objectForKey:@"nickName"] frame:CGRectMake(5, 2, 320, 40) tag:0 font:[UIFont boldSystemFontOfSize:16] color:[UIColor blackColor] numberOfLines:1];
    lblHeader.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblHeader];*/
    lblNickName.text=[dictPeople objectForKey:@"nickName"];
    NSString *strURL=[NSString stringWithFormat:@"%@/%@",KServerURL,[dictPeople objectForKey:@"userImagePath"]];
    
    //UIImageView *imageForPeople = [[UIImageView alloc]initWithFrame:CGRectMake(20, 60, 130, 130)];
    [ProfileImage setImageWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    //[imageForPeople.layer setShadowColor:[[UIColor whiteColor] CGColor]];
    //[imageForPeople.layer setShadowOffset:CGSizeMake(0, 1)];
    //[imageForPeople.layer setShadowRadius:3.0];
    //[imageForPeople.layer setShadowOpacity:0.8];
   // [self.view addSubview:imageForPeople];
    //[imageForPeople release];
    
   /* UIButton *btnLike = [self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"liked-btn@2x.png"] frame:CGRectMake(165, 60, 126, 44) tag:1122 selector:@selector(btnLike_TouchUpInside) target:self];
    //[self.view addSubview:btnLike];
    
    UIButton *btnShare = [self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"share@2x.png"] frame:CGRectMake(165, 115, 126, 44) tag:2233 selector:@selector(btnShare_TouchUpInside) target:self];
    //[self.view addSubview:btnShare];*/

    //Age Calculation from the date of Birth
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *birthdate=[dateFormatter dateFromString:[dictPeople valueForKey:@"dateOfBirth"]];
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthdate
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];

    
    NSMutableString *strdetails=[[NSMutableString alloc]init];
    [strdetails appendFormat:@"%d",age];
    if ([dictPeople valueForKey:@"gender"]) {
        [strdetails appendFormat:@"/%@",[dictPeople valueForKey:@"gender"]];
    }
    
    if ([dictPeople valueForKey:@"orientation"]) {
        [strdetails appendFormat:@"/%@",[dictPeople valueForKey:@"orientation"]];
    }
    lbldetails.text=strdetails;
    
    lblStatus.text=[dictPeople valueForKey:@"status"];
    lblStatus.font=[UIFont fontWithName:@"Museo Sans" size:14];
    
    lbldetails.font=[UIFont fontWithName:@"Museo Sans" size:14];
   
    TxtViewDescription.font=[UIFont fontWithName:@"Museo Sans" size:14];
    TxtViewDescription.text=[dictPeople valueForKey:@"description"];
    TxtViewDescription.textColor=[UIColor whiteColor];
  /*  UIView *footerView = [self createViewWithFrame:CGRectMake(0, 350, 320, 65) tag:111];
    if (IS_IPHONE_5)
    {
        footerView.frame = CGRectMake(0, 360+77, 320, 65);
    }
    footerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"city_tavern_bg.png"]];
    [self.view addSubview:footerView];
    
    UIButton *btnSendMessage = [self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"send-message.png"] frame:CGRectMake(7, 9, 150, 44) tag:1111 selector:@selector(btnSendMessage_TouchUpInside) target:self];
        [footerView addSubview:btnSendMessage];*/
   
    NSString *strReseverID=[NSString stringWithFormat:@"%@",[dictPeople valueForKey:@"bartsyId"]];
    NSString *strSenderID=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]];
    
   if ([strReseverID isEqualToString:strSenderID]) {
     
       btnSendMsg.enabled=NO;

   }
   
    if (!IS_IPHONE_5) {
        
        Footview.frame=CGRectMake(Footview.frame.origin.x, Footview.frame.origin.y-80, Footview.frame.size.width, Footview.frame.size.height);
        btnSendMsg.frame=CGRectMake(btnSendMsg.frame.origin.x, btnSendMsg.frame.origin.y-80, btnSendMsg.frame.size.width, btnSendMsg.frame.size.height);
        btnSendDrink.frame=CGRectMake(btnSendDrink.frame.origin.x, btnSendDrink.frame.origin.y-80, btnSendDrink.frame.size.width, btnSendDrink.frame.size.height);
    }
    
   // UIButton *btnSendDrink = [self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"send-drink-hover.png"] frame:CGRectMake(163, 9, 150, 44) tag:2222 selector:@selector(btnSendDrink_TouchUpInside) target:self];
   // [footerView addSubview:btnSendDrink];

}
-(void)btnTopShare_TouchUpInside
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Block User",@"Report as Spam",nil];
    actionSheet.tag = 1;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(actionSheet.tag == 1 && buttonIndex ==0)
    {
    }
    if(actionSheet.tag == 1 && buttonIndex ==1)
    {
    }

}
-(void)btnLike_TouchUpInside
{
    
}
-(void)btnShare_TouchUpInside
{
    
}
-(IBAction)btnSendMessage_TouchUpInside
{
    MessageListViewController *obj = [[MessageListViewController alloc] init];
    obj.dictForReceiver = dictPeople;
    [self.navigationController pushViewController:obj animated:YES];
    [obj release];
}
-(IBAction)btnSendDrink_TouchUpInside
{
    appDelegate.isComingForMenu=YES;
    
    //Passing the dict value to HomeviewController
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PeopleSelected" object:dictPeople userInfo:nil];
   
    [self.navigationController popViewControllerAnimated:NO];

}
-(IBAction)btnBack_TouchUpInside
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnLike_TouchUpInside:(UIButton*)sender
{
    intLikeStatus=!intLikeStatus;
    isRequestForLike=YES;
    self.sharedController=[SharedController sharedController];
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    [self.sharedController likePeopleWithBartsyId:[dictPeople objectForKey:@"bartsyId"] status:intLikeStatus withDelegate:self];
}

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    [self hideProgressView:nil];
    
    if([[result objectForKey:@"errorCode"] integerValue]!=0)
    {
        [self createAlertViewWithTitle:@"Error" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
    }
    else if(isRequestForLike==YES)
    {
        UIButton *btnLike=(UIButton*)[self.view viewWithTag:777];
//        intLikeStatus=[[dictPeople objectForKey:@"like"] integerValue];
        if(intLikeStatus==1)
        {
            [btnLike setImage:[UIImage imageNamed:@"icon_favourite_unselect.png"] forState:UIControlStateNormal];
        }
        else
        {
            [btnLike setImage:[UIImage imageNamed:@"icon_favorites.png"] forState:UIControlStateNormal];
        }

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
