//
//  NSNetwork.h
//  myPANTONE
//
//  Created by Alex Cohen on 8/12/09.
//  Copyright 2009 Toomuchspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

extern NSString* const NSNetworkReachabilityChangedNotification;

@interface NSNetwork : NSObject {
	SCNetworkReachabilityRef	_reachRef;
	SCNetworkReachabilityFlags	_flags;
	NSString*					_hostname;
	NSString*					_address;
}

@property (readonly,copy) NSString* hostname;
@property (readonly,copy) NSString* address;

@property (readonly) BOOL canBeReached;
@property (readonly) BOOL canBeReachedViaCellNetwork;
@property (readonly) BOOL connectionRequired;
@property (readonly) BOOL willConnectOnTraffic;
@property (readonly) BOOL interventionRequired;
@property (readonly) BOOL isLocalAddress;
@property (readonly) BOOL isDirect;

+ (NSNetwork*)defaultNetwork;
+ (NSNetwork*)networkWithHost:(NSString*)hostname;
+ (NSNetwork*)networkWithAddress:(NSString*)address;

- (id)initWithHost:(NSString*)hostname;
- (id)initWithAddress:(NSString*)address;

@end


