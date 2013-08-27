//
//  AccountInfoViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 11/07/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "AccountInfoViewController.h"

@interface AccountInfoViewController (){
    
    UIImageView *profileImg;
    UILabel *profileName;
    UITextView *aboutme;
    
    UITableView *pastordersTbl;
    
    BOOL is_pastOrders;
    
    NSMutableArray *pastorderArray;
}

@end

@implementation AccountInfoViewController
@synthesize resultAccountInfo;
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
    
    is_pastOrders=NO;
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    [self.sharedController getUserProfileWithBartsyId:[[NSUserDefaults standardUserDefaults] valueForKey:@"bartsyId"] delegate:self];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.sharedController=[SharedController sharedController];
    
    //Navigation Bar implementation
   /* self.view.backgroundColor=[UIColor colorWithRed:0.09 green:0.09 blue:0.098 alpha:1.0];
    UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [self.view addSubview:imgViewForTop];
    [imgViewForTop release];
    
    UILabel *lblMsg=[self createLabelWithTitle:@"User Profile" frame:CGRectMake(0, 0, 320, 44) tag:0 font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] numberOfLines:1];
    lblMsg.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblMsg];*/
    
    /*UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(100.25, 13.25, 119.5, 23.5)];
    imgLogo.image=[UIImage imageNamed:@"logo_Header.png"];
    [self.view addSubview:imgLogo];
    [imgLogo release];*/
    
    //Setting's Button declaration
    
    
  /*  UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(280, 0, 50, 44);
    [settingBtn addTarget:self action:@selector(Button_Action:) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.tag=401;
    [self.view addSubview:settingBtn];
    
    UIImageView *imgViewBack = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
    imgViewBack.image = [UIImage imageNamed:@"settings"];
    [settingBtn addSubview:imgViewBack];
    [imgViewBack release];
  
    
    UILabel *lblcheckin=[self createLabelWithTitle:@"Edit:" frame:CGRectMake(-22, 0, 140, 44) tag:9996 font:[UIFont boldSystemFontOfSize:12] color:[UIColor blackColor] numberOfLines:0];
    lblcheckin.textAlignment=NSTextAlignmentLeft;
    [settingBtn addSubview:lblcheckin];
    
    is_pastOrders=NO;
    
    profileImg=[[UIImageView alloc]initWithFrame:CGRectMake(20,imgViewForTop.frame.size.height+20,90, 90)];
    profileImg.layer.borderColor=[UIColor whiteColor].CGColor;
    profileImg.image=[UIImage imageNamed:@"logo_Header"];
    [self.view addSubview:profileImg];
    
    profileName=[self createLabelWithTitle:@"" frame:CGRectMake(20, profileImg.frame.size.height+profileImg.frame.origin.y+2, 300, 70) tag:0 font:[UIFont systemFontOfSize:30] color:[UIColor colorWithRed:191.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0] numberOfLines:1];
    [self.view addSubview:profileName];
    
    aboutme=[[UITextView alloc]initWithFrame:CGRectMake(12,profileName.frame.size.height+profileName.frame.origin.y-10, 300, 45)];
    aboutme.backgroundColor=[UIColor clearColor];
    aboutme.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
    aboutme.font=[UIFont systemFontOfSize:14];
    aboutme.textAlignment=NSTextAlignmentLeft;
    aboutme.editable=NO;
    [self.view addSubview:aboutme];
    
    pastorderArray=[[NSMutableArray alloc]init];
    
    pastordersTbl=[[[UITableView alloc]initWithFrame:CGRectMake(0, aboutme.frame.origin.y+aboutme.frame.size.height, 320, 133) style:UITableViewStylePlain] autorelease];
    if (IS_IPHONE_5) {
        
        pastordersTbl.frame=CGRectMake(0, aboutme.frame.origin.y+aboutme.frame.size.height, 320, 230);
    }
	pastordersTbl.delegate=self;
	pastordersTbl.dataSource=self;
    pastordersTbl.backgroundColor=[UIColor colorWithRed:0.09 green:0.09 blue:0.098 alpha:1.0];
    [pastordersTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [pastordersTbl setShowsVerticalScrollIndicator:NO];
	[self.view addSubview:pastordersTbl];*/
    
    lblStatus.font=[UIFont fontWithName:@"Museo Sans" size:14];
    lbldetails.font=[UIFont fontWithName:@"Museo Sans" size:14];
    TxtViewDescription.font=[UIFont fontWithName:@"Museo Sans" size:14];
    //lblNickName.font=[UIFont fontWithName:@"MuseoSans-300" size:14];

    
}
-(IBAction)btnBack_TouchUpInside
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-----------Button Actions

