//
//  CustomDrinksViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 31/05/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CustomDrinksViewController : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger intCurrentPosition;
    NSMutableArray *arrCategories;
    NSMutableArray *arrIngridents;
}
@property(nonatomic,assign)NSInteger intCurrentPosition;
-(void)loadScreenWithCategories;
@end
