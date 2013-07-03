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
//    [btnCustom setBackgroundImage:image forState:UIControlStateNormal];
    [btnCustom setImage:image forState:UIControlStateNormal];
    [btnCustom setTitle:strTitle forState:UIControlStateNormal];
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
    lbl.tag=intTag;
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

-(UITextField*)createTextFieldWithFrame:(CGRect)frame tag:(NSInteger)tag delegate:(id)
delegate
{
    UITextField *txtField=[[UITextField alloc] initWithFrame:frame];
    txtField.borderStyle = UITextBorderStyleRoundedRect;
    txtField.delegate=delegate;
    txtField.tag = tag;
//    txtField.textAlignment=UITextAlignmentCenter;
    txtField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    txtField.returnKeyType = UIReturnKeyDone;
    return txtField;
}

-(UIView*)createViewWithFrame:(CGRect)frame tag:(NSInteger)tag
{
     UIView *viewBg=[[UIView alloc]initWithFrame:frame];
    viewBg.backgroundColor=[UIColor clearColor];
    viewBg.tag=tag;
    return viewBg;
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

-(void)heartBeat
{
    self.sharedController=[SharedController sharedController];
    [self.sharedController heartBeatWithBartsyId:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] venueId:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] delegate:self];
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

- (UIImage *)scaleAndRotateImage:(UIImage *)img
{
    int kMaxResolution = 100;//1280; // Or whatever
    
    CGImageRef imgRef = img.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = img.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef contextImg = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(contextImg, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(contextImg, -height, 0);
    }
    else {
        CGContextScaleCTM(contextImg, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(contextImg, 0, -height);
    }
    
    CGContextConcatCTM(contextImg, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
