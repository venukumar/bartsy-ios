//
//  UserSettingsView.h
//  Bartsy
//
//  Created by Techvedika on 8/22/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserProfileViewController.h"
#import "AccountInfoViewController.h"
#import "PaymentEditView.h"
#import "NotificationsViewController.h"
#import "PastOrderView.h"
#import "FavouriteViewController.h"
@interface UserSettingsView : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITableView *tableview;
    NSMutableArray *tblArray_Obj;
    
}

@end
