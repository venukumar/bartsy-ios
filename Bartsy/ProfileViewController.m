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
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define kDateMMDDYYYY                       @"MM/dd/yyyy"

@interface ProfileViewController ()
{
    NSDictionary *dictResult;
    BOOL isRequestForSavingProfile;
    NSArray *arrGender;
    NSArray *arrOrientation;
    NSArray *arrStatus;
}
@property (nonatomic,retain)NSDictionary *dictResult;
@end

@implementation ProfileViewController
@synthesize dictResult,auth,strGender,isCmgFromGetStarted;
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
    
    isChecked=YES;
    intOrientation=1;
    
    self.trackedViewName = @"Profile Screen";

    self.view.backgroundColor=[UIColor lightGrayColor];
    
//    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 405)];
//    scrollView.tag=143225;
//    scrollView.scrollEnabled=YES;
//    [self.view addSubview:scrollView];
//    [scrollView release];

        
    UILabel *lblHeader=[self createLabelWithTitle:@"Edit your profile" frame:CGRectMake(0, 0, 320, 40) tag:0 font:[UIFont boldSystemFontOfSize:18] color:[UIColor whiteColor] numberOfLines:1];
    lblHeader.backgroundColor=[UIColor blackColor];
    lblHeader.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblHeader];
    
    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, 320, 420) style:UITableViewStyleGrouped];
    tblView.backgroundColor=[UIColor clearColor];
    tblView.backgroundView=nil;
    tblView.dataSource=self;
    tblView.delegate=self;
    tblView.tag=143225;
    [self.view addSubview:tblView];
    [tblView release];


    arrGender=[[NSArray alloc]initWithObjects:@"Female",@"Male", nil];
    arrOrientation=[[NSArray alloc]initWithObjects:@"I'm straight",@"I'm gay",@"I'm bisexual", nil];
    arrStatus=[[NSArray alloc]initWithObjects:@"I'm single",@"I'm seeing someone/here for friends",@"I'm married/here for friends", nil];
    
    
    if(appDelegate.isLoginForFB==YES)
    {
        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        self.sharedController=[SharedController sharedController];
        [sharedController gettingUserProfileInformationWithAccessToken:appDelegate.session.accessTokenData.accessToken delegate:self];
    }
    else if(isCmgFromGetStarted==NO)
    {
        [self googlePlusDetails];
    }
   
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
{
    if(section==0)
    {
        return @"Account Information*";
    }
    else if(section==1)
    {
        return @"How venue staff will see you*";
    }
    else if(section==2)
    {
        return @"Payment Information";
    }
    else
    {
        return @"See and be seen";
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==3)
    return 50;
    else
        return 0;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==3)
    {
        UIView *viewFooter=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
        
        UIButton *btnCancel=[self createUIButtonWithTitle:@"Cancel" image:nil frame:CGRectMake(50, 5, 100, 40) tag:0 selector:@selector(btnCancel_TouchUpInside) target:self];
        btnCancel.titleLabel.font=[UIFont boldSystemFontOfSize:18];
        btnCancel.titleLabel.textColor=[UIColor blackColor];
        [viewFooter addSubview:btnCancel];
        
        UIButton *btnSubmit=[self createUIButtonWithTitle:@"Submit" image:nil frame:CGRectMake(160, 5, 100, 40) tag:0 selector:@selector(btnContinue_TouchUpInside) target:self];
        btnSubmit.titleLabel.font=[UIFont boldSystemFontOfSize:18];
        btnSubmit.titleLabel.textColor=[UIColor blackColor];
        [viewFooter addSubview:btnSubmit];
        
        return viewFooter;
    }
    else
        return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 85;
    }
    else if(indexPath.section==1)
    {
        return 120;
    }
    else if(indexPath.section==2)
    {
        return 50;
    }
    else
    {
        if(isChecked)
        return 300;
        else
            return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    cell.tag=indexPath.section+1;

    if(indexPath.section==0)
    {
        UILabel *lblEmailId=[self createLabelWithTitle:@"Email/userId:" frame:CGRectMake(10, 10, 100, 30) tag:0 font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] numberOfLines:1];
        lblEmailId.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:lblEmailId];
        
        txtFldEmailId=[self createTextFieldWithFrame:CGRectMake(110, 10, 180, 30) tag:111 delegate:self];
        txtFldEmailId.text=[dictResult objectForKey:@"username"];
        txtFldEmailId.placeholder=@"Email/userId";
        txtFldEmailId.font=[UIFont systemFontOfSize:15];
        [cell.contentView addSubview:txtFldEmailId];
        
        UILabel *lblPassword=[self createLabelWithTitle:@"Password:" frame:CGRectMake(10, 42, 100, 30) tag:0 font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] numberOfLines:1];
        lblPassword.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:lblPassword];
        
        txtFldPassword=[self createTextFieldWithFrame:CGRectMake(110, 42, 180, 30) tag:222 delegate:self];
        txtFldPassword.secureTextEntry=YES;
        txtFldPassword.placeholder=@"6 or more characters";
        txtFldPassword.font=[UIFont systemFontOfSize:15];
        [cell.contentView addSubview:txtFldPassword];

    }
    else if(indexPath.section==1)
    {
        NSString *strURL=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=100&height=100",[dictResult objectForKey:@"id"]];
        NSLog(@"Pic URL is %@",strURL);
        NSURL *url=[[NSURL alloc]initWithString:strURL];
        
        imgViewProfilePicture=[self createImageViewWithImage:nil frame:CGRectMake(5, 10, 100, 100) tag:0];
        if(appDelegate.isLoginForFB&&[[NSUserDefaults standardUserDefaults]objectForKey:@"GooglePlusAuth"]==nil)
            [imgViewProfilePicture setImageWithURL:url];
        else if([[dictResult objectForKey:@"url"] length])
            [imgViewProfilePicture setImageWithURL:[dictResult objectForKey:@"url"]];
        else
            [imgViewProfilePicture setImage:[UIImage imageNamed:@"DefaultUser.png"]];
        
        [url release];
        [[imgViewProfilePicture layer] setShadowOffset:CGSizeMake(0, 1)];
        [[imgViewProfilePicture layer] setShadowColor:[[UIColor redColor] CGColor]];
        [[imgViewProfilePicture layer] setShadowRadius:3.0];
        [[imgViewProfilePicture layer] setShadowOpacity:0.8];
        imgViewProfilePicture.tag=333;
        [cell.contentView addSubview:imgViewProfilePicture];
        [imgViewProfilePicture setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClicked)];
        [tap setNumberOfTouchesRequired:1];
        [tap setNumberOfTapsRequired:1];
        [imgViewProfilePicture addGestureRecognizer:tap];
        
        
        UILabel *lblNickName=[self createLabelWithTitle:@"Nick Name:" frame:CGRectMake(120, 10, 100, 20) tag:0 font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] numberOfLines:1];
        lblNickName.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:lblNickName];
        
        txtFldNickName=[self createTextFieldWithFrame:CGRectMake(120, 35, 150, 30) tag:444 delegate:self];
        txtFldNickName.placeholder=@"Nick Name";
        if([dictResult count])
        {
            if([dictResult objectForKey:@"nickname"]!=(id)[NSNull null]&&[[dictResult objectForKey:@"nickname"] length]&&[dictResult objectForKey:@"nickname"]!=nil)
                txtFldNickName.text=[NSString stringWithFormat:@"%@",[dictResult objectForKey:@"nickname"]];
            else if([[dictResult objectForKey:@"last_name"] length])
                txtFldNickName.text=[NSString stringWithFormat:@"%@ %@",[dictResult objectForKey:@"first_name"],[[dictResult objectForKey:@"last_name"] substringToIndex:1]];
            else
                txtFldNickName.text=[NSString stringWithFormat:@"%@",[dictResult objectForKey:@"first_name"]];
        }
        txtFldNickName.font=[UIFont systemFontOfSize:15];
        [cell.contentView addSubview:txtFldNickName];
        
        UILabel *lblMessage=[self createLabelWithTitle:@"<- Click on picture to change" frame:CGRectMake(120, 90, 180, 20) tag:0 font:[UIFont systemFontOfSize:12] color:[UIColor blackColor] numberOfLines:1];
        lblMessage.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:lblMessage];

    }
    else if(indexPath.section==2)
    {
        UIImageView *imgViewCreditCard=[self createImageViewWithImage:[UIImage imageNamed:@"creditcard.png"] frame:CGRectMake(5, 5, 41, 40) tag:0];
        [cell.contentView addSubview:imgViewCreditCard];

        
        UILabel *lblCreditCard=[self createLabelWithTitle:@"Add credit card..." frame:CGRectMake(50, 5, 120, 40) tag:0 font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] numberOfLines:1];
        lblCreditCard.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:lblCreditCard];
        
        [lblCreditCard setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnCreditCard_TouchUpInside)];
        [tap setNumberOfTouchesRequired:1];
        [tap setNumberOfTapsRequired:1];
        [lblCreditCard addGestureRecognizer:tap];
        
        UIView *viewLine=[[UIView alloc]initWithFrame:CGRectMake(180, 18, 1, 20)];
        viewLine.backgroundColor=[UIColor lightGrayColor];
        [cell.contentView addSubview:viewLine];
        [viewLine release];
        
        UILabel *lblPaypal=[self createLabelWithTitle:@"Add PayPal..." frame:CGRectMake(184, 5, 115, 40) tag:0 font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] numberOfLines:1];
        lblPaypal.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:lblPaypal];
        
        [lblPaypal setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tapForPaypal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnPaypal_TouchUpInside)];
        [tapForPaypal setNumberOfTouchesRequired:1];
        [tapForPaypal setNumberOfTapsRequired:1];
        [lblPaypal addGestureRecognizer:tapForPaypal];
        
        
    }
    else
    {
        UILabel *lblCheck=[self createLabelWithTitle:@"Check to see others:" frame:CGRectMake(10, 10, 150, 30) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:1];
        lblCheck.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:lblCheck];
        
        UIButton *btnCheckbox=[self createUIButtonWithTitle:@"" image:nil frame:CGRectMake(155, 10, 28, 28) tag:0 selector:@selector(btnCheckbox_TouchUpInside) target:self];
        if(isChecked)
            [btnCheckbox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        else
            [btnCheckbox setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

        [cell.contentView addSubview:btnCheckbox];

        UILabel *lblProfile=[self createLabelWithTitle:@"Profile Visible" frame:CGRectMake(190, 10, 150, 30) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:1];
        lblProfile.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:lblProfile];
        
        if(isChecked)
        {
            UILabel *lblDescription=[self createLabelWithTitle:@"Description:" frame:CGRectMake(10, 50, 200, 20) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:1];
            lblDescription.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:lblDescription];
            
            txtViewDescription=[[UITextView alloc] initWithFrame:CGRectMake(10, 70, 280, 50)];
            txtViewDescription.tag=555;
            txtViewDescription.delegate=self;
            txtViewDescription.text=@"Enter something about you that you'd like others to see while you're checked in at a venue";
            [[txtViewDescription layer]setBorderWidth:1];
            [[txtViewDescription layer]setBorderColor:[[UIColor blackColor] CGColor]];
            [[txtViewDescription layer]setCornerRadius:5];
            txtViewDescription.textColor=[UIColor lightGrayColor];
            txtViewDescription.font=[UIFont systemFontOfSize:12];
            [cell.contentView addSubview:txtViewDescription];
            
            UILabel *lblGender=[self createLabelWithTitle:@"Gender:" frame:CGRectMake(10, 133, 120, 20) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:1];
            lblGender.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:lblGender];
            
            UIButton *btnMale=[self createUIButtonWithTitle:@"" image:nil frame:CGRectMake(90, 130, 28, 28) tag:0 selector:@selector(btnGender_TouchUpInside:) target:self];
            btnMale.tag=143;
            if([[dictResult objectForKey:@"gender"] isEqualToString:@"male"])
            {
                [btnMale setImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
                self.strGender=[[NSString stringWithFormat:@"Male"] retain];
            }
            else
                [btnMale setImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btnMale];
            
            
            UILabel *lblMale=[self createLabelWithTitle:@"Male" frame:CGRectMake(125, 133, 50, 20) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:1];
            lblMale.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:lblMale];
            
            UIButton *btnFeMale=[self createUIButtonWithTitle:@"" image:nil frame:CGRectMake(180, 130, 28, 28) tag:0 selector:@selector(btnGender_TouchUpInside:) target:self];
            btnFeMale.tag=225;
            if([[dictResult objectForKey:@"gender"] isEqualToString:@"female"])
            {
                self.strGender=[[NSString stringWithFormat:@"Female"] retain];
                [btnFeMale setImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
            }
            else 
                [btnFeMale setImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btnFeMale];
            
            
            UILabel *lblFeMale=[self createLabelWithTitle:@"Female" frame:CGRectMake(210, 133, 120, 20) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:1];
            lblFeMale.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:lblFeMale];
            
            UILabel *lblDOB=[self createLabelWithTitle:@"Date of birth:" frame:CGRectMake(10, 170, 120, 20) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:1];
            lblDOB.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:lblDOB];
            
            
            UITextField *txtFldDOB=[self createTextFieldWithFrame:CGRectMake(95, 165, 150, 30) tag:666 delegate:self];
            txtFldDOB.placeholder=@"MM/DD/YYYY";
            txtFldDOB.font=[UIFont systemFontOfSize:15];
            [cell.contentView addSubview:txtFldDOB];
            
            
            UILabel *lblOrientation=[self createLabelWithTitle:@"Orientation:" frame:CGRectMake(10, 205, 80, 20) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:1];
            lblOrientation.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:lblOrientation];
            
            
            UIButton *btnStraight=[self createUIButtonWithTitle:@"" image:nil frame:CGRectMake(90, 205, 28, 28) tag:999 selector:@selector(btnOrientation_TouchUpInside:) target:self];
            if(intOrientation==1)
                [btnStraight setImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
            else
                [btnStraight setImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btnStraight];
            
            
            UILabel *lblStraight=[self createLabelWithTitle:@"Straight" frame:CGRectMake(135, 208, 50, 20) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:1];
            lblStraight.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:lblStraight];
            
            
            UIButton *btnGay=[self createUIButtonWithTitle:@"" image:nil frame:CGRectMake(90, 235, 28, 28) tag:888 selector:@selector(btnOrientation_TouchUpInside:) target:self];
            if(intOrientation==2)
                [btnGay setImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
            else
                [btnGay setImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btnGay];
            
            
            UILabel *lblGay=[self createLabelWithTitle:@"Gay" frame:CGRectMake(135, 238, 50, 20) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:1];
            lblGay.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:lblGay];
            
            UIButton *btnBisexual=[self createUIButtonWithTitle:@"" image:nil frame:CGRectMake(90, 265, 28, 28) tag:777 selector:@selector(btnOrientation_TouchUpInside:) target:self];
            if(intOrientation==3)
                [btnBisexual setImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
            else
                [btnBisexual setImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btnBisexual];
            
            
            UILabel *lblBisexual=[self createLabelWithTitle:@"Bisexual" frame:CGRectMake(135, 268, 100, 20) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:1];
            lblBisexual.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:lblBisexual];

        }
                
        
    }
    
    return cell;
}

