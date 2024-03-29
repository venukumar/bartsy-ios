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
//-(void)saveProfileInfoWithId:(NSString*)strId name:(NSString*)strName loginType:(NSString*)strLoginType gender:(NSString*)strGender userName:(NSString*)strUserName profileImage:(UIImage*)imgProfile firstName:(NSString*)strFirstName lastName:(NSString*)strLastName dob:(NSString*)strDOB orientation:(NSString*)strOrientation status:(NSString*)strStatus description:(NSString*)strDescription nickName:(NSString*)strNickName emailId:(NSString*)strEmailId showProfile:(NSString*)strShowProfileStatus creditCardNumber:(NSString*)strcreditCardNumber expiryDate:(NSString*)strExpiryDate expYear:(NSString*)strExpYear delegate:(id)aDelegate;
-(void)saveUserProfileWithBartsyLogin:(NSString*)strBartsyLogin bartsyPassword:(NSString*)strBartsyPassword fbUserName:(NSString*)strFbUserName fbId:(NSString*)strFbID googleId:(NSString*)strGoogleId loginType:(NSString*)strLoginType gender:(NSString*)strGender profileImage:(UIImage*)imgProfile orientation:(NSString*)strOrientation nickName:(NSString*)strNickName showProfile:(NSString*)strShowProfileStatus creditCardNumber:(NSString*)strcreditCardNumber expiryDate:(NSString*)strExpiryMonth expYear:(NSString*)strExpYear firstName:(NSString*)strFirstName lastName:(NSString*)strLastName dob:(NSString*)strDOB status:(NSString*)strStatus description:(NSString*)strDescription googleUsername:(NSString*)strGoogleUserName firstName:(NSString*)str2FirstName lastname:(NSString*)str2LastName ethnicity:(NSString*)strethnicity city:(NSString*)strcity state:(NSString*)strstate zipcode:(NSString*)strZipcode delegate:(id)aDelegate;
-(void)createOrderWithOrderStatus:(NSString*)strStatus basePrice:(NSString*)strBasePrice totalPrice:(NSString*)strTotalPrice tipPercentage:(NSString*)strPercentage itemName:(NSString*)strName produceId:(NSString*)strProdId description:(NSString*)strDescription receiverBartsyId:(NSString*)strReceiverId delegate:(id)aDelegate;
-(void)checkInAtBartsyVenueWithId:(NSString*)strVenueId delegate:(id)aDelegate;
-(void)checkOutAtBartsyVenueWithId:(NSString*)strVenueId delegate:(id)aDelegate;
-(void)gettingPeopleListFromVenue:(NSString*)strVenueId delegate:(id)aDelegate;
-(void)getUserOrdersWithBartsyId:(NSString*)strBartsyId delegate:(id)aDelegate;
-(void)heartBeatWithBartsyId:(NSString*)strBartsyId venueId:(NSString*)strVenueId delegate:(id)aDelegate;
-(void)getIngredientsListWithVenueId:(NSString*)strVenueId delegate:(id)aDelegate;
-(void)createOrderWithOrderStatus:(NSString*)strStatus basePrice:(NSString*)strBasePrice totalPrice:(NSString*)strTotalPrice tipPercentage:(NSString*)strPercentage itemName:(NSString*)strName produceId:(NSString*)strProdId description:(NSString*)strDescription ingredients:(NSArray*)arrIngredients receiverBartsyId:(NSString*)strReceiverId delegate:(id)aDelegate;
-(void)syncUserDetailsWithUserName:(NSString*)strUserName type:(NSString*)strType bartsyId:(NSString*)strBartsyId delegate:(id)aDelegate;
-(void)loginWithEmailID:(NSString*)strEmailId password:(NSString*)strPassword delegate:(id)aDelegate;
-(void)getUserProfileWithBartsyId:(NSString*)strBastsyId delegate:(id)aDelegate;
-(void)getPastOrderWithVenueWithId:(NSString*)strVenueId bartsyId:(NSString*)strbartsyId date:(NSString*)date  delegate:(id)aDelegate;
-(void)getNotificationsWithDelegate:(id)aDelegate;
-(void)sendMessageWithSenderId:(NSString*)strSenderBarstsyID receiverId:(NSString*)strReceiverBartsyId message:(NSString*)message delegate:(id)aDelegate;
-(void)getMessagesWithReceiverId:(NSString*)strReceiverBartsyId delegate:(id)aDelegate;
-(void)likePeopleWithBartsyId:(NSString*)strBartsyId status:(NSInteger)intStatus withDelegate:(id)aDelegate;
-(void)shareAMessage:(NSString*)message AccessToken:(NSString*)strToken delegate:(id)aDelegate;
-(void)getPastOrderbbybartsyId:(NSString*)strbartsyId delegate:(id)aDelegate;
-(void)getUserRewardsbybartsyID:(NSString*)strbartsyID delegate:(id)aDelegate;
-(void)getCocktailsbyvenueID:(NSString*)venueID delegate:(id)aDelegate;
-(void)saveFavoriteDrinkbyvenueID:(NSString*)venuID bartsyID:(NSString*)bartsyID description:(NSString*)description specialinstruction:(NSString*)instructions itemlist:(NSArray*)itemlist delegate:(id)aDelegate;
-(void)getFavoriteDrinksbybartsyID:(NSString*)strbartsyID venueID:(NSString*)venueID delegate:(id)aDelegate;
-(void)SaveOrderWithOrderStatus:(NSString*)strStatus basePrice:(NSString*)strBasePrice totalPrice:(NSString*)strTotalPrice tipPercentage:(NSString*)strPercentage itemName:(NSString*)strName splcomments:(NSString*)splcomments description:(NSString*)strDescription itemlist:(NSArray*)arritemlist receiverBartsyId:(NSString*)strReceiverId delegate:(id)aDelegate;
-(void)DeleteFavoritebyfavoriteID:(NSString*)favoriteID venueID:(NSString*)venueID bydelegate:(id)aDelegate;
-(void)GetVenueRewards:(NSString*)venueID bydelegate:(id)aDelegate;
@end
