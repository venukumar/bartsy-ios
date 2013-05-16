//
//  AppDelegate.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 26/04/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *deviceToken;
    NSArray *arrStatus;
    id delegateForCurrentViewController;
}
@property (nonatomic,retain)id delegateForCurrentViewController;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)NSString *deviceToken;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) FBSession *session;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
