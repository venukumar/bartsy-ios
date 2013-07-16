//
//  AppDelegate.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 26/04/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Crittercism.h"
#import "Constants.h"
#import "Reachability.h"
#import "NSNetwork.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *deviceToken;
    NSArray *arrStatus;
    id delegateForCurrentViewController;
    BOOL isComingForOrders;
    BOOL isComingForPeople;
    UIAlertView *alertView;
    BOOL isLoginForFB;
    NSInteger intPeopleCount;
    NSInteger intOrderCount;
    Reachability *internetReachable;
    Reachability *hostReachable;
    NSMutableArray *arrOrders;
    NSMutableArray *arrOrdersTimer;
    NSTimer *timerForOrderStatusUpdate;
    UIBackgroundTaskIdentifier bgTask;
    NSTimer *timerForHeartBeat;
    NSMutableArray *arrPeople;
    BOOL isCmgForWelcomeScreen;
    UITabBarController *tabBar;
}
@property (nonatomic,retain)UITabBarController *tabBar;
@property(nonatomic,retain)NSMutableArray *arrPeople;
@property(nonatomic,retain)NSTimer *timerForOrderStatusUpdate;
@property(nonatomic,retain)NSTimer *timerForHeartBeat;
@property(nonatomic,retain)NSMutableArray *arrOrders;
@property(nonatomic,retain)NSMutableArray *arrOrdersTimer;
@property(nonatomic,assign)BOOL isLoginForFB;
@property (nonatomic,retain)id delegateForCurrentViewController;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)NSString *deviceToken;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) FBSession *session;
@property (nonatomic,assign)BOOL isComingForOrders;
@property (nonatomic,assign)BOOL isComingForPeople;
@property(nonatomic,assign)NSInteger intPeopleCount;
@property(nonatomic,assign)NSInteger intOrderCount;
@property BOOL internetActive;
@property BOOL hostActive;
@property(nonatomic,assign)BOOL isCmgForWelcomeScreen;

- (void) checkNetworkStatus:(NSNotification *)notice;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)checkUserCheckInStatus;
-(void)startTimerToCheckOrderStatusUpdate;
-(void)stopTimerForOrderStatusUpdate;
-(void)checkOrderStatusUpdate;
-(void)startTimerToCheckHeartBeat;
-(void)stopTimerForHeartBeat;
-(void)showAPIVersionAlertWithReason:(NSString*)strReason;
-(void)controllerDidFinishLoadingWithResult:(id)result;
-(void)controllerDidFailLoadingWithError:(NSError*)error;
-(NSString*)getPredicateWithOrderStatus:(NSInteger)intStatus;
@end

