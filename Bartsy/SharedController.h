//
//  SharedController.h
//  DriverAnyWhere
//
//  Created by Sai Sridhar on 13/12/11.
//  Copyright 2011 Tech Vedika Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJSON.h"
#import "Reachability.h"
#import "NSNetwork.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
@protocol SharedControllerDelegate <NSObject>

-(void)controllerDidFinishLoadingWithResult:(id)result;
-(void)controllerDidFailLoadingWithError:(NSError*)error;

@end

@interface SharedController : NSObject
{
    id<SharedControllerDelegate> delegate;
    Reachability *reach;
    NSMutableData *data;
    AppDelegate *appDelegate;
    BOOL isMyWebservice;
}
@property (nonatomic,retain) NSMutableData *data;
@property(nonatomic,assign)id<SharedControllerDelegate> delegate;

+ (SharedController *)sharedController;
+ (AppDelegate*)appDelegate;


//Facebook SignIn and PRofile and Contacts
-(void)gettingUserProfileInformationWithAccessToken:(NSString*)strToken delegate:(id)aDelegate;

- (void)sendRequest:(NSMutableURLRequest *)urlRequest;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)aDelegate;
-(void)getMenuListWithVenueID:(NSString*)strVenueId delegate:(id)aDelegate;
-(void)getVenueListWithDelegate:(id)aDelegate;
-(void)saveProfileInfoWithId:(NSString*)strId name:(NSString*)strName loginType:(NSString*)strLoginType gender:(NSString*)strGender userName:(NSString*)strUserName profileImage:(UIImage*)imgProfile delegate:(id)aDelegate;
-(void)createOrderWithOrderStatus:(NSString*)strStatus basePrice:(NSString*)strBasePrice totalPrice:(NSString*)strTotalPrice tipPercentage:(NSString*)strPercentage itemName:(NSString*)strName produceId:(NSString*)strProdId delegate:(id)aDelegate;
@end
