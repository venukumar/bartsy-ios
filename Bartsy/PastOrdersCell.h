//
//  PastOrdersCell.h
//  Bartsy
//
//  Created by Techvedika on 7/15/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PastOrdersCell : UITableViewCell{
    
    UIImageView *statusimage;
    
    UILabel *title;
    UILabel *address;
    UILabel *no_drinks;
    UILabel *drinkslbl;
}
@property(nonatomic,retain)UIImageView *statusimage;
@property(nonatomic,retain)UILabel *title;
@property(nonatomic,retain)UILabel *address;
@property(nonatomic,retain)UILabel *no_drinks;
@property(nonatomic,retain)UILabel *drinkslbl;
@end
