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
@interface UserProfileViewController : BaseViewController{
    
    IBOutlet UIImageView *ProfileImage;
    
    IBOutlet UITextView *Description;
    IBOutlet UILabel *lblStatus;
    IBOutlet UILabel *lbldetails;
    
}

@end
