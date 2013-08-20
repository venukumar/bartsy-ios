//
//  RewardsTableCell.m
//  Bartsy
//
//  Created by Techvedika on 7/18/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "RewardsTableCell.h"

@implementation RewardsTableCell
@synthesize venueImgview,venueName,venueaddress,venuepoints;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        venueImgview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 18, 60, 60)];
        [self.contentView addSubview:venueImgview];
        
        venueName=[[UILabel alloc] initWithFrame:CGRectMake(85, 5, 250, 20) ];
        venueName.font=[UIFont systemFontOfSize:17];
        venueName.font=[UIFont fontWithName:@"MuseoSans-300" size:17.0];
        venueName.backgroundColor=[UIColor clearColor];
        venueName.textColor=[UIColor whiteColor];
        venueName.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:venueName];
        
       /* UIImageView *addresimg=[[UIImageView alloc]initWithFrame:CGRectMake(71, 36, 12.5, 15.5)];
        addresimg.image=[UIImage imageNamed:@"map"];
        [self.contentView addSubview:addresimg];
        [addresimg release];*/
        venueaddress=[[UILabel alloc]initWithFrame:CGRectMake(85,25,250,40)];
        venueaddress.font=[UIFont systemFontOfSize:12];
        venueaddress.backgroundColor=[UIColor clearColor];
        venueaddress.font=[UIFont fontWithName:@"Museo Sans" size:12.0];
        venueaddress.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        venueaddress.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:venueaddress];
        
        venuepoints=[[UILabel alloc]initWithFrame:CGRectMake(85,45, 250, 40)];
        venuepoints.font=[UIFont systemFontOfSize:10];
        venuepoints.backgroundColor=[UIColor clearColor];
        venuepoints.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        venuepoints.textAlignment=NSTextAlignmentLeft;
        venuepoints.font=[UIFont fontWithName:@"Museo Sans" size:10.0];
        [self.contentView addSubview:venuepoints];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
