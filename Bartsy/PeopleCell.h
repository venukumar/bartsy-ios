//
//  PeopleCell.h
//  Bartsy
//
//  Created by Techvedika on 8/26/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UIImageView *imgProfile;
@property(nonatomic,retain)IBOutlet UILabel *lblName;
@property(nonatomic,retain)IBOutlet UIImageView *imgExclation;
@property(nonatomic,retain)IBOutlet UILabel *lbldetails;
@property(nonatomic,retain)IBOutlet UIImageView *imgRelation;
@property(nonatomic,retain)IBOutlet UILabel *lblStatus;
@property(nonatomic,retain)IBOutlet UIImageView *imgMsg;
@property(nonatomic,retain)IBOutlet UILabel *lblMessage;
@end
