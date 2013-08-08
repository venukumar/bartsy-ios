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
    BOOL isSaveFavorite;
    BOOL isDeleteFavorite;
    BOOL isGettingFavorites;
}
@property(nonatomic,retain)NSMutableArray *arrCustomDrinks;
@end

@implementation CustomDrinkViewController
@synthesize dictCustomDrinks,viewtype,dictitemdetails,arrIndex,isEdit,arrayEditInfo,arrCustomDrinks;
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

    mainScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0,46,320,self.view.bounds.size.height)];
    mainScroll.tag=554;
    [mainScroll setScrollEnabled:YES];
    [self.view addSubview:mainScroll];
  
    if (viewtype==2 || ([dictitemdetails valueForKey:@"option_groups"] && viewtype==3)) {
        
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

    }else if (viewtype==1 || (![dictitemdetails valueForKey:@"option_groups"] && viewtype==3)){
       
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
        
        CGSize myStringSize = [[dictitemdetails valueForKey:@"description"] sizeWithFont:[UIFont systemFontOfSize:14]
                                   constrainedToSize:CGSizeMake(310, 100)
                                       lineBreakMode:NSLineBreakByWordWrapping];
        UILabel *lbldescription=[[UILabel alloc]initWithFrame:CGRectMake(5, 59,310, myStringSize.height+30)];
        lbldescription.text=[dictitemdetails valueForKey:@"description"];
        lbldescription.textColor=[UIColor whiteColor];
        lbldescription.numberOfLines=6;
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
    
    UITextField* instructionfield = [[[UITextField alloc] initWithFrame:CGRectMake(-1.5,295, 323, 30)] autorelease];
    if (IS_IPHONE_5) {
        instructionfield.frame=CGRectMake(-1.5,385, 323, 30);
    }
    [instructionfield setBorderStyle:UITextBorderStyleLine];
    instructionfield.placeholder=@"Optional";
    instructionfield.delegate=self;
    instructionfield.tag=559;
    instructionfield.textColor=[UIColor whiteColor];
    instructionfield.layer.borderWidth=1.5;
    instructionfield.layer.borderColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f].CGColor;
    [mainScroll addSubview:instructionfield];

    if ([dictitemdetails valueForKey:@"specialInstructions"] && [[dictitemdetails valueForKey:@"specialInstructions"] length]>0) {
        instructionfield.text=[dictitemdetails valueForKey:@"specialInstructions"];
    }
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
    if (!isEdit || viewtype==1||viewtype==3) {
        
        [arrCustomDrinks addObject:dictitemdetails];
    }
    
    //if Viewtype is 2 it is ingradient selection
    if (viewtype==2 && isEdit==NO) {
 
        [self HashmappingIngradients:dictitemdetails];
                      
    }else if ([dictitemdetails valueForKey:@"option_groups"] && viewtype==3){
        //[arrCustomDrinks removeAllObjects];
       /* NSArray *arrOptionGroup=[dictitemdetails valueForKey:@"option_groups"];

        for (NSDictionary *dictoption in arrOptionGroup) {
 
            NSArray *arroption=[dictoption valueForKey:@"options"];
            NSMutableArray *arrOptionList=[[NSMutableArray alloc]init];
            NSMutableDictionary *dictOptionList=[[NSMutableDictionary alloc]init];
            //[dictOptionList setObject:[dictoption valueForKey:@"text"] forKey:@"text"];
            
            //[dictOptionList setObject:[dictoption valueForKey:@"type"] forKey:@"type"];
            for (int k=0;k<[arroption count];k++) {
                NSMutableDictionary *dict1Temp=[NSMutableDictionary dictionaryWithDictionary:[arroption objectAtIndex:k]];
                
                //NSDictionary *dictOptionGroup=[[NSDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:[dict1Temp valueForKey:@"name"] ]];
                [dict1Temp setObject:@"0" forKey:@"Selected"];

                [arrOptionList addObject:dict1Temp];
                
            }
            [dictOptionList setObject:arrOptionList forKey:@"options"];
            [arrCustomDrinks addObject:dictOptionList];
        }*/
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
    
    isGettingFavorites=YES;
    [self.sharedController getFavoriteDrinksbybartsyID:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] venueID:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] delegate:self];

   if(viewtype==2 && isEdit==YES){
      
       //[arrCustomDrinks addObjectsFromArray: arrayEditInfo];
       [arrCustomDrinks addObject:dictitemdetails];
       [self HashmappingIngradients:dictitemdetails];

       UITableView *tableview=(UITableView*)[self.view viewWithTag:555];
       [tableview reloadData];
   }
}

