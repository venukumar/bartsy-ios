//
//  RewardsTableCell.h
//  Bartsy
//
//  Created by Techvedika on 7/18/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardsTableCell : UITableViewCell{
    
    UIImageView *venueImgview;
    
    UILabel *venueName;
    UILabel *venueaddress;
    UILabel *venuepoints;
    
}
@property(nonatomic,retain)UIImageView *venueImgview;
@property(nonatomic,retain)UILabel *venueName;
@property(nonatomic,retain)UILabel *venueaddress;
@property(nonatomic,retain)UILabel *venuepoints;
@end
