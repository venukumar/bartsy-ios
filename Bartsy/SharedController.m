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
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.0.109:8080/Bartsy/venue/getMenu"];
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
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
	if(isMyWebservice==YES)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSString *jsonString = [[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding] autorelease];
        NSError *outError = nil;
        
        id result = jsonString;
        isMyWebservice=NO;
        
        if (outError == nil )
        {
            NSLog(@" result ----- :%@",result);
            [delegate controllerDidFinishLoadingWithResult:result];
        }
        else
        {
            NSLog(@" result :%@ -----  error :%@",result, outError);
            
            [self showAlertWithTitle:@"Warning" message:[outError description] delegate:nil];
            [delegate controllerDidFailLoadingWithError:nil];
        }
    }
    else
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
            
          //  [self showAlertWithTitle:kAlertTitle message:kServerAlertMessage delegate:nil];
            [delegate controllerDidFailLoadingWithError:outError];
        }
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
