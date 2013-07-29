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
    UILabel *venuename;
    UILabel *description;
    UILabel *lblTime;
    UILabel *lblPickedtime;
    UILabel *lblSender;
    UILabel *lblRecepient;
    UILabel *lblTotalPrice;
    UILabel *lblOrderId;
}
@property(nonatomic,retain)UIImageView *statusimage;
@property(nonatomic,retain)UILabel *title;
@property(nonatomic,retain)UILabel *venuename;
@property(nonatomic,retain)UILabel *description;
@property(nonatomic,retain)UILabel *lblTime;
@property(nonatomic,retain)UILabel *lblPickedtime;
@property(nonatomic,retain)UILabel *lblSender;
@property(nonatomic,retain)UILabel *lblRecepient;
@property(nonatomic,retain)UILabel *lblTotalPrice;
@property(nonatomic,retain)UILabel *lblOrderId;
@end
