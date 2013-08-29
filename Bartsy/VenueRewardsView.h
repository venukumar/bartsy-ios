//
//  VenueRewardsView.h
//  Bartsy
//
//  Created by Techvedika on 8/29/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UIImageView+WebCache.h"
#import "VenueRewardCell.h"
@interface VenueRewardsView : BaseViewController{
    
    IBOutlet UITableView *venueTable;
    
    IBOutlet UIImageView *VenueImg;
    IBOutlet UILabel *VenueName;
    IBOutlet UILabel *Venueaddress;
    IBOutlet UILabel *Venuerewards;
    
    NSMutableArray *arrRewards;
}
-(IBAction)btnBack_TouchUpInside;
@property(nonatomic,retain)NSDictionary *dictVenueInfo;
@end
