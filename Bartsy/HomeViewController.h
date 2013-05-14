//
//  HomeViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 01/05/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PayPalMobile.h"

@interface HomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,PayPalPaymentDelegate>
{
    NSDictionary *dictSelectedToMakeOrder;
    BOOL isRequestForOrder;
}
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) PayPalPayment *completedPayment;

-(void)orderTheDrink;

@end
