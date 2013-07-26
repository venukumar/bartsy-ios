//
//  MessageListViewController.m
//  Bartsy
//
//  Created by Techvedika on 6/20/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "MessageListViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"


@interface MessageListViewController ()
{
    BOOL isSendWebService;
    BOOL isGetMessageWebService;
    UIBubbleTableView *bubbleTableView;
    UITextField *txtField;
    UIView *viewForTextField;
    NSMutableArray *bubbleData;

}
@end

@implementation MessageListViewController
@synthesize dictForReceiver,imgSelf,imgReceiver;
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
    self.navigationController.navigationBarHidden=YES;
    self.sharedController=[SharedController sharedController];
    
    UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [self.view addSubview:imgViewForTop];
    [imgViewForTop release];
    
    UILabel *lblHeader=[self createLabelWithTitle:@"Messages" frame:CGRectMake(0, 2, 320, 40) tag:0 font:[UIFont boldSystemFontOfSize:16] color:[UIColor blackColor] numberOfLines:1];
    lblHeader.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblHeader];

    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(5, 0, 50, 40);
    [btnBack addTarget:self action:@selector(btnBack_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];

    UIImageView *imgViewBack = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 12, 20)];
    imgViewBack.image = [UIImage imageNamed:@"arrow-left.png"];
    [btnBack addSubview:imgViewBack];
    [imgViewBack release];

    NSURL *urlSelf=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Bartsy/userImages/%@",KServerURL,[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:urlSelf]
