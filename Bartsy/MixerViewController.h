//
//  MixerViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 03/06/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MixerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrMixers;
}
@property(nonatomic,retain)NSMutableArray *arrMixers;
@end
