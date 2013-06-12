//
//  MyRewardsViewController.m
//  Bartsy
//
//  Created by Techvedika on 6/12/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "MyRewardsViewController.h"
#import "Constants.h"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface MyRewardsViewController ()
{
    UIView *customPickerView;
    UIDatePicker *pickerViewDate;
    UIBarButtonItem *barButtonPrev;
    UIBarButtonItem *barButtonNext;
    UIScrollView *scrollView;
}
@end

@implementation MyRewardsViewController

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
    self.title = @"My Rewards";
    self.navigationController.navigationBarHidden=NO;
    self.sharedController=[SharedController sharedController];

    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
    scrollView.tag=111;
    [self.view addSubview:scrollView];
    [scrollView release];

    UILabel *lblDate = [self createLabelWithTitle:@"Date:" frame:CGRectMake(50, 30, 200, 40) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor blackColor] numberOfLines:1];
    lblDate.backgroundColor=[UIColor clearColor];
    lblDate.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:lblDate];
    
//    NSString *strDOB= [NSString stringWithFormat:@"%@",
//                       [df stringFromDate:datePicker.date]];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:kDateMMDDYYYY];
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *dateString = [dateFormat stringFromDate:today];
    [dateFormat release];

    UIButton *btnDate = [self createUIButtonWithTitle:nil image:[UIImage imageNamed:@"box.png"] frame:CGRectMake(155, 35, 150, 30) tag:0 selector:@selector(btnDate_TouchUpInside) target:self];
    [scrollView addSubview:btnDate];

    UILabel *lblDateValue = [self createLabelWithTitle:dateString frame:CGRectMake(5, -5, 200, 40) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor blackColor] numberOfLines:1];
    lblDateValue.tag = 225;
    lblDateValue.backgroundColor = [UIColor clearColor];
    lblDateValue.textAlignment = NSTextAlignmentLeft;
    [btnDate addSubview:lblDateValue];
    
    UILabel *lblStartIndex = [self createLabelWithTitle:@"Start Index:" frame:CGRectMake(50, 70, 200, 40) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor blackColor] numberOfLines:1];
    lblStartIndex.backgroundColor = [UIColor clearColor];
    lblStartIndex.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:lblStartIndex];
    
    UITextField *txtFldStartIndex = [self createTextFieldWithFrame:CGRectMake(155, 75, 150, 30) tag:666 delegate:self];
    txtFldStartIndex.keyboardType = UIKeyboardTypeNumberPad;
    txtFldStartIndex.font = [UIFont systemFontOfSize:15];
    [scrollView addSubview:txtFldStartIndex];

    UILabel *lblNoofResults = [self createLabelWithTitle:@"No of results:" frame:CGRectMake(50, 110, 200, 40) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor blackColor] numberOfLines:1];
    lblNoofResults.backgroundColor = [UIColor clearColor];
    lblNoofResults.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:lblNoofResults];
    
    UITextField *txtFldResults = [self createTextFieldWithFrame:CGRectMake(155, 115, 150, 30) tag:777 delegate:self];
    txtFldResults.keyboardType = UIKeyboardTypeNumberPad;
    txtFldResults.font = [UIFont systemFontOfSize:15];
    [scrollView addSubview:txtFldResults];

    UIButton *btnContinue=[self createUIButtonWithTitle:@"Save&Continue" image:nil frame:CGRectMake(90, 180, 150, 40) tag:0 selector:@selector(btnContinue_TouchUpInside) target:self];
    btnContinue.backgroundColor=[UIColor darkGrayColor];
    [scrollView addSubview:btnContinue];

	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.delegateForCurrentViewController=self;
}
-(void)btnDate_TouchUpInside
{
    UITextField *txtFldStartIndex = (UITextField*)[self.view viewWithTag:666];
    [txtFldStartIndex resignFirstResponder];
    
    UITextField *txtFldResults = (UITextField*)[self.view viewWithTag:777];
    [txtFldResults resignFirstResponder];

    [self designPickerView:@"Date"];
}
-(void)btnContinue_TouchUpInside
{
   UILabel *lblDateValue = (UILabel*)[self.view viewWithTag:225];
    UITextField *txtFldStartIndex = (UITextField*)[self.view viewWithTag:666];
    UITextField *txtFldResults = (UITextField*)[self.view viewWithTag:777];
    if ([txtFldStartIndex.text length] == 0)
    {
        [self.sharedController showAlertWithTitle:@"Error" message:@"Please enter Start index" delegate:self];
        return;
    }
    else if ([txtFldResults.text length] == 0)
    {
        [self.sharedController showAlertWithTitle:@"Error" message:@"Please enter result value" delegate:self];
        return;
    }
    NSLog(@"text is %@,%@,%@",txtFldStartIndex.text,txtFldResults.text,lblDateValue.text);
}

-(void)designPickerView:(NSString*)type
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    customPickerView.center =CGPointMake(160,700);
    [UIView commitAnimations];
    
    customPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,650,320,300)];
	customPickerView.tag = 300;
	[self.view addSubview:customPickerView];
    
    if (IS_IPHONE_5) {
        customPickerView.center = CGPointMake(160,480);
    }
    else
    {
        customPickerView.center = CGPointMake(160,306);
    }
    
    //Adding toolbar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
//    barButtonPrev = [[[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleDone target:self action:@selector(barButtonPrev_onTouchUpInside:)] autorelease];
    
//    barButtonNext = [[[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(barButtonNext_onTouchUpInside:)] autorelease];
    
    UIBarButtonItem *barButtonSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(barButtonDone_onTouchUpInside:)];
    
    toolBar.items = [[[NSArray alloc] initWithObjects:barButtonSpace,barButtonDone,nil] autorelease];
    [customPickerView addSubview:toolBar];
    [toolBar release];
    
    if([type isEqualToString:@"Date"])
    {        
        pickerViewDate= [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, 320, 250)];
        pickerViewDate.datePickerMode = UIDatePickerModeDate;
        pickerViewDate.hidden = NO;
        pickerViewDate.tag = 444;
        pickerViewDate.backgroundColor=[UIColor clearColor];
        pickerViewDate.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [pickerViewDate addTarget:self
                           action:@selector(changeDateFromLabel:)
                 forControlEvents:UIControlEventValueChanged];
        [customPickerView addSubview:pickerViewDate];
    }

    if([type isEqualToString:@"TextField"])
    {
        if (IS_IPHONE_5)
        {
            customPickerView.center = CGPointMake(160,394);
        }
        else
        {
            customPickerView.center = CGPointMake(160,306);
        }
    }
}
- (void)changeDateFromLabel:(id)sender
{
    UILabel *lblDateValue = (UILabel*)[self.view viewWithTag:225];

	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:kDateMMDDYYYY];
	lblDateValue.text = [NSString stringWithFormat:@"%@",
                         [df stringFromDate:pickerViewDate.date]];
	[df release];
}

-(void)barButtonDone_onTouchUpInside:(UIButton *)sender
{
    scrollView.scrollEnabled = YES;
    
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    UITextField *txtFldStartIndex = (UITextField*)[self.view viewWithTag:666];
    [txtFldStartIndex resignFirstResponder];
    
    UITextField *txtFldResults = (UITextField*)[self.view viewWithTag:777];
    [txtFldResults resignFirstResponder];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    customPickerView.center = CGPointMake(160,700);
    [UIView commitAnimations];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == 666) {
        [scrollView setContentOffset:CGPointMake(0,10) animated:YES];
    }
    else if (textField.tag == 777) {
        [scrollView setContentOffset:CGPointMake(0,50) animated:YES];
    }
    [self designPickerView:@"TextField"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
