//
//  LoginViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 26/04/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "ProfileViewController.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <QuartzCore/QuartzCore.h>
#import "WebViewController.h"
@interface LoginViewController : BaseViewController<UIScrollViewDelegate,GPPSignInDelegate>
{
    
}
@end
