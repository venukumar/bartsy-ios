//
//  MixerViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 03/06/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "BaseViewController.h"

@interface MixerViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrMixers;
    NSDictionary *dictIngrident;
    NSDictionary *dictSelectedToMakeOrder;
    NSInteger btnValue;
    NSMutableDictionary *dictTemp;
    NSDictionary *dictPeopleSelectedForDrink;
}
@property (nonatomic,retain)NSDictionary *dictPeopleSelectedForDrink;
@property(nonatomic,retain)NSDictionary *dictIngrident;
@property(nonatomic,retain)NSMutableArray *arrMixers;
@property(nonatomic,retain)NSDictionary *dictSelectedToMakeOrder;
@end
