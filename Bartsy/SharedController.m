//
//  SharedController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 26/04/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
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

-(void)getMenuListWithVenueID:(NSString*)strVenueId delegate:(id)aDelegate;
{
    self.delegate=aDelegate;
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/venue/getMenu",KServerURL];
    
    NSMutableDictionary *dictProfile=[[NSMutableDictionary alloc] initWithObjectsAndKeys:strVenueId,@"venueId",nil];
    
    [dictProfile setValue:KAPIVersionNumber forKey:@"apiVersion"];
    
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

-(void)getVenueListWithDelegate:(id)aDelegate
{
    self.delegate=aDelegate;
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/venue/getVenueList",KServerURL];
    
        NSMutableDictionary *dictProfile=[[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    [dictProfile setValue:KAPIVersionNumber forKey:@"apiVersion"];

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

/*

-(void)saveProfileInfoWithId:(NSString*)strPassword name:(NSString*)strName loginType:(NSString*)strLoginType gender:(NSString*)strGender userName:(NSString*)strBartsyLogin profileImage:(UIImage*)imgProfile firstName:(NSString*)strFirstName lastName:(NSString*)strLastName dob:(NSString*)strDOB orientation:(NSString*)strOrientation status:(NSString*)strStatus description:(NSString*)strDescription nickName:(NSString*)strNickName emailId:(NSString*)strEmailId showProfile:(NSString*)strShowProfileStatus creditCardNumber:(NSString*)strcreditCardNumber expiryDate:(NSString*)strExpiryDate expYear:(NSString*)strExpYear delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSData *imageData= UIImagePNGRepresentation(imgProfile);
    
    //NSMutableDictionary *dictProfile=[[NSMutableDictionary alloc] initWithObjectsAndKeys:strUserName,@"emailId",strUserName,@"userName",strPassword,@"password",strNickName,@"nickname",@"facebook",@"loginType",@"1",@"deviceType",appDelegate.deviceToken,@"deviceToken",strGender,@"gender",strOrientation,@"orientation",strShowProfileStatus,@"showProfile",strcreditCardNumber,@"creditCardNumber",strExpiryDate,@"expMonth",strExpYear,@"expYear",strStatus,@"status",strDescription,@"description",strEmailId,@"emailId",strDOB,@"dateofbirth",strFirstName,@"firstname",strLastName,@"lastname",nil];
    
    
    NSMutableDictionary *dictProfile=[[NSMutableDictionary alloc] initWithObjectsAndKeys:strBartsyLogin,@"barstyLogin",strUserName,@"facebookUserName",strPassword,@"password",strNickName,@"nickname",@"facebook",@"loginType",@"1",@"deviceType",appDelegate.deviceToken,@"deviceToken",strGender,@"gender",strOrientation,@"orientation",strShowProfileStatus,@"showProfile",strcreditCardNumber,@"creditCardNumber",strExpiryDate,@"expMonth",strExpYear,@"expYear",strStatus,@"status",strDescription,@"description",strEmailId,@"emailId",strDOB,@"dateofbirth",strFirstName,@"firstname",strLastName,@"lastname",nil];
    
    [dictProfile setValue:KAPIVersionNumber forKey:@"apiVersion"];

    NSMutableDictionary *dictUserProfile=[[NSMutableDictionary alloc]initWithObjectsAndKeys:dictProfile,@"details", nil];
    
    NSLog(@"Profile Info : \n %@",dictUserProfile);
    
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/user/saveUserProfile",KServerURL];
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in dictUserProfile)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dictUserProfile objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSString* FileParamConstant = [NSString stringWithFormat:@"userImage"];
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"userImage.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [self sendRequest:request];
    [url release];
    [request release];
    
}
 */

-(void)saveUserProfileWithBartsyLogin:(NSString*)strBartsyLogin bartsyPassword:(NSString*)strBartsyPassword fbUserName:(NSString*)strFbUserName fbId:(NSString*)strFbID googleId:(NSString*)strGoogleId loginType:(NSString*)strLoginType gender:(NSString*)strGender profileImage:(UIImage*)imgProfile orientation:(NSString*)strOrientation nickName:(NSString*)strNickName showProfile:(NSString*)strShowProfileStatus creditCardNumber:(NSString*)strcreditCardNumber expiryDate:(NSString*)strExpiryMonth expYear:(NSString*)strExpYear firstName:(NSString*)strFirstName lastName:(NSString*)strLastName dob:(NSString*)strDOB status:(NSString*)strStatus description:(NSString*)strDescription delegate:(id)aDelegate
{
    
    self.delegate=aDelegate;
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSData *imageData= UIImagePNGRepresentation(imgProfile);

    NSMutableDictionary *dictProfile=[[NSMutableDictionary alloc] init];
    //WithObjectsAndKeys:strBartsyLogin,@"barstyLogin",strUserName,@"facebookUserName",strPassword,@"password",strNickName,@"nickname",@"facebook",@"loginType",@"1",@"deviceType",appDelegate.deviceToken,@"deviceToken",strGender,@"gender",strOrientation,@"orientation",strShowProfileStatus,@"showProfile",strcreditCardNumber,@"creditCardNumber",strExpiryDate,@"expMonth",strExpYear,@"expYear",strStatus,@"status",strDescription,@"description",strEmailId,@"emailId",strDOB,@"dateofbirth",strFirstName,@"firstname",strLastName,@"lastname",nil];

    [dictProfile setObject:strBartsyLogin forKey:@"bartsyLogin"];
    [dictProfile setObject:strBartsyPassword forKey:@"bartsyPassword"];
    [dictProfile setObject:strFbUserName forKey:@"facebookUserName"];
   
    if(strFbID!=nil&&[strFbID length])
    [dictProfile setObject:strFbID forKey:@"facebookId"];
    
    if(strGoogleId!=nil&&[strGoogleId length])
    [dictProfile setObject:strGoogleId forKey:@"googleId"];
    
    [dictProfile setObject:strGender forKey:@"gender"];
    [dictProfile setObject:strNickName forKey:@"nickname"];
    [dictProfile setObject:@"1" forKey:@"deviceType"];
    [dictProfile setObject:appDelegate.deviceToken forKey:@"deviceToken"];
    [dictProfile setObject:strOrientation forKey:@"orientation"];
    [dictProfile setObject:strShowProfileStatus forKey:@"showProfile"];
    
    if(strcreditCardNumber!=nil&&[strcreditCardNumber length])
    [dictProfile setObject:strcreditCardNumber forKey:@"creditCardNumber"];
    
    if(strExpiryMonth!=nil&&[strExpiryMonth length])
    [dictProfile setObject:strExpiryMonth forKey:@"expMonth"];
    
    if(strExpYear!=nil&&[strExpYear length])
    [dictProfile setObject:strExpYear forKey:@"expYear"];
    
    [dictProfile setObject:strDOB forKey:@"dateofbirth"];
    
    [dictProfile setObject:strDescription forKey:@"description"];
    
    if(strFirstName!=nil&&[strFirstName length])
    [dictProfile setObject:strFirstName forKey:@"firstname"];
    
    if (strLastName!=nil&&[strLastName length])
    [dictProfile setObject:strLastName forKey:@"lastname"];
    
    [dictProfile setObject:strStatus forKey:@"status"];
    
    [dictProfile setValue:KAPIVersionNumber forKey:@"apiVersion"];
    
    NSMutableDictionary *dictUserProfile=[[NSMutableDictionary alloc]initWithObjectsAndKeys:dictProfile,@"details", nil];
    
    NSLog(@"Profile Info : \n %@",dictUserProfile);
    
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/user/saveUserProfile",KServerURL];
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in dictUserProfile)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dictUserProfile objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSString* FileParamConstant = [NSString stringWithFormat:@"userImage"];
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"userImage.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [self sendRequest:request];
    [url release];
    [request release];

}

-(void)createOrderWithOrderStatus:(NSString*)strStatus basePrice:(NSString*)strBasePrice totalPrice:(NSString*)strTotalPrice tipPercentage:(NSString*)strPercentage itemName:(NSString*)strName produceId:(NSString*)strProdId description:(NSString*)strDescription receiverBartsyId:(NSString*)strReceiverId delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if(strProdId==nil&&strProdId!=(id)[NSNull null])
        strProdId=@"1";
    
    NSMutableDictionary *dictProfile=[[NSMutableDictionary alloc] initWithObjectsAndKeys:strStatus,@"orderStatus",strBasePrice,@"basePrice",strTotalPrice,@"totalPrice",strPercentage,@"tipPercentage",strName,@"itemName",strProdId,@"itemId",[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"],@"venueId",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"],@"bartsyId",strDescription,@"description",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"],@"recieverBartsyId",@"NO",@"drinkAcceptance",@"Take care",@"specialInstructions", nil];
    [dictProfile setValue:KAPIVersionNumber forKey:@"apiVersion"];

    //NSMutableDictionary *dictProfile=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"New",@"orderStatus",@"10",@"basePrice",@"11",@"totalPrice",@"10",@"tipPercentage",@"Chilled Beer(Knockout)",@"itemName",@"143",@"itemId", nil];
    
    NSLog(@"Order Details : \n %@",dictProfile);
    
    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictProfile];
    NSData *dataProfile=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/order/placeOrder",KServerURL];
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataProfile];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[self sendRequest:request];
    
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
             [delegate controllerDidFinishLoadingWithResult:result];
         }
         else
         {
             NSLog(@"Error is %@",error);
             [delegate controllerDidFailLoadingWithError:error];
         }
         
     }
     ];
    
    [url release];
    [request release];
}

