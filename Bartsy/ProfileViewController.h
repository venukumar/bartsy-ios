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
#import "VenueListViewController.h"

@interface ProfileViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView *customPickerView;
    UIBarButtonItem *barButtonPrev;
    UIBarButtonItem *barButtonNext;
    UIDatePicker *datePicker;
    UIPickerView *pickerViewForm;
    NSInteger intTextFieldTagValue;
    BOOL isSelectedPicker;
    NSInteger intIndex;
}
-(void)saveProfileData:(NSDictionary*)dict;
@end
