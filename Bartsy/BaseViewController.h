//
//  BaseViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 26/04/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SharedController.h"
@interface BaseViewController : UIViewController
{
    AppDelegate *appDelegate;
    UIAlertView *progressView;
    SharedController *sharedController;
    UIAlertView *alertViewBase;
}
@property (nonatomic,retain)UIAlertView *alertViewBase;
@property (nonatomic, retain) UIAlertView *progressView;
@property (nonatomic, assign) SharedController *sharedController;

-(UIButton*)createUIButtonWithTitle:(NSString*)strTitle image:(UIImage*)image frame:(CGRect)frame tag:(NSInteger)intTage selector:(SEL)btnSelector target:(id)target;
-(UILabel*)createLabelWithTitle:(NSString*)strTitle frame:(CGRect)frame tag:(NSInteger)intTag font:(UIFont*)font color:(UIColor*)color numberOfLines:(NSInteger)intNoOflines;
-(UIImageView*)createImageViewWithImage:(UIImage*)image frame:(CGRect)frame tag:(NSInteger)intTag;

- (UIAlertView *)createProgressViewToParentView:(UIView *)view withTitle:(NSString *)title;
- (void)hideProgressView:(UIAlertView *)inProgressView;

- (void)createAlertViewWithTitle:(NSString *)strTitle message:(NSString*)strMsg cancelBtnTitle:(NSString*)strCancel otherBtnTitle:(NSString*)strTitle1 delegate:(id)delegate tag:(NSInteger)tag;
- (void)hideAlertView;
@end
