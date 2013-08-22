//
//  PeopleDetailViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 24/06/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

enum{
    
    
    PeopleDetails=1,
    ViewProfile=2
    
};
typedef NSInteger TypeofView;
@interface PeopleDetailViewController : BaseViewController<UIActionSheetDelegate>
{
    NSDictionary *dictPeople;
    NSInteger intLikeStatus;
    BOOL isRequestForLike;
    
    IBOutlet UIImageView *ProfileImage;
    
    IBOutlet UITextView *TxtViewDescription;
   
    IBOutlet UILabel *lblStatus;
    IBOutlet UILabel *lbldetails;
    IBOutlet UILabel *lblNickName;
    IBOutlet UIButton *btnSendMsg;
    IBOutlet UIButton *btnSendDrink;
    IBOutlet UIImageView *Footview;
    NSInteger TypeofView;
}
@property(nonatomic,retain)NSDictionary *dictPeople;
@property(nonatomic,assign)NSInteger TypeofView;
-(IBAction)btnBack_TouchUpInside;
-(IBAction)btnSendDrink_TouchUpInside;
-(IBAction)btnSendMessage_TouchUpInside;
@end
