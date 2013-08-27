//
//  AppDelegate.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 26/04/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "RootViewController.h"
#import "WelcomeViewController.h"
#define kEnabled                @"enabled"
#define kSimulator              @"Simulator"
#import <AudioToolbox/AudioToolbox.h>
#import "GAI.h"
#import "FrontViewController.h"

@implementation AppDelegate
@synthesize deviceToken,delegateForCurrentViewController,isComingForOrders,isLoginForFB,intPeopleCount,intOrderCount;
@synthesize internetActive, hostActive,arrOrders,arrOrdersTimer,timerForOrderStatusUpdate,timerForHeartBeat,arrPeople,isCmgForWelcomeScreen,arrOrdersList;
@synthesize  tabBar;
@synthesize isComingForPeople,timerforGetMessages,isComingForMenu;
@synthesize isCmgForShowingOrderUI;
- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    arrStatus=[[NSArray alloc]initWithObjects:@"Waiting for bartender to accept",@"Your order was rejected by Bartender",@"Order was accepted",@"Ready for pickup",@"Order is Failed",@"Order is picked up",@"Noshow",@"Your order was timedout",@"Your order was rejected",@"Drink offered",@"Past Order", nil];

    //arrStatus=[[NSArray alloc]initWithObjects:@"Accepted",@"Ready for pickup",@"Order is picked up",@"Order is picked up", nil];
    
    [Crittercism enableWithAppID:@"51b196e597c8f25177000005"];
    
    arrPeople=[[NSMutableArray alloc]init];
    arrOrders=[[NSMutableArray alloc]init];
    arrOrdersList=[[NSMutableArray alloc]init];
//    // Optional: automatically send uncaught exceptions to Google Analytics.
//    [GAI sharedInstance].trackUncaughtExceptions = YES;
//    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
//    [GAI sharedInstance].dispatchInterval = 20;
//    // Optional: set debug to YES for extra debugging information.
//    [GAI sharedInstance].debug = YES;
//    // Create tracker instance.
//    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-40090000-1"];
//
    NSLog(@"My userID %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"bartsyId"]);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"bartsyId"])
    {
        isCmgForWelcomeScreen=YES;
        LoginViewController *loginObj=[[LoginViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:loginObj];
        [self.window addSubview:nav.view];
        /*
        WelcomeViewController *homeObj = [[WelcomeViewController alloc] init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:homeObj];
        [self.window addSubview:nav.view];
         */
    }
    else
    {
        LoginViewController *loginObj=[[LoginViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:loginObj];
        [self.window addSubview:nav.view];
    }
    
    [self.window makeKeyAndVisible];
    
    //[self registerMobileDevice];
    
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
    
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    
    [self checkNetworkStatus:nil];
    //hostReachable = [[Reachability reachabilityWithHostName:KServerURL] retain];
    //[hostReachable startNotifier];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    return YES;
}


- (void) checkNetworkStatus:(NSNotification *)notice
{
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.internetActive = NO;
            [self showAlertForWifiList];
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            [self checkUserCheckInStatus];
            break;
            
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            [self checkUserCheckInStatus];
            break;
            
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            
            break;
            
        }
    }
    
}
-(void)registerMobileDevice
{
    MobileDeviceRegistrationRequest *mobileDeviceRegistrationRequest =
    [MobileDeviceRegistrationRequest mobileDeviceRegistrationRequest];
    mobileDeviceRegistrationRequest.mobileDevice.mobileDeviceId =
    @"ABCDEF";
    mobileDeviceRegistrationRequest.mobileDevice.mobileDescription = @"TestingRegistration";
    mobileDeviceRegistrationRequest.mobileDevice.phoneNumber = @"1111111111";
    mobileDeviceRegistrationRequest.anetApiRequest.merchantAuthentication.name = @"sudheerp143";
    mobileDeviceRegistrationRequest.anetApiRequest.merchantAuthentication.password = @"Techvedika@007";
    
    [AuthNet authNetWithEnvironment:ENV_TEST];
    
    AuthNet *an = [AuthNet getInstance];
    [an mobileDeviceRegistrationRequest:mobileDeviceRegistrationRequest];
}

