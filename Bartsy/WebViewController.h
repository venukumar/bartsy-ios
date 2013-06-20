//
//  WebViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 20/06/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>
{
    NSString *strTitle;
    NSString *strHTMLPath;
}
@property(nonatomic,retain)NSString *strTitle;
@property(nonatomic,retain)NSString *strHTMLPath;
@end