-(void)checkInAtBartsyVenueWithId:(NSString*)strVenueId delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/user/userCheckIn",KServerURL];
    
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:strVenueId,@"venueId",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"],@"bartsyId",nil];
    
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];

    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictCheckIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self sendRequest:request];
    [url release];
    [request release];
}


-(void)checkOutAtBartsyVenueWithId:(NSString*)strVenueId delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/user/userCheckOut",KServerURL];
    
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:strVenueId,@"venueId",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"],@"bartsyId",nil];
    
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];

    
    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictCheckIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self sendRequest:request];
    [url release];
    [request release];
}

-(void)gettingPeopleListFromVenue:(NSString*)strVenueId delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/data/checkedInUsersList",KServerURL];
    
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:strVenueId,@"venueId",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"],@"bartsyId",nil];
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];

    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictCheckIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self sendRequest:request];
    [url release];
    [request release];
}

-(void)getUserOrdersWithBartsyId:(NSString*)strBartsyId delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/data/getUserOrders",KServerURL];
    
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:strBartsyId,@"bartsyId",nil];
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];

    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictCheckIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self sendRequest:request];
    [url release];
    [request release];
}

-(void)heartBeatWithBartsyId:(NSString*)strBartsyId venueId:(NSString*)strVenueId delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/user/heartBeat",KServerURL];
    
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:strVenueId,@"venueId",strBartsyId,@"bartsyId",nil];
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];

    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictCheckIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [NSURLConnection connectionWithRequest:request delegate:nil];
    [url release];
    [request release];
}

