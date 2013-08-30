//
//  UserProfileViewController.m
//  Bartsy
//
//  Created by Techvedika on 8/22/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController
@synthesize datepicker,txtEmail,txtPswd,txtConfirmPswd,txtNickname,txtDOB,accesoryView,txtGender,txtLookingto,txtOrientation,pickerObj,txtdescription;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.delegateForCurrentViewController=self;
}

- (void)viewDidLoad
{
    isChecked=YES;
    intOrientation=1;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    dictProfileInfo=[[NSMutableDictionary alloc]init];
    
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    self.sharedController=[SharedController sharedController];
    [sharedController getUserProfileWithBartsyId:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] delegate:self];
       
    [self getServerPublicKey];
    
    [scrollview setContentSize:CGSizeMake(scrollview.frame.size.width, 700)];
    
    [datepicker addTarget:self action:@selector(Dateformate:) forControlEvents:UIControlEventValueChanged];
    
    arrayGender=[[NSArray alloc]initWithObjects:@"",@"Male",@"Female", nil];
    arrayLookingTo=[[NSArray alloc]initWithObjects:@"",@"singles",@"friends", nil];
    arrayOrientation=[[NSArray alloc]initWithObjects:@"",@"Straight",@"Gay",@"Bisexual", nil];
    
    if (!IS_IPHONE_5) {
        
        [scrollview setFrame:CGRectMake(0,44, 320, 380)];
    }
    txtEmail.font=[UIFont fontWithName:@"MuseoSans-300" size:16.0];
    txtGender.font=[UIFont fontWithName:@"MuseoSans-300" size:16.0];
    txtLookingto.font=[UIFont fontWithName:@"MuseoSans-300" size:16.0];
    txtNickname.font=[UIFont fontWithName:@"MuseoSans-300" size:16.0];
    txtOrientation.font=[UIFont fontWithName:@"MuseoSans-300" size:16.0];
    txtdescription.font=[UIFont fontWithName:@"MuseoSans-300" size:16.0];
    txtDOB.font=[UIFont fontWithName:@"MuseoSans-300" size:16.0];
    
    
}

-(IBAction)btnBack_TouchUpInside
{
    [self.navigationController popViewControllerAnimated:YES];
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
        SDImageCache *sharedSDImageCache=[SDImageCache sharedImageCache];
        [sharedSDImageCache clearMemory];
        [sharedSDImageCache clearDisk];
        [sharedSDImageCache cleanDisk];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            if ([[result valueForKey:@"errorCode"] integerValue]==0) {
                
                NSLog(@"Dictionary %@  \n URL is %@",result,[NSString stringWithFormat:@"%@/%@",KServerURL,[result valueForKey:@"userImage"]]);
                dictProfileInfo=[[NSMutableDictionary alloc]initWithDictionary:result];
                
                [self LoadProfile];

                
            }else{
                
                [self createAlertViewWithTitle:@"Error" message:[result valueForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
            }
            
        }
}
    
-(void)controllerDidFailLoadingWithError:(NSError*)error{
    
    [self hideProgressView:nil];
    
    [self createAlertViewWithTitle:@"Error" message:[error localizedDescription] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
    
}

-(IBAction)Dateformate:(id)sender{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:kDateMMDDYYYY];
   NSString *strDOB= [NSString stringWithFormat:@"%@",
              [df stringFromDate:datepicker.date]];
    txtDOB.text=strDOB;
    
    
}
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag==101) {
        
        return [arrayGender count];
        
    }else if(pickerView.tag==102){
        
        return [arrayLookingTo count];
        
    }else if (pickerView.tag==103){
        
        return [arrayOrientation count];
    
    }
    
    return nil;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (pickerView.tag==101) {
        
        return [arrayGender objectAtIndex:row];
        
    }else if(pickerView.tag==102){
        
        return [arrayLookingTo objectAtIndex:row];
        
    }else if (pickerView.tag==103){
        
        return [arrayOrientation objectAtIndex:row];
        
    }
    
    return nil;
}

