//
//  WebViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 20/06/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize strTitle,strHTMLPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden=YES;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

	//self.navigationItem.title=[strTitle substringToIndex:[strTitle length]];
    UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [self.view addSubview:imgViewForTop];
    [imgViewForTop release];
    
    UILabel *lblMsg=[self createLabelWithTitle:@"Account Settings" frame:CGRectMake(0, 0, 320, 44) tag:0 font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] numberOfLines:1];
    lblMsg.textAlignment=NSTextAlignmentCenter;
    lblMsg.text=[strTitle substringToIndex:[strTitle length]];
    [self.view addSubview:lblMsg];
    
    NSString *strPth = [[NSBundle mainBundle]pathForResource:strHTMLPath ofType:@"html"];
    
    NSString *string = [[NSString alloc] initWithContentsOfFile:strPth];
    
    
	UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, imgViewForTop.frame.size.height, 320, [UIScreen mainScreen].bounds.size.height-104)];
    if (IS_IPHONE_5) {
        webView.frame=CGRectMake(0, imgViewForTop.frame.size.height, 320, [UIScreen mainScreen].bounds.size.height-100);
    }
	webView.delegate=self;
	webView.tag=333;
	webView.scalesPageToFit=YES;
	[self.view addSubview:webView];
    [webView loadHTMLString:string baseURL:nil];
	[webView release];

}

//starting activity indicator for showing the content loading
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicatorView.center = webView.center;
	activityIndicatorView.tag=444;
	[webView addSubview:activityIndicatorView];
	[activityIndicatorView startAnimating];
	[activityIndicatorView release];
}

//stoping and removing the activity indicator
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	UIActivityIndicatorView *activityIndicatorView =(UIActivityIndicatorView*)[webView viewWithTag:444];
	[activityIndicatorView removeFromSuperview];
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