-(void)HashmappingIngradients:(NSDictionary*)Dict{
    
    NSArray *arrOptionGroup=[Dict valueForKey:@"option_groups"];
    for (NSDictionary *dictoption in arrOptionGroup) {
        
        if ([[dictoption valueForKey:@"text"] isEqualToString:@"Mixers"]) {
            
            NSArray *arroption=[dictoption valueForKey:@"options"];
            for (int k=0;k<[arroption count];k++) {
                
                //[arrCustomDrinks addObject:[[NSUserDefaults standardUserDefaults] dictionaryForKey:[arroption objectAtIndex:k] ]];
                NSDictionary *tempDict=[[NSDictionary alloc
                                         ]initWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:[arroption objectAtIndex:k] ]];
                NSMutableDictionary *dictlist=[[NSMutableDictionary alloc]init];
                [dictlist setObject:[tempDict valueForKey:@"text"] forKey:@"text"];
                
                [dictlist setObject:[tempDict valueForKey:@"type"] forKey:@"type"];
                NSMutableArray *arrlist=[[NSMutableArray alloc]init];
                for (int l=0;l<[[tempDict valueForKey:@"options"] count];l++) {
                    NSMutableDictionary *dicttemp=[NSMutableDictionary dictionaryWithDictionary:[[tempDict valueForKey:@"options"] objectAtIndex:l]];
                    [dicttemp setObject:@"0" forKey:@"Selected"];
                    [arrlist addObject:dicttemp];
                    
                }
                [dictlist setObject:arrlist forKey:@"options"];
                [arrCustomDrinks addObject:dictlist];
                [arrlist release];
                [tempDict release];
                [dictlist release];
            }
        }
    }
    NSLog(@"%@",arrCustomDrinks);
}

-(void)btnBack_TouchUpInside
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)Button_Order:(UIButton*)button{
    
    [self Saving_Orderitems];
}