-(void)showAlertForWifiList
{
    NSDictionary *dictVenue=nil;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]!=nil)
    {
        dictVenue=[[NSUserDefaults standardUserDefaults]objectForKey:@"VenueDetails"];
    }
    else
    {
        dictVenue=[[[NSUserDefaults standardUserDefaults]objectForKey:@"Venues"] objectAtIndex:0];
    }
        if(alertView!=nil)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [alertView release];
            alertView=nil;
        }
        
        NSString *strTitle=[NSString stringWithFormat:@"Internet Connection Required. Please connect to %@ Wi-Fi to continue Bartsy\n Wi-Fi Name: %@ \n Password: %@",[dictVenue objectForKey:@"venueName"],[dictVenue objectForKey:@"wifiName"],[dictVenue objectForKey:@"wifiPassword"]];
        alertView=[[UIAlertView alloc]initWithTitle:nil message:strTitle delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
}


-(void)startTimerToCheckOrderStatusUpdate
{
    if(self.timerForOrderStatusUpdate==nil)
    {
        self.timerForOrderStatusUpdate = [[NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(checkOrderStatusUpdate) userInfo:nil repeats:YES] retain];
    }
    
}

-(void)stopTimerForOrderStatusUpdate
{
    if(self.timerForOrderStatusUpdate!=nil)
    {
        [self.timerForOrderStatusUpdate invalidate];
        [self.timerForOrderStatusUpdate release];
        self.timerForOrderStatusUpdate=nil;
        
    }
}

