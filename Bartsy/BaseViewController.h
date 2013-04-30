//
//  BaseViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 26/04/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BaseViewController : UIViewController
{
    AppDelegate *appDelegate;
}
-(UIButton*)createUIButtonWithTitle:(NSString*)strTitle image:(UIImage*)image frame:(CGRect)frame tag:(NSInteger)intTage selector:(SEL)btnSelector target:(id)target;
-(UILabel*)createLabelWithTitle:(NSString*)strTitle frame:(CGRect)frame tag:(NSInteger)intTag font:(UIFont*)font color:(UIColor*)color numberOfLines:(NSInteger)intNoOflines;
@end
