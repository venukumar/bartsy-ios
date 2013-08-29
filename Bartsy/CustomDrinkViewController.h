//
//  CustomDrinkViewController.h
//  Bartsy
//
//  Created by Techvedika on 7/24/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"
enum{
    
    LocuMenuView=1,
    CustomDrinksView=2,
    CocktailsView=3,
    RecentOrderView=4,
    FavoriteView=4,
    LocuOptionView=5
    
};
typedef NSInteger viewtype;
@interface CustomDrinkViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSDictionary *dictitemdetails;
    
    IBOutlet UILabel *titleName;
    IBOutlet UIButton *btnBack;
    IBOutlet UIButton *btnFavt;
    
    IBOutlet UIButton *btnCancel;
    IBOutlet UIButton *btnaddOrder;
    IBOutlet UIImageView *Footview;
    
    IBOutlet UIView *contentView;
    NSInteger viewtype;
    
    int arrIndex;
    
    NSInteger favoriteID;
    NSMutableArray *arrayEditInfo;
    BOOL isEdit;
}
@property(nonatomic,retain) NSDictionary *dictitemdetails;
@property(nonatomic,retain)NSMutableArray *arrayEditInfo;
@property(nonatomic,assign)NSInteger viewtype;
@property(nonatomic,assign)int arrIndex;
@property(nonatomic,assign)BOOL isEdit;
-(IBAction)btnBack_TouchUpInside;
-(IBAction)Button_Action:(UIButton*)sender;
-(IBAction)Button_Order:(UIButton*)button;
-(IBAction)FB_Like:(id)sender;
@end
