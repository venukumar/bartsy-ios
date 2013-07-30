//
//  HomeViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 01/05/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AppDelegate.h"
#import "MobileDeviceLoginRequest.h"
#import "AuthNet.h"

@interface HomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,AuthNetDelegate>
{
    NSDictionary *dictSelectedToMakeOrder;
    BOOL isRequestForOrder;
    NSDictionary *dictVenue;
    BOOL isRequestForPeople;
    NSArray *arrStatus;
    NSMutableArray *arrBundledOrders;
    NSMutableDictionary *dictTemp;
    NSDictionary *dictPeopleSelectedForDrink;
    NSMutableArray *arrOrdersTimedOut;
    NSMutableArray *arrOrdersOffered;
    NSInteger intNoOfSections;

}
@property (nonatomic,retain)NSDictionary *dictPeopleSelectedForDrink;
@property(nonatomic,retain)NSDictionary *dictVenue;
-(void)orderTheDrink;
-(void)reloadDataPeopleAndOrderCount;
-(NSString*)getPredicateWithOrderStatus:(NSInteger)intStatus;
-(void)loadOrdersView;
-(UIColor*)getTheColorForOrderStatus:(NSInteger)intStatus;
-(void)updateOrderStatusForaOfferedDrinkWithStatus:(NSString*)strStatus withOrderId:(NSString*)strOrderId;
-(NSString*)getTheStatusMessageForOrder:(NSDictionary*)dictOrder;
-(void)showMultiItemOrderUI;
@end
