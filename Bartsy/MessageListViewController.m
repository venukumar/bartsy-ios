//
//  MessageListViewController.m
//  Bartsy
//
//  Created by Techvedika on 6/20/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "MessageListViewController.h"

@interface MessageListViewController ()
{
    BOOL isSendWebService;
}
@end

@implementation MessageListViewController
@synthesize dictForReceiver;
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
    self.title = @"Notifications";
    self.navigationController.navigationBarHidden=NO;
    self.sharedController=[SharedController sharedController];
    
//    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 415)];
//    tblView.dataSource=self;
//    tblView.delegate=self;
//    tblView.tag=111;
//    [self.view addSubview:tblView];
//
    UIButton *btnClose1=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"close.png"] frame:CGRectMake(278, 67, 30, 30) tag:1111 selector:@selector(btnClose_TouchUpInside:) target:self];
    [self.view addSubview:btnClose1];

	// Do any additional setup after loading the view.
}
-(void)btnClose_TouchUpInside:(UIButton*)sender
{
    isSendWebService = YES;
    [self.sharedController sendMessageWithSenderId:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] receiverId:[dictForReceiver objectForKey:@"bartsyId"] message:@"hello" delegate:self];
}
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text = @"hello";
    return cell;
}*/
#pragma mark- Shared controller delegates

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    [self hideProgressView:nil];
    
    if ([[result objectForKey:@"errorCode"] integerValue]!=0)
    {
        [self createAlertViewWithTitle:@"Error" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
        
    }
    else if ([[result objectForKey:@"notifications"] count])
    {
    }
}
-(void)controllerDidFailLoadingWithError:(NSError*)error;
{
    [self hideProgressView:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
