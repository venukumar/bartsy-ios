//
//  ProfileViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 30/04/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "RootViewController.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <QuartzCore/QuartzCore.h>
#import "CardIO.h"
#import "Crypto.h"

@interface ProfileViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,CardIOPaymentViewControllerDelegate>
{
    UIView *customPickerView;
    UIBarButtonItem *barButtonPrev;
    UIBarButtonItem *barButtonNext;
    UIDatePicker *datePicker;
    UIPickerView *pickerViewForm;
    NSInteger intTextFieldTagValue;
    BOOL isSelectedPicker;
    NSInteger intIndex;
    GTMOAuth2Authentication *auth;
    BOOL isProfileExistsCheck;
    BOOL isChecked;
    NSInteger intOrientation;
    NSString *strGender;
    UITextField *txtFldEmailId;
    UITextField *txtFldPassword;
    UIImageView *imgViewProfilePicture;
    UITextField *txtFldNickName;
    UITextView *txtViewDescription;
    BOOL isCmgFromGetStarted;
    BOOL isReloadingForProfileVisible;
    NSMutableDictionary *dictProfileData;
    CardIOCreditCardInfo *creditCardInfo;
    BOOL isCmgForLogin;
    BOOL isSelectedSingles;
    BOOL isSelectedFriends;
    BOOL isCmgForEditProfile;
    NSString *strPassword;
    NSString *strDOB;
    NSString *strServerPublicKey;
    UITextField *txtFldFirstName;
    UITextField *txtFldLastName;
    NSString *strFirstName;
    NSString *strLastName;
}
@property(nonatomic,retain)NSString *strDOB;
@property(nonatomic,retain)NSString *strPassword;
@property(nonatomic,assign)BOOL isCmgForEditProfile;
@property(nonatomic,assign)BOOL isCmgForLogin;
@property(nonatomic,retain)CardIOCreditCardInfo *creditCardInfo;
@property(nonatomic,retain)NSMutableDictionary *dictProfileData;
@property(nonatomic,assign)BOOL isReloadingForProfileVisible;
@property(nonatomic,assign)BOOL isCmgFromGetStarted;
@property(nonatomic,retain)NSString *strGender;
@property(nonatomic,retain)GTMOAuth2Authentication *auth;
@property(nonatomic,retain)UITextView *txtViewDescription;
@property(nonatomic,retain)NSString *strServerPublicKey;
@property(nonatomic,retain)NSString *strFirstName;
@property(nonatomic,retain)NSString *strLastName;
-(void)saveProfileData:(NSDictionary*)dict;
-(void)setImageWithURL:(NSURL*)url;
@end
