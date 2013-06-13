//
//  PastOrdersViewController.h
//  Bartsy
//
//  Created by Techvedika on 6/12/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PastOrdersViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(nonatomic,retain)NSMutableArray *arrayForPastOrders;
@end
