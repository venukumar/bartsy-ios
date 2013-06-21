//
//  MessageListViewController.h
//  Bartsy
//
//  Created by Techvedika on 6/20/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface MessageListViewController : BaseViewController<SharedControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
}
@property(nonatomic,retain)NSDictionary *dictForReceiver;
@end
