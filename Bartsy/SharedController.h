//
//  SharedController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 26/04/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJSON.h"
#import "Reachability.h"
#import "NSNetwork.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "Constants.h"

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
-(void)saveProfileInfoWithId:(NSString*)strId name:(NSString*)strName loginType:(NSString*)strLoginType gender:(NSString*)strGender userName:(NSString*)strUserName profileImage:(UIImage*)imgProfile firstName:(NSString*)strFirstName lastName:(NSString*)strLastName dob:(NSString*)strDOB orientation:(NSString*)strOrientation status:(NSString*)strStatus description:(NSString*)strDescription nickName:(NSString*)strNickName emailId:(NSString*)strEmailId showProfile:(NSString*)strShowProfileStatus creditCardNumber:(NSString*)strcreditCardNumber expiryDate:(NSString*)strExpiryDate expYear:(NSString*)strExpYear delegate:(id)aDelegate;
-(void)createOrderWithOrderStatus:(NSString*)strStatus basePrice:(NSString*)strBasePrice totalPrice:(NSString*)strTotalPrice tipPercentage:(NSString*)strPercentage itemName:(NSString*)strName produceId:(NSString*)strProdId description:(NSString*)strDescription receiverBartsyId:(NSString*)strReceiverId delegate:(id)aDelegate;
-(void)checkInAtBartsyVenueWithId:(NSString*)strVenueId delegate:(id)aDelegate;
-(void)checkOutAtBartsyVenueWithId:(NSString*)strVenueId delegate:(id)aDelegate;
-(void)gettingPeopleListFromVenue:(NSString*)strVenueId delegate:(id)aDelegate;
-(void)getUserOrdersWithBartsyId:(NSString*)strBartsyId delegate:(id)aDelegate;
-(void)heartBeatWithBartsyId:(NSString*)strBartsyId venueId:(NSString*)strVenueId delegate:(id)aDelegate;
-(void)getIngredientsListWithVenueId:(NSString*)strVenueId delegate:(id)aDelegate;
-(void)createOrderWithOrderStatus:(NSString*)strStatus basePrice:(NSString*)strBasePrice totalPrice:(NSString*)strTotalPrice tipPercentage:(NSString*)strPercentage itemName:(NSString*)strName produceId:(NSString*)strProdId description:(NSString*)strDescription ingredients:(NSArray*)arrIngredients delegate:(id)aDelegate;
-(void)syncUserDetailsWithUserName:(NSString*)strUserName type:(NSString*)strType bartsyId:(NSString*)strBartsyId delegate:(id)aDelegate;
@end