-(void)btnCreditCard_TouchUpInside
{
    
}

-(void)btnPaypal_TouchUpInside
{
    
}

-(void)btnCheckbox_TouchUpInside
{
    isChecked=!isChecked;
    isReloadingForProfileVisible=YES;
    UITableView *tblView=(UITableView*)[self.view viewWithTag:143225];
    [tblView reloadData];
}

-(void)btnGender_TouchUpInside:(UIButton*)sender
{
    
    if([self.strGender length]==0)
    {
        [sender setImage:[UIImage imageNamed:@"radio_button_selected1.png"]  forState:UIControlStateNormal];
        self.strGender=[NSString stringWithFormat:@"%@",(sender.tag==143?@"Male":@"Female")];
    }
    else if([self.strGender length]&&sender.tag==143)
    {
        [sender setImage:[UIImage imageNamed:@"radio_button_selected1.png"]  forState:UIControlStateNormal];
        UIButton *btnFemale=(UIButton*)[self.view viewWithTag:225];
        [btnFemale setImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
        self.strGender=[NSString stringWithFormat:@"Male"];
    }
    else if([self.strGender length]&&sender.tag==225)
    {
        [sender setImage:[UIImage imageNamed:@"radio_button_selected1.png"]  forState:UIControlStateNormal];
        UIButton *btnFemale=(UIButton*)[self.view viewWithTag:143];
        [btnFemale setImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
        self.strGender=[NSString stringWithFormat:@"Female"];
    }
}

-(void)btnOrientation_TouchUpInside:(UIButton*)sender
{
    UIButton *btnStraight=(UIButton*)[self.view viewWithTag:999];
    UIButton *btnGay=(UIButton*)[self.view viewWithTag:888];
    UIButton *btnBisexual=(UIButton*)[self.view viewWithTag:777];

    if(sender.tag==999)
    {
        intOrientation=1;
        [btnStraight setImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
        [btnGay setImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
        [btnBisexual setImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];

    }
    else if(sender.tag==888)
    {
        intOrientation=2;
        [btnGay setImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
        [btnStraight setImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
        [btnBisexual setImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
    }
    else if(sender.tag==777)
    {
        intOrientation=3;
        [btnBisexual setImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
        [btnStraight setImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
        [btnGay setImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)googlePlusDetails
{
    NSMutableDictionary *dictGoogle=[[NSMutableDictionary alloc]init];
    
    //GTMOAuth2Authentication *auth=[[NSUserDefaults standardUserDefaults]objectForKey:@"GooglePlusAuth"];
    
    NSString  *accessTocken = [auth valueForKey:@"accessToken"]; // access tocken pass in .pch file
    [accessTocken retain];
    NSString *str =  [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/userinfo?access_token=%@",accessTocken];
    NSString* escapedUrl = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",escapedUrl]];
    NSString *jsonData = [[NSString alloc] initWithContentsOfURL:url usedEncoding:nil error:nil];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSString *userId=[jsonDictionary objectForKey:@"id"];
    [dictGoogle setObject:[jsonDictionary objectForKey:@"email"] forKey:@"username"];
    NSLog(@" user deata %@",jsonData);
    NSLog(@"Received Access Token:%@",auth);
    
    //
    GTLServicePlus* plusService = [[[GTLServicePlus alloc] init] autorelease];
    plusService.retryEnabled = YES;
    [plusService setAuthorizer:auth];
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:userId];
    
    [plusService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,GTLPlusPerson *person,NSError *error)
     {
         if (error)
         {
             GTMLoggerError(@"Error: %@", error);
         }
         else
         {
             // Retrieve the display name and "about me" text
             [person retain];
             GTLPlusPersonImage *image  =person.image;
             NSString *strimag=[image valueForKey:@"url"];
             if(person.displayName!=nil)
             [dictGoogle setObject:person.displayName forKey:@"first_name"];
             
             [dictGoogle setObject:@"" forKey:@"last_name"];

             if(person.gender!=nil)
             [dictGoogle setObject:person.gender  forKey:@"gender"];
             if(strimag!=nil)
             [dictGoogle setObject:strimag forKey:@"url"];
             if(person.nickname!=nil)
             [dictGoogle setObject:person.nickname forKey:@"nickname"];
             if(dictResult==nil)
             {
                 dictResult=[[NSDictionary alloc] initWithDictionary:dictGoogle];
             }
             else
             {
                 [dictResult release];
                 dictResult=nil;
                 dictResult=[[NSDictionary alloc] initWithDictionary:dictGoogle];
             }
             
             isProfileExistsCheck=YES;
             [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
             self.sharedController=[SharedController sharedController];
             [sharedController syncUserDetailsWithUserName:[dictResult objectForKey:@"username"] type:@"login" bartsyId:@"" delegate:self];
         }
     }];

}

-(void)loadProfileDetails:(NSDictionary*)dict
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143225];
    
    UILabel *lblName=[self createLabelWithTitle:@"First Name:" frame:CGRectMake(10, 50, 100, 30) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor whiteColor] numberOfLines:1];
    lblName.textAlignment=NSTextAlignmentLeft;
    [scrollView addSubview:lblName];
    
    UITextField *txtFldFirstName=[self createTextFieldWithFrame:CGRectMake(95, 50, 200, 30) tag:222 delegate:self];
    txtFldFirstName.text=[dict objectForKey:@"first_name"];
    txtFldFirstName.font=[UIFont systemFontOfSize:15];
    [scrollView addSubview:txtFldFirstName];
    
    UILabel *lblLastName=[self createLabelWithTitle:@"Last Name:" frame:CGRectMake(10, 80, 100, 30) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor whiteColor] numberOfLines:1];
    lblLastName.textAlignment=NSTextAlignmentLeft;
    [scrollView addSubview:lblLastName];
    
    UITextField *txtFldLastName=[self createTextFieldWithFrame:CGRectMake(95, 80, 200, 30) tag:333 delegate:self];
    txtFldLastName.text=[dict objectForKey:@"last_name"];
    txtFldLastName.font=[UIFont systemFontOfSize:15];
    [scrollView addSubview:txtFldLastName];
    
    UILabel *lblNickName=[self createLabelWithTitle:@"Nick Name:" frame:CGRectMake(10, 115, 100, 30) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor whiteColor] numberOfLines:1];
    lblNickName.textAlignment=NSTextAlignmentLeft;
    [scrollView addSubview:lblNickName];
    
    UITextField *txtFldNickName=[self createTextFieldWithFrame:CGRectMake(95, 115, 200, 30) tag:999 delegate:self];
    txtFldNickName.placeholder=@"Nick Name";
    txtFldNickName.text=[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"first_name"],[[dict objectForKey:@"last_name"] substringToIndex:1]];
    txtFldNickName.font=[UIFont systemFontOfSize:15];
    [scrollView addSubview:txtFldNickName];
    
    UILabel *lblPicture=[self createLabelWithTitle:@"Picture:" frame:CGRectMake(10, 150, 80, 30) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor whiteColor] numberOfLines:1];
    lblPicture.textAlignment=NSTextAlignmentLeft;
    [scrollView addSubview:lblPicture];
    
    NSString *strURL=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[dict objectForKey:@"id"]];
    NSLog(@"Pic URL is %@",strURL);
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    UIImageView *imgViewProfilePicture=[self createImageViewWithImage:nil frame:CGRectMake(95, 155, 60, 60) tag:0];
   
    if(appDelegate.isLoginForFB&&[[NSUserDefaults standardUserDefaults]objectForKey:@"GooglePlusAuth"]==nil)
    [imgViewProfilePicture setImageWithURL:url];
    else
    [imgViewProfilePicture setImageWithURL:[dict objectForKey:@"url"]];

    [url release];
    [[imgViewProfilePicture layer] setShadowOffset:CGSizeMake(0, 1)];
    [[imgViewProfilePicture layer] setShadowColor:[[UIColor whiteColor] CGColor]];
    [[imgViewProfilePicture layer] setShadowRadius:3.0];
    [[imgViewProfilePicture layer] setShadowOpacity:0.8];
    imgViewProfilePicture.tag=333;
    [scrollView addSubview:imgViewProfilePicture];
    [imgViewProfilePicture setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClicked)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [imgViewProfilePicture addGestureRecognizer:tap];
    
    
    UILabel *lblDOB=[self createLabelWithTitle:@"D.O.B:" frame:CGRectMake(10, 225, 80, 30) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor whiteColor] numberOfLines:1];
    lblDOB.textAlignment=NSTextAlignmentLeft;
    [scrollView addSubview:lblDOB];
    
    UITextField *txtFldDOB=[self createTextFieldWithFrame:CGRectMake(95, 225, 200, 30) tag:444 delegate:self];
    txtFldDOB.placeholder=@"Select D.O.B";
    txtFldDOB.font=[UIFont systemFontOfSize:15];
    [scrollView addSubview:txtFldDOB];
    
    UILabel *lblGender=[self createLabelWithTitle:@"Gender:" frame:CGRectMake(10, 255, 80, 30) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor whiteColor] numberOfLines:1];
    lblGender.textAlignment=NSTextAlignmentLeft;
    [scrollView addSubview:lblGender];
    
    UITextField *txtFldGender=[self createTextFieldWithFrame:CGRectMake(95, 255, 200, 30) tag:555 delegate:self];
    txtFldGender.text=[dict objectForKey:@"gender"];
    txtFldGender.font=[UIFont systemFontOfSize:15];
    [scrollView addSubview:txtFldGender];
    
    UILabel *lblOrientation=[self createLabelWithTitle:@"Orientation:" frame:CGRectMake(10, 285, 80, 30) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor whiteColor] numberOfLines:1];
    lblOrientation.textAlignment=NSTextAlignmentLeft;
    [scrollView addSubview:lblOrientation];
    
    UITextField *txtFldOrientation=[self createTextFieldWithFrame:CGRectMake(95, 285, 200, 30) tag:666 delegate:self];
    txtFldOrientation.text=@"I'm straight";
    txtFldOrientation.font=[UIFont systemFontOfSize:14];
    [scrollView addSubview:txtFldOrientation];
    
    UILabel *lblStatus=[self createLabelWithTitle:@"Status:" frame:CGRectMake(10, 315, 80, 30) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor whiteColor] numberOfLines:1];
    lblStatus.textAlignment=NSTextAlignmentLeft;
    [scrollView addSubview:lblStatus];
    
    UITextField *txtFldStatus=[self createTextFieldWithFrame:CGRectMake(95, 315, 200, 30) tag:777 delegate:self];
    txtFldStatus.text=@"I'm single";
    txtFldStatus.font=[UIFont systemFontOfSize:14];
    [scrollView addSubview:txtFldStatus];
    
    UILabel *lblDescription=[self createLabelWithTitle:@"Description:" frame:CGRectMake(10, 345, 80, 30) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor whiteColor] numberOfLines:1];
    lblDescription.textAlignment=NSTextAlignmentLeft;
    [scrollView addSubview:lblDescription];
    
    UITextField *txtFldDescription=[self createTextFieldWithFrame:CGRectMake(95, 345, 200, 30) tag:888 delegate:self];
    txtFldDescription.placeholder=@"Description";
    txtFldDescription.font=[UIFont systemFontOfSize:14];
    [scrollView addSubview:txtFldDescription];
    
    UILabel *lblEmailId=[self createLabelWithTitle:@"Email Id:" frame:CGRectMake(10, 375, 80, 30) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor whiteColor] numberOfLines:1];
    lblEmailId.textAlignment=NSTextAlignmentLeft;
    [scrollView addSubview:lblEmailId];
    
    UITextField *txtFldEmailId=[self createTextFieldWithFrame:CGRectMake(95, 375, 200, 30) tag:1110 delegate:self];
    txtFldEmailId.placeholder=@"Email Id";
    txtFldEmailId.font=[UIFont systemFontOfSize:14];
    [scrollView addSubview:txtFldEmailId];

    
    UIButton *btnCancel=[self createUIButtonWithTitle:@"Cancel" image:nil frame:CGRectMake(10, 420, 100, 40) tag:0 selector:@selector(btnCancel_TouchUpInside) target:self];
    btnCancel.backgroundColor=[UIColor darkGrayColor];
    [self.view addSubview:btnCancel];
    
    UIButton *btnContinue=[self createUIButtonWithTitle:@"Save&Continue" image:nil frame:CGRectMake(150, 420, 150, 40) tag:0 selector:@selector(btnContinue_TouchUpInside) target:self];
    btnContinue.backgroundColor=[UIColor darkGrayColor];
    [self.view addSubview:btnContinue];
    
    [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(removeLoader) userInfo:nil repeats:NO];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UITableView *tblView=(UITableView*)[self.view viewWithTag:143225];    
    [tblView setContentOffset:CGPointMake(0,400) animated:YES];
    
    if([textView.text isEqualToString:@"Enter something about you that you'd like others to see while you're checked in at a venue"])
    {
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    else if([textView.text length]==0&&range.length==1)
    {
        textView.text=@"Enter something about you that you'd like others to see while you're checked in at a venue";
        textView.textColor=[UIColor lightGrayColor];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(customPickerView!=nil)
    {
        [customPickerView removeFromSuperview];
        [customPickerView release];
        customPickerView=nil;
    }
    
//    for (int i=2; i<=10; i++)
//    {
//        UITextField *txtFldData=(UITextField*)[self.view viewWithTag:111*i];
//        if(textField.tag!=i*111)
//        [txtFldData resignFirstResponder];
//    }
    
    UITableView *tblView=(UITableView*)[self.view viewWithTag:143225];
    intTextFieldTagValue=textField.tag;
    
    if(textField.tag==444)
    [tblView setContentOffset:CGPointMake(0,100) animated:YES];

    
    if(textField.tag==666)    {
        [textField resignFirstResponder];
        [tblView setContentOffset:CGPointMake(0,480) animated:YES];
        [self showPickerView];

    }
    /*
    else if(textField.tag==888||textField.tag==1110)
    {
        NSInteger index=intTextFieldTagValue/111;
        [scrollView setContentOffset:CGPointMake(0,(index-2)*30) animated:YES];
    }
     */
    
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
//    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143225];
//    scrollView.contentSize=CGSizeMake(320, 405);
//    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//    scrollView.scrollEnabled=NO;
    
    UITableView *tblView=(UITableView*)[self.view viewWithTag:143225];
    [tblView setContentOffset:CGPointMake(0,0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

-(void)showPickerView
{
    isSelectedPicker=NO;
    customPickerView.center =CGPointMake(160,700);

    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143225];

    UITextField *txtFldData=(UITextField*)[self.view viewWithTag:intTextFieldTagValue];
    [txtFldData resignFirstResponder];
    
    UITextField *txtFldData1=(UITextField*)[scrollView viewWithTag:intTextFieldTagValue];
    [txtFldData1 resignFirstResponder];

    
    if(customPickerView!=nil)
    {
        [customPickerView removeFromSuperview];
        [customPickerView release];
        customPickerView=nil;
    }
    NSInteger index=intTextFieldTagValue/111;
    
    //[scrollView setContentOffset:CGPointMake(0,(index-2)*30) animated:YES];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    customPickerView.center =CGPointMake(160,700);
	[UIView commitAnimations];
    
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,650,320,235)];
    customPickerView.tag = 200;
	[self.view addSubview:customPickerView];
    
	//Adding toolbar
	UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    barButtonPrev = [[[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleDone target:self action:@selector(barButtonPrev_onTouchUpInside:)] autorelease];
    
    barButtonNext = [[[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(barButtonNext_onTouchUpInside:)] autorelease];
    UIBarButtonItem *barButtonDone;
    
    barButtonDone = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonDone_onTouchUpInside:)] autorelease];
    
	UIBarButtonItem *barButtonSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    //toolBar.items = [[[NSArray alloc] initWithObjects:barButtonPrev,barButtonNext,barButtonSpace,barButtonDone,nil] autorelease];
    toolBar.items = [[[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] autorelease];
    [customPickerView addSubview:toolBar];
	[toolBar release];
	    
    barButtonPrev.enabled=YES;
    barButtonNext.enabled=YES;
    
    //Adding picker view
    if(intTextFieldTagValue==666)
    {
        datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.hidden = NO;
        datePicker.backgroundColor=[UIColor clearColor];
        datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [datePicker addTarget:self
                       action:@selector(changeDateFromLabel:)
             forControlEvents:UIControlEventValueChanged];
        [customPickerView addSubview:datePicker];
    }
    else
    {
        pickerViewForm=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
        pickerViewForm.delegate=self;
        pickerViewForm.dataSource=self;
        pickerViewForm.showsSelectionIndicator = YES;
        pickerViewForm.backgroundColor=[UIColor clearColor];
        [customPickerView addSubview:pickerViewForm];
    }
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if (IS_IPHONE_5)
    {
        customPickerView.center =CGPointMake(160,420);
    }
    else
    {
        customPickerView.center =CGPointMake(160,320);
    }
    
    [UIView commitAnimations];
    [self.view bringSubviewToFront:customPickerView];
}

- (void)changeDateFromLabel:(id)sender
{    
    UITextField *lblData=(UITextField*)[self.view viewWithTag:666];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:kDateMMDDYYYY];
    lblData.text = [NSString stringWithFormat:@"%@",
                            [df stringFromDate:datePicker.date]];
    [df release];
}


