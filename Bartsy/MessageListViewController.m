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
    self.title = @"Messages";
    self.navigationController.navigationBarHidden=NO;
    self.sharedController=[SharedController sharedController];
    
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
    
    viewForTextField = [[UIView alloc] init];
    if (IS_IPHONE_5)
    {
        viewForTextField.frame = CGRectMake(0, 469, 320, 35);
    }
    else
    {
        viewForTextField.frame = CGRectMake(0, 381, 320, 35);
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

    
    //Adding Bubble View Table View Code
    bubbleTableView = [[UIBubbleTableView alloc]init];
    if (IS_IPHONE_5)
    {
        bubbleTableView.frame = CGRectMake(0, 0, 320, 465);
    }
    else
    {
        bubbleTableView.frame = CGRectMake(0, 0, 320, 382);
    }
    bubbleData = [[NSMutableArray alloc] init];
    
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
}
-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    isGetMessageWebService = YES;
    [self.sharedController getMessagesWithReceiverId:[dictForReceiver objectForKey:@"bartsyId"] delegate:self];
}

-(void)btnSend_TouchUpInside:(UIButton*)sender
{
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
     isGetMessageWebService=NO;
    isSendWebService = YES;
    [self.sharedController sendMessageWithSenderId:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] receiverId:[dictForReceiver objectForKey:@"bartsyId"] message:txtField.text delegate:self];
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
        viewForTextField.frame = frame;
        
        frame = bubbleTableView.frame;
        frame.size.height -= kbSize.height;
        bubbleTableView.frame = frame;
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = viewForTextField.frame;
        frame.origin.y += kbSize.height;
        viewForTextField.frame = frame;
        
        frame = bubbleTableView.frame;
        frame.size.height += kbSize.height;
        bubbleTableView.frame = frame;
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
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
        [self createAlertViewWithTitle:@"Error" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
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
            if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] stringValue] isEqualToString:[dictMsg objectForKey:@"senderId"]])
            {
                isSentByMe=YES;
            }
            isSentByMe=!isSentByMe;
            NSBubbleData *bubbleMsg = [NSBubbleData dataWithText:[dictMsg objectForKey:@"message"] date:date type:isSentByMe];
            
            if(!isSentByMe)
                bubbleMsg.avatar=imgSelf;
            else
                bubbleMsg.avatar=imgReceiver;
            
            [bubbleData addObject:bubbleMsg];
        }
        [bubbleTableView reloadData];
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
