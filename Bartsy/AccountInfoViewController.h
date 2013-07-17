//
//  AccountInfoViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 11/07/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UIImageView+WebCache.h"
#import "AccountSettingsViewController.h"
#import "PastOrdersCell.h"
#import "SDImageCache.h"
@interface AccountInfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    
    id resultAccountInfo;
}
@property(nonatomic,retain)id resultAccountInfo;
@end
