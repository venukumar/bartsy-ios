//
//  PastOrdersViewController.m
//  Bartsy
//
//  Created by Techvedika on 6/12/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "PastOrdersViewController.h"
@interface PastOrdersViewController ()

@end

@implementation PastOrdersViewController
@synthesize arrayForPastOrders,strDate;
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
    
        UIBarButtonItem *btnBack=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(btnCancel_TouchUpInside)];
        self.navigationItem.backBarButtonItem=btnBack;
    
    self.navigationItem.title=[NSString stringWithFormat:@"Displaying orders for %@",strDate];
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] init];
    [newAttributes setObject:[UIFont boldSystemFontOfSize:13.5] forKey:UITextAttributeFont];
    [self.navigationController.navigationBar setTitleTextAttributes:newAttributes];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderStatus == [c]'1' OR orderStatus == [c]'4' OR orderStatus == [c]'5' OR orderStatus == [c]'6' OR orderStatus == [c]'7' OR orderStatus == [c]'8'"];
    [arrayForPastOrders filterUsingPredicate:predicate];
    
    self.navigationController.navigationBarHidden=NO;
    self.sharedController=[SharedController sharedController];
    
    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 415)];
    if (IS_IPHONE_5)
    {
        tblView.frame = CGRectMake(0, 0, 320, 495);
    }
    tblView.dataSource=self;
    tblView.delegate=self;
    tblView.tag=111;
    [self.view addSubview:tblView];

	// Do any additional setup after loading the view.
}

-(void)btnCancel_TouchUpInside
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.delegateForCurrentViewController=self;
}
#pragma mark - Table view delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if ([arrayForPastOrders count]) {
        return [arrayForPastOrders count];
    }
    else
    {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  
    if ([arrayForPastOrders count])
    {
        UILabel *lblItemName = [self createLabelWithTitle:[[arrayForPastOrders objectAtIndex:indexPath.row] objectForKey:@"itemName"] frame:CGRectMake(10, 2, 250, 15) tag:0 font:[UIFont boldSystemFontOfSize:13] color:[UIColor blackColor] numberOfLines:1];
        lblItemName.backgroundColor=[UIColor clearColor];
        lblItemName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblItemName];
        
        UILabel *lbldescription = [self createLabelWithTitle:[[arrayForPastOrders objectAtIndex:indexPath.row] objectForKey:@"description"] frame:CGRectMake(10, 15,250, 45) tag:0 font:[UIFont systemFontOfSize:13] color:[UIColor grayColor] numberOfLines:3];
        lbldescription.backgroundColor=[UIColor clearColor];
        lbldescription.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbldescription];
        
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat       = @"yyyy-MM-dd'T'HH:mm:ssZ";
        NSDate *date    = [dateFormatter dateFromString:[[arrayForPastOrders objectAtIndex:indexPath.row] objectForKey:@"dateCreated"]];
        
        
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"aa kk:mm 'on' EEEE MMMM d"];
        
        NSString *newDateString = [outputFormatter stringFromDate:date];
        
        NSMutableArray *arrDateComps=[[NSMutableArray alloc]initWithArray:[newDateString componentsSeparatedByString:@" "]];
        
        if([arrDateComps count]==5)
        {
            NSString *strMeridian;
            NSString *strTime=[arrDateComps objectAtIndex:0];
            NSInteger intHours=[[[strTime componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
            if(intHours>=12)
            {
                strMeridian=[NSString stringWithFormat:@"PM"];
                NSString *strTime;
                
                if(intHours==12)
                {
                    strTime=[NSString stringWithFormat:@"%i:%i",12,[[arrDateComps objectAtIndex:1] integerValue]];
                }
                else
                {
                    strTime=[NSString stringWithFormat:@"%i:%i",intHours-12,[[arrDateComps objectAtIndex:1] integerValue]];
                    
                }
                [arrDateComps replaceObjectAtIndex:0 withObject:strTime];
            }
            else
            {
                strMeridian=[NSString stringWithFormat:@"AM"];
            }
            [arrDateComps insertObject:strMeridian atIndex:0];
        }
        
        
        NSCalendar * cal = [NSCalendar currentCalendar];
        NSDateComponents *comps = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit) fromDate:date];
        
        if([[arrDateComps objectAtIndex:0] isEqualToString:@"PM"]&&comps.hour>12)
            comps.hour-=12;
        
        NSString *strDate1 = [NSString stringWithFormat:@"Placed at: %@%i:%@%i:%@%i %@ on %@ %i,%i",(comps.hour<10? @"0" : @""),comps.hour,(comps.minute<10? @"0":@""),comps.minute,(comps.second<10? @"0":@""),comps.second,[arrDateComps objectAtIndex:0],[arrDateComps objectAtIndex:4],comps.day,comps.year];
        

        UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 280, 15)];
        lblTime.font = [UIFont systemFontOfSize:14];
        lblTime.text = strDate1;
        lblTime.tag = 1234234567;
        lblTime.backgroundColor = [UIColor clearColor];
        lblTime.textColor = [UIColor blackColor] ;
        lblTime.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblTime];
        [lblTime release];
        
        
        UILabel *lblRecepient = [[UILabel alloc]initWithFrame:CGRectMake(10, 75, 280, 15)];
        lblRecepient.font = [UIFont systemFontOfSize:14];
        lblRecepient.text = [NSString stringWithFormat:@"Recipient : %@",[[arrayForPastOrders objectAtIndex:indexPath.row] objectForKey:@"nickName"]];
        lblRecepient.tag = 1234234567;
        lblRecepient.backgroundColor = [UIColor clearColor];
        lblRecepient.textColor = [UIColor blackColor] ;
        lblRecepient.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblRecepient];
        [lblRecepient release];

        
        NSString *stringFortotalPrice = [NSString stringWithFormat:@"$%.2f",[[[arrayForPastOrders objectAtIndex:indexPath.row] objectForKey:@"totalPrice"] floatValue]];
        
        UILabel *lblTotalPrice = [self createLabelWithTitle:stringFortotalPrice frame:CGRectMake(270, 2, 200, 15) tag:0 font:[UIFont boldSystemFontOfSize:11] color:[UIColor blackColor] numberOfLines:1];
        lblTotalPrice.backgroundColor=[UIColor clearColor];
        lblTotalPrice.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblTotalPrice];
 
    }
    else
    {
        cell.textLabel.text=@"No past orders\nGo to the drinks tab to place some";
        cell.textLabel.numberOfLines=5;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 100;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
