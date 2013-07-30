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
    CustomDrinksView=2
    
};
typedef NSInteger viewtype;
@interface CustomDrinkViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSDictionary *dictCustomDrinks;
    NSDictionary *dictitemdetails;
    
    NSInteger viewtype;
}
@property(nonatomic,retain) NSDictionary *dictCustomDrinks;
@property(nonatomic,retain) NSDictionary *dictitemdetails;

@property(nonatomic,assign)NSInteger viewtype;

@end
