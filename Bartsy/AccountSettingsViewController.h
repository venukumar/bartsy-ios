//
//  AccountSettingsViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 7/10/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WebViewController.h"
#import "ProfileViewController.h"
@interface AccountSettingsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arySettings;
    NSMutableArray *aryMsg;
}
@end
