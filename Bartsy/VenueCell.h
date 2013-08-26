//
//  VenueCell.h
//  Bartsy
//
//  Created by Techvedika on 8/26/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueCell : UITableViewCell{
    
    IBOutlet UIImageView *imgVenue;
    IBOutlet UILabel *lblVenueName;
    IBOutlet UILabel *lblVenueAddress;
    IBOutlet UILabel *lblNoCheckin;
    IBOutlet UILabel *lblVenueStatus;
    IBOutlet UIImageView *imgwifi;
    IBOutlet UILabel *lbldistance;
    IBOutlet UILabel *lblmiles;
    IBOutlet UIImageView *imgChecked;
}
@property(nonatomic,retain)IBOutlet UIImageView *imgVenue,*imgwifi,*imgChecked;
@property(nonatomic,retain)IBOutlet UILabel *lblVenueName;
@property(nonatomic,retain)IBOutlet UILabel  *lblVenueAddress;
@property(nonatomic,retain)IBOutlet UILabel *lblNoCheckin;
@property(nonatomic,retain)IBOutlet UILabel *lblVenueStatus;
@property(nonatomic,retain)IBOutlet UILabel *lbldistance;
@property(nonatomic,retain)IBOutlet UILabel *lblmiles;

@end