-(void)checkOrderStatusUpdate
{    
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/data/getUserOrders",KServerURL];
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"],@"bartsyId",nil];
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];
    [dictCheckIn setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthCode"] forKey:@"oauthCode"];

    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictCheckIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *dataOrder, NSError *error)
     {
         if(error==nil)
         {
             SBJSON *jsonParser = [[SBJSON new] autorelease];
             NSString *jsonString = [[[NSString alloc] initWithData:dataOrder encoding:NSUTF8StringEncoding] autorelease];
             id result = [jsonParser objectWithString:jsonString error:nil];
             
             if(arrOrdersTimer!=nil)
             {
                 [arrOrdersTimer removeAllObjects];
                 [arrOrdersTimer release];
                 arrOrdersTimer=nil;
             }
             
             arrOrdersTimer=[[NSMutableArray alloc]initWithArray:[result objectForKey:@"orders"]];
             
             NSMutableArray *arrPlacedOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"PlacedOrders"]];
             
             for (int i=0; i<0; i++)
             //for (int i=0; i<[arrPlacedOrders count]; i++)
             {
                 NSMutableDictionary *dictOrder=[[NSMutableDictionary alloc]initWithDictionary:[arrPlacedOrders objectAtIndex:i]];
                 
                 NSDate* date1 = [dictOrder objectForKey:@"Time"];
                 NSDate* date2 = [NSDate date];
                 NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
                 NSLog(@"Time is %f",distanceBetweenDates);
                 double secondsInAnMinute = 60;
                 NSInteger intMinutesBetweenDates = distanceBetweenDates / secondsInAnMinute;
                 
                 NSMutableArray *arrOrdersTemp=[[NSMutableArray alloc]initWithArray:arrOrdersTimer];
                 NSPredicate *pred=[NSPredicate predicateWithFormat:@"orderId ==[c] %@",[dictOrder objectForKey:@"orderId"]];
                 [arrOrdersTemp filterUsingPredicate:pred];

                 NSLog(@"Order is %@",arrOrdersTemp);

                 NSDictionary *dictOrderTemp;
                 BOOL isOrderExists=NO;
                 BOOL isSameStatus=NO;
                 if([arrOrdersTemp count])
                 {
                     dictOrderTemp=[arrOrdersTemp objectAtIndex:0];
                     isOrderExists=YES;
                     isSameStatus=[[dictOrder objectForKey:@"orderStatus"] integerValue]==[[dictOrderTemp objectForKey:@"orderStatus"] integerValue];
                 }
                 
                 if(intMinutesBetweenDates>=[[dictOrder objectForKey:@"orderTimeout"] integerValue])
                 {
                     UILocalNotification *localNotificationForOrderFailure = [[UILocalNotification alloc]init];
                     localNotificationForOrderFailure.alertBody =[NSString stringWithFormat:@"Something is wrong with this order(%i). Please check with your bartender",[[dictOrder objectForKey:@"orderId"] integerValue]];
                     localNotificationForOrderFailure.fireDate = [NSDate date];
                     localNotificationForOrderFailure.soundName = UILocalNotificationDefaultSoundName;
                     localNotificationForOrderFailure.userInfo =[NSDictionary
                                                                       dictionaryWithObjectsAndKeys:[dictOrder objectForKey:@"orderId"],@"orderId",localNotificationForOrderFailure.alertBody,@"Message", nil];
                     [[UIApplication sharedApplication] scheduleLocalNotification:localNotificationForOrderFailure];
                     
                     NSMutableArray *arrOrdersTimeOut=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"OrdersTimedOut"]];
                     [arrOrdersTimeOut addObject:dictOrder];
                     
                     [[NSUserDefaults standardUserDefaults]setObject:arrOrdersTimeOut forKey:@"OrdersTimedOut"];
                     
                     NSMutableArray *arrPlacedOrdersTemp=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"PlacedOrders"]];
                     [arrPlacedOrdersTemp removeObject:dictOrder];
                     [[NSUserDefaults standardUserDefaults]setObject:arrPlacedOrdersTemp forKey:@"PlacedOrders"];

                     [[NSUserDefaults standardUserDefaults]synchronize];

                 }
                 else if([dictOrderTemp count]&&!isSameStatus)
                 {
                     if([[dictOrderTemp objectForKey:@"orderStatus"] integerValue]!=5)
                     {
                         [dictOrder setObject:[dictOrderTemp objectForKey:@"orderStatus"] forKey:@"orderStatus"];
                         [arrPlacedOrders replaceObjectAtIndex:i  withObject:dictOrder];
                     }
                     else
                     {
                         [arrPlacedOrders removeObjectAtIndex:i];
                     }
                     [[NSUserDefaults standardUserDefaults]setObject:arrPlacedOrders forKey:@"PlacedOrders"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                 }
             }
             
             [arrOrdersTimer removeObjectsInArray:arrOrders];

             if([arrOrdersTimer count])
             {
                 NSSortDescriptor *sortDescriptor=[[NSSortDescriptor alloc]initWithKey:@"orderStatus" ascending:NO selector:nil];
                 [arrOrdersTimer sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                 
                 for (int i=0;i<[arrOrdersTimer count];i++)
                 {
                     NSDictionary *dict=[arrOrdersTimer objectAtIndex:i];

                     if([[dict objectForKey:@"orderStatus"] integerValue]!=0&&[[dict objectForKey:@"orderStatus"] integerValue]!=9)
                     {
                         //Checking weather this order is already shown or not for that orderstatus
                         NSMutableArray *arrOrderIdsAndStatus=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"OrderIdsAndStatus"]];
                         
                         NSPredicate *pred1=[NSPredicate predicateWithFormat:[self getPredicateWithOrderStatus:[[dict objectForKey:@"orderStatus"] integerValue]]];
                         NSPredicate *pred2=[NSPredicate predicateWithFormat:@"orderId ==[c] %@",[dict objectForKey:@"orderId"]];
                         
                         NSPredicate *predCompound=[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:pred1,pred2, nil]];
                         
                         [arrOrderIdsAndStatus filterUsingPredicate:predCompound];
                         
                         
                         //It is the first time showing notification for that status
                         if([arrOrderIdsAndStatus count]==0)
                         {
                             NSMutableArray *arrOrderIdsAndStatusTemp=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"OrderIdsAndStatus"]];
                             NSDictionary *dictOrderIdAndStatus=[[NSDictionary alloc]initWithObjectsAndKeys:[dict objectForKey:@"orderId"],@"orderId",[dict objectForKey:@"orderStatus"],@"orderStatus", nil];
                             [arrOrderIdsAndStatusTemp addObject:dictOrderIdAndStatus];
                             
                             [[NSUserDefaults standardUserDefaults]setObject:arrOrderIdsAndStatusTemp forKey:@"OrderIdsAndStatus"];
                             [[NSUserDefaults standardUserDefaults]synchronize];
                             
                             UILocalNotification *localNotificationForOrderStatusUpdate = [[UILocalNotification alloc]init];
                             localNotificationForOrderStatusUpdate.alertBody =[NSString stringWithFormat:@"%@ with number %i",[arrStatus objectAtIndex:[[dict objectForKey:@"orderStatus"] integerValue]],[[dict objectForKey:@"userSessionCode"] integerValue]];
                             localNotificationForOrderStatusUpdate.fireDate = [NSDate date];
                             localNotificationForOrderStatusUpdate.soundName = UILocalNotificationDefaultSoundName;
                             localNotificationForOrderStatusUpdate.userInfo = [NSDictionary
                                                                               dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@ with number %i",[arrStatus objectAtIndex:[[dict objectForKey:@"orderStatus"] integerValue]],[[dict objectForKey:@"userSessionCode"] integerValue]],@"Message", nil];
                             
                             [[UIApplication sharedApplication] scheduleLocalNotification:localNotificationForOrderStatusUpdate];
                         }
                         
                     }
                 }
                 
                 
                 
                 
             }
             
         }
         else
         {
             NSLog(@"Error is %@",error);
         }
         
     }
     ];
    
    [url release];
    [request release];
}

