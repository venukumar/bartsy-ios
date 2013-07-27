//
//  CustomDrinkViewController.m
//  Bartsy
//
//  Created by Techvedika on 7/24/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "CustomDrinkViewController.h"
#import "Constants.h"
@interface CustomDrinkViewController (){
    
    NSMutableArray *arrCustomDrinks;
    
    NSMutableArray *arrIndexSelected;
}

@end

@implementation CustomDrinkViewController
@synthesize dictCustomDrinks;
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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:18.0/255.0 alpha:1.0];
    UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [self.view addSubview:imgViewForTop];
    [imgViewForTop release];
    
    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(100.25, 13.25, 119.5, 23.5)];
    imgLogo.image=[UIImage imageNamed:@"logo_Header.png"];
    [self.view addSubview:imgLogo];
    [imgLogo release];

    arrIndexSelected=[[NSMutableArray alloc]init];
   
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(5, 0, 50, 40);
    [btnBack addTarget:self action:@selector(btnBack_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    UIImageView *imgViewBack = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 12, 20)];
    imgViewBack.image = [UIImage imageNamed:@"arrow-left.png"];
    [btnBack addSubview:imgViewBack];
    [imgViewBack release];
    
    arrCustomDrinks=[[NSMutableArray alloc]init];
    
    UIScrollView *mainScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0,46,320,self.view.bounds.size.height)];
    mainScroll.tag=554;
    [mainScroll setScrollEnabled:YES];
    [self.view addSubview:mainScroll];

    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 367-75) style:UITableViewStylePlain];
    tblView.dataSource=self;
    tblView.backgroundColor = [UIColor blackColor];
    tblView.delegate=self;
    tblView.tag=555;
    [mainScroll addSubview:tblView];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568)
    {
        tblView.frame=CGRectMake(0,47, 320, 455-75);
    }
    
    [tblView release];

    UITextField* field = [[UITextField alloc] initWithFrame:CGRectMake(5, tblView.frame.origin.y+tblView.frame.size.height+3, 310, 30)];
    [field setBorderStyle:UITextBorderStyleRoundedRect];
    field.placeholder=@"Special instructions";
    field.delegate=self;
    [mainScroll addSubview:field];

    UIButton *orderBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame=CGRectMake(5,330, 250, 30);
    if (IS_IPHONE_5) {
        orderBtn.frame=CGRectMake(5,430, 250, 30);

    }
    orderBtn.tag=556;
    [orderBtn setTitle:@"Add to order" forState:UIControlStateNormal];
    [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(Button_Order:) forControlEvents:UIControlEventTouchUpInside];
    orderBtn.backgroundColor=[UIColor blackColor];
    [mainScroll addSubview:orderBtn];
    
    NSArray *tempArray=[[dictCustomDrinks valueForKey:@"menus"] valueForKey:@"sections"];
    for (NSDictionary *dict in tempArray) {
        
        if ([[dict valueForKey:@"section_name"] isEqualToString:@"Spirit"]) {
            //[arrCustomDrinks addObject:dict];
            for (NSDictionary *tempdict in [dict valueForKey:@"subsections"]) {
               // NSLog(@"dict %@",tempdict);
                //if ([[tempdict valueForKey:@"Arrow"] integerValue]==1) {
                    [arrCustomDrinks addObject:tempdict];
                    NSArray *subitemArray=[tempdict valueForKey:@"contents"];
                    for (NSDictionary *tempdict in subitemArray) {
                        
                        [tempdict setValue:@"0" forKey:@"Selected"];
                        
                   // }
                }
            }
        }else if ([[dict valueForKey:@"section_name"] isEqualToString:@"Mixer"]){
            for (NSDictionary *tempdict in [dict valueForKey:@"subsections"]) {
               // NSLog(@"dict %@",tempdict);
                [arrCustomDrinks addObject:tempdict];
                NSArray *subitemArray=[tempdict valueForKey:@"contents"];

                for (NSDictionary *tempdict in subitemArray) {
                    
                    [tempdict setValue:@"0" forKey:@"Selected"];

                }

            }
            
        }
    }
}

-(void)btnBack_TouchUpInside
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)Button_Order:(UIButton*)sender{
    
    
}
#pragma mark - Table view Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [arrCustomDrinks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
            

    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"sectionBg.png"]];
    UILabel *headerTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 3, 280, 30)];
    [headerTitle setBackgroundColor:[UIColor clearColor]];
    [headerTitle setFont:[UIFont boldSystemFontOfSize:16]];
    [headerTitle setTextColor:[UIColor whiteColor]];
    headerTitle.text=[[arrCustomDrinks objectAtIndex:section] valueForKey:@"subsection_name"];
    [headerView addSubview:headerTitle];
        
    return headerView;
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:section] valueForKey:@"contents"];
    return [subitemArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    //NSDictionary *dictForOrder=[pastorderArray objectAtIndex:indexPath.row];
    
   
    cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage            imageNamed:@"fathers_office-bg.png"]];
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(40, 2, 270, 40)];
    lblName.font=[UIFont systemFontOfSize:14];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.textColor=[UIColor whiteColor];
    [cell.contentView addSubview:lblName];
    
    NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"contents"];
   
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(10, 10, 22, 22);
    button.tag=indexPath.row;
    [button addTarget:self action:@selector(checkboxButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"tick_mark"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"tickmark_select"] forState:UIControlStateSelected];
    [cell.contentView addSubview:button];
    
    if ([arrIndexSelected containsObject:indexPath]) {
        button.selected=YES;
    }else{
        button.selected=NO;
    }
    lblName.text=[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    [lblName release];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([arrIndexSelected containsObject:indexPath] ) {
        
        [arrIndexSelected removeObject:indexPath];
    }else{
        [arrIndexSelected addObject:indexPath];
    }
    
    [tableView reloadData];
    
}

-(void)checkboxButton:(UIButton*)sender{
    
    NSLog(@"button tag %d",sender.tag);
    UITableView *tableview=(UITableView*)[self.view viewWithTag:555];
  
    sender.selected=YES;
                

    btnTag=sender.tag;
}
#pragma mark------------TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    UIScrollView *scrollview=(UIScrollView*)[self.view viewWithTag:554];
        
    [scrollview setContentOffset:CGPointMake(0, textField.frame.origin.y-90)];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    UIScrollView *scrollview=(UIScrollView*)[self.view viewWithTag:554];
    [scrollview setContentOffset:CGPointMake(0,0)];
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
