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
    FavoriteView=4
    
};
typedef NSInteger viewtype;
@interface CustomDrinkViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSDictionary *dictitemdetails;
    
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

@end