-(void)Button_Action:(UIButton*)sender{
    
    if (sender.tag==401) {
        
        AccountSettingsViewController *obj = [[AccountSettingsViewController alloc]init];
        [self.navigationController pushViewController:obj animated:YES];
        [obj release];
    }
    
}

#pragma mark-----------Tableview Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        
    return pastorderArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 153;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0,0, 320,60)];
    headerview.backgroundColor=[UIColor blackColor];

   UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(12,-5,200,30)];
    title.textAlignment=NSTextAlignmentLeft;
    title.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
    title.text=@"Past Orders";
    title.backgroundColor=[UIColor clearColor];
    title.font=[UIFont systemFontOfSize:12];
    [headerview addSubview:title ];
    [title release];
    
   /* UILabel *checkinlbl=[[UILabel alloc]initWithFrame:CGRectMake(260,-5,60,30)];
    checkinlbl.textAlignment=NSTextAlignmentLeft;
    checkinlbl.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
    checkinlbl.text=@"Check-ins";
    checkinlbl.backgroundColor=[UIColor clearColor];
    checkinlbl.font=[UIFont systemFontOfSize:12];
    [headerview addSubview:checkinlbl ];
    [checkinlbl release];*/
    return [headerview autorelease];
}
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
     PastOrdersCell *cell = [tableView1 dequeueReusableCellWithIdentifier:MyIdentifier];
    NSDictionary *dictForOrder=[pastorderArray objectAtIndex:indexPath.row];
    if (cell == nil)
    {
        cell = [[PastOrdersCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:MyIdentifier];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fathers_office-bg.png"]];
    cell.backgroundView = bg;
    [bg release];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.venuename.text=[NSString stringWithFormat:@"Venue:%@",[dictForOrder objectForKey:@"venueName"]];
    NSMutableString *itemName = [[NSMutableString alloc]init];
    NSArray *array1Temp=[dictForOrder valueForKey:@"itemsList"];
    for (int i=0; i<array1Temp.count; i++) {
        NSDictionary *dict1Temp=[array1Temp objectAtIndex:i];
        
        [itemName appendFormat:@"%@,",[dict1Temp valueForKey:@"itemName"]];
        
    }
    NSString *strTrim;
    if ([itemName length]>1) {
        strTrim = (NSMutableString*)[itemName substringToIndex:[itemName length]-1];
    }
    cell.title.text=[NSString stringWithFormat:@"Item:%@",strTrim];
    [itemName release];
    if ([[dictForOrder objectForKey:@"description"] isKindOfClass:[NSNull class]])
      cell.description.text=@"";
    else
     cell.description.text=[dictForOrder objectForKey:@"description"];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat       = @"yyyy-MM-dd'T'HH:mm:ssZ";
    NSDate *date    = [dateFormatter dateFromString:[dictForOrder objectForKey:@"dateCreated"]];
    
    
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
    
    cell.lblTime.text=strDate1;
    if ([dictForOrder objectForKey:@"picked"]) {
        
        cell.lblPickedtime.text=[NSString stringWithFormat:@"Picked at:%@",@"Not available"];

    }else{
        cell.lblPickedtime.text=[NSString stringWithFormat:@"Picked at: %@",@"Order was Cancelled"];

    }
    cell.lblSender.text = [NSString stringWithFormat:@"Sender : %@",[dictForOrder objectForKey:@"senderNickname"]];
    cell.lblRecepient.text = [NSString stringWithFormat:@"Recipient : %@",[dictForOrder objectForKey:@"recipientNickname"]];
   
    if([[[pastorderArray objectAtIndex:indexPath.row] objectForKey:@"senderBartsyId"]doubleValue]==[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] doubleValue]&&[[pastorderArray objectAtIndex:indexPath.row] objectForKey:@"lastState"]!=(id)[NSNull null]&&[[[pastorderArray objectAtIndex:indexPath.row] objectForKey:@"lastState"] integerValue]!=1)
    {
        NSString *stringFortotalPrice = [NSString stringWithFormat:@"$%.2f",[[dictForOrder objectForKey:@"totalPrice"] floatValue]];
        cell.lblTotalPrice.text=stringFortotalPrice;
    }
    
     cell.lblOrderId.text = [NSString stringWithFormat:@"OrderId : %@",[dictForOrder objectForKey:@"orderId"]];
    

    return cell;
}


