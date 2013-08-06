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
@synthesize strTitle,strHTMLPath,viewtype;

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
    
    UILabel *lblMsg=[self createLabelWithTitle:@"" frame:CGRectMake(0, 0, 320, 44) tag:0 font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] numberOfLines:1];
    lblMsg.textAlignment=NSTextAlignmentCenter;
    lblMsg.text=[strTitle substringToIndex:[strTitle length]];
    if(viewtype==1)
    {
        lblMsg.text=[strTitle substringToIndex:[strTitle length]-2];
    }
    [self.view addSubview:lblMsg];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(10, 11, 12, 20);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"arrow-left.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBack_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    
    UIButton *btnBack1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack1.frame = CGRectMake(10, 11, 40, 30);
    [btnBack1 addTarget:self action:@selector(btnBack_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack1];
    
    NSString *strPth = [[NSBundle mainBundle]pathForResource:strHTMLPath ofType:@"html"];
    
    NSString *string = [[NSString alloc] initWithContentsOfFile:strPth];
    
    
	UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, imgViewForTop.frame.size.height, 320, [UIScreen mainScreen].bounds.size.height-65)];
    if (viewtype==2) {
        webView.frame=CGRectMake(0, imgViewForTop.frame.size.height, 320, [UIScreen mainScreen].bounds.size.height-104);
    }
    if (IS_IPHONE_5) {
        if (viewtype==1) {
            webView.frame=CGRectMake(0, imgViewForTop.frame.size.height, 320, [UIScreen mainScreen].bounds.size.height-55);
        }else if (viewtype==2){
            webView.frame=CGRectMake(0, imgViewForTop.frame.size.height, 320, [UIScreen mainScreen].bounds.size.height-100);
        }
        
    }
	webView.delegate=self;
	webView.tag=333;
	webView.scalesPageToFit=YES;
	[self.view addSubview:webView];
    [webView loadHTMLString:string baseURL:nil];
	[webView release];

}

-(void)btnBack_TouchUpInside
{
    [self.navigationController popViewControllerAnimated:YES];
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
