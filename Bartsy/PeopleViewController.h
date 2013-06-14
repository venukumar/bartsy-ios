//
//  PeopleViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 14/06/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleViewController : UITableViewController
{
    NSMutableArray *arrPeople;
    NSInteger btnValue;
}
@property(nonatomic,retain)NSMutableArray *arrPeople;
@end
