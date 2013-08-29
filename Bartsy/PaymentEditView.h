//
//  PaymentEditView.h
//  Bartsy
//
//  Created by Techvedika on 8/29/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CardIO.h"
#import "Crypto.h"
@interface PaymentEditView : BaseViewController<CardIOPaymentViewControllerDelegate>{
    
    NSString *strServerPublicKey;
    NSMutableDictionary *dictProfileInfo;

     CardIOCreditCardInfo *creditCardInfo;
    
    IBOutlet UITextField *txtFirstname;
    IBOutlet UITextField *txtLastname;
    IBOutlet UILabel *lblcreditcardnumber;
}
-(IBAction)btnBack_TouchUpInside;
-(IBAction)btnDelete_TouchUpInside;
-(IBAction)btnCreditCard_TouchUpInside;
@end
