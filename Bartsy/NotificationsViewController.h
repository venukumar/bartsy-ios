//
//  NotificationsViewController.h
//  Bartsy
//
//  Created by Techvedika on 6/20/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MessageListViewController.h"
enum{
    
    TabbarView=1,
    SettingView=2,
    
};
typedef NSInteger NotifViewType;
@interface NotificationsViewController : BaseViewController<SharedControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
    

}
@property(nonatomic,retain)NSMutableArray *arrayForNotifications;
@property(nonatomic,assign)NSInteger NotifViewType;
@end
