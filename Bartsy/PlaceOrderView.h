//
//  PlaceOrderView.h
//  Bartsy
//
//  Created by Techvedika on 8/28/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceOrderView : UIViewController{
    
    IBOutlet UIImageView *imgReciepent;
    IBOutlet UILabel *lblReciepName;
    IBOutlet UILabel *lblTotalPrice;
    IBOutlet UILabel *lblTip;
    IBOutlet UILabel *lblTax;
    IBOutlet UILabel *lblOrderCount;
    
    IBOutlet UIView *OrdersCell;
}

@end