-(NSString*)getPredicateWithOrderStatus:(NSInteger)intStatus
{
    NSString *strPred;
    if(intStatus==0)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'0'"];
    else if(intStatus==2)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'2'"];
    else if(intStatus==3)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'3'"];
    else if(intStatus==4)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'4'"];
    else if(intStatus==5)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'5'"];
    else if(intStatus==6)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'6'"];
    else if(intStatus==7)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'7'"];
    else if(intStatus==8)
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'8'"];
    else
        strPred=[NSString stringWithFormat:@"orderStatus == [c]'9'"];
    
    return strPred;
}

-(void)startTimerToCheckHeartBeat
{
    if(self.timerForHeartBeat==nil)
    {
        self.timerForHeartBeat = [[NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(checkHeartBeat) userInfo:nil repeats:YES] retain];
    }
    
}

-(void)stopTimerForHeartBeat
{
    if(self.timerForHeartBeat!=nil)
    {
        [self.timerForHeartBeat invalidate];
        [self.timerForHeartBeat release];
        self.timerForHeartBeat=nil;
        
    }
}

-(void)checkHeartBeat
{
    if(delegateForCurrentViewController!=nil)
    [delegateForCurrentViewController heartBeat];
}

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    intOrderCount=[[result objectForKey:@"orderCount"] integerValue];
    intPeopleCount=[[result objectForKey:@"userCount"] integerValue];
    
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:[[result objectForKey:@"unReadNotifications"] integerValue]];
    
    if([delegateForCurrentViewController isKindOfClass:[HomeViewController class]])
        [delegateForCurrentViewController reloadDataPeopleAndOrderCount];
}


-(void)controllerDidFailLoadingWithError:(NSError*)error
{
    NSLog(@"Error is %@",error);
}

#pragma mark------------Timer for Get Message
-(void)startTimerTOGetMessages{
    
    if (![self.timerforGetMessages isValid] && self.timerforGetMessages==nil) {
        
        self.timerforGetMessages = [[NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(checkNewMessages) userInfo:nil repeats:YES] retain];
    }else{
        [self.timerforGetMessages invalidate];
        self.timerforGetMessages=nil;
         self.timerforGetMessages = [[NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(checkNewMessages) userInfo:nil repeats:YES] retain];
    }
}

