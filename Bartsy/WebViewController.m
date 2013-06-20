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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
	self.navigationItem.title=[strTitle substringToIndex:[strTitle length]-3];
	
    
    NSString *strPth = [[NSBundle mainBundle]pathForResource:strHTMLPath ofType:@"html"];
    
    NSString *string = [[NSString alloc] initWithContentsOfFile:strPth];
    
    
	UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-60)];
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