queue:[NSOperationQueue mainQueue]
completionHandler:^(NSURLResponse *response, NSData *dataOrder, NSError *error)
    {
        imgSelf=[[UIImage alloc] initWithData:dataOrder];
    }];
    
    NSURL *urlReceiver=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Bartsy/userImages/%@",KServerURL,[dictForReceiver objectForKey:@"bartsyId"]]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:urlReceiver]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *dataOrder1, NSError *error)
     {
         imgReceiver=[[UIImage alloc] initWithData:dataOrder1];
     }];
    
    
    //Adding Bubble View Table View Code
    bubbleTableView = [[UIBubbleTableView alloc]init];
    if (IS_IPHONE_5)
    {
        bubbleTableView.frame = CGRectMake(0, 44, 320, 420);
    }
    else
    {
        bubbleTableView.frame = CGRectMake(0, 44, 320, 332);
    }
    bubbleData = [[NSMutableArray alloc] init];
    bubbleTableView.backgroundColor = [UIColor blackColor];
    bubbleTableView.bubbleDataSource = self;
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    bubbleTableView.snapInterval = 120;
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    bubbleTableView.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
//   bubbleTableView.typingBubble = NSBubbleTypingTypeNone;
    [bubbleTableView reloadData];
    [self.view addSubview:bubbleTableView];

	// Do any additional setup after loading the view.
    
    /*
    UIButton   *btnRefresh=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRefresh.frame=CGRectMake(213.5,4, 30, 30);
    btnRefresh.tag=1000;
    [btnRefresh setBackgroundImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    [btnRefresh addTarget:self action:@selector(btnRefresh_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [bottomContentView addSubview:btnRefresh];
     */
    
    UIBarButtonItem *btnRefresh=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"refresh.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnRefresh_TouchUpInside)];
    self.navigationItem.rightBarButtonItem=btnRefresh;
    
    
    viewForTextField = [[UIView alloc] init];
    if (IS_IPHONE_5)
    {
        viewForTextField.frame = CGRectMake(0, 464, 320, 35);
    }
    else
    {
        viewForTextField.frame = CGRectMake(0, 376, 320, 35);
    }
    viewForTextField.backgroundColor = [UIColor grayColor];
    [self.view addSubview:viewForTextField];
    
    txtField = [[UITextField alloc] initWithFrame:CGRectMake(2,3, 275, 30)];
    txtField.borderStyle = UITextBorderStyleRoundedRect;
    txtField.placeholder=@"Type Message";
    txtField.delegate = self;
    txtField.autocorrectionType = UITextAutocorrectionTypeNo;
    txtField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [viewForTextField addSubview:txtField];
    
    UIButton *btnSend = [self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"arrow_chat.png"] frame:CGRectMake(285, 3, 28, 28) tag:1111 selector:@selector(btnSend_TouchUpInside:) target:self];
    [viewForTextField addSubview:btnSend];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    //Marking as all message read
    [[appDelegate.tabBar.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
}


-(void)btnRefresh_TouchUpInside
{
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    isGetMessageWebService = YES;
    [self.sharedController getMessagesWithReceiverId:[dictForReceiver objectForKey:@"bartsyId"] delegate:self];
    
   
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [appDelegate stopTimerForGetMessages];
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    isGetMessageWebService = YES;
    [self.sharedController getMessagesWithReceiverId:[dictForReceiver objectForKey:@"bartsyId"] delegate:self];
    getmsgtimer=  [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(Get_Messagetimer:) userInfo:nil repeats:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    if ([getmsgtimer isValid]) {
        
        [getmsgtimer invalidate];
    }

      [appDelegate startTimerTOGetMessages];
}
-(void)btnBack_TouchUpInside
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnSend_TouchUpInside:(UIButton*)sender
{
    if ([txtField.text length])
    {
        NSData *data = [txtField.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        NSString *encodedstr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self createProgressViewToParentView:self.view withTitle:@"Sending Message..."];
        isGetMessageWebService=NO;
        isSendWebService = YES;
        [self.sharedController sendMessageWithSenderId:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] receiverId:[dictForReceiver objectForKey:@"bartsyId"] message:encodedstr delegate:self];
        [encodedstr release];
    }
    else
    {
        [self.sharedController showAlertWithTitle:nil message:@"Message should not be empty" delegate:nil];
    }
}

-(void)Get_Messagetimer:(NSTimer*)sender{
    
    isGetMessageWebService = YES;
    [self.sharedController getMessagesWithReceiverId:[dictForReceiver objectForKey:@"bartsyId"] delegate:self];
    
}
#pragma mark - Keyboard notification methods

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^
    {
        
        CGRect frame = viewForTextField.frame;
        frame.origin.y -= kbSize.height;
        if (IS_IPHONE_5)
        {
            viewForTextField.frame = CGRectMake(0, 296.5, 320, 35);
        }
        else
        {
            viewForTextField.frame = CGRectMake(0, 209, 320, 35);
        }
        frame = bubbleTableView.frame;
        frame.size.height -= kbSize.height;
        if (IS_IPHONE_5)
        {
            bubbleTableView.frame = CGRectMake(0, 44, 320, 255);
        }
        else
        {
            bubbleTableView.frame = CGRectMake(0, 44, 320, 165);
        }
    }];
    
    if (IS_IPHONE_5)
    {
        if(intHeight>465)
        {
            [bubbleTableView setContentOffset:CGPointMake(0, intHeight-240) animated:YES];
        }
    }
    else if(intHeight>262)
    {
        [bubbleTableView setContentOffset:CGPointMake(0,intHeight-160) animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = viewForTextField.frame;
        frame.origin.y += kbSize.height;
        if (IS_IPHONE_5)
        {
            viewForTextField.frame = CGRectMake(0, 464, 320, 35);
        }
        else
        {
            viewForTextField.frame = CGRectMake(0, 376, 320, 35);
        }
        
        frame = bubbleTableView.frame;
        frame.size.height += kbSize.height;
        if (IS_IPHONE_5)
        {
            bubbleTableView.frame = CGRectMake(0, 45, 320, 420);
        }
        else
        {
            bubbleTableView.frame = CGRectMake(0, 44, 320, 332);
        }
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    
    if (IS_IPHONE_5)
    {
        if(intHeight>465)
        {
            [bubbleTableView setContentOffset:CGPointMake(0, intHeight-465) animated:YES];
        }
    }
    else if(intHeight>382)
    {
        [bubbleTableView setContentOffset:CGPointMake(0,intHeight-378) animated:YES];
    }
    
    if ([txtField.text length])
    {
        [self createProgressViewToParentView:self.view withTitle:@"Sending Message..."];
        isGetMessageWebService=NO;
        isSendWebService = YES;
        [self.sharedController sendMessageWithSenderId:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] receiverId:[dictForReceiver objectForKey:@"bartsyId"] message:txtField.text delegate:self];
    }
    else
    {
        [self.sharedController showAlertWithTitle:nil message:@"Message should not be empty" delegate:nil];
    }
    
    return YES;
}
#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}
#pragma mark- Shared controller delegates

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    [self hideProgressView:nil];
    
    if ([[result objectForKey:@"errorCode"] integerValue]!=0)
    {
        //[self createAlertViewWithTitle:@"" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
        NSLog(@"result %@",result);
    }
    else if (isGetMessageWebService == YES)
    {
        isGetMessageWebService=NO;
        [bubbleData removeAllObjects];
        
        NSMutableArray *arrayForMessages = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"messages"]];
        
        for (int i = 0 ; i<[arrayForMessages count]; i++)
        {
            NSDictionary *dictMsg=[arrayForMessages objectAtIndex:i];
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat       = @"yyyy-MM-dd'T'HH:mm:ssZ";
            NSDate *date    = [dateFormatter dateFromString:[dictMsg objectForKey:@"date"]];
            
            BOOL isSentByMe=NO;
            
            NSString *strBartsyId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]];
            if([strBartsyId doubleValue] ==[[dictMsg objectForKey:@"senderId"]doubleValue])
            {
                isSentByMe=YES;
            }
            isSentByMe=!isSentByMe;
            NSData *data = [[dictMsg objectForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
            NSString *decodedstr = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
           
            NSBubbleData *bubbleMsg = [NSBubbleData dataWithText:decodedstr date:date type:isSentByMe];
            
            if(!isSentByMe)
                bubbleMsg.avatar=imgSelf;
            else
                bubbleMsg.avatar=imgReceiver;
            
            [bubbleData addObject:bubbleMsg];
            [decodedstr release];
        }
        [bubbleTableView reloadData];
        
        [bubbleTableView layoutIfNeeded];
        
        CGSize tableViewSize=bubbleTableView.contentSize;
        intHeight=tableViewSize.height;
        
        if (IS_IPHONE_5)
        {
            if(intHeight>465)
            {
                if (bubbleData.count<4) 
                [bubbleTableView setContentOffset:CGPointMake(0, intHeight-420) animated:YES];
                else
                [bubbleTableView setContentOffset:CGPointMake(0, intHeight-240) animated:YES];
            }
        }
        else if(intHeight>382)
        {
            if (bubbleData.count<4) {
                [bubbleTableView setContentOffset:CGPointMake(0,intHeight-348) animated:YES];
            }else
               [bubbleTableView setContentOffset:CGPointMake(0,intHeight-160) animated:YES];
        }
        
        NSLog(@"TableView height is %i",intHeight);
    }
    else if (isSendWebService == YES)
    {
        txtField.text=@"";
        isGetMessageWebService = YES;
        [self.sharedController getMessagesWithReceiverId:[dictForReceiver objectForKey:@"bartsyId"] delegate:self];
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
