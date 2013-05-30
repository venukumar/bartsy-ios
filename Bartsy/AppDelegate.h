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

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *deviceToken;
    NSArray *arrStatus;
    id delegateForCurrentViewController;
    BOOL isComingForOrders;
    UIAlertView *alertView;
    BOOL isLoginForFB;
}
@property(nonatomic,assign)BOOL isLoginForFB;
@property (nonatomic,retain)id delegateForCurrentViewController;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)NSString *deviceToken;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) FBSession *session;
@property (nonatomic,assign)BOOL isComingForOrders;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
