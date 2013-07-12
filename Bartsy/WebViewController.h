//
//  WebViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 20/06/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Constants.h"

 enum{
    
    loginview=1,
    profileview=2
    
};
typedef NSInteger viewtype;
@interface WebViewController :BaseViewController <UIWebViewDelegate>
{
    NSString *strTitle;
    NSString *strHTMLPath;
    NSInteger viewtype;
}
@property(nonatomic,retain)NSString *strTitle;
@property(nonatomic,retain)NSString *strHTMLPath;
@property(nonatomic,assign)NSInteger viewtype;
@end