-(void)barButtonDone_onTouchUpInside:(id)sender
{
    UITableView *scrollView=(UITableView*)[self.view viewWithTag:143225];
    scrollView.userInteractionEnabled = YES;
    
    UITextField *txtFldData=(UITextField*)[self.view viewWithTag:intTextFieldTagValue];

    if(intTextFieldTagValue==666)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:kDateMMDDYYYY];
        txtFldData.text = [NSString stringWithFormat:@"%@",
                                [df stringFromDate:datePicker.date]];
        [df release];
    }
    else
    {
        if(intTextFieldTagValue==555)
        {
            txtFldData.text =[arrGender objectAtIndex:intIndex];
        }
        else if(intTextFieldTagValue==666)
        {
            txtFldData.text= [arrOrientation objectAtIndex:intIndex];
        }
        else
        {
            txtFldData.text= [arrStatus objectAtIndex:intIndex];
        }
    }
   	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	customPickerView.center =CGPointMake(160,700);
	[UIView commitAnimations];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    if(intTextFieldTagValue==555)
    {
        return [arrGender count];
    }
    else if(intTextFieldTagValue==666)
    {
        return [arrOrientation count];
    }
    else
    {
        return [arrStatus count];
    }
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(intTextFieldTagValue==555)
    {
        return [arrGender objectAtIndex:row];
    }
    else if(intTextFieldTagValue==666)
    {
        return [arrOrientation objectAtIndex:row];
    }
    else
    {
        return [arrStatus objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    isSelectedPicker=YES;
    
    intIndex=row;
    
    UITextField *txtFldData=(UITextField*)[self.view viewWithTag:intTextFieldTagValue];
    if(intTextFieldTagValue==555)
    {
        txtFldData.text =[arrGender objectAtIndex:row];
    }
    else if(intTextFieldTagValue==666)
    {
        txtFldData.text= [arrOrientation objectAtIndex:row];
    }
    else
    {
        txtFldData.text= [arrStatus objectAtIndex:row];
    }
}


-(void)removeLoader
{
    [self hideProgressView:nil];
}


- (void)photoClicked
{
    if(customPickerView!=nil)
    {
        [customPickerView removeFromSuperview];
        [customPickerView release];
        customPickerView=nil;
    }
    UITextField *txtFldData=(UITextField*)[self.view viewWithTag:intTextFieldTagValue];
    [txtFldData resignFirstResponder];
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"Capturing Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Photo",@"Select a Photo from Gallery", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    if(buttonIndex==0)
    {
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if(buttonIndex==1)
    {
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
    [picker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    UIImage *img=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImageView *imgView=(UIImageView*)[self.view viewWithTag:333];
    imgView.image=img;
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
    //NSString *strId=[NSString stringWithFormat:@"%i",[[dict objectForKey:@"id"] integerValue]];
    
   


    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:kDateMMDDYYYY];
    NSString *strDOB= [NSString stringWithFormat:@"%@",
                    [df stringFromDate:datePicker.date]];
    
    if([strDOB length]==0||strDOB==nil||strDOB==(id)[NSNull null])
    strDOB=@"";
    
    NSString *strOrientation=[NSString stringWithFormat:@"%@",(intOrientation==1?@"Straight":(intOrientation==2?@"Gay":@"Bisexual"))];
    
    if(imgViewProfilePicture.image!=nil&&[txtFldEmailId.text length]&&[txtFldPassword.text length]>=6&&[txtFldNickName.text length])
    {
            [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
            [sharedController saveProfileInfoWithId:txtFldPassword.text name:@"" loginType:@"0" gender:strGender userName:txtFldEmailId.text profileImage:imgViewProfilePicture.image firstName:@"" lastName:@"" dob:strDOB orientation:strOrientation status:@"" description:txtViewDescription.text nickName:txtFldNickName.text emailId:@"" delegate:self];
        
       
    }
    else
        [self createAlertViewWithTitle:@"" message:@"Username,password,profile picture, nick name should not be empty" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
    
}

-(BOOL)validemail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
    return [emailTest evaluateWithObject:candidate];
}

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    [self hideProgressView:nil];
    
    if(isRequestForSavingProfile==NO&&isProfileExistsCheck==NO)
    {
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
        
        isProfileExistsCheck=YES;
        [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
        self.sharedController=[SharedController sharedController];
        [sharedController syncUserDetailsWithUserName:[result objectForKey:@"username"] type:@"login" bartsyId:@"" delegate:self];
    }
    else if(isProfileExistsCheck==YES)
    {
        isProfileExistsCheck=NO;
        if([[result objectForKey:@"errorCode"] integerValue]==1)
        {
            UITableView *tblView=(UITableView*)[self.view viewWithTag:143225];
            [tblView reloadData];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setObject:[result objectForKey:@"bartsyId"] forKey:@"bartsyId"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            if([[result objectForKey:@"venueId"] integerValue]&&[result objectForKey:@"venueId"]!=nil)
            {
                [[NSUserDefaults standardUserDefaults]setObject:[result objectForKey:@"venueId"] forKey:@"CheckInVenueId"];
                NSDictionary *dictVenueDetails=[[NSDictionary alloc]initWithObjectsAndKeys:[result objectForKey:@"venueId"],@"venueId",[result objectForKey:@"venueName"],@"venueName", nil];
                [[NSUserDefaults standardUserDefaults]setObject:dictVenueDetails forKey:@"VenueDetails"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                appDelegate.intOrderCount=[[result objectForKey:@"orderCount"]integerValue];
                appDelegate.intPeopleCount=[[result objectForKey:@"userCount"]integerValue];
                
                
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
    else if(isRequestForSavingProfile==YES)
    {
        [self hideProgressView:nil];
        isRequestForSavingProfile=NO;
        
        
        if([[result objectForKey:@"errorCode"] integerValue]==0)
        {
            NSManagedObjectContext *context=[appDelegate managedObjectContext];
            
            NSManagedObject *mngObjProfile=[NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context];
            [mngObjProfile setValue:[dictResult objectForKey:@"name"] forKey:@"name"];
            
            //    NSString *strURL=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[dict objectForKey:@"id"]];
            //    NSURL *url=[[NSURL alloc]initWithString:strURL];
            //    NSData *dataPhoto=[NSData dataWithContentsOfURL:url];
            //    [mngObjProfile setValue:dataPhoto forKey:@"photo"];
            [mngObjProfile setValue:[NSNumber numberWithInteger:[[result objectForKey:@"bartsyUserId"] integerValue]] forKey:@"bartsyId"];
            [context save:nil];
            
            [[NSUserDefaults standardUserDefaults]setObject:[result objectForKey:@"bartsyId"] forKey:@"bartsyId"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            if([[result objectForKey:@"userCheckedIn"] integerValue]==0&&[result objectForKey:@"userCheckedIn"]!=nil)
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
        else
        {
            [self createAlertViewWithTitle:@"Error" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
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
