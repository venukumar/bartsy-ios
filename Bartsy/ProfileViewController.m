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
    
    self.trackedViewName = @"Profile Screen";

    self.view.backgroundColor=[UIColor blackColor];
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    scrollView.tag=143225;
    [self.view addSubview:scrollView];
    
    
    UILabel *lblHeader=[self createLabelWithTitle:@"Profile" frame:CGRectMake(0, 0, 320, 40) tag:0 font:[UIFont boldSystemFontOfSize:18] color:[UIColor whiteColor] numberOfLines:1];
    lblHeader.textAlignment=NSTextAlignmentCenter;
    [scrollView addSubview:lblHeader];
    
    [scrollView release];

    arrGender=[[NSArray alloc]initWithObjects:@"Female",@"Male", nil];
    arrOrientation=[[NSArray alloc]initWithObjects:@"I'm straight",@"I'm gay",@"I'm bisexual", nil];
    arrStatus=[[NSArray alloc]initWithObjects:@"I'm single",@"I'm seeing someone/here for friends",@"I'm married/here for friends", nil];
    
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    self.sharedController=[SharedController sharedController];
    [sharedController gettingUserProfileInformationWithAccessToken:appDelegate.session.accessTokenData.accessToken delegate:self];
    
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
    txtFldNickName.font=[UIFont systemFontOfSize:15];
    [scrollView addSubview:txtFldNickName];
    
    UILabel *lblPicture=[self createLabelWithTitle:@"Picture:" frame:CGRectMake(10, 150, 80, 30) tag:0 font:[UIFont boldSystemFontOfSize:15] color:[UIColor whiteColor] numberOfLines:1];
    lblPicture.textAlignment=NSTextAlignmentLeft;
    [scrollView addSubview:lblPicture];
    
    NSString *strURL=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[dict objectForKey:@"id"]];
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    UIImageView *imgViewProfilePicture=[self createImageViewWithImage:nil frame:CGRectMake(95, 155, 60, 60) tag:0];
    [imgViewProfilePicture setImageWithURL:url];
    [url release];
    [[imgViewProfilePicture layer] setShadowOffset:CGSizeMake(0, 1)];
    [[imgViewProfilePicture layer] setShadowColor:[[UIColor whiteColor] CGColor]];
    [[imgViewProfilePicture layer] setShadowRadius:3.0];
    [[imgViewProfilePicture layer] setShadowOpacity:0.8];
    imgViewProfilePicture.tag=111;
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
    txtFldDOB.text=@"Select D.O.B";
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

    
    UIButton *btnCancel=[self createUIButtonWithTitle:@"Cancel" image:nil frame:CGRectMake(10, 420, 100, 40) tag:0 selector:@selector(btnCancel_TouchUpInside) target:self];
    btnCancel.backgroundColor=[UIColor darkGrayColor];
    [self.view addSubview:btnCancel];
    
    UIButton *btnContinue=[self createUIButtonWithTitle:@"Save&Continue" image:nil frame:CGRectMake(150, 420, 150, 40) tag:0 selector:@selector(btnContinue_TouchUpInside) target:self];
    btnContinue.backgroundColor=[UIColor darkGrayColor];
    [self.view addSubview:btnContinue];
    
    [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(removeLoader) userInfo:nil repeats:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(customPickerView!=nil)
    {
        [customPickerView removeFromSuperview];
        [customPickerView release];
        customPickerView=nil;
    }
    UITextField *txtFldData=(UITextField*)[self.view viewWithTag:intTextFieldTagValue];
    [txtFldData resignFirstResponder];
    
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143225];

    intTextFieldTagValue=textField.tag;
    
    if(textField.tag==444||textField.tag==555||textField.tag==666||textField.tag==777)
    {
        [textField resignFirstResponder];
        [self showPickerView];

    }
    else if(textField.tag==888)
    {
        NSInteger index=intTextFieldTagValue/111;
        [scrollView setContentOffset:CGPointMake(0,(index-2)*30) animated:YES];
    }
}

-(void)showPickerView
{
    isSelectedPicker=NO;
    customPickerView.center =CGPointMake(160,700);

    if(customPickerView!=nil)
    {
        [customPickerView removeFromSuperview];
        [customPickerView release];
        customPickerView=nil;
    }
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143225];    
    NSInteger index=intTextFieldTagValue/111;
    
    [scrollView setContentOffset:CGPointMake(0,(index-2)*30) animated:YES];

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
    if(intTextFieldTagValue==444)
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
    UITextField *lblData=(UITextField*)[self.view viewWithTag:444];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:kDateMMDDYYYY];
    lblData.text = [NSString stringWithFormat:@"%@",
                            [df stringFromDate:datePicker.date]];
    [df release];
}


-(void)barButtonDone_onTouchUpInside:(id)sender
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143225];
    scrollView.userInteractionEnabled = YES;
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    UITextField *txtFldData=(UITextField*)[self.view viewWithTag:intTextFieldTagValue];

    if(intTextFieldTagValue==444)
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

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:143225];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
-(void)removeLoader
{
    [self hideProgressView:nil];
}


- (void)photoClicked
{
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
    }
    else if(buttonIndex==1)
    {
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil];
    [picker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    UIImage *img=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImageView *imgView=(UIImageView*)[self.view viewWithTag:111];
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
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    NSString *strId=[NSString stringWithFormat:@"%i",[[dict objectForKey:@"id"] integerValue]];
    UIImageView *imgViewProfilePic=(UIImageView*)[self.view viewWithTag:111];
    UITextField *txtFldFirstName=(UITextField*)[self.view viewWithTag:222];
    UITextField *txtFldLastName=(UITextField*)[self.view viewWithTag:333];
    UITextField *txtFldGender=(UITextField*)[self.view viewWithTag:555];
    UITextField *txtFldOrientation=(UITextField*)[self.view viewWithTag:666];
    UITextField *txtFldStatus=(UITextField*)[self.view viewWithTag:777];
    UITextField *txtFldDescription=(UITextField*)[self.view viewWithTag:888];
    UITextField *txtFldNickName=(UITextField*)[self.view viewWithTag:999];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:kDateMMDDYYYY];
    NSString *strDOB= [NSString stringWithFormat:@"%@",
                    [df stringFromDate:datePicker.date]];
    
    [sharedController saveProfileInfoWithId:strId name:[dict objectForKey:@"name"] loginType:@"0" gender:txtFldGender.text userName:[dict objectForKey:@"username"] profileImage:imgViewProfilePic.image firstName:txtFldFirstName.text lastName:txtFldLastName.text dob:strDOB orientation:txtFldOrientation.text status:txtFldStatus.text description:txtFldDescription.text nickName:txtFldNickName.text delegate:self];
    
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
