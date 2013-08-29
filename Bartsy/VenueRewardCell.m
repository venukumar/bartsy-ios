//
//  VenueRewardCell.m
//  Bartsy
//
//  Created by Techvedika on 8/29/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "VenueRewardCell.h"

@implementation VenueRewardCell
@synthesize lblpoints,lblpointsDescription,redeemBtn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *arraynib=[[NSBundle mainBundle]loadNibNamed:@"VenueRewardCell" owner:self options:nil];
        self=[arraynib objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