-(void)Button_Action:(UIButton*)sender{
    
   // UITextField *txtfield=(UITextField*)[mainScroll viewWithTag:559];
    if (sender.tag==557) {
        if (sender.selected) {
            
            sender.selected=NO;
            isDeleteFavorite=YES;
            [self createProgressViewToParentView:self.view withTitle:@"Deleting your favorite drink..."];
           
            [self.sharedController DeleteFavoritebyfavoriteID:[NSString stringWithFormat:@"%d",favoriteID] venueID:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] bydelegate:self];

        }else{
            sender.selected=YES;
            
            [self SavingFavorites];
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
    if (!([dictitemdetails valueForKey:@"option_groups"] && viewtype==3)){
        
    if (section==0) {
        headerTitle.text=[[arrCustomDrinks objectAtIndex:section] valueForKey:@"name"];

    }else{
        headerTitle.text=[[arrCustomDrinks objectAtIndex:section] valueForKey:@"text"];

     }
    }else{
       headerTitle.text=@"Cocktails";
    }
    [headerView addSubview:headerTitle];
        
    return headerView;
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!([dictitemdetails valueForKey:@"option_groups"] && viewtype==3)){
        
        if (section==0) {
            NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:section] valueForKey:@"option_groups"];
            NSArray *arraytemp=[subitemArray valueForKey:@"options"];
            NSArray *array2temp=[arraytemp objectAtIndex:0];
            
            return [array2temp count];
            
        }else{
            NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:section] valueForKey:@"options"];
            return [subitemArray count];
        }

    }else{
        NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:section] valueForKey:@"options"];
        return [subitemArray count];
    }
      
    return nil;
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
     if (!([dictitemdetails valueForKey:@"option_groups"] && viewtype==3)){
         if (indexPath.section==0) {
             NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"option_groups"];
             NSArray *arraytemp=[subitemArray valueForKey:@"options"];
             NSArray *array2temp=[arraytemp objectAtIndex:0];

             if ([[[array2temp objectAtIndex:indexPath.row] valueForKey:@"Selected"] integerValue]==1) {
                 button.selected=YES;
                 lblPrice.text=[NSString stringWithFormat:@"$%@",[[array2temp objectAtIndex:indexPath.row] valueForKey:@"price"]];
             }else{
                 lblPrice.text=nil;
                 button.selected=NO;
             }
             
         }else{
             NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"options"] ;
             if ([[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"Selected"] integerValue]==1) {
                 button.selected=YES;
                 if ([[subitemArray objectAtIndex:indexPath.row] valueForKey:@"price"]) {
                     lblPrice.text=[NSString stringWithFormat:@"$%@",[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"price"]];
                 }else{
                      lblPrice.text=@"$0";
                 }
                 
             }else{
                 
                 lblPrice.text=nil;
                 button.selected=NO;
             }
             
         }

     }else{
         
         NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"options"] ;
         if ([[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"Selected"] integerValue]==1) {
             button.selected=YES;
             lblPrice.text=[NSString stringWithFormat:@"$%@",[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"price"]];
         }else{
             
             lblPrice.text=nil;
             button.selected=NO;
         }

     }
        [lblPrice release];
    
     if (!([dictitemdetails valueForKey:@"option_groups"] && viewtype==3)){
         
         if (indexPath.section==0) {
             NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"option_groups"];
             
             NSArray *arrytemp=[subitemArray valueForKey:@"options"];
             NSArray *array2temp=[arrytemp objectAtIndex:0];
             
             lblName.text=[NSString stringWithFormat:@"%@ (%@)",[[array2temp objectAtIndex:indexPath.row] valueForKey:@"name"],[[array2temp objectAtIndex:indexPath.row] valueForKey:@"price"]];
             
         }else{
             NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"options"];
             
             if ([[subitemArray objectAtIndex:indexPath.row] valueForKey:@"price"]) {
                 lblName.text=[NSString stringWithFormat:@"%@ (%@)",[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"name"],[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"price"]];
             }else{
                 lblName.text=[NSString stringWithFormat:@"%@ (%@)",[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"name"],@"0"];
             }

         }

     }else{
         
         NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"options"];
         lblName.text=[NSString stringWithFormat:@"%@ (%@)",[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"name"],[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"price"]];
     }
        
    [lblName release];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!([dictitemdetails valueForKey:@"option_groups"] && viewtype==3)){
        if (indexPath.section==0) {
           
            NSMutableArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"option_groups"];
            NSArray *arrytemp=[subitemArray valueForKey:@"options"];
            NSMutableArray *array2temp=[arrytemp objectAtIndex:0];
            NSMutableDictionary *dict=[array2temp objectAtIndex:indexPath.row];
            NSDictionary *dictType=[subitemArray objectAtIndex:0];
            if ([[dictType valueForKey:@"type"] isEqualToString:@"OPTION_CHOOSE"]) {
                
                [self Reset_Selection:indexPath.section];
            }
            [dict setObject:@"1" forKey:@"Selected"];
                        
        }else{
            id item=[arrCustomDrinks objectAtIndex:indexPath.section];
            if ([[item valueForKey:@"type"] isEqualToString:@"OPTION_CHOOSE"]) {
                
                [self Reset_Selection:indexPath.section];
            }
            NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"options"];
            if ([[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"Selected"] integerValue]==1) {
                
                NSMutableDictionary *dict=[subitemArray objectAtIndex:indexPath.row];
                [dict setObject:@"0" forKey:@"Selected"];
            }else{
                
                NSMutableDictionary *dict=[subitemArray objectAtIndex:indexPath.row];
                [dict setObject:@"1" forKey:@"Selected"];
            }
        }
        [tableView reloadData];
        
        [self calculateTotalPrice:indexPath.section];
    }else{
        
        id item=[arrCustomDrinks objectAtIndex:indexPath.section];
        if ([[item valueForKey:@"type"] isEqualToString:@"OPTION_CHOOSE"]) {
            
            [self Reset_Selection:indexPath.section];
        }
        NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"options"];
        if ([[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"Selected"] integerValue]==1) {
            
            NSMutableDictionary *dict=[subitemArray objectAtIndex:indexPath.row];
            [dict setObject:@"0" forKey:@"Selected"];
        }else{
            
            NSMutableDictionary *dict=[subitemArray objectAtIndex:indexPath.row];
            [dict setObject:@"1" forKey:@"Selected"];
        }

        [tableView reloadData];
        [self calculateTotalPrice:indexPath.section];
    }
    
   
}