#pragma mark-----------Sharedcontroller Delegate
-(void)controllerDidFinishLoadingWithResult:(id)result{
   // if (!is_pastOrders) {
    [self hideProgressView:nil];
        SDImageCache *sharedSDImageCache=[SDImageCache sharedImageCache];
        [sharedSDImageCache clearMemory];
        [sharedSDImageCache clearDisk];
        [sharedSDImageCache cleanDisk];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
        
            if ([[result valueForKey:@"errorCode"] integerValue]==0) {
                
                NSLog(@"Dictionary %@  \n URL is %@",result,[NSString stringWithFormat:@"%@/%@",KServerURL,[result valueForKey:@"userImage"]]);
        
                //resultAccountInfo=[result retain];
                lblNickName.text=[result valueForKey:@"nickname"];
                [ProfileImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KServerURL,[result valueForKey:@"userImage"]]]];
                profileName.text=[result valueForKey:@"nickname"];
                
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                NSDate *birthdate=[dateFormatter dateFromString:[result valueForKey:@"dateofbirth"]];
                NSDate* now = [NSDate date];
                NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                                   components:NSYearCalendarUnit
                                                   fromDate:birthdate
                                                   toDate:now
                                                   options:0];
                NSInteger age = [ageComponents year];
                
                
                NSMutableString *strdetails=[[NSMutableString alloc]init];
                [strdetails appendFormat:@"%d",age];
                if ([result valueForKey:@"gender"]) {
                    [strdetails appendFormat:@"/%@",[result valueForKey:@"gender"]];
                }
                
                if ([result valueForKey:@"orientation"] && [[result valueForKey:@"orientation"] length]) {
                    [strdetails appendFormat:@"/%@",[result valueForKey:@"orientation"]];
                }
                lbldetails.text=strdetails;

                lblStatus.text=[result valueForKey:@"status"];
                
                TxtViewDescription.text=[result valueForKey:@"description"];
                [dateFormatter release];
                //[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reloadPIC) userInfo:nil repeats:NO];
            }else{
                
                [self createAlertViewWithTitle:@"Error" message:[result valueForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
            }
        
        }else if ([result isKindOfClass:[NSArray class]]){
        
        
            NSLog(@"Array %@",result);
    
        }
        //is_pastOrders=YES;
        //[pastorderArray removeAllObjects];
        //[self.sharedController getPastOrderbbybartsyId:[[NSUserDefaults standardUserDefaults] objectForKey:@"bartsyId"] delegate:self];
    /*}else{
        [self hideProgressView:nil];

        if ([result isKindOfClass:[NSDictionary class]]) {
            
            
            NSLog(@"Dictionary %@",result);
            if ([[result valueForKey:@"errorCode"]integerValue]==0) {
                
              NSArray  *resultarray=[result valueForKey:@"pastOrders"];
                
                for (NSDictionary *dic in resultarray) {
                    
                    [pastorderArray addObject:dic];
                    
                }
                [pastordersTbl reloadData];
            }else{
                [self createAlertViewWithTitle:@"Error" message:@"Oops no orders found!" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
            }
            
        }else if ([result isKindOfClass:[NSArray class]]){
            
            
            NSLog(@"Array %@",result);
            
        }
        is_pastOrders=NO;
    }*/
}
-(void)controllerDidFailLoadingWithError:(NSError*)error{
    
    [self hideProgressView:nil];

    [self createAlertViewWithTitle:@"Error" message:[error localizedDescription] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:nil tag:0];
    
}

-(void)reloadPIC
{
    [profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KServerURL,[resultAccountInfo valueForKey:@"userImage"]]]];
}

-(void)dealloc{
    
    [super dealloc];
    [profileImg release];
    [profileName release];
    [aboutme release];
    [pastorderArray release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
