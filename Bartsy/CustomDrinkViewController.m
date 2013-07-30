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
    
    UIScrollView *mainScroll;
    
    NSMutableArray *arrCustomDrinks;
    
    int indexselected;
}

@end

@implementation CustomDrinkViewController
@synthesize dictCustomDrinks,viewtype,dictitemdetails;
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
    
    self.sharedController=[SharedController sharedController];
    
    self.view.backgroundColor=[UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:18.0/255.0 alpha:1.0];
    UIImageView *imgViewForTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgViewForTop.image=[UIImage imageNamed:@"top_header_bar.png"];
    [self.view addSubview:imgViewForTop];
    [imgViewForTop release];
    
    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(100.25, 13.25, 119.5, 23.5)];
    imgLogo.image=[UIImage imageNamed:@"logo_Header.png"];
    [self.view addSubview:imgLogo];
    [imgLogo release];

   
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(5, 0, 50, 40);
    [btnBack addTarget:self action:@selector(btnBack_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    UIImageView *imgViewBack = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 12, 20)];
    imgViewBack.image = [UIImage imageNamed:@"arrow-left.png"];
    [btnBack addSubview:imgViewBack];
    [imgViewBack release];
    
    arrCustomDrinks=[[NSMutableArray alloc]init];
    indexselected=-1;
    mainScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0,46,320,self.view.bounds.size.height)];
    mainScroll.tag=554;
    [mainScroll setScrollEnabled:YES];
    [self.view addSubview:mainScroll];
    NSLog(@"dict%@",dictitemdetails);
    if (viewtype==2) {
        
        UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 367-100) style:UITableViewStylePlain];
        tblView.dataSource=self;
        tblView.backgroundColor = [UIColor blackColor];
        tblView.delegate=self;
        tblView.tag=555;
        [tblView setSeparatorColor:[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f]];
        [mainScroll addSubview:tblView];
        
        if (IS_IPHONE_5)
        {
            tblView.frame=CGRectMake(0,0, 320, 455-105);
        }
        
        [tblView release];

    }else if (viewtype==1){
       
        UILabel *lblitem=[[UILabel alloc]initWithFrame:CGRectMake(5, 38,310, 18)];
        lblitem.text=[dictitemdetails valueForKey:@"name"];
        lblitem.textColor=[UIColor whiteColor];
        lblitem.backgroundColor=[UIColor clearColor];
        [mainScroll addSubview:lblitem];
        [lblitem release];
        
        UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 56, 320, 1.5)];
        lineview.backgroundColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f];
        [mainScroll addSubview:lineview];
        [lineview release];
        
        UILabel *lbldescription=[[UILabel alloc]initWithFrame:CGRectMake(5, 59,310, 54)];
        lbldescription.text=[dictitemdetails valueForKey:@"description"];
        lbldescription.textColor=[UIColor whiteColor];
        lbldescription.numberOfLines=3;
        lbldescription.backgroundColor=[UIColor clearColor];
        [mainScroll addSubview:lbldescription];
        [lbldescription release];

    }
    
    UILabel *lblinstruction=[[UILabel alloc]initWithFrame:CGRectMake(5, 275,180,18)];
    if (IS_IPHONE_5) {
        lblinstruction.frame=CGRectMake(5, 357,180,18);
    }
    lblinstruction.text=@"Special instructions";
    lblinstruction.textColor=[UIColor whiteColor];
    lblinstruction.backgroundColor=[UIColor clearColor];
    [mainScroll addSubview:lblinstruction];
    [lblinstruction release];
    
    UITextField* field = [[[UITextField alloc] initWithFrame:CGRectMake(-1.5,295, 323, 30)] autorelease];
    if (IS_IPHONE_5) {
        field.frame=CGRectMake(-1.5,385, 323, 30);
    }
    [field setBorderStyle:UITextBorderStyleLine];
    field.placeholder=@"Optional";
    field.delegate=self;
    field.tag=559;
    field.textColor=[UIColor whiteColor];
    field.layer.borderWidth=1.5;
    field.layer.borderColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f].CGColor;
    [mainScroll addSubview:field];

    UIButton *orderBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame=CGRectMake(5,330, 250, 30);
    if (IS_IPHONE_5) {
        orderBtn.frame=CGRectMake(5,418, 250, 30);

    }
    orderBtn.tag=556;
    if (![dictitemdetails valueForKey:@"price"]) {
        [orderBtn setTitle:[NSString stringWithFormat:@"%@-$%@",@"Add to order",@"0"] forState:UIControlStateNormal];

    }else{
        [orderBtn setTitle:[NSString stringWithFormat:@"%@-$%@",@"Add to order",[dictitemdetails valueForKey:@"price"]] forState:UIControlStateNormal];

    }
    [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(Button_Order:) forControlEvents:UIControlEventTouchUpInside];
    orderBtn.backgroundColor=[UIColor colorWithRed:92.0/255.0 green:92.0/255.0 blue:104.0/255.0 alpha:1.0];
    [mainScroll addSubview:orderBtn];
    [arrCustomDrinks addObject:dictitemdetails];
    
    //if Viewtype is 2 it is ingradient selection
    if (viewtype==2) {
        
        //Parsing the GetIngradient Data
        NSArray *tempArray=[dictCustomDrinks valueForKey:@"menus"];
        for (NSDictionary *dict in tempArray) {
            
            NSArray *temp2Array=[dict valueForKey:@"sections"];
            for (NSDictionary *dict in temp2Array) {
                
                if ([[dict valueForKey:@"section_name"] isEqualToString:@"Mixer"]){
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
       
    }
        
    
    UIButton *buttonFav=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonFav.frame=CGRectMake(265, 328, 13, 13);
    if (IS_IPHONE_5)
        buttonFav.frame=CGRectMake(265, 418, 13, 13);
   
    
    buttonFav.tag=557;
    [buttonFav addTarget:self action:@selector(Button_Action:) forControlEvents:UIControlEventTouchUpInside];
    [buttonFav setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [buttonFav setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [mainScroll addSubview:buttonFav];
    
    UILabel *lblfav=[[UILabel alloc]initWithFrame:CGRectMake(285,328, 100, 18)];
    if (IS_IPHONE_5)
        lblfav.frame=CGRectMake(285, 418, 100, 18);

    lblfav.textColor=[UIColor whiteColor];
    lblfav.text=@"Favorite";
    lblfav.textAlignment=NSTextAlignmentLeft;
    lblfav.backgroundColor=[UIColor clearColor];
    lblfav.font=[UIFont systemFontOfSize:9];
    [mainScroll addSubview:lblfav];
    [lblfav release];
    
    UIButton *buttonLike=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonLike.frame=CGRectMake(265, 346, 13, 13);
    if (IS_IPHONE_5)
        buttonLike.frame=CGRectMake(265, 433, 13, 13);

    buttonLike.tag=558;
    [buttonLike addTarget:self action:@selector(Button_Action:) forControlEvents:UIControlEventTouchUpInside];
    [buttonLike setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [buttonLike setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [mainScroll addSubview:buttonLike];
    
    UILabel *lbllike=[[UILabel alloc]initWithFrame:CGRectMake(285,346, 100, 18)];
    if (IS_IPHONE_5)
        lbllike.frame=CGRectMake(285, 432, 100, 18);
    lbllike.textColor=[UIColor whiteColor];
    lbllike.text=@"Like";
    lbllike.textAlignment=NSTextAlignmentLeft;
    lbllike.backgroundColor=[UIColor clearColor];
    lbllike.font=[UIFont systemFontOfSize:9];
    [mainScroll addSubview:lbllike];
    [lbllike release];
    

}

-(void)btnBack_TouchUpInside
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)Button_Order:(UIButton*)sender{
    
    if (viewtype==1) {
        NSLog(@"Final order %@",arrCustomDrinks);

    }else if (viewtype==2){
        UIButton *btnFav=(UIButton*)[mainScroll viewWithTag:557];
        
         if (viewtype==2 && btnFav.selected){
            NSMutableArray *arritemlist=[[NSMutableArray alloc]init];
            for (NSDictionary *dictTemp in arrCustomDrinks) {
                NSMutableDictionary *dictitemlist=[[NSMutableDictionary alloc]init];
                
                NSLog(@"%@",dictTemp);
                NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:[dictTemp objectForKey:@"contents"]];
                NSArray *filterarr=[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
                for (NSDictionary *dictTemp in filterarr)
                {
                    [dictitemlist setObject:[dictTemp valueForKey:@"name"] forKey:@"itemName"];
                    [dictitemlist setObject:[dictTemp valueForKey:@"price"] forKey:@"basePrice"];
                    [dictitemlist setObject:[dictTemp valueForKey:@"ingredientId"] forKey:@"itemId"];
                    [dictitemlist setObject:@"" forKey:@"title"];
                    [dictitemlist setObject:@"1" forKey:@"quantity"];
                    [dictitemlist setObject:@"" forKey:@"description"];
                    
                    [arritemlist addObject:dictitemlist];
                    
                }
            }
            
            NSLog(@"arritemlist %@",arritemlist);
            // SBJSON *jsonObj=[SBJSON new];
            // NSString *strJson=[jsonObj stringWithObject:arritemlist];
            //[self createProgressViewToParentView:self.view withTitle:@"Saving your favorite drink..."];
            
            [self.sharedController saveFavoriteDrinkbyvenueID:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] bartsyID:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] description:@"" specialinstruction:@"" itemlist:arritemlist delegate:self];
        }
        
        NSLog(@"Final order %@",arrCustomDrinks);

    }

}

-(void)Button_Action:(UIButton*)sender{
    
   // UITextField *txtfield=(UITextField*)[mainScroll viewWithTag:559];
    if (sender.tag==557) {
        if (sender.selected) {
            
            sender.selected=NO;
        }else{
            sender.selected=YES;
        }
        
    }else if (sender.tag==558){
        if (sender.selected) {
            
            sender.selected=NO;
        }else{
            sender.selected=YES;
        }
    }
    
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
    if (section==0) {
        headerTitle.text=[[arrCustomDrinks objectAtIndex:section] valueForKey:@"section_name"];

    }else{
        headerTitle.text=[[arrCustomDrinks objectAtIndex:section] valueForKey:@"subsection_name"];

    }
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
    //[button addTarget:self action:@selector(checkboxButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    button.userInteractionEnabled=NO;
    [cell.contentView addSubview:button];
    
    UILabel *lblPrice=[[UILabel alloc]initWithFrame:CGRectMake(260, 5, 50, 25)];
    lblPrice.font=[UIFont boldSystemFontOfSize:18];
    lblPrice.textColor=[UIColor colorWithRed:35.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1.0];
    lblPrice.adjustsFontSizeToFitWidth=YES;
    lblPrice.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:lblPrice];
    
     if ([[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"Selected"] integerValue]==1) {
        button.selected=YES;
         lblPrice.text=[NSString stringWithFormat:@"$%@",[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"price"]];
    }else{
        lblPrice.text=nil;
        button.selected=NO;
    }
    [lblPrice release];
    lblName.text=[NSString stringWithFormat:@"%@ (%@)",[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"name"],[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"price"]];
    [lblName release];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"contents"];
    
    if (indexPath.section==0) {
        
        if (indexselected!=-1) {
            NSDictionary *dict2=[subitemArray objectAtIndex:indexselected];
            [dict2 setValue:@"0" forKey:@"Selected"];
            
        }

        NSDictionary *dict=[subitemArray objectAtIndex:indexPath.row];
        [dict setValue:@"1" forKey:@"Selected"];
       

        indexselected=indexPath.row;
                
    }else{
       // NSDictionary *dict=[subitemArray objectAtIndex:indexPath.row];

        if ([[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"Selected"] integerValue]==1) {
            
            NSDictionary *dict=[subitemArray objectAtIndex:indexPath.row];
            [dict setValue:@"0" forKey:@"Selected"];
            
        }else{
            
            NSDictionary *dict=[subitemArray objectAtIndex:indexPath.row];
            [dict setValue:@"1" forKey:@"Selected"];
        }
    }
    
    [tableView reloadData];

    [self calculateTotalPrice];
}

-(void)calculateTotalPrice
{
    float floatTotalPrice=0.0;
    
    for (int i=0;i<[arrCustomDrinks count]; i++)
    {
        NSDictionary *dict=[arrCustomDrinks objectAtIndex:i];
        
        NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"contents"]];
        NSArray *filterarr=[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
        for (NSDictionary *dictTemp in filterarr)
        {
            floatTotalPrice+=[[dictTemp objectForKey:@"price"] floatValue];
        }
    }
    UIButton *orderBtn=(UIButton*)[mainScroll viewWithTag:556];
     [orderBtn setTitle:[NSString stringWithFormat:@"%@-$%.2f",@"Add to order",floatTotalPrice] forState:UIControlStateNormal];
    NSLog(@"%f",floatTotalPrice);
}

#pragma mark------------Webservice Delegates
-(void)controllerDidFinishLoadingWithResult:(id)result
{
    [self hideProgressView:nil];
    
    if([[result objectForKey:@"errorCode"] integerValue]!=0)
    {
        [self createAlertViewWithTitle:@"Error" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
    }
    else
    {
        NSLog(@"result %@",result);
    }

}

-(void)controllerDidFailLoadingWithError:(NSError*)error
{
    [self hideProgressView:nil];
    
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