-(void)calculateTotalPrice:(int)section
{
    float floatTotalPrice=0.0;
    
    for (int i=0;i<[arrCustomDrinks count]; i++)
    {
        if (!([dictitemdetails valueForKey:@"option_groups"] && viewtype==3)){
            
            NSDictionary *dict=[arrCustomDrinks objectAtIndex:i];
            if ([dict valueForKey:@"option_groups"]) {
                NSMutableArray *arrytemp=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"option_groups"]];
                NSArray *array2temp=[arrytemp objectAtIndex:0];
                NSArray *filterarr=[[array2temp valueForKey:@"options"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
                for (NSDictionary *dictTemp in filterarr)
                {
                    floatTotalPrice+=[[dictTemp objectForKey:@"price"] floatValue];
                }
            }else{
                
                NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"options"]];
                NSArray *filterarr=[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
                for (NSDictionary *dictTemp in filterarr)
                {
                    floatTotalPrice+=[[dictTemp objectForKey:@"price"] floatValue];
                }
                [arrTemp release];
                
            }

        }else{
            NSDictionary *dict=[arrCustomDrinks objectAtIndex:i];

            NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"options"]];
            NSArray *filterarr=[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
            for (NSDictionary *dictTemp in filterarr)
            {
                floatTotalPrice+=[[dictTemp objectForKey:@"price"] floatValue];
            }
            [arrTemp release];
        }
    }
    UIButton *orderBtn=(UIButton*)[mainScroll viewWithTag:556];
     [orderBtn setTitle:[NSString stringWithFormat:@"%@-$%.2f",@"Add to order",floatTotalPrice] forState:UIControlStateNormal];
}