-(void)getIngredientsListWithVenueId:(NSString*)strVenueId delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/inventory/getIngredients",KServerURL];
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:strVenueId,@"venueId",nil];
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];

    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictCheckIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self sendRequest:request];
    [url release];
    [request release];
}

-(void)createOrderWithOrderStatus:(NSString*)strStatus basePrice:(NSString*)strBasePrice totalPrice:(NSString*)strTotalPrice tipPercentage:(NSString*)strPercentage itemName:(NSString*)strName produceId:(NSString*)strProdId description:(NSString*)strDescription ingredients:(NSArray*)arrIngredients delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSMutableDictionary *dictProfile=[[NSMutableDictionary alloc] initWithObjectsAndKeys:strStatus,@"orderStatus",strBasePrice,@"basePrice",strTotalPrice,@"totalPrice",strPercentage,@"tipPercentage",strName,@"itemName",strProdId,@"itemId",[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"],@"venueId",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"],@"bartsyId",strDescription,@"description",arrIngredients,@"ingredients",@"custom",@"type", nil];
    [dictProfile setValue:KAPIVersionNumber forKey:@"apiVersion"];

    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictProfile];
    
    NSLog(@"JSON string \n %@",strJson);
    
    NSData *dataProfile=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/order/placeOrder",KServerURL];
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataProfile];
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
             NSLog(@"JSON response is %@",jsonString);

             id result = [jsonParser objectWithString:jsonString error:nil];
             NSLog(@"Result is %@",result);
             [delegate controllerDidFinishLoadingWithResult:result];
         }
         else
         {
             NSLog(@"Error is %@",[error description]);
             [delegate controllerDidFinishLoadingWithResult:error];
         }
         
     }
     ];
    
    [url release];
    [request release];
}