#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
    if (pickerView.tag==101) {
        
        txtGender.text=[arrayGender objectAtIndex:row];

    }else if (pickerView.tag==102){
        txtLookingto.text=[arrayLookingTo objectAtIndex:row];
    }else if (pickerView.tag==103){
        txtOrientation.text=[arrayOrientation objectAtIndex:row];
    }
   
}
-(void)LoadProfile{
    
    [ProfileImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KServerURL,[dictProfileInfo valueForKey:@"userImage"]]]];

    txtEmail.text=[dictProfileInfo valueForKey:@"email"];
    txtPswd.text=[dictProfileInfo valueForKey:@"bartsyPassword"];
    txtConfirmPswd.text=[dictProfileInfo valueForKey:@"bartsyPassword"];
    txtNickname.text=[dictProfileInfo valueForKey:@"nickname"];
    
    txtDOB.text=[dictProfileInfo valueForKey:@"dateofbirth"];
    txtGender.text=[dictProfileInfo valueForKey:@"gender"];
    if ([[dictProfileInfo valueForKey:@"status"] length]) {
        txtLookingto.text=[dictProfileInfo valueForKey:@"status"];
    }else{
        txtLookingto.text=@"";
    }
    if ([[dictProfileInfo valueForKey:@"orientation"] length]) {
        txtOrientation.text=[dictProfileInfo valueForKey:@"orientation"];

    }else{
        txtOrientation.text=@"";

    }
    if ([[dictProfileInfo valueForKey:@"description"] length]) {
       txtdescription.text=[dictProfileInfo valueForKey:@"description"]; 
    }else{
        txtdescription.text=@"Enter something about you that you'd like others to see while you're checked in at a venue";
        txtdescription.textColor=[UIColor lightGrayColor];

    }
    
    
}
-(IBAction)DismissPicker:(id)sender{
    
    if (txtGender.editing || txtLookingto.editing||txtOrientation.editing) {
        
        
        [accesoryView removeFromSuperview];
        [pickerObj removeFromSuperview];

    }
    if (txtDOB.editing) {
        
        [accesoryView removeFromSuperview];
        [datepicker removeFromSuperview];
    }

}
//-------------    Profile Button Actions   ------------//
-(IBAction)Selectprofilepic:(id)sender{
    
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo from camera",@"Select from Gallery", nil];
    [sheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraCaptureModePhoto])
        {
            UIImagePickerController *picker=[[UIImagePickerController alloc] init];
            picker.delegate=self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.showsCameraControls=YES;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else{
            NSLog(@"No Device");
        }
        
    } else if (buttonIndex == 1) {
        
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:nil];
        
    } else if (buttonIndex == 2) {
        
        
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIImage *resized=[self imageWithImage:image scaledToSize:CGSizeMake(130, 122)];
    
    ProfileImage.image=resized;
    
    [self dismissViewControllerAnimated:picker completion:nil];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
#pragma mark------------Update User Profile
-(IBAction)UpdateProfile{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *birthdate=[dateFormatter dateFromString:txtDOB.text];
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthdate
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
     [dateFormatter release];
    if ( age<21) {
        [self createAlertViewWithTitle:@"" message:@"Please,enter your date of birth and make sure user age is at least 21" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
        return;
        
    }
   
    [self createProgressViewToParentView:self.view withTitle:@"Updating profile..."];
    NSData *imageData= UIImagePNGRepresentation(ProfileImage.image);
    
    NSMutableDictionary *dictProfile=[[NSMutableDictionary alloc] init];
        [dictProfile setObject:txtEmail.text forKey:@"bartsyLogin"];
        [dictProfile setObject:txtEmail.text forKey:@"email"];
        [dictProfile setObject:txtConfirmPswd.text forKey:@"bartsyPassword"];
            
    [dictProfile setObject:txtGender.text forKey:@"gender"];
    [dictProfile setObject:txtNickname.text forKey:@"nickname"];
    [dictProfile setObject:@"1" forKey:@"deviceType"];
    [dictProfile setObject:appDelegate.deviceToken forKey:@"deviceToken"];
    [dictProfile setObject:txtOrientation.text forKey:@"orientation"];
    
       
    [dictProfile setObject:txtDOB.text forKey:@"dateofbirth"];
    
    if ([txtdescription.text isEqualToString:@"Enter something about you that you'd like others to see while you're checked in at a venue"]) {
        [dictProfile setObject:@"" forKey:@"description"];
    }else
       [dictProfile setObject:txtdescription.text forKey:@"description"];
    
    [dictProfile setObject:[dictProfileInfo valueForKey:@"firstname"] forKey:@"firstname"];
    [dictProfile setObject:[dictProfileInfo valueForKey:@"lastname"] forKey:@"lastname"];
    [dictProfile setObject:txtLookingto.text forKey:@"status"];
    
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
 
             if ([[result valueForKey:@"errorCode"] integerValue]==0) {
                 [self createAlertViewWithTitle:@"" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
                 [self.navigationController popViewControllerAnimated:YES];
             }else
            
                 [self createAlertViewWithTitle:@"" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
             

         }
         else
         {
             NSLog(@"Error is %@",error);
             [self createAlertViewWithTitle:@"" message:[error  localizedDescription] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
         }
         
     }
     ];

           
    [txtDOB resignFirstResponder];
    [txtGender resignFirstResponder];
    [txtLookingto resignFirstResponder];
    [txtOrientation resignFirstResponder];
    

}

-(IBAction)PickerView:(id)sender
{
    pickerObj = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    [self.view addSubview:pickerObj];
    pickerObj.delegate = self;
    pickerObj.showsSelectionIndicator = YES;
}
#pragma mark------------TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textField.inputAccessoryView=nil;
    textField.inputView=nil;
    
    if (textField==txtDOB) {
       [scrollview setContentOffset:CGPointMake(0,250 )];
        textField.inputAccessoryView=accesoryView;
        textField.inputView=datepicker;
    }else if (textField==txtGender){
        [scrollview setContentOffset:CGPointMake(0,290 )];

        [self PickerView:nil];
        pickerObj.tag=101;
        txtGender.inputAccessoryView=accesoryView;
        txtGender.inputView=pickerObj;
        [pickerObj reloadComponent:0];
    }else if (textField==txtLookingto){
        [scrollview setContentOffset:CGPointMake(0,320 )];
        [self PickerView:nil];
        pickerObj.tag=102;
        txtLookingto.inputAccessoryView=accesoryView;
        txtLookingto.inputView=pickerObj;
        [pickerObj reloadComponent:0];
    }else if (textField==txtOrientation){
        [scrollview setContentOffset:CGPointMake(0,360 )];
        [self PickerView:nil];
        
        pickerObj.tag=103;

        textField.inputAccessoryView=accesoryView;
        textField.inputView=pickerObj;
        [pickerObj reloadComponent:0];
    }else
     [scrollview setContentOffset:CGPointMake(0, textField.frame.origin.y-20)];

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    
    [scrollview setContentOffset:CGPointMake(0,0)];
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if([textView.text isEqualToString:@"Enter something about you that you'd like others to see while you're checked in at a venue"])
    {
        textView.text=@"";
        textView.textColor=[UIColor whiteColor];
    }
    [scrollview setContentOffset:CGPointMake(0, textView.frame.origin.y-50)];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return YES;
    }
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