-(void)stopTimerForGetMessages{
    
    if ([self.timerforGetMessages isValid]) {
        
        [self.timerforGetMessages invalidate];
        [self.timerforGetMessages release];
    }
}

-(void)checkNewMessages{
    
    //NSLog(@"newmessage");
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/data/checkedInUsersList",KServerURL];
    
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedVenueID"],@"venueId",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"],@"bartsyId",nil];
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];
    [dictCheckIn setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthCode"] forKey:@"oauthCode"];

    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictCheckIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *dataOrder, NSError *error)
     {
         if(error==nil)
         {
             SBJSON *jsonParser = [[SBJSON new] autorelease];
             NSString *jsonString = [[[NSString alloc] initWithData:dataOrder encoding:NSUTF8StringEncoding] autorelease];
             id result = [jsonParser objectWithString:jsonString error:nil];
             [self.arrPeople removeAllObjects];
             [self.arrPeople addObjectsFromArray:[result objectForKey:@"checkedInUsers"]];
             
             int i=0;
             for (NSDictionary *dic in self.arrPeople) {
                 
                 if ([[dic valueForKey:@"hasMessages"] isEqualToString:@"New"]) {
                     
                     i++;
                     /*alertView=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"You got a message from %@",[dic valueForKey:@"nickName"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     alertView.tag=0;
                     [alertView show];*/

                 }
                 [[self.tabBar.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [NSString stringWithFormat:@"%d",i];
                 if (i==0) {
                    [[self.tabBar.viewControllers objectAtIndex:2] tabBarItem].badgeValue =nil;
                 }
             }
             
         }
         else
         {
             NSLog(@"Error is %@",error);
         }
         
     }
     ];
    
    
    [url release];
    [request release];
    [dictCheckIn release];

}
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
    // Handle the notificaton when the app is running
    NSLog(@"application: didReceiveLocalNotification:");
    app.applicationIconBadgeNumber = 0;
    NSDictionary *userInfoCurrent = notif.userInfo;
    
    NSLog(@"Info is %@",userInfoCurrent);
        
    if(alertView!=nil)
    {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [alertView release];
        alertView=nil;
    }
    
    alertView=[[UIAlertView alloc]initWithTitle:@"" message:[userInfoCurrent valueForKey:@"Message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertView.tag=143225;
    [alertView show];
    
    NSLog(@"Receive Local Notification while the app is still running...");
    NSLog(@"current notification is %@",notif);
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    self.deviceToken = [[[[devToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""]
						stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"device token is %@",deviceToken);
	NSInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
 	// Set the defaults to disabled unless we find otherwise...
	NSString *pushBadge = kEnabled;
	NSString *pushAlert = kEnabled;
	NSString *pushSound = kEnabled;
	
	// Check what Registered Types are turned on. This is a bit tricky since if two are enabled, and one is off, it will return a number 2... not telling you which
	// one is actually disabled. So we are literally checking to see if rnTypes matches what is turned on, instead of by number. The "tricky" part is that the
	// single notification types will only match if they are the ONLY one enabled.  Likewise, when we are checking for a pair of notifications, it will only be
	// true if those two notifications are on.  This is why the code is written this way
	
	
	if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound))
	{
		pushBadge = kEnabled;
		pushAlert = kEnabled;
		pushSound = kEnabled;
	}
	else if(rntypes == ( UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound))
	{
		pushAlert = kEnabled;
		pushSound =kEnabled;
	}
	else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound))
	{
		pushBadge = kEnabled;
		pushSound = kEnabled;
	}
	else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)){
		pushBadge = kEnabled;
		pushAlert = kEnabled;
	}
	else if(rntypes == UIRemoteNotificationTypeBadge){
		pushBadge = kEnabled;
	}
	else if(rntypes == UIRemoteNotificationTypeAlert){
		pushAlert = kEnabled;
	}
	else if(rntypes == UIRemoteNotificationTypeSound){
		pushSound = kEnabled;
	}
	
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
	
	// Prepare the Device Token for Registration (remove spaces and < >)
	
	
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    UIDevice *device = [UIDevice currentDevice];
    NSString *strCurrentDevice=[NSString stringWithFormat:@"%@ your",[device model]];
	int len=[strCurrentDevice length];
	
    for(int j =0;j<len;j++)
    {
        NSRange range=[strCurrentDevice rangeOfString:kSimulator options:0 range:NSMakeRange(0,len-1)];
        if(range.location<len)
        {
            self.deviceToken=@"42efbf98e0d39862b230428f1b1c9308ab63c19a4e55b0b46015f2061670093d";
            break;
        }
		
        
    }
    
}
//application did recive remote notification.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSLog(@"PN: %@",userInfo);
    
    NSLog(@"Current VC is %@",delegateForCurrentViewController);
    //    if([delegateForCurrentViewController isKindOfClass:[HomeViewController class]])
    //    {
    //        [delegateForCurrentViewController reloadData];
    //    }
    
    if([[userInfo objectForKey:@"messageType"] isEqualToString:@"updateOrderStatus"]&&[[userInfo valueForKey:@"orderStatus"] integerValue])
    {
        AudioServicesPlaySystemSound(1007);

        if(alertView!=nil)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [alertView release];
            alertView=nil;
        }
        
        alertView=[[UIAlertView alloc]initWithTitle:@"" message:[[userInfo objectForKey:@"aps"] valueForKey:@"alert"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag=143225;
        [alertView show];
        
        intOrderCount=[[userInfo objectForKey:@"orderCount"] integerValue];
        
        if([delegateForCurrentViewController isKindOfClass:[HomeViewController class]])
            [delegateForCurrentViewController reloadDataPeopleAndOrderCount];

    }
    else if([[userInfo objectForKey:@"messageType"] isEqualToString:@"orderTimeout"])
    {
        AudioServicesPlaySystemSound(1007);

        if(alertView!=nil)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [alertView release];
            alertView=nil;
        }
        
        alertView=[[UIAlertView alloc]initWithTitle:@"" message:[[userInfo objectForKey:@"aps"] valueForKey:@"alert"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag=143225;
        [alertView show];
    }
    else if([[userInfo objectForKey:@"messageType"] isEqualToString:@"heartBeat"])
    {
        //AudioServicesPlaySystemSound(1007);
        [delegateForCurrentViewController heartBeat];
        
        intOrderCount=[[userInfo objectForKey:@"orderCount"] integerValue];
        intPeopleCount=[[userInfo objectForKey:@"userCount"] integerValue];
       
        if([delegateForCurrentViewController isKindOfClass:[HomeViewController class]])
        [delegateForCurrentViewController reloadDataPeopleAndOrderCount];
    }
    else if([[userInfo objectForKey:@"messageType"] isEqualToString:@"DrinkOffered"])
    {
        AudioServicesPlaySystemSound(1007);
        if(alertView!=nil)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [alertView release];
            alertView=nil;
        }
        
        alertView=[[UIAlertView alloc]initWithTitle:@"" message:[[userInfo objectForKey:@"aps"] valueForKey:@"alert"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alertView.tag=225;
        [alertView show];
    }
    else if([[userInfo objectForKey:@"messageType"] isEqualToString:@"DrinkOfferRejected"])
    {
        AudioServicesPlaySystemSound(1007);
        if(alertView!=nil)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [alertView release];
            alertView=nil;
        }
        
        alertView=[[UIAlertView alloc]initWithTitle:@"" message:[[userInfo objectForKey:@"aps"] valueForKey:@"alert"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if([[userInfo objectForKey:@"messageType"] isEqualToString:@"DrinkOfferAccepted"])
    {
        AudioServicesPlaySystemSound(1007);
        if(alertView!=nil)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [alertView release];
            alertView=nil;
        }
        
        alertView=[[UIAlertView alloc]initWithTitle:@"" message:[[userInfo objectForKey:@"aps"] valueForKey:@"alert"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }else if ([[userInfo objectForKey:@"messageType"] isEqualToString:@"message"]){
        
        AudioServicesPlaySystemSound(1007);
        if(alertView!=nil)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [alertView release];
            alertView=nil;
        }
        
        alertView=[[UIAlertView alloc]initWithTitle:@"" message:[[userInfo objectForKey:@"aps"] valueForKey:@"alert"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag=6666;
        [alertView show];
        [[tabBar.viewControllers objectAtIndex:2] tabBarItem].badgeValue = @"1";
    }
}

- (void)alertView:(UIAlertView *)alertView1 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView1.tag==143225||alertView1.tag==225)
    {
        isComingForOrders=YES;
        
        if(tabBar.selectedIndex==0)
        {
            [delegateForCurrentViewController viewWillAppear:YES];
        }
        else
        {
            [tabBar setSelectedIndex:0];
            [delegateForCurrentViewController viewWillAppear:YES];
        }
        
        /*
        if([delegateForCurrentViewController isKindOfClass:[HomeViewController class]])
        {
            [delegateForCurrentViewController reloadData];
        }
        else if([delegateForCurrentViewController isKindOfClass:[FrontViewController class]])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Back" object:nil];
        }
        else
        {
            
            UIViewController *viewController=(UIViewController*)delegateForCurrentViewController;
            HomeViewController *obj=[[HomeViewController alloc]init];
            obj.dictVenue=[[NSUserDefaults standardUserDefaults]objectForKey:@"VenueDetails"];
            [viewController.navigationController pushViewController:obj animated:YES];
            [obj release];
            
        }
         */
    }else if (alertView1.tag==6666)
    {
        
        isComingForPeople=YES;
        
        if(tabBar.selectedIndex==0)
        {
            [delegateForCurrentViewController viewWillAppear:YES];
        }
        else
        {
            [tabBar setSelectedIndex:0];
            [delegateForCurrentViewController viewWillAppear:YES];
        }

        
    }
//    else if(alertView1.tag==225)
//    {
//        if(buttonIndex==0)
//        [self updateOrderStatusForaOfferedDrink:@"8"]; //Rejected the Order
//        else
//        [self updateOrderStatusForaOfferedDrink:@"0"]; //Accepted the Order
//
//    }
    else if(alertView1.tag==111222)
    {
        exit(0);
    }
}


// FBSample logic
// The native facebook application transitions back to an authenticating application when the user
// chooses to either log in, or cancel. The url passed to this method contains the token in the
// case of a successful login. By passing the url to the handleOpenURL method of FBAppCall the provided
// session object can parse the URL, and capture the token for use by the rest of the authenticating
// application; the return value of handleOpenURL indicates whether or not the URL was handled by the
// session object, and does not reflect whether or not the login was successful; the session object's
// state, as well as its arguments passed to the state completion handler indicate whether the login
// was successful; note that if the session is nil or closed when handleOpenURL is called, the expression
// will be boolean NO, meaning the URL was not handled by the authenticating application
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if(isLoginForFB)
    {
        // attempt to extract a token from the url
        return [FBAppCall handleOpenURL:url
                      sourceApplication:sourceApplication
                            withSession:self.session];
    }
    else
    {
        UIViewController *viewController=(UIViewController*)delegateForCurrentViewController;
        [viewController createProgressViewToParentView:viewController.view withTitle:@"Loading..."];
        return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
}

// FBSample logic
// Whether it is in applicationWillTerminate, in applicationDidEnterBackground, or in some other part
// of your application, it is important that you close an active session when it is no longer useful
// to your application; if a session is not properly closed, a retain cycle may occur between the block
// and an object that holds a reference to the session object; close releases the handler, breaking any
// inadvertant retain cycles
- (void)applicationWillTerminate:(UIApplication *)application {
    // FBSample logic
    // if the app is going away, we close the session if it is open
    // this is a good idea because things may be hanging off the session, that need
    // releasing (completion block, etc.) and other components in the app may be awaiting
    // close notification in order to do cleanup
    [self.session close];
    [self saveContext];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if(self.timerForOrderStatusUpdate!=nil)
    {
        UIApplication   *app = [UIApplication sharedApplication];
        bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            [app endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        }];
        
        // Start the long-running task and return immediately.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // inform others to stop tasks, if you like
            
        });
    }

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]!=nil)
       {
           [self startTimerTOGetMessages];

       }
}

