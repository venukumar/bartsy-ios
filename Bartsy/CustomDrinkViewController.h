//
//  CustomDrinkViewController.h
//  Bartsy
//
//  Created by Techvedika on 7/24/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDrinkViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSDictionary *dictCustomDrinks;
    int btnTag;
}
@property(nonatomic,retain) NSDictionary *dictCustomDrinks;
@end
