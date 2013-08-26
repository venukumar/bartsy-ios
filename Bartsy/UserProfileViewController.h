//
//  UserProfileViewController.h
//  Bartsy
//
//  Created by Techvedika on 8/22/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
@interface UserProfileViewController : BaseViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>{
    
    IBOutlet UIImageView *ProfileImage;
    IBOutlet UIScrollView *scrollview;
    
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPswd;
    IBOutlet UITextField *txtConfirmPswd;
    IBOutlet UITextField *txtNickname;
    IBOutlet UITextField *txtDOB;

    NSArray   *arrayGender;
    NSArray   *arrayLookingTo;
    NSArray   *arrayOrientation;
    
    BOOL isChecked;
    NSInteger intOrientation;
    NSString *strServerPublicKey;
    
    NSMutableDictionary *dictProfileInfo;
}
-(IBAction)btnBack_TouchUpInside;
@property(nonatomic,retain)IBOutlet UITextField *txtEmail;
@property(nonatomic,retain)IBOutlet UITextField *txtPswd;
@property(nonatomic,retain)IBOutlet UITextField *txtConfirmPswd;
@property(nonatomic,retain)IBOutlet UITextField *txtNickname;
@property(nonatomic,retain)IBOutlet UITextField *txtDOB;
@property(nonatomic,retain)IBOutlet UITextField *txtGender;
@property(nonatomic,retain)IBOutlet UITextField *txtLookingto;
@property(nonatomic,retain)IBOutlet UITextField *txtOrientation;
@property(nonatomic,retain)IBOutlet UITextView *txtdescription;
@property(nonatomic,retain)IBOutlet UIDatePicker *datepicker;
@property(nonatomic,retain)IBOutlet UIPickerView *pickerObj;
@property(nonatomic,retain)IBOutlet UIView *accesoryView;
-(IBAction)Dateformate:(id)sender;
-(IBAction)DismissPicker:(id)sender;
-(IBAction)UpdateProfile;
-(IBAction)Selectprofilepic:(id)sender;
@end