// FBSample logic
// It is possible for the user to switch back to your application, from the native Facebook application,
// when the user is part-way through a login; You can check for the FBSessionStateCreatedOpenening
// state in applicationDidBecomeActive, to identify this situation and close the session; a more sophisticated
// application may choose to notify the user that they switched away from the Facebook application without
// completely logging in
- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkUserCheckInStatus) userInfo:nil repeats:NO];
    
}


-(void)checkUserCheckInStatus
{
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]!=nil&&[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]!=nil)
    {
        NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/user/syncUserDetails",KServerURL];
        NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"checkin",@"type",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"],@"bartsyId",deviceToken,@"deviceToken",@"1",@"deviceType",nil];
        [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];

        NSLog(@"syncUserDetails Details \n %@",dictCheckIn);
        SBJSON *jsonObj=[SBJSON new];
        NSString *strJson=[jsonObj stringWithObject:dictCheckIn];
        NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url=[[NSURL alloc]initWithString:strURL];
        NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:dataCheckIn];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *dataOrder, NSError *error)
         {
             if(error==nil)
             {
                 SBJSON *jsonParser = [[SBJSON new] autorelease];
                 NSString *jsonString = [[[NSString alloc] initWithData:dataOrder encoding:NSUTF8StringEncoding] autorelease];
                 id result = [jsonParser objectWithString:jsonString error:nil];
                 NSLog(@"Result is %@",result);
                 
                 
                 @try
                 {
                     if([[result objectForKey:@"venueId"] integerValue]==0)
                     {
                         [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"CheckInVenueId"];
                         [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"VenueDetails"];
                         [[NSUserDefaults standardUserDefaults]synchronize];
                         
                         [self stopTimerForOrderStatusUpdate];
                         [self stopTimerForHeartBeat];
                         
                         if([delegateForCurrentViewController isKindOfClass:[WelcomeViewController class]])
                         {
                             [delegateForCurrentViewController reloadWelcomeScreen];
                         }
                         else if(delegateForCurrentViewController!=nil)
                         {
                             UIViewController *viewCont=(UIViewController*)delegateForCurrentViewController;
                             
                             for (UIViewController *viewController in viewCont.navigationController.viewControllers)
                             {
                                 if([viewController isKindOfClass:[WelcomeViewController class]])
                                 {
                                     NSLog(@"vc is %@",delegateForCurrentViewController);
                                     UIViewController *viewCont=(UIViewController*)delegateForCurrentViewController;
                                     [viewCont.navigationController popToViewController:viewController animated:YES];
                                 }
                             }
                              
                         }
                     }
                     else
                     {
                         [self startTimerToCheckHeartBeat];
                         intOrderCount=[[result objectForKey:@"orderCount"]integerValue];
                         intPeopleCount=[[result objectForKey:@"userCount"]integerValue];
                         UIViewController *viewCont=(UIViewController*)delegateForCurrentViewController;
                         if([viewCont isKindOfClass:[HomeViewController class]])
                         {
                             [viewCont  reloadDataPeopleAndOrderCount];
                         }
                         
                     }
                 }
                 @catch (NSException *exception)
                 {
                     NSLog(@"Exception name is %@, reason is %@",exception.name,exception.reason);
                 }

             }
             else
             {
                 NSLog(@"Error is %@",error);
             }
             
         }
         ];

        
        [url release];
        [request release];
         
    }
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


-(void)showAPIVersionAlertWithReason:(NSString*)strReason
{
    if(alertView!=nil)
    {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [alertView release];
        alertView=nil;
    }
    
    alertView=[[UIAlertView alloc]initWithTitle:@"" message:strReason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertView.tag=111222;
    [alertView show];
}
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Bartsy" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Bartsy.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
