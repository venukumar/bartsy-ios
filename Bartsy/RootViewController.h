//
//  RootViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 11/07/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RootViewController : BaseViewController
{
    UITabBarController *tabBar;
}
@property (nonatomic,retain)UITabBarController *tabBar;
@end