-(void)syncUserDetailsWithUserName:(NSString*)strUserName type:(NSString*)strType bartsyId:(NSString*)strBartsyId delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/user/syncUserDetails",KServerURL];

    NSString *strLoginType=[NSString stringWithFormat:@"%@",([strType isEqualToString:@"facebook"]?@"facebookId":@"googleId")];
    
    
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:strType,@"type",strUserName,strLoginType,appDelegate.deviceToken,@"deviceToken",@"1",@"deviceType",strBartsyId,@"bartsyId",nil];
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];

    NSLog(@"Sync Details %@",dictCheckIn);
    
    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictCheckIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self sendRequest:request];
    [url release];
    [request release];
}

-(void)loginWithEmailID:(NSString*)strEmailId password:(NSString*)strPassword delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/user/bartsyUserLogin",KServerURL];
    NSMutableDictionary *dictLogIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:strEmailId,@"bartsyLogin",strPassword,@"bartsyPassword",nil];
    [dictLogIn setValue:KAPIVersionNumber forKey:@"apiVersion"];

    NSLog(@"Login Details %@",dictLogIn);
    
    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictLogIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self sendRequest:request];
    [url release];
    [request release];
}

-(void)getUserProfileWithBartsyId:(NSString*)strBastsyId delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/user/getUserProfile",KServerURL];
    
    NSMutableDictionary *dictLogIn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:strBastsyId,@"bartsyId",nil];
    [dictLogIn setValue:KAPIVersionNumber forKey:@"apiVersion"];

    NSLog(@"Login Details %@",dictLogIn);
    
    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictLogIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self sendRequest:request];
    [url release];
    [request release];
}

-(void)getPastOrderWithVenueWithId:(NSString*)strVenueId bartsyId:(NSString*)strbartsyId date:(NSString*)date  delegate:(id)aDelegate
{
    self.delegate=aDelegate;
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/order/getPastOrders",KServerURL];
    
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] init ];
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];
    if(date!=nil&&[date length])
    [dictCheckIn setObject:date forKey:@"date"];
    [dictCheckIn setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] forKey:@"bartsyId"];
    [dictCheckIn setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] forKey:@"venueId"];

    NSLog(@"dict is %@",dictCheckIn);
    SBJSON *jsonObj=[SBJSON new];
    NSString *strJson=[jsonObj stringWithObject:dictCheckIn];
    NSData *dataCheckIn=[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataCheckIn];
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
            [self showAlertWithTitle:@"NetWorkStatus" message:@"Internet Connection Required" delegate:nil];
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
    
    NSLog(@" JSON String ----- :%@",jsonString);

    NSError *outError = nil;
        
    id result = [jsonParser objectWithString:jsonString error:&outError];
    if (outError == nil )
    {
        NSLog(@" result ----- :%@",result);
        if([result isKindOfClass:[NSDictionary class]])
        {
            if([[result objectForKey:@"errorCode"] integerValue]==100)
            {
                [appDelegate showAPIVersionAlertWithReason:[result objectForKey:@"errorMessage"]];
                return;
            }
        }
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