//Saving the Order details
-(void)Saving_Orderitems{
    
    
    NSMutableArray *arrMultiItemOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"multiitemorders"]];
    
    UITextField *txtFieldSpecialInstructions=(UITextField*)[mainScroll viewWithTag:559];
    // Saving the Locu menu order in UserDefaults
    if (viewtype==1)
    {
        NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:[arrMultiItemOrders objectAtIndex:arrIndex]];
        if (txtFieldSpecialInstructions.text.length>0) {
            [dictItem setObject:txtFieldSpecialInstructions.text forKey:@"specialInstructions"];
            
        }else{
            [dictItem setObject:@"" forKey:@"specialInstructions"];
            
        }
        [dictItem setObject:@"Menu" forKey:@"ItemType"];
        [arrMultiItemOrders replaceObjectAtIndex:arrIndex withObject:dictItem];
        
        [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        appDelegate.isCmgForShowingOrderUI=YES;
        [arrMultiItemOrders release];
        [dictItem release];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (viewtype==2){
        // Saving the Locu Mixed Drink menu order in UserDefaults & showing on popup
        
        NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]init];
        
        float totalPrice = 0.0;
        NSMutableString *itemdescription =[[NSMutableString alloc]init];
        NSLog(@"%@",arrCustomDrinks);

        for (NSDictionary *dictTemp in arrCustomDrinks) {
            
            
            if (![dictTemp valueForKey:@"options"]) {
                
                [dictItem setObject:arrCustomDrinks forKey:@"ArrayInfo"];

                NSArray *arrTemp=[dictTemp valueForKey:@"option_groups"];
                NSArray *array2temp=[arrTemp objectAtIndex:0];
                NSArray *filterarr=[[array2temp valueForKey:@"options"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];

                for (NSDictionary *dict1Temp in filterarr)
                {
                    totalPrice+=[[dict1Temp valueForKey:@"price"] floatValue];
                    [itemdescription appendFormat:@"%@,",[dict1Temp valueForKey:@"name"]];
                }
                [dictItem setObject:[dictTemp valueForKey:@"name"] forKey:@"name"];
                
                
            }else{
                NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:[dictTemp objectForKey:@"options"]];
                NSArray *filterarr=[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
                
                for (NSDictionary *dictTemp in filterarr)
                {
                    
                    totalPrice+=[[dictTemp valueForKey:@"price"] floatValue];
                    [itemdescription appendFormat:@"%@,",[dictTemp valueForKey:@"name"]];
                   
                }
                [arrTemp release];
            }
        }

        [dictItem setObject:itemdescription forKey:@"description"];
        [dictItem setObject:[NSNumber numberWithInt:2] forKey:@"Viewtype"];
        [dictItem setObject:[NSString stringWithFormat:@"%.2f",totalPrice] forKey:@"price"];

        if (txtFieldSpecialInstructions.text.length>0) {
            [dictItem setObject:txtFieldSpecialInstructions.text forKey:@"specialInstructions"];
            
        }else{
            [dictItem setObject:@"" forKey:@"specialInstructions"];
            
        }
        [dictItem setObject:@"Menu" forKey:@"ItemType"];
        [arrMultiItemOrders addObject:dictItem];
        [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        appDelegate.isCmgForShowingOrderUI=YES;
        [arrMultiItemOrders release];
        [dictItem release];
        [itemdescription release];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }else if((![dictitemdetails valueForKey:@"option_groups"] &&viewtype==3 )){
        
        NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:dictitemdetails];
        if (txtFieldSpecialInstructions.text.length>0) {
            [dictItem setObject:txtFieldSpecialInstructions.text forKey:@"specialInstructions"];
            
        }else{
            [dictItem setObject:@"" forKey:@"specialInstructions"];
            
        }
        [dictItem setObject:@"Menu" forKey:@"ItemType"];
        
        [arrMultiItemOrders addObject:dictItem];
        [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        appDelegate.isCmgForShowingOrderUI=YES;
        [arrMultiItemOrders release];
        [dictItem release];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if ([dictitemdetails valueForKey:@"option_groups"] && viewtype==3){
        
        NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]init];
        
        float totalPrice = 0.0;
        NSMutableString *itemdescription =[[NSMutableString alloc]init];
        NSLog(@"%@",arrCustomDrinks);
        
        for (NSDictionary *dictTemp in arrCustomDrinks) {
            
                NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:[dictTemp objectForKey:@"options"]];
                NSArray *filterarr=[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
                
                for (NSDictionary *dictTemp in filterarr)
                {
                    
                    totalPrice+=[[dictTemp valueForKey:@"price"] floatValue];
                    [itemdescription appendFormat:@"%@,",[dictTemp valueForKey:@"name"]];
                    
                }
            
                [arrTemp release];
        }
        if (itemdescription.length>0) {
            [itemdescription deleteCharactersInRange:NSMakeRange([itemdescription length]-1, 1)];
        }
        [dictItem setObject:itemdescription forKey:@"name"];
        [dictItem setObject:itemdescription forKey:@"description"];
        [dictItem setObject:[NSNumber numberWithInt:2] forKey:@"Viewtype"];
        [dictItem setObject:[NSString stringWithFormat:@"%.2f",totalPrice] forKey:@"price"];
        [dictItem setObject:arrCustomDrinks forKey:@"ArrayInfo"];
        
        if (txtFieldSpecialInstructions.text.length>0) {
            [dictItem setObject:txtFieldSpecialInstructions.text forKey:@"specialInstructions"];
            
        }else{
            [dictItem setObject:@"" forKey:@"specialInstructions"];
            
        }
        [dictItem setObject:@"Menu" forKey:@"ItemType"];
        [arrMultiItemOrders addObject:dictItem];
        [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        appDelegate.isCmgForShowingOrderUI=YES;
        [arrMultiItemOrders release];
        [dictItem release];
        [itemdescription release];
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}

//Saving the favorite
-(void)SavingFavorites{
    
    UITextField *txtFieldSpecialInstructions=(UITextField*)[mainScroll viewWithTag:559];

    NSMutableArray *arritemlist=[[NSMutableArray alloc]init];
    for (NSDictionary *dictTemp in arrCustomDrinks) {
        
        if (viewtype==1 ||(![dictitemdetails valueForKey:@"option_groups"] &&viewtype==3 )) {
            NSMutableDictionary *dictitemlist=[[NSMutableDictionary alloc]init];
            
            [dictitemlist setObject:[dictTemp valueForKey:@"name"] forKey:@"itemName"];
            [dictitemlist setObject:[NSString stringWithFormat:@"%@",[dictTemp valueForKey:@"price"]] forKey:@"basePrice"];
            [dictitemlist setObject:@"1" forKey:@"quantity"];
            [dictitemlist setObject:@"" forKey:@"itemId"];
            [dictitemlist setObject:@"" forKey:@"title"];
            [dictitemlist setObject:[dictTemp valueForKey:@"description"] forKey:@"description"];
            [arritemlist addObject:dictitemlist];
            [dictitemlist release];
            
        }else if (viewtype==2){
            NSMutableArray *arrTemp;NSArray *filterarr;
            if ([dictTemp objectForKey:@"option_groups"]) {
                arrTemp=[[NSMutableArray alloc]initWithArray:[dictTemp objectForKey:@"option_groups"]];
                NSArray *array2temp=[arrTemp objectAtIndex:0];
                filterarr=[[array2temp valueForKey:@"options"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
            }else{
            arrTemp=[[NSMutableArray alloc]initWithArray:[dictTemp objectForKey:@"options"]];
            filterarr=[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
            }
            
            for (NSDictionary *dictTemp in filterarr)
            {
                NSMutableDictionary *dictitemlist=[[NSMutableDictionary alloc]init];
                
                [dictitemlist setObject:[dictTemp valueForKey:@"name"] forKey:@"itemName"];
                if ([dictTemp valueForKey:@"price"]) {
                    [dictitemlist setObject:[dictTemp valueForKey:@"price"] forKey:@"basePrice"];

                }else{
                    [dictitemlist setObject:@"0" forKey:@"basePrice"];

                }
                if ([dictTemp valueForKey:@"id"]) {
                    [dictitemlist setObject:[dictTemp valueForKey:@"id"] forKey:@"itemId"];

                }else{
                    [dictitemlist setObject:@"" forKey:@"itemId"];

                }
                [dictitemlist setObject:@"" forKey:@"title"];
                [dictitemlist setObject:@"1" forKey:@"quantity"];
                [dictitemlist setObject:@"" forKey:@"description"];
                
                [arritemlist addObject:dictitemlist];
                [dictitemlist release];
                
            }
            [arrTemp release];
        }else if ([dictitemdetails valueForKey:@"option_groups"] && viewtype==3){
            
            break;
        }
    }
    
    isSaveFavorite=YES;
    NSString *strDescription;
    if ([txtFieldSpecialInstructions.text length]>0) {
        strDescription=txtFieldSpecialInstructions.text;
    }else{
        strDescription=@"";
    }
    [self createProgressViewToParentView:self.view withTitle:@"Saving your favorite drink..."];
    [self.sharedController saveFavoriteDrinkbyvenueID:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] bartsyID:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] description:strDescription specialinstruction:@"" itemlist:arritemlist delegate:self];
    [arritemlist release];
    
}

-(void)Reset_Selection:(int)section{
    
        NSMutableDictionary *dict=[arrCustomDrinks objectAtIndex:section];
        if ([dict valueForKey:@"option_groups"]) {
            NSMutableArray *arrytemp=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"option_groups"]];
            NSArray *array2temp=[arrytemp objectAtIndex:0];
            NSArray *filterarr=[[array2temp valueForKey:@"options"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
            
            for (int i=0;i<[filterarr count];i++)
            {
                NSMutableDictionary *dict1Temp=[filterarr objectAtIndex:i];
                [dict1Temp setObject:@"0" forKey:@"Selected"];
            }
            [arrytemp release];
        }else{
            
            NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"options"]];
            NSArray *filterarr=[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
            for (NSMutableDictionary *dictTemp in filterarr)
            {
                [dictTemp setObject:@"0" forKey:@"Selected"];
            }
            [arrTemp release];
        }
}

-(void)ParsingFavorites:(id)results{
    
    NSArray *arrmenues=[results valueForKey:@"menus"];
    for (int i=0; i<[arrmenues count]; i++) {
        NSDictionary *dicmainsections=[arrmenues objectAtIndex:i];
        
        NSArray *arrsections=[dicmainsections valueForKey:@"sections"];
        for (int j=0; j<[arrsections count]; j++) {
            
            NSDictionary *dictsection=[arrsections objectAtIndex:j];
            
            NSArray *arrsubSection=[dictsection valueForKey:@"subsections"];
            for (int k=0; k<[arrsubSection count];k++) {
                NSDictionary *dictSubSection=[ arrsubSection objectAtIndex:k];
                NSArray *arrContent=[dictSubSection valueForKey:@"contents"];

                for (int l=0; l<arrContent.count;l++) {
                    NSDictionary *dictContent=[arrContent objectAtIndex:l];
                    NSLog(@"%@",dictContent);
                    if (viewtype==1 || (![dictitemdetails valueForKey:@"option_groups"] && viewtype==3)){
                        
                        if ([[dictContent valueForKey:@"name"] isEqualToString:[dictitemdetails valueForKey:@"name"] ]) {
                            
                            favoriteID=[[dictContent valueForKey:@"favorite_id"] integerValue];
                            UIButton *btnFav=(UIButton*)[mainScroll viewWithTag:557];
                            btnFav.selected=YES;
                            NSLog(@"%d",favoriteID);
                            
                        }
                    }else if (viewtype==2){
                        
                        for (int x=0;i<arrCustomDrinks.count; i++) {
                            if ([[dictContent valueForKey:@"name"] isEqualToString:[[arrCustomDrinks objectAtIndex:x] valueForKey:@"name"] ]) {
                                
                                favoriteID=[[dictContent valueForKey:@"FavID"] integerValue];
                                UIButton *btnFav=(UIButton*)[mainScroll viewWithTag:557];
                                btnFav.selected=YES;
                                NSLog(@"%d",favoriteID);
                            }
 
                        }
                  }

                  
                }
    
            }
        }
    }
    /*for (int x=0; x<[arrFavorites count]; x++) {
      
        NSDictionary *dict1Temp=[arrFavorites objectAtIndex:x];
        NSArray *array1Temp=[dict1Temp valueForKey:@"contents"];
        for (int y=0; y<array1Temp.count; y++) {
            NSDictionary *dict2Temp=[array1Temp objectAtIndex:y];
            if (viewtype==1 || (![dictitemdetails valueForKey:@"option_groups"] && viewtype==3)){
                
                if ([[dict2Temp valueForKey:@"name"] isEqualToString:[dictitemdetails valueForKey:@"name"] ]) {
                    
                    favoriteID=[[dict1Temp valueForKey:@"FavID"] integerValue];
                    NSLog(@"%d",favoriteID);
                    
                }
            }else if (viewtype==2){
                
                if ([[dict2Temp valueForKey:@"name"] isEqualToString:[[arrCustomDrinks objectAtIndex:y] valueForKey:@"name"] ]) {
                    
                    favoriteID=[[dict1Temp valueForKey:@"FavID"] integerValue];
                    NSLog(@"%d",favoriteID);
                }
            }
            
        }
       
    }
    if ([arrFavorites containsObject:@""]) {
        
    }*/
    
}
#pragma mark------------Webservice Delegates
-(void)controllerDidFinishLoadingWithResult:(id)result
{
    [self hideProgressView:nil];
    if (isSaveFavorite) {
        
        isSaveFavorite=YES;
        if([[result objectForKey:@"errorCode"] integerValue]!=0)
        {
            [self createAlertViewWithTitle:@"Error" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
        }
        else
        {
           // NSLog(@"result %@",result);
            [self createAlertViewWithTitle:@"" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
            favoriteID=[[result valueForKey:@"favoriteDrinkId"] integerValue];
            NSLog(@"fa%d",favoriteID);
        }

    }else if (isDeleteFavorite){
        
        isDeleteFavorite=YES;
        
    }else if (isGettingFavorites){
        isGettingFavorites=NO;
        if([[result objectForKey:@"errorCode"] integerValue]==0)
        {
            [self ParsingFavorites:result];
            //NSLog(@"result %@",result);
            
        }
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

-(void)dealloc{
    
    [super dealloc];
    [dictitemdetails release];
    [dictCustomDrinks release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
