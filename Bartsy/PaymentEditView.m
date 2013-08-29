//
//  PaymentEditView.m
//  Bartsy
//
//  Created by Techvedika on 8/29/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "PaymentEditView.h"

@interface PaymentEditView ()

@end

@implementation PaymentEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dictProfileInfo=[[NSMutableDictionary alloc]init];

    
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    self.sharedController=[SharedController sharedController];
    [sharedController getUserProfileWithBartsyId:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] delegate:self];
    
    [self getServerPublicKey];
}

-(void)getServerPublicKey
{
    NSString *strURL=[NSString stringWithFormat:@"%@/Bartsy/user/getServerPublicKey",KServerURL];
    
    NSMutableDictionary *dictCheckIn=[[NSMutableDictionary alloc] init];
    [dictCheckIn setValue:KAPIVersionNumber forKey:@"apiVersion"];
    //[dictCheckIn setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthCode"] forKey:@"oauthCode"];
    
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
             strServerPublicKey = [[NSString alloc] initWithData:dataOrder encoding:NSUTF8StringEncoding];
             NSLog(@"Key is \n %@",strServerPublicKey);
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

#pragma mark--------------Webservice Delegates
-(void)controllerDidFinishLoadingWithResult:(id)result{
    
    [self hideProgressView:nil];
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        if ([[result valueForKey:@"errorCode"] integerValue]==0) {
            
            NSLog(@"Dictionary %@  \n URL is %@",result,[NSString stringWithFormat:@"%@/%@",KServerURL,[result valueForKey:@"userImage"]]);
            dictProfileInfo=[NSMutableDictionary dictionaryWithDictionary:result];
             if ([[result valueForKey:@"errorCode"] integerValue]==0) {
                 
                 if([[result objectForKey:@"creditCardNumber"]length]>=16)
                 {
                     creditCardInfo=[[CardIOCreditCardInfo alloc]init];
                     creditCardInfo.cardNumber=[result objectForKey:@"creditCardNumber"];
                     
                     // NSString *s=[Crypto decryptRSA:[result objectForKey:@"creditCardNumber"] key:strServerPublicKey data:data];
                     if([result objectForKey:@"expMonth"]!=nil)
                         creditCardInfo.expiryMonth=[[result objectForKey:@"expMonth"] integerValue];
                     
                     if([result objectForKey:@"expYear"]!=nil)
                         creditCardInfo.expiryYear=[[result objectForKey:@"expYear"] integerValue];
                     
                     if([creditCardInfo.redactedCardNumber length]){
                         
                         lblcreditcardnumber.text=creditCardInfo.redactedCardNumber;
                     }
                 }

                 txtFirstname.text=[result valueForKey:@"firstname"];
                 txtLastname.text=[result valueForKey:@"lastname"];
             }
           
            
        }else{
            
            [self createAlertViewWithTitle:@"Error" message:[result valueForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
        }
        
    }
}

-(void)controllerDidFailLoadingWithError:(NSError*)error{
    
    [self hideProgressView:nil];
    
    [self createAlertViewWithTitle:@"Error" message:[error localizedDescription] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
    
}


-(IBAction)btnBack_TouchUpInside
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnCreditCard_TouchUpInside
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = @"0f13c2616ead46e7a000674d20743cfe"; // get your app token from the card.io website
    [self.navigationController presentViewController:scanViewController animated:YES completion:nil];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    creditCardInfo=[info retain];
    if([creditCardInfo.redactedCardNumber length]){
        
        lblcreditcardnumber.text=creditCardInfo.redactedCardNumber;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

-(IBAction)btnDelete_TouchUpInside
{
    creditCardInfo=nil;
    lblcreditcardnumber.text=nil;
}

#pragma mark------------Update User Profile
-(IBAction)UpdateProfile{
    
  /*  NSString *strEncryptedCreditCardNumber=[Crypto encryptRSA:creditCardInfo.cardNumber key:strServerPublicKey];
    [self createProgressViewToParentView:self.view withTitle:@"Updating profile..."];
       
    NSMutableDictionary *dictProfile=[[NSMutableDictionary alloc] init];
    if (txtFirstname.text.length && txtLastname.text.length) {
        [dictProfile setObject:txtFirstname.text forKey:@"firstname"];
        [dictProfile setObject:txtLastname.text forKey:@"lastname"];
    }else{
        
        [self createAlertViewWithTitle:@"" message:@"Please, enter firstname and lastname" cancelBtnTitle:@"Ok" otherBtnTitle:nil delegate:nil tag:0];
        return;
    }
    
    
    if(strEncryptedCreditCardNumber!=nil&&[strEncryptedCreditCardNumber length])
    {
        NSLog(@"strcredit %@",strEncryptedCreditCardNumber);
        NSMutableString *strCCNumber=[[NSMutableString alloc]initWithString:strEncryptedCreditCardNumber];
        strCCNumber=[strCCNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        strCCNumber=[strCCNumber stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        [dictProfile setObject:strCCNumber forKey:@"creditCardNumber"];
    }
    
    [dictProfile setObject:[NSString stringWithFormat:@"%i",creditCardInfo.expiryMonth] forKey:@"expMonth"];
    
     [dictProfile setObject:[NSString stringWithFormat:@"%i",creditCardInfo.expiryYear] forKey:@"expYear"];
    [dictProfile setObject:@"1" forKey:@"deviceType"];
    [dictProfile setObject:appDelegate.deviceToken forKey:@"deviceToken"];
    
    
    [dictProfile setValue:KAPIVersionNumber forKey:@"apiVersion"];
    
    
    NSMutableDictionary *dictUserProfile=[[NSMutableDictionary alloc]initWithObjectsAndKeys:dictProfile,@"details", nil];
    
    NSLog(@"dictprofile %@",dictUserProfile);
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
    
   // NSData *imageData=[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KServerURL,[dictProfileInfo valueForKey:@"userImage"]]];
    
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
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *dataOrder, NSError *error)
     {
         [self hideProgressView:nil];
         if(error==nil)
         {
             SBJSON *jsonParser = [[SBJSON new] autorelease];
             NSString *jsonString = [[[NSString alloc] initWithData:dataOrder encoding:NSUTF8StringEncoding] autorelease];
             id result = [jsonParser objectWithString:jsonString error:nil];
             
             [self createAlertViewWithTitle:@"" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
             
             
         }
         else
         {
             NSLog(@"Error is %@",error);
             [self createAlertViewWithTitle:@"" message:[error  localizedDescription] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
         }
         
     }
     ];*/
    
    
}

#pragma mark------------TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
   
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
