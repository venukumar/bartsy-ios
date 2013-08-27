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
#import "PeopleCell.h"
@interface HomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,AuthNetDelegate>
{
    NSDictionary *dictSelectedToMakeOrder;
    BOOL isRequestForOrder;
    NSDictionary *dictVenue;
    BOOL isRequestForPeople;
    NSArray *arrStatus;
    NSMutableArray *arrBundledOrders;
    //NSMutableDictionary *dictTemp;
    NSDictionary *dictPeopleSelectedForDrink;
    NSMutableArray *arrOrdersTimedOut;
    NSMutableArray *arrOrdersOffered;
    NSInteger intNoOfSections;
    
    BOOL isLocuMenu;
    IBOutlet UIScrollView *scrollmain;
    IBOutlet UIButton *btnDismiss;
    IBOutlet UILabel *lblOrderStatus,*lblOrderID,*lblPlacedtime,*lblExpires,*lblIOrdertemName,*lblOrderOpt_Desp,*lblItemPrice, *lblOrderTip, *lblOrderTax, *lblOrderTotal,*lblOrderCode;
    IBOutlet UIButton *btnAccept;
    IBOutlet UIButton *btnReject;
    IBOutlet UIImageView *imgSender;
   
    IBOutlet UILabel *lblfOrderStatus,*lblfOrderID,*lblfPlacedtime,*lblfExpires,*lblfOrdertemName,*lblfOrderOpt_Desp,*lblfItemPrice, *lblfOrderTip, *lblfOrderTax, *lblfOrderTotal;
    IBOutlet UIImageView *Senderimg,*Recieverimg;
    IBOutlet UILabel *lblfOrdersender,*lblfOrderreciever;
    IBOutlet UIButton *btnfDismiss;
    IBOutlet UILabel *lblPickInfo;

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
-(IBAction)btnDismiss_TouchUpInside:(UIButton*)sender;
-(IBAction)btnReject_TouchUpInside:(UIButton*)sender;
-(IBAction)btnAccept_TouchUpInside:(UIButton*)sender;
@end
