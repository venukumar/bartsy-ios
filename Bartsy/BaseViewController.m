//
//  BaseViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 26/04/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize progressView,sharedController,alertViewBase;

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
}

-(UIButton*)createUIButtonWithTitle:(NSString*)strTitle image:(UIImage*)image frame:(CGRect)frame tag:(NSInteger)intTag selector:(SEL)btnSelector target:(id)target
{
    UIButton *btnCustom=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCustom setTitle:strTitle forState:UIControlStateNormal];
    [btnCustom setBackgroundImage:image forState:UIControlStateNormal];
    [btnCustom addTarget:target action:btnSelector forControlEvents:UIControlEventTouchUpInside];
    btnCustom.tag=intTag;
    btnCustom.frame=frame;
    btnCustom.backgroundColor=[UIColor clearColor];
    return btnCustom;
}

-(UILabel*)createLabelWithTitle:(NSString*)strTitle frame:(CGRect)frame tag:(NSInteger)intTag font:(UIFont*)font color:(UIColor*)color numberOfLines:(NSInteger)intNoOflines
{
    UILabel *lbl=[[[UILabel alloc]initWithFrame:frame] autorelease];
    lbl.text=strTitle;
    lbl.font=font;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.textColor=color;
    lbl.numberOfLines=intNoOflines;
    return lbl;
}

-(UIImageView*)createImageViewWithImage:(UIImage*)image frame:(CGRect)frame tag:(NSInteger)intTag
{
    UIImageView *imgView=[[[UIImageView alloc]initWithFrame:frame] autorelease];
    imgView.image=image;
    imgView.tag=intTag;
    return imgView;
    
}

//Creating Progreessview wth label
- (UIAlertView *)createProgressViewToParentView:(UIView *)view withTitle:(NSString *)title
{
    if(progressView !=nil)
	{
		[progressView dismissWithClickedButtonIndex:0 animated:YES];
		progressView = nil;
		[progressView release];
		
	}
    
	progressView = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[progressView show];
	
	UIActivityIndicatorView *loaderView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(130, 60, 25, 25)];
	loaderView.tag = 3333;
	loaderView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	loaderView.backgroundColor = [UIColor clearColor];
	[progressView addSubview:loaderView];
	[loaderView startAnimating];
    [loaderView release];
	return progressView;
}

- (void)hideProgressView:(UIAlertView *)inProgressView
{
    
	if(progressView !=nil)
	{
		[progressView dismissWithClickedButtonIndex:0 animated:YES];
		progressView = nil;
		[progressView release];
	}
}

//Creating Progreessview wth label
- (void)createAlertViewWithTitle:(NSString *)strTitle message:(NSString*)strMsg cancelBtnTitle:(NSString*)strCancel otherBtnTitle:(NSString*)strTitle1 delegate:(id)delegate tag:(NSInteger)tag
{
    if(alertViewBase !=nil)
	{
		[alertViewBase dismissWithClickedButtonIndex:0 animated:YES];
        [alertViewBase release];
		alertViewBase = nil;
		
	}
    
    if(strTitle)
    {
        alertViewBase = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:delegate cancelButtonTitle:strCancel otherButtonTitles:strTitle1,nil];
        alertViewBase.tag=tag;
        [alertViewBase show];
    }
    else
    {
        alertViewBase = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:delegate cancelButtonTitle:strCancel otherButtonTitles:nil];
        alertViewBase.tag=tag;
        [alertViewBase show];
    }
	
}

-(void)hideAlertView
{
    
	if(alertViewBase !=nil)
	{
		[alertViewBase dismissWithClickedButtonIndex:0 animated:YES];
        [alertViewBase release];
		alertViewBase = nil;
		
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
