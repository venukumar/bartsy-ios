//
//  PeopleDetailViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 24/06/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface PeopleDetailViewController : BaseViewController
{
    NSDictionary *dictPeople;
    NSInteger intLikeStatus;
    BOOL isRequestForLike;
}
@property(nonatomic,retain)NSDictionary *dictPeople;
@end
