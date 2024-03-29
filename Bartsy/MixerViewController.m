//
//  MixerViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 03/06/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "MixerViewController.h"
#import "PeopleViewController.h"
#import "UIImageView+WebCache.h"
@interface MixerViewController ()

@end

@implementation MixerViewController
@synthesize arrMixers,dictIngrident,dictSelectedToMakeOrder,dictPeopleSelectedForDrink;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if(appDelegate.isComingForOrders)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Back" object:nil];
        return;
    }}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title=@"Mixers";
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.delegateForCurrentViewController=self;
    UIBarButtonItem *btnContinue=[[UIBarButtonItem alloc]initWithTitle:@"Continue" style:UIBarButtonItemStylePlain target:self action:@selector(btnContinue_TouchUpInside)];
    self.navigationItem.rightBarButtonItem=btnContinue;
    
    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
    tblView.dataSource=self;
    tblView.delegate=self;
    [self.view addSubview:tblView];
    [tblView release];
    
}


-(void)btnContinue_TouchUpInside
{
    NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:arrMixers];
    [arrTemp filterUsingPredicate:[NSPredicate predicateWithFormat:@"Checked==1"]];
    
    if(1)
    {
        dictSelectedToMakeOrder=[[NSDictionary alloc]initWithDictionary:dictIngrident];
        
        UIView *viewA=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        viewA.backgroundColor=[UIColor clearColor];
        viewA.tag=222;
        [self.view addSubview:viewA];
        
        UIView *viewB=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        viewB.backgroundColor=[UIColor blackColor];
        viewB.layer.opacity=0.6;
        viewB.tag=333;
        [viewA addSubview:viewB];
        
        UIView *viewC = [[UIView alloc]initWithFrame:CGRectMake(12, 20, 295, 358)];
        viewC.layer.cornerRadius = 2;
        viewC.layer.borderWidth = 2;
        viewC.backgroundColor = [UIColor redColor];
        viewC.layer.borderColor = [UIColor redColor].CGColor;
        viewC.layer.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
        viewC.tag=444;
        [viewB addSubview:viewC];
        
        UIView *viewHeaderPhoto = [[UIView alloc]initWithFrame:CGRectMake(11, 5, 268, 90)];
        viewHeaderPhoto.backgroundColor = [UIColor blackColor];
        viewHeaderPhoto.layer.cornerRadius = 6;
        viewHeaderPhoto.tag = 11111;
        [viewC addSubview:viewHeaderPhoto];
        
        //NSMutableArray *arrPeopleTemp=[[NSMutableArray alloc]initWithArray:arrPeople];
        //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"bartsyId == %i",[[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] integerValue]];
        //[arrPeopleTemp filterUsingPredicate:predicate];
        
        NSLog(@"Bartsy id is %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]);
        
        for (int i=0; i<[appDelegate.arrPeople count]; i++)
        {
            NSDictionary *dictMember=[appDelegate.arrPeople objectAtIndex:i];
            if([[NSString stringWithFormat:@"%@",[dictMember objectForKey:@"bartsyId"]]isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]]])
            {
                dictTemp=[[NSMutableDictionary alloc] initWithDictionary:dictMember];
                break;
            }
        }
        
        
        UIImageView *imgViewPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(10,10,60,60)];
        NSString *strURL=[NSString stringWithFormat:@"%@/%@%@",KServerURL,[[NSUserDefaults standardUserDefaults]objectForKey:@"ImagePath"],[dictTemp objectForKey:@"bartsyId"]];
        
        NSLog(@"URL is %@",strURL);
        //[imgViewPhoto setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]]]];
        imgViewPhoto.tag=143225;
        [imgViewPhoto setImageWithURL:[NSURL URLWithString:strURL]];
        [viewHeaderPhoto addSubview:imgViewPhoto];
        [imgViewPhoto release];
        
        NSLog(@"nickname is %@",[dictTemp objectForKey:@"nickname"]);
        
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 72, 120, 18)];
        lblName.text=[dictTemp objectForKey:@"nickName"];
        lblName.font=[UIFont systemFontOfSize:10];
        lblName.tag=111222333;
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=[UIColor whiteColor];
        [viewHeaderPhoto addSubview:lblName];
        [lblName release];
        
        UILabel *lblMsg=[[UILabel alloc]initWithFrame:CGRectMake(85, 10, 160, 60)];
        lblMsg.text=@"Click on photo if you would like to send drink to other people";
        lblMsg.font=[UIFont systemFontOfSize:15];
        lblMsg.numberOfLines=3;
        lblMsg.backgroundColor=[UIColor clearColor];
        lblMsg.textColor=[UIColor whiteColor];
        [viewHeaderPhoto addSubview:lblMsg];
        [lblMsg release];
        
        
        UIButton *btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPhoto.frame = CGRectMake(10,5,105,50);
        [btnPhoto addTarget:self action:@selector(btnPhoto_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        btnPhoto.backgroundColor=[UIColor clearColor];
        [viewHeaderPhoto addSubview:btnPhoto];
        
        [viewHeaderPhoto release];
        
        
        UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(11, 100, 268, 45)];
        viewHeader.backgroundColor = [UIColor blackColor];
        viewHeader.layer.cornerRadius = 6;
        viewHeader.tag = 555;
        [viewC addSubview:viewHeader];
        [viewHeader release];
        
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(7, 7, 250, 30)];
        lblTitle.font = [UIFont boldSystemFontOfSize:15];
        lblTitle.text = [dictIngrident objectForKey:@"name"];
        lblTitle.tag = 666;
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = [UIColor whiteColor] ;
        lblTitle.textAlignment = NSTextAlignmentCenter;
        [viewHeader addSubview:lblTitle];
        [lblTitle release];
        
        UIView *viewDetail = [[UIView alloc]initWithFrame:CGRectMake(11, 153, 200, 100)];
        viewDetail.backgroundColor = [UIColor whiteColor];
        viewDetail.layer.borderWidth = 1;
        viewDetail.layer.borderColor = [UIColor grayColor].CGColor;
        viewDetail.layer.cornerRadius = 6;
        viewDetail.tag = 777;
        [viewC addSubview:viewDetail];
        [viewDetail release];
        
        //    UIImageView *imgViewDrink = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 80)];
        //    imgViewDrink.image = [UIImage imageNamed:@"drinks.png"];
        //    imgViewDrink.layer.borderWidth = 1;
        //    imgViewDrink.layer.cornerRadius = 2;
        //    imgViewDrink.layer.borderColor = [UIColor grayColor].CGColor;
        //    [[imgViewDrink layer] setShadowOffset:CGSizeMake(0, 1)];
        //    [[imgViewDrink layer] setShadowColor:[[UIColor grayColor] CGColor]];
        //    [[imgViewDrink layer] setShadowRadius:3.0];
        //    [[imgViewDrink layer] setShadowOpacity:0.8];
        //    [viewDetail addSubview:imgViewDrink];
        //    [imgViewDrink release];
        
        NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
        NSPredicate *pred=[NSPredicate predicateWithFormat:@"Checked==1"];
        for (int i=0; i<[arrMixers count]; i++)
        {
            NSMutableArray *arrTem=[[NSMutableArray alloc]initWithArray:[[arrMixers objectAtIndex:i] objectForKey:@"ingredients"]];
            [arrTem filterUsingPredicate:pred];
            [arrTemp addObjectsFromArray:arrTem];
            [arrTem release];
        }
        NSMutableString *strDescription=[[NSMutableString alloc]init];
        for (NSDictionary *dict in arrTemp)
        {
            NSString *strDesc=[NSString stringWithFormat:@"%@,",[dict objectForKey:@"name"]];
            [strDescription appendString:strDesc];
        }
        
        if([strDescription length])
            strDescription=(NSMutableString*)[strDescription substringToIndex:[strDescription length]-1];
        
        NSString *strIngridentDescription=@"";
        if([[dictIngrident objectForKey:@"description"] length]&&[dictIngrident objectForKey:@"description"]!=nil &&[dictIngrident objectForKey:@"description"]!=(id)[NSNull null])
        {
            strIngridentDescription=[NSString stringWithFormat:@"%@",[dictIngrident objectForKey:@"description"]];
        }
        
        UITextView *txtViewNotes = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, 185, 50)];
        txtViewNotes.tag = 1000;
        txtViewNotes.backgroundColor = [UIColor clearColor];
        txtViewNotes.editable = NO;
        txtViewNotes.text =[NSString stringWithFormat:@"%@ \n%@",strIngridentDescription,strDescription];
        txtViewNotes.textColor = [UIColor blackColor];
        txtViewNotes.font = [UIFont boldSystemFontOfSize:10];
        [viewDetail addSubview:txtViewNotes];
        [txtViewNotes release];
        
        UIButton *btnCustomise = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCustomise.frame = CGRectMake(50,65,105,25);
        btnCustomise.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btnCustomise setTitle:@"Customise" forState:UIControlStateNormal];
        btnCustomise.titleLabel.textColor = [UIColor whiteColor];
        btnCustomise.backgroundColor=[UIColor blackColor];
        [btnCustomise addTarget:self action:@selector(btnCustomise_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        //[viewDetail addSubview:btnCustomise];
        
        UIView *viewPrice = [[UIView alloc]initWithFrame:CGRectMake(216, 153, 63, 100)];
        viewPrice.backgroundColor = [UIColor whiteColor];
        viewPrice.layer.borderWidth = 1;
        viewPrice.layer.borderColor = [UIColor grayColor].CGColor;
        viewPrice.layer.cornerRadius = 6;
        viewPrice.tag = 888;
        [viewC addSubview:viewPrice];
        [viewPrice release];
        
        UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 63, 30)];
        lblPrice.font = [UIFont boldSystemFontOfSize:20];
        lblPrice.text = [NSString
                         stringWithFormat:@"$%@",[dictIngrident objectForKey:@"price"]];
        lblPrice.backgroundColor = [UIColor clearColor];
        lblPrice.textColor = [UIColor brownColor] ;
        lblPrice.textAlignment = NSTextAlignmentCenter;
        [viewPrice addSubview:lblPrice];
        [lblPrice release];
        
        //    UILabel *lblPriceOff = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 63, 30)];
        //    lblPriceOff.font = [UIFont boldSystemFontOfSize:12];
        //    lblPriceOff.text = @"($2 off)";
        //    lblPriceOff.backgroundColor = [UIColor clearColor];
        //    lblPriceOff.textColor = [UIColor blackColor] ;
        //    lblPriceOff.textAlignment = NSTextAlignmentCenter;
        //    [viewPrice addSubview:lblPriceOff];
        //    [lblPriceOff release];
        
        UIView *viewTip = [[UIView alloc]initWithFrame:CGRectMake(11, 261, 268, 45)];
        viewTip.backgroundColor = [UIColor whiteColor];
        viewTip.layer.borderWidth = 1;
        viewTip.layer.borderColor = [UIColor grayColor].CGColor;
        viewTip.layer.cornerRadius = 6;
        viewTip.tag = 999;
        [viewC addSubview:viewTip];
        [viewTip release];
        
        UIButton *btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn10.frame = CGRectMake(37,10,23,23);
        btn10.tag = 10;
        [btn10 setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
        [btn10 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [viewTip addSubview:btn10];
        
        
        UILabel *lbl10 = [[UILabel alloc]initWithFrame:CGRectMake(60, 7, 30, 30)];
        lbl10.font = [UIFont boldSystemFontOfSize:12];
        lbl10.text = @"10%";
        lbl10.backgroundColor = [UIColor clearColor];
        lbl10.textColor = [UIColor blackColor] ;
        lbl10.textAlignment = NSTextAlignmentCenter;
        [viewTip addSubview:lbl10];
        [lbl10 release];
        
        UIButton *btn20 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn20.frame = CGRectMake(90,10,23,23);
        btn20.tag = 15;
        [btn20 setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
        [btn20 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [viewTip addSubview:btn20];
        
        UILabel *lbl15 = [[UILabel alloc]initWithFrame:CGRectMake(118, 7, 30, 30)];
        lbl15.font = [UIFont boldSystemFontOfSize:12];
        lbl15.text = @"15%";
        lbl15.backgroundColor = [UIColor clearColor];
        lbl15.textColor = [UIColor blackColor] ;
        lbl15.textAlignment = NSTextAlignmentCenter;
        [viewTip addSubview:lbl15];
        [lbl15 release];
        
        UIButton *btn30 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn30.frame = CGRectMake(148,10,23,23);
        [btn30 setBackgroundImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
        btn30.tag = 20;
        [btn30 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [viewTip addSubview:btn30];
        
        btnValue=btn30.tag;
        
        UILabel *lbl20 = [[UILabel alloc]initWithFrame:CGRectMake(180, 7, 30, 30)];
        lbl20.font = [UIFont boldSystemFontOfSize:12];
        lbl20.text = @"20%";
        lbl20.backgroundColor = [UIColor clearColor];
        lbl20.textColor = [UIColor blackColor] ;
        lbl20.textAlignment = NSTextAlignmentCenter;
        [viewTip addSubview:lbl20];
        [lbl20 release];
        
        UIButton *btn40 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn40.frame = CGRectMake(210,10,23,23);
        [btn40 setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
        btn40.tag = 40;
        [btn40 addTarget:self action:@selector(btnTip_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        //[viewTip addSubview:btn40];
        
        UITextField *txtFieldTip = [[UITextField alloc] initWithFrame:CGRectMake(223,7, 40, 30)];
        [txtFieldTip setBackground:[UIImage imageNamed:@"txt-box1.png"]];
        txtFieldTip.delegate = self;
        txtFieldTip.tag = 500;
        txtFieldTip.font = [UIFont boldSystemFontOfSize:12];
        txtFieldTip.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtFieldTip.textAlignment = NSTextAlignmentCenter;
        txtFieldTip.autocorrectionType = UITextAutocorrectionTypeNo;
        //[viewTip addSubview:txtFieldTip];
        [txtFieldTip release];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame = CGRectMake(148,317,120,30);
        btnCancel.titleLabel.textColor = [UIColor whiteColor];
        [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        btnCancel.backgroundColor=[UIColor blackColor];
        [btnCancel addTarget:self action:@selector(btnCancel_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [viewC addSubview:btnCancel];
        
        UIButton *btnOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        btnOrder.frame = CGRectMake(20,317,115,30);
        [btnOrder setTitle:@"Order" forState:UIControlStateNormal];
        btnOrder.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        btnOrder.titleLabel.textColor = [UIColor whiteColor];
        btnOrder.backgroundColor=[UIColor blackColor];
        [btnOrder addTarget:self action:@selector(btnOrder_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [viewC addSubview:btnOrder];
        
        [viewA release];
        [viewB release];
        [viewC release];


    }
}

-(void)btnPhoto_TouchUpInside
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PeopleSelected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedPeople:) name:@"PeopleSelected" object:nil];
    
    PeopleViewController *obj=[[PeopleViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:obj];
    [self presentViewController:nav animated:YES completion:nil];
    [nav release];
    [obj release];
    
}

-(void)selectedPeople:(NSNotification*)notification
{
    dictPeopleSelectedForDrink=[[NSDictionary alloc]initWithDictionary:notification.object];
    UIImageView *imgView=(UIImageView*)[self.view viewWithTag:143225];    
    NSString *strURL=[NSString stringWithFormat:@"%@/%@%@",KServerURL,[[NSUserDefaults standardUserDefaults]objectForKey:@"ImagePath"],[dictPeopleSelectedForDrink objectForKey:@"bartsyId"]];

    NSLog(@"URL is %@",strURL);
    //[imgView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]]]];
    [imgView setImageWithURL:[NSURL URLWithString:strURL]];
    UILabel *lblName=(UILabel*)[self.view viewWithTag:111222333];
    lblName.text=[dictPeopleSelectedForDrink objectForKey:@"nickName"];
    
    
}


-(void)btnTip_TouchUpInside:(id)sender
{
    if(btnValue!=0)
    {
        UIButton *btn=(UIButton*)[self.view viewWithTag:btnValue];
        [btn setBackgroundImage:[UIImage imageNamed:@"radio_button1.png"] forState:UIControlStateNormal];
    }
    btnValue=[sender tag];
    [sender setBackgroundImage:[UIImage imageNamed:@"radio_button_selected1.png"] forState:UIControlStateNormal];
    
    if(btnValue==40)
    {
        UITextField *txtFld=(UITextField*)[self.view viewWithTag:500];
        [txtFld becomeFirstResponder];
    }
}

-(void)btnCancel_TouchUpInside
{
    UIView *viewA = (UIView*)[self.view viewWithTag:222];
    [viewA removeFromSuperview];
}

-(void)btnOrder_TouchUpInside
{
    //[self orderTheDrink];
    UIView *viewA = (UIView*)[self.view viewWithTag:222];
    [viewA removeFromSuperview];
    self.sharedController=[SharedController sharedController];
    
    if([dictPeopleSelectedForDrink count]==0||[[dictPeopleSelectedForDrink objectForKey:@"bartsyId"] isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]])
    {
        [self createProgressViewToParentView:self.view withTitle:@"Sending Order details to Bartender..."];
    }
    else
    {
        NSString *strMsg=[NSString stringWithFormat:@"Sending Order details to %@...",[dictPeopleSelectedForDrink objectForKey:@"nickName"]];
        [self createProgressViewToParentView:self.view withTitle:strMsg];
    }
    
    NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"Checked==1"];
    for (int i=0; i<[arrMixers count]; i++)
    {
        NSMutableArray *arrTem=[[NSMutableArray alloc]initWithArray:[[arrMixers objectAtIndex:i] objectForKey:@"ingredients"]];
        [arrTem filterUsingPredicate:pred];
        [arrTemp addObjectsFromArray:arrTem];
        [arrTem release];
    }
    
    NSLog(@"Spirit is %@",dictSelectedToMakeOrder);
    
    NSMutableArray *arrIds=[[NSMutableArray alloc]init];
    [arrIds addObject:[dictSelectedToMakeOrder objectForKey:@"ingredientId"]];
    
    NSMutableString *strDescription=[[NSMutableString alloc]init];
    
    float floatBasePrice=[[dictSelectedToMakeOrder objectForKey:@"price"] floatValue];
    for (NSDictionary *dict in arrTemp)
    {
        floatBasePrice+=[[dict objectForKey:@"price"]floatValue];
        
        [arrIds addObject:[dict objectForKey:@"ingredientId"]];
        
        NSString *strDesc=[NSString stringWithFormat:@"%@,",[dict objectForKey:@"name"]];
        [strDescription appendString:strDesc];
    }
    
    if([strDescription length])
        strDescription=(NSMutableString*)[strDescription substringToIndex:[strDescription length]-1];
    
    [arrTemp release];
    
    NSString *strBasePrice=[NSString stringWithFormat:@"%.2f",floatBasePrice];
    
    NSString *strTip;
    if(btnValue!=40)
        strTip=[NSString stringWithFormat:@"%i",btnValue];
    else
    {
        UITextField *txtFld=(UITextField*)[self.view viewWithTag:500];
        strTip=[NSString stringWithFormat:@"%i",[txtFld.text integerValue]];
    }
    
    //Tax on item
    float subTotal=(floatBasePrice*(([strTip floatValue]+9.5)))/100;
    float totalPrice=floatBasePrice+subTotal;
    
    NSString *strTotalPrice1=[NSString stringWithFormat:@"%.2f",totalPrice];

    //Tip on item
    float tipTotal = ([[dictSelectedToMakeOrder objectForKey:@"price"] floatValue]*[strTip floatValue])/100;
    NSString *strTipTotal=[NSString stringWithFormat:@"%.2f",tipTotal];
    
    NSLog(@"Tip is %@",strTipTotal);
    
    NSString *strBartsyId;
    if([dictPeopleSelectedForDrink count])
        strBartsyId=[NSString stringWithFormat:@"%@",[dictPeopleSelectedForDrink objectForKey:@"bartsyId"]];
    else
        strBartsyId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"]];

    
    
    [self.sharedController createOrderWithOrderStatus:@"New" basePrice:strBasePrice totalPrice:strTotalPrice1 tipPercentage:strTipTotal itemName:[dictSelectedToMakeOrder objectForKey:@"name"] produceId:[dictSelectedToMakeOrder objectForKey:@"ingredientId"] description:strDescription ingredients:arrIds receiverBartsyId:strBartsyId delegate:self];
    
    //[strDescription release];
    //[arrIds release];
}


#pragma mark - TextFields Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *viewC=(UIView*)[self.view viewWithTag:444];
    viewC.frame=CGRectMake(12, -2, 295, 268);
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    UIView *viewC=(UIView*)[self.view viewWithTag:444];
    viewC.frame=CGRectMake(12, 50, 295, 268);
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrMixers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[arrMixers objectAtIndex:section] objectForKey:@"categoryName"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[arrMixers objectAtIndex:section] objectForKey:@"ingredients"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
    NSDictionary *dict=[[[arrMixers objectAtIndex:indexPath.section] objectForKey:@"ingredients"] objectAtIndex:indexPath.row];
    cell.textLabel.textColor=[UIColor blackColor];
	cell.textLabel.text=[dict objectForKey:@"name"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"$%@",[dict objectForKey:@"price"]];
    
    if([[dict objectForKey:@"Checked"] integerValue])
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dictMixer=[[[arrMixers objectAtIndex:indexPath.section] objectForKey:@"ingredients"] objectAtIndex:indexPath.row];
    [dictMixer setValue:[NSNumber numberWithBool:![[dictMixer objectForKey:@"Checked"] boolValue]] forKey:@"Checked"];
    
    [[[arrMixers objectAtIndex:indexPath.section] objectForKey:@"ingredients"] replaceObjectAtIndex:indexPath.row withObject:dictMixer];
    
    [tableView reloadData];    
}

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    [self hideProgressView:nil];
    
    if([[result objectForKey:@"errorCode"] integerValue]==1)
    {
        [self createAlertViewWithTitle:@"Error" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
    }
    else
    {
        appDelegate.intOrderCount=[[result objectForKey:@"orderCount"] integerValue];
        [appDelegate startTimerToCheckOrderStatusUpdate];
        NSMutableArray *arrPlacedOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"PlacedOrders"]];
        NSMutableDictionary *dictOrderPlaced=[[NSMutableDictionary alloc]initWithDictionary:dictSelectedToMakeOrder];
        [dictOrderPlaced setValue:[result objectForKey:@"orderId"] forKey:@"orderId"];
        [dictOrderPlaced setValue:[result objectForKey:@"orderStatus"] forKey:@"orderStatus"];
        [dictOrderPlaced setValue:[result objectForKey:@"orderTimeout"] forKey:@"orderTimeout"];
        [dictOrderPlaced setValue:[NSNumber numberWithInteger:btnValue] forKey:@"tipPercentage"];
        
        NSDate* date = [NSDate date];
        
        [dictOrderPlaced setValue:date forKey:@"Time"];
        
        NSLog(@"Order is %@",dictOrderPlaced);
        
        [arrPlacedOrders addObject:dictOrderPlaced];
        [[NSUserDefaults standardUserDefaults]setObject:arrPlacedOrders forKey:@"PlacedOrders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [arrPlacedOrders release];
        
        [self createAlertViewWithTitle:nil message:@"Your order was sent" cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:111222];
    }
}

-(void)controllerDidFailLoadingWithError:(NSError*)error
{
    [self hideProgressView:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==111222)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
