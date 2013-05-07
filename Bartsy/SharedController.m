//
//  SharedController.m
//  DriverAnyWhere
//
//  Created by Sai Sridhar on 13/12/11.
//  Copyright 2011 Tech Vedika Software. All rights reserved.
//

#import "SharedController.h"

static SharedController *sharedController;

@implementation SharedController
@synthesize delegate,data;

#pragma mark--- Initialization Methods ---

+(SharedController *)sharedController
{
	if (sharedController == nil )
	{
		sharedController = [[self alloc] init];
	}
	return sharedController;
}


- (id)init
{
	if ((self = [super init]) )
	{
	}
	return self;
}


+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (sharedController == nil)
		{
			sharedController = [super allocWithZone:zone];
			return sharedController; // assignment and return on first allocation
		}
	}
	return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone
{
	return self;
}


- (id)retain
{
	return self;
}


- (unsigned)retainCount
{
	return UINT_MAX; //denotes an object that cannot be released
}


- (void)release
{
	// do nothing
}


+ (AppDelegate*)appDelegate
{
	return (AppDelegate*)[UIApplication sharedApplication].delegate;
}


//Facebook friends list

#pragma mark- getting  facebook user profile list

//Facebook Profile details
-(void)gettingUserProfileInformationWithAccessToken:(NSString*)strToken delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    isMyWebservice=NO;
    
    NSString *strURL=[NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@",strToken];
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [self sendRequest:request];
    [url release];
    [request release];
}

-(void)getMenuListWithDelegate:(id)aDelegate
{
    self.delegate=aDelegate;
    NSString *strURL=[NSString stringWithFormat:@"http://54.235.76.180:8080/Bartsy/venue/getMenu"];
    
    NSDictionary *dictProfile=[[NSDictionary alloc] initWithObjectsAndKeys:@"100001",@"venueId",nil];
    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictProfile];
    NSData *dataProfile=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataProfile];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self sendRequest:request];
    [url release];
    [request release];
}

-(void)saveProfileInfoWithId:(NSString*)strId name:(NSString*)strName loginType:(NSString*)strLoginType gender:(NSString*)strGender delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSDictionary *dictProfile=[[NSDictionary alloc] initWithObjectsAndKeys:strId,@"loginId",strName,@"userName",@"facebook",@"loginType",strGender,@"gender",@"1",@"deviceType",appDelegate.deviceToken,@"deviceToken", nil];
    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictProfile];
    NSData *dataProfile=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strURL=[NSString stringWithFormat:@"http://54.235.76.180:8080/Bartsy/user/saveUserProfile"];
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataProfile];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self sendRequest:request];
    [url release];
    [request release];
    
}

-(void)createOrderWithOrderStatus:(NSString*)strStatus basePrice:(NSString*)strBasePrice totalPrice:(NSString*)strTotalPrice tipPercentage:(NSString*)strPercentage itemName:(NSString*)strName produceId:(NSString*)strProdId delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSDictionary *dictProfile=[[NSDictionary alloc] initWithObjectsAndKeys:strStatus,@"orderStatus",strBasePrice,@"basePrice",strTotalPrice,@"totalPrice",strPercentage,@"tipPercentage",strName,@"itemName",strProdId,@"itemId",@"100001",@"venueId",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"],@"bartsyId", nil];
    //NSDictionary *dictProfile=[[NSDictionary alloc] initWithObjectsAndKeys:@"New",@"orderStatus",@"10",@"basePrice",@"11",@"totalPrice",@"10",@"tipPercentage",@"Chilled Beer(Knockout)",@"itemName",@"143",@"itemId", nil];
    
    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictProfile];
    NSData *dataProfile=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strURL=[NSString stringWithFormat:@"http://54.235.76.180:8080/Bartsy/order/placeOrder"];
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataProfile];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self sendRequest:request];
    [url release];
    [request release];
}


- (void)sendRequest:(NSMutableURLRequest *)urlRequest
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
    
	reach = [Reachability reachabilityWithHostName:[urlRequest.URL host]];
	
    if (reach != nil)
	{
		NetworkStatus internetStatus = [reach currentReachabilityStatus];
		
		if (( internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
		{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //	[self showAlertWithTitle:@"NetWorkStatus" message:@"Internet Connection Required" delegate:nil];
            [delegate controllerDidFailLoadingWithError:nil];
            return;
		}
        [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}
#pragma mark--- URL Connection Delegate Methods ---

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [NSMutableData data];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)aData
{
    [self.data appendData:aData];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    SBJSON *jsonParser = [[SBJSON new] autorelease];
    
    NSString *jsonString = [[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding] autorelease];
    NSError *outError = nil;
    
    id result = [jsonParser objectWithString:jsonString error:&outError];
    if (outError == nil )
    {
        NSLog(@" result ----- :%@",result);
        [delegate controllerDidFinishLoadingWithResult:result];
    }
    else
    {
        NSLog(@" result :%@ -----  error :%@",result, outError);
        [delegate controllerDidFailLoadingWithError:outError];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [delegate controllerDidFailLoadingWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    if( [[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust] )
    {
        return YES;
    }
    return NO;
}


- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}



#pragma mark--- Alert Methods ---

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)aDelegate
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:aDelegate cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}






@end
