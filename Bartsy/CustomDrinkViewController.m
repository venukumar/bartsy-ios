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
    UITextField* instructionfield;
}
@property(nonatomic,retain)NSMutableArray *arrCustomDrinks;
@end

@implementation CustomDrinkViewController
@synthesize viewtype,dictitemdetails,arrIndex,isEdit,arrayEditInfo,arrCustomDrinks;
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
    
    /*UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(100.25, 13.25, 119.5, 23.5)];
    imgLogo.image=[UIImage imageNamed:@"logo_Header.png"];
    [self.view addSubview:imgLogo];
    [imgLogo release];*/
   
    
    
    UILabel *lblMsg=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 240, 44)];
    lblMsg.textColor=[UIColor blackColor];
    if (viewtype==3 || viewtype==1 || viewtype==2 || viewtype==4) {
        lblMsg.text=[dictitemdetails valueForKey:@"name"];
    }
    lblMsg.textAlignment=NSTextAlignmentCenter;
    lblMsg.backgroundColor=[UIColor clearColor];
    lblMsg.font=[UIFont boldSystemFontOfSize:18];
    [self.view addSubview:lblMsg];
    [lblMsg release];

    
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
  
    NSLog(@"%@",dictitemdetails);
    
    UIView *favtView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    favtView.backgroundColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f];
    [mainScroll addSubview:favtView];
    
    
    UIButton *buttonFav=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonFav.frame=CGRectMake(155, 2, 26, 26);
    if (IS_IPHONE_5)
        buttonFav.frame=CGRectMake(155,2, 26, 26);
    
    buttonFav.tag=557;
    [buttonFav addTarget:self action:@selector(Button_Action:) forControlEvents:UIControlEventTouchUpInside];
    [buttonFav setImage:[UIImage imageNamed:@"unfav_icon"] forState:UIControlStateNormal];
    [buttonFav setImage:[UIImage imageNamed:@"fav_icon"] forState:UIControlStateSelected];
    [favtView addSubview:buttonFav];

    UILabel *lblfav=[[UILabel alloc]initWithFrame:CGRectMake(192,0, 125, 30)];
    if (IS_IPHONE_5)
        lblfav.frame=CGRectMake(192, 0, 125, 30);
    
    lblfav.textColor=[UIColor whiteColor];
    lblfav.text=@"Save to favorites";
    lblfav.textAlignment=NSTextAlignmentLeft;
    lblfav.backgroundColor=[UIColor clearColor];
    lblfav.font=[UIFont systemFontOfSize:16];
    [favtView addSubview:lblfav];
    [lblfav release];

    
    if (viewtype==2 || viewtype==3 || viewtype==4) {
        
        UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 30, 320, 367-80) style:UITableViewStylePlain];
        tblView.dataSource=self;
        tblView.backgroundColor = [UIColor blackColor];
        tblView.delegate=self;
        tblView.tag=555;
        [tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //[tblView setSeparatorColor:[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f]];
        [mainScroll addSubview:tblView];
        
        if (IS_IPHONE_5)
        {
            tblView.frame=CGRectMake(0,30, 320, 455-80);
        }
        
        [tblView release];
        UIView *footview=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
        footview.backgroundColor=[UIColor clearColor];
        UILabel *lblinstruction=[[UILabel alloc]initWithFrame:CGRectMake(5, 2,180,18)];
        lblinstruction.text=@"Special instructions";
        lblinstruction.textColor=[UIColor whiteColor];
        lblinstruction.backgroundColor=[UIColor clearColor];
        lblinstruction.font=[UIFont fontWithName:@"Museo Sans" size:14.0];
        [footview addSubview:lblinstruction];
        [lblinstruction release];
        
        UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0,21,320, 1.5)];
        lineview.backgroundColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f];
        [footview addSubview:lineview];
        
        instructionfield = [[[UITextField alloc] initWithFrame:CGRectMake(0,23, 320, 30)] autorelease];
        [instructionfield setBorderStyle:UITextBorderStyleLine];
        instructionfield.placeholder=@"Optional";
        instructionfield.delegate=self;
        instructionfield.tag=559;
        instructionfield.textColor=[UIColor whiteColor];
        instructionfield.font=[UIFont fontWithName:@"Museo Sans" size:14.0];
        //instructionfield.layer.borderWidth=1.0;
        //instructionfield.layer.borderColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f].CGColor;
        [footview addSubview:instructionfield];
        if ([dictitemdetails valueForKey:@"specialInstructions"] && [[dictitemdetails valueForKey:@"specialInstructions"] length]>0) {
            instructionfield.text=[dictitemdetails valueForKey:@"specialInstructions"];
        }

        tblView.tableFooterView=footview;

    }else if (viewtype==1){
       
        UILabel *lblitem=[[UILabel alloc]initWithFrame:CGRectMake(5, 48,310, 18)];
        lblitem.text=[dictitemdetails valueForKey:@"name"];
        lblitem.textColor=[UIColor whiteColor];
        lblitem.backgroundColor=[UIColor clearColor];
        [mainScroll addSubview:lblitem];
        [lblitem release];
        
        UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 66, 320, 1.5)];
        lineview.backgroundColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f];
        [mainScroll addSubview:lineview];
        [lineview release];
        
        CGSize myStringSize = [[dictitemdetails valueForKey:@"description"] sizeWithFont:[UIFont systemFontOfSize:14]
                                   constrainedToSize:CGSizeMake(310, 100)
                                       lineBreakMode:NSLineBreakByWordWrapping];
        UILabel *lbldescription=[[UILabel alloc]initWithFrame:CGRectMake(5,69,310, myStringSize.height+30)];
        lbldescription.text=[dictitemdetails valueForKey:@"description"];
        lbldescription.textColor=[UIColor whiteColor];
        lbldescription.numberOfLines=6;
        lbldescription.backgroundColor=[UIColor clearColor];
        [mainScroll addSubview:lbldescription];
        [lbldescription release];
        
        UILabel *lblinstruction=[[UILabel alloc]initWithFrame:CGRectMake(5, 175,180,18)];
        if (IS_IPHONE_5) {
            lblinstruction.frame=CGRectMake(5, 187,180,18);
        }
        lblinstruction.text=@"Special instructions";
        lblinstruction.textColor=[UIColor whiteColor];
        lblinstruction.backgroundColor=[UIColor clearColor];
        lblinstruction.font=[UIFont fontWithName:@"Museo Sans" size:17.0];
        [mainScroll addSubview:lblinstruction];
        [lblinstruction release];
        
        instructionfield = [[[UITextField alloc] initWithFrame:CGRectMake(-1.5,195, 323, 30)] autorelease];
        if (IS_IPHONE_5) {
            instructionfield.frame=CGRectMake(-1.5,215, 323, 30);
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
    }
    
    UIButton *orderBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame=CGRectMake(162,324, 150, 40);
    if (IS_IPHONE_5) {
        orderBtn.frame=CGRectMake(162,418, 150, 30);

    }
    orderBtn.tag=556;
    if (![dictitemdetails valueForKey:@"price"]) {
        [orderBtn setTitle:[NSString stringWithFormat:@"%@-$%@",@"Add to order",@"0"] forState:UIControlStateNormal];

    }else{
        [orderBtn setTitle:[NSString stringWithFormat:@"%@-$%@",@"Add to order",[dictitemdetails valueForKey:@"price"]] forState:UIControlStateNormal];

    }
    [orderBtn setTitle:[NSString stringWithFormat:@"%@",@"Add to order"] forState:UIControlStateNormal];
    [orderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(Button_Order:) forControlEvents:UIControlEventTouchUpInside];
    [orderBtn addTarget:self action:@selector(ButtonHighlight:) forControlEvents:UIControlEventTouchDown];
    orderBtn.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:175.0/255.0 blue:222.0/255.0 alpha:1.0];
    orderBtn.titleLabel.font=[UIFont fontWithName:@"Museo Sans" size:14.0];
    [mainScroll addSubview:orderBtn];
    
    UIButton *cancelorderBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelorderBtn.frame=CGRectMake(9,324, 150, 40);
    if (IS_IPHONE_5) {
        cancelorderBtn.frame=CGRectMake(9,418, 150, 40);
    }
    cancelorderBtn.titleLabel.font=[UIFont fontWithName:@"Museo Sans" size:14.0];
    [cancelorderBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelorderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelorderBtn addTarget:self action:@selector(btnBack_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [cancelorderBtn addTarget:self action:@selector(ButtonHighlight:) forControlEvents:UIControlEventTouchDown];
    cancelorderBtn.tag=4445;
    cancelorderBtn.backgroundColor=[UIColor colorWithRed:5.0/255.0 green:5.0/255.0 blue:6.0/255.0 alpha:1.0];
    [mainScroll addSubview:cancelorderBtn];
    
    if (!isEdit || viewtype==1) {

        if ([dictitemdetails valueForKey:@"option_groups"]) {

            NSArray *arrTemp=[dictitemdetails valueForKey:@"option_groups"];
            for (int x=0; x<arrTemp.count; x++) {
                
                NSDictionary *dictTemp=[arrTemp objectAtIndex:x];
                if (![[dictTemp valueForKey:@"text"] isEqualToString:@"Mixers"]) {
                    NSMutableDictionary *dictOptionsGrup=[[NSMutableDictionary alloc]init];

                    for(id key in dictitemdetails){
                        if (![key isEqualToString:@"option_groups"]) {
                            [dictOptionsGrup setObject:[dictitemdetails valueForKey:key] forKey:key];
 
                        }else{
                            NSArray *arr1Temp=[dictitemdetails valueForKey:key];
                           // NSMutableArray *arrlist=[[NSMutableArray alloc]init];
                          //  [arrlist addObject:[arr1Temp objectAtIndex:0]];
                            [dictOptionsGrup setObject:[arr1Temp objectAtIndex:0] forKey:key];
                           // [arrlist release];

                        }
                    }
                    
                    [arrCustomDrinks addObject:dictOptionsGrup];
                    [dictOptionsGrup release];
                }
            }
        }else{
            [arrCustomDrinks addObject:dictitemdetails];

        }

    }
    
    //if Viewtype is 2 it is ingradient selection
    if (viewtype==2 && isEdit==NO) {
 
        [self HashmappingIngradients:dictitemdetails];
                      
    }else if (viewtype==3 && isEdit==NO){
        [arrCustomDrinks removeAllObjects];
        NSArray *arrOptionGroup=[dictitemdetails valueForKey:@"option_groups"];
        for (NSDictionary *dictoption in arrOptionGroup) {
 
            NSMutableArray *arrContent=[[NSMutableArray alloc]init];

            NSArray *arroption=[dictoption valueForKey:@"options"];
            for (int k=0;k<[arroption count];k++) {
                //NSMutableDictionary *dict1Temp=[arroption objectAtIndex:k];
                //[dict1Temp setObject:@"0" forKey:@"Selected"];

                NSDictionary *dictOptionGroup=[[NSDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:[arroption objectAtIndex:k]]];
                NSArray *arrTemp=[dictOptionGroup valueForKey:@"option_groups"];
              
                for (int l=0; l<1;l++ ) {
                    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:[arrTemp objectAtIndex:l]];
                                        
                    NSArray *arr2Temp=[dict valueForKey:@"options"];
                    NSMutableArray *arrList=[[NSMutableArray alloc]init];
                    for (int x=0;x<arr2Temp.count;x++) {
                        NSMutableDictionary *dict2Temp=[[NSMutableDictionary alloc]initWithDictionary:[arr2Temp objectAtIndex:x]];
                        if ([[dict2Temp valueForKey:@"selected"] boolValue]==true) {
                            [dict2Temp setObject:[NSNumber numberWithBool:true] forKey:@"selected"];

                        }else{
                        [dict2Temp setObject:[NSNumber numberWithBool:false] forKey:@"selected"];
                        }

                        [arrList addObject:dict2Temp];
                        [dict2Temp release];
                    }
                    [dict setObject:arrList forKey:@"options"];
                    [arrContent addObject:dict];
                    
                    [dict release];
                    [arrList release];
                }
                [dictOptionGroup release];
                
            }
            [arrCustomDrinks addObjectsFromArray:arrContent];
            

        }
        
        [arrCustomDrinks setValue:[dictitemdetails valueForKey:@"name"] forKey:@"itemName"];
        [arrCustomDrinks setValue:[dictitemdetails valueForKey:@"name"] forKey:@"name"];

        [arrCustomDrinks setValue:[dictitemdetails valueForKey:@"description"] forKey:@"description"];
        [arrCustomDrinks setValue:[dictitemdetails valueForKey:@"category"] forKey:@"category"];
        [arrCustomDrinks setValue:[dictitemdetails valueForKey:@"instructions"] forKey:@"instructions"];
        [arrCustomDrinks setValue:[dictitemdetails valueForKey:@"ingredients"] forKey:@"ingredients"];

    }
        
    
   /* UIButton *buttonLike=[UIButton buttonWithType:UIButtonTypeCustom];
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
    [lbllike release];*/
    
    isGettingFavorites=YES;
    [self.sharedController getFavoriteDrinksbybartsyID:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] venueID:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] delegate:self];

    //[self.sharedController performSelectorOnMainThread:@selector() withObject:nil waitUntilDone:YES];
    
   if( viewtype==2&&isEdit==YES || viewtype==3&&isEdit==YES || viewtype==4 && isEdit==YES){
      

       [arrCustomDrinks addObjectsFromArray:arrayEditInfo];
       NSLog(@"%@",arrCustomDrinks);
       UITableView *tableview=(UITableView*)[self.view viewWithTag:555];
       [tableview reloadData];
   }else if (viewtype==4 && isEdit==NO){
       [arrCustomDrinks removeAllObjects];
       NSArray *arrayTemp=[dictitemdetails valueForKey:@"option_groups"];
       
       [arrCustomDrinks addObjectsFromArray:arrayTemp];
       
   }
    if (viewtype==2||viewtype==3||viewtype==4) {
        [self calculateTotalPrice:0];

    }
}

-(void)ButtonHighlight:(UIButton*)sender{
    
    if (sender.tag==4445) {
        sender.backgroundColor=[UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:1.0];

    }else{
        sender.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:92.0/255.0 blue:118.0/255.0 alpha:1.0];

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
                    if ([[dicttemp valueForKey:@"selected"] boolValue]==true) {
                        [dicttemp setObject:[NSNumber numberWithBool:true] forKey:@"selected"];

                    }else{
                        [dicttemp setObject:[NSNumber numberWithBool:false] forKey:@"selected"];
                    }
                    [arrlist addObject:dicttemp];
                    //[dicttemp release];
                }
                [dictlist setObject:arrlist forKey:@"options"];
                [arrCustomDrinks addObject:dictlist];
                [arrlist release];
                [tempDict release];
                [dictlist release];
            }
        }
    }
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
    [headerTitle setFont:[UIFont systemFontOfSize:17]];
    headerTitle.font=[UIFont fontWithName:@"Museo Sans" size:17.0];

    [headerTitle setTextColor:[UIColor whiteColor]];
    UILabel *lbltype=[[UILabel alloc]initWithFrame:CGRectMake(120, 3, 280, 30)];
    [lbltype setBackgroundColor:[UIColor clearColor]];
    [lbltype setFont:[UIFont systemFontOfSize:12]];
    lbltype.font=[UIFont fontWithName:@"Museo Sans" size:12.0];

    [lbltype setTextColor:[UIColor whiteColor]];
    if (viewtype==4){
        NSDictionary *dictsection=[arrCustomDrinks objectAtIndex:section];

         headerTitle.text=[NSString stringWithFormat:@"%@",[dictsection valueForKey:@"text"]];
        if ([[dictsection valueForKey:@"type"] isEqualToString:@"OPTION_CHOOSE"] ||[[dictsection valueForKey:@"type"] isEqualToString:@"ITEM_SELECT"]) {
            
            lbltype.text=[NSString stringWithFormat:@"(%@)",@"choose one"];
        }else{
            lbltype.text=[NSString stringWithFormat:@"(%@)",@"choose any"];
        }
        
    }else if (viewtype==2){
        NSDictionary *dictsection=[arrCustomDrinks objectAtIndex:section];

    if (section==0) {
        headerTitle.text=[NSString stringWithFormat:@"%@",[dictsection valueForKey:@"name"]];
        if ([[dictsection valueForKey:@"type"] isEqualToString:@"OPTION_CHOOSE"] ||[[dictsection valueForKey:@"type"] isEqualToString:@"ITEM_SELECT"]) {
            
            lbltype.text=[NSString stringWithFormat:@"(%@)",@"choose one"];
        }else{
            lbltype.text=[NSString stringWithFormat:@"(%@)",@"choose any"];
        }


    }else{
        headerTitle.text=[NSString stringWithFormat:@"%@",[dictsection valueForKey:@"text"]];
        if ([[dictsection valueForKey:@"type"] isEqualToString:@"OPTION_CHOOSE"] ||[[dictsection valueForKey:@"type"] isEqualToString:@"ITEM_SELECT"]) {
            
            lbltype.text=[NSString stringWithFormat:@"(%@)",@"choose one"];
        }else{
            lbltype.text=[NSString stringWithFormat:@"(%@)",@"choose any"];
        }


     }
    }else if(viewtype==3){
        NSDictionary *dictsection=[arrCustomDrinks objectAtIndex:section];
        headerTitle.text=[NSString stringWithFormat:@"%@",[dictsection valueForKey:@"text"]];
        if ([[dictsection valueForKey:@"type"] isEqualToString:@"OPTION_CHOOSE"] ||[[dictsection valueForKey:@"type"] isEqualToString:@"ITEM_SELECT"]) {
            
            lbltype.text=[NSString stringWithFormat:@"(%@)",@"choose one"];
        }else{
            lbltype.text=[NSString stringWithFormat:@"(%@)",@"choose any"];
        }

    }
    CGSize lblwidth=[headerTitle.text sizeWithFont:[UIFont boldSystemFontOfSize:16] forWidth:280 lineBreakMode:NSLineBreakByWordWrapping];
    lbltype.frame=CGRectMake(lblwidth.width+14, lbltype.frame.origin.y, lbltype.frame.size.width, lbltype.frame.size.height);
    [headerView addSubview:headerTitle];
    [headerView addSubview:lbltype];
    
    UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0,32,320, 1.5)];
    lineview.backgroundColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f];
    [headerView addSubview:lineview];
    [lineview release];
    return headerView;
   
}
/*
-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==[arrCustomDrinks count]-1) {
        
        UIView *footview=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
        footview.backgroundColor=[UIColor clearColor];
        UILabel *lblinstruction=[[UILabel alloc]initWithFrame:CGRectMake(5, 2,180,18)];
        lblinstruction.text=@"Special instructions";
        lblinstruction.textColor=[UIColor whiteColor];
        lblinstruction.backgroundColor=[UIColor clearColor];
        [footview addSubview:lblinstruction];
        [lblinstruction release];
        
        UITextField* instructionfield = [[[UITextField alloc] initWithFrame:CGRectMake(0,22, 320, 30)] autorelease];
        [instructionfield setBorderStyle:UITextBorderStyleLine];
        instructionfield.placeholder=@"Optional";
        instructionfield.delegate=self;
        instructionfield.tag=559;
        instructionfield.textColor=[UIColor whiteColor];
        //instructionfield.layer.borderWidth=1.5;
        //instructionfield.layer.borderColor=[UIColor colorWithRed:(0.0f/255.0f) green:(175.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0f].CGColor;
        [footview addSubview:instructionfield];

        return footview;
    }else{
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==[arrCustomDrinks count]-1) {
        
        return 100;
    }else
    return 0;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (viewtype==4){
        NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:section] valueForKey:@"options"];
        return [subitemArray count];
    }else if (viewtype==2 ){
        
        if (section==0) {
            NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:section] valueForKey:@"option_groups"];
            NSArray *arraytemp=[subitemArray valueForKey:@"options"];
            
            return [arraytemp count];
            
        }else{
            NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:section] valueForKey:@"options"];
            return [subitemArray count];
        }

    }else if(viewtype==3){
        NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:section] valueForKey:@"options"];
        return [subitemArray count];
    }
      
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(viewtype==3){
        NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"options"];
        if (indexPath.row==[subitemArray count]-1) {
            
            return 64;
        }
    }else if (viewtype==4){
        NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"options"];
        if (indexPath.row==[subitemArray count]-1) {
            
            return 64;
        }
        
    }else if (viewtype==2 ){
        
        if (indexPath.section==0) {
            NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"option_groups"];
            NSArray *arraytemp=[subitemArray valueForKey:@"options"];
            
            if (indexPath.row==[arraytemp count]-1) {
                
                return 64;
            }
            
        }else{
            NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"options"];
            if (indexPath.row==[subitemArray count]-1) {
                
                return 64;
            }
        }
        
    }
    
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;    
   
    cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
   // cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage            imageNamed:@"fathers_office-bg.png"]];
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 270, 44)];
    lblName.font=[UIFont systemFontOfSize:16];
    lblName.font=[UIFont fontWithName:@"Museo Sans" size:16.0];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.textColor=[UIColor whiteColor];
    [cell.contentView addSubview:lblName];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(10, 10, 22, 22);
    button.tag=indexPath.row;
    //[button addTarget:self action:@selector(checkboxButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"uncheck_icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"check_icon"] forState:UIControlStateSelected];
    button.userInteractionEnabled=NO;
    [cell.contentView addSubview:button];
    
    UILabel *lblPrice=[[UILabel alloc]initWithFrame:CGRectMake(270, 0, 50, 44)];
    lblPrice.font=[UIFont boldSystemFontOfSize:18];
    lblPrice.textColor=[UIColor colorWithRed:33.0/255.0 green:169.0/255.0 blue:204.0/255.0 alpha:1.0];
    //lblPrice.adjustsFontSizeToFitWidth=YES;
    lblPrice.backgroundColor=[UIColor clearColor];
    lblPrice.font=[UIFont fontWithName:@"Museo Sans" size:18.0];
    [cell.contentView addSubview:lblPrice];
    if (viewtype==4) {
        NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"options"] ;
        if ([[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"selected"] integerValue]==1) {
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

    }else if (viewtype==2){
         if (indexPath.section==0) {
             NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"option_groups"];
             NSArray *arraytemp=[subitemArray valueForKey:@"options"];

             if ([[[arraytemp objectAtIndex:indexPath.row] valueForKey:@"selected"] integerValue]==1) {
                 button.selected=YES;
                 lblPrice.text=[NSString stringWithFormat:@"$%@",[[arraytemp objectAtIndex:indexPath.row] valueForKey:@"price"]];
             }else{
                 lblPrice.text=nil;
                 button.selected=NO;
             }
             
         }else{
             NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"options"] ;
             if ([[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"selected"] integerValue]==1) {
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

     }else if(viewtype==3){
         
         id subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"options"] ;
         if ([[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"selected"] integerValue]==1) {
             button.selected=YES;
             lblPrice.text=[NSString stringWithFormat:@"$%@",[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"price"]];
         }else{
             
             lblPrice.text=nil;
             button.selected=NO;
         }

     }
        [lblPrice release];
    
    if(viewtype==4){
        NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"options"];
        if ([[subitemArray objectAtIndex:indexPath.row] valueForKey:@"price"]) {
            lblName.text=[NSString stringWithFormat:@"%@ (%@)",[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"name"],[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"price"]];
        }else{
            lblName.text=[NSString stringWithFormat:@"%@ (%@)",[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"name"],@"0"];
        }

    }else if (viewtype==2){
         
         if (indexPath.section==0) {
             NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"option_groups"];
             
             NSArray *arrytemp=[subitemArray valueForKey:@"options"];
             
             lblName.text=[NSString stringWithFormat:@"%@ (%@)",[[arrytemp objectAtIndex:indexPath.row] valueForKey:@"name"],[[arrytemp objectAtIndex:indexPath.row] valueForKey:@"price"]];
             
         }else{
             NSArray *subitemArray=[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"options"];
             
             if ([[subitemArray objectAtIndex:indexPath.row] valueForKey:@"price"]) {
                 lblName.text=[NSString stringWithFormat:@"%@ (%@)",[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"name"],[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"price"]];
             }else{
                 lblName.text=[NSString stringWithFormat:@"%@ (%@)",[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"name"],@"0"];
             }

         }

     }else if(viewtype==3){
         
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
    if (viewtype==4) {
        id item=[arrCustomDrinks objectAtIndex:indexPath.section];
        NSMutableDictionary *dictitemlist=[[NSMutableDictionary alloc]initWithDictionary:[arrCustomDrinks objectAtIndex:indexPath.section]];
        NSMutableArray *subitemArray=[[NSMutableArray alloc]initWithArray:[dictitemlist valueForKey:@"options"]];
        if ([[item valueForKey:@"type"] isEqualToString:@"OPTION_CHOOSE"]) {
            
            //[self Reset_Selection:indexPath.section];
            for (int i=0; i<[subitemArray count]; i++)
            {
                NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:[subitemArray objectAtIndex:i]];
                if(indexPath.row!=i)
                    [dictItem setObject:[NSNumber numberWithBool:false] forKey:@"selected"];
                else
                    [dictItem setObject:[NSNumber numberWithBool:true] forKey:@"selected"];
                [subitemArray replaceObjectAtIndex:i withObject:dictItem];
                [dictItem release];
            }
        }else{
                NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:[subitemArray objectAtIndex:indexPath.row]];
                if ([[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"selected"] integerValue]==1) {
                    
                    [dictItem setObject:[NSNumber numberWithBool:false] forKey:@"selected"];
                }else{
                    
                    [dictItem setObject:[NSNumber numberWithBool:true] forKey:@"selected"];
                }
                [subitemArray replaceObjectAtIndex:indexPath.row withObject:dictItem];
            [dictItem release];
                
        }
            
            NSMutableDictionary *dictmenu=[[NSMutableDictionary alloc]initWithDictionary:[arrCustomDrinks objectAtIndex:indexPath.section]];
            [dictmenu setObject:subitemArray forKey:@"options"];
            [arrCustomDrinks replaceObjectAtIndex:indexPath.section withObject:dictmenu];
        [dictitemlist release];
        [subitemArray release];
        [dictmenu release];

        [tableView reloadData];
        [self calculateTotalPrice:indexPath.section];
    }else if (viewtype==2){
        if (indexPath.section==0) {
            NSMutableDictionary *subitemdict=[[NSMutableDictionary alloc]initWithDictionary:[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"option_groups"]];
            NSMutableArray *arrytemp=[[NSMutableArray alloc]initWithArray:[subitemdict valueForKey:@"options"]];
            //NSMutableDictionary *dict=[arrytemp objectAtIndex:indexPath.row];
            id dictType=[subitemdict valueForKey:@"type"];
            
            if ([dictType isEqualToString:@"OPTION_CHOOSE"]) {
                
                //[[(NSMutableArray*)[[arrCustomDrinks objectAtIndex:indexPath.section] valueForKey:@"option_groups"] valueForKey:@"options"] setObject:@"0" forKey:@"Selected"];
                for (int i=0; i<[arrytemp count]; i++)
                {
                    NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:[arrytemp objectAtIndex:i]];
                    if(indexPath.row!=i)
                    [dictItem setObject:[NSNumber numberWithBool:false] forKey:@"selected"];
                    else
                    [dictItem setObject:[NSNumber numberWithBool:true] forKey:@"selected"];
                    [arrytemp replaceObjectAtIndex:i withObject:dictItem];
                    [dictItem release];
                }
                
            }
            [subitemdict setObject:arrytemp forKey:@"options"];
            NSMutableDictionary *dictIngrident=[[NSMutableDictionary alloc]initWithDictionary:[arrCustomDrinks objectAtIndex:indexPath.section]];
            [dictIngrident setObject:subitemdict forKey:@"option_groups"];
            [arrCustomDrinks replaceObjectAtIndex:indexPath.section withObject:dictIngrident];
            //[[arrCustomDrinks objectAtIndex:indexPath.section] setObject:subitemdict forKey:@"option_groups"];
            [subitemdict release];
            [arrytemp release];
            [dictIngrident release];
        }else{
            id item=[arrCustomDrinks objectAtIndex:indexPath.section];
            
            
            NSMutableDictionary *dictitemlist=[[NSMutableDictionary alloc]initWithDictionary:[arrCustomDrinks objectAtIndex:indexPath.section]];
            NSMutableArray *subitemArray=[[NSMutableArray alloc]initWithArray:[dictitemlist valueForKey:@"options"]];
            if ([[item valueForKey:@"type"] isEqualToString:@"OPTION_CHOOSE"]) {
                
               // [self Reset_Selection:indexPath.section];
                for (int i=0; i<[subitemArray count]; i++)
                {
                    NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:[subitemArray objectAtIndex:i]];
                    if(indexPath.row!=i)
                        [dictItem setObject:[NSNumber numberWithBool:false] forKey:@"selected"];
                    else
                        [dictItem setObject:[NSNumber numberWithBool:true] forKey:@"selected"];
                    [subitemArray replaceObjectAtIndex:i withObject:dictItem];
                    [dictItem release];
                }

            }else{
                NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:[subitemArray objectAtIndex:indexPath.row]];
                if ([[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"selected"] integerValue]==1) {
                    
                    [dictItem setObject:[NSNumber numberWithBool:false] forKey:@"selected"];
                }else{
                    
                    [dictItem setObject:[NSNumber numberWithBool:true] forKey:@"selected"];
                }
                [subitemArray replaceObjectAtIndex:indexPath.row withObject:dictItem];
                [dictItem release];
            }
            
            NSMutableDictionary *dictIngrident=[[NSMutableDictionary alloc]initWithDictionary:[arrCustomDrinks objectAtIndex:indexPath.section]];
            [dictIngrident setObject:subitemArray forKey:@"options"];
            [arrCustomDrinks replaceObjectAtIndex:indexPath.section withObject:dictIngrident];
            
            [subitemArray release];
            [dictitemlist release];
            [dictIngrident release];
        }
        [tableView reloadData];
        
        [self calculateTotalPrice:indexPath.section];
    }else if(viewtype==3){
        
        id item=[arrCustomDrinks objectAtIndex:indexPath.section];
        NSMutableDictionary *dictitemlist=[[NSMutableDictionary alloc]initWithDictionary:[arrCustomDrinks objectAtIndex:indexPath.section]];
        NSMutableArray *subitemArray=[[NSMutableArray alloc]initWithArray:[dictitemlist valueForKey:@"options"]];
        if ([[item valueForKey:@"type"] isEqualToString:@"OPTION_CHOOSE"]) {
            
            for (int i=0; i<[subitemArray count]; i++)
            {
                NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:[subitemArray objectAtIndex:i]];
                if(indexPath.row!=i)
                    [dictItem setObject:[NSNumber numberWithBool:false] forKey:@"selected"];
                else
                    [dictItem setObject:[NSNumber numberWithBool:true] forKey:@"selected"];
                [subitemArray replaceObjectAtIndex:i withObject:dictItem];
                [dictItem release];
            }
            //[self Reset_Selection:indexPath.section];
        }else{
            NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:[subitemArray objectAtIndex:indexPath.row]];
            if ([[[subitemArray objectAtIndex:indexPath.row] valueForKey:@"selected"] integerValue]==1) {
                
                [dictItem setObject:[NSNumber numberWithBool:false] forKey:@"selected"];
            }else{
                
                [dictItem setObject:[NSNumber numberWithBool:false] forKey:@"selected"];
            }
            [subitemArray replaceObjectAtIndex:indexPath.row withObject:dictItem];
            [dictItem release];
        }
       
        NSMutableDictionary *dictIngrident=[[NSMutableDictionary alloc]initWithDictionary:[arrCustomDrinks objectAtIndex:indexPath.section]];
        [dictIngrident setObject:subitemArray forKey:@"options"];
        [arrCustomDrinks replaceObjectAtIndex:indexPath.section withObject:dictIngrident];
        
        [dictitemlist release];
        [subitemArray release];
        [dictIngrident release];
        [tableView reloadData];
        [self calculateTotalPrice:indexPath.section];
    }
    
   
}

-(void)calculateTotalPrice:(int)section
{
    float floatTotalPrice=0.0;
    
    for (int i=0;i<[arrCustomDrinks count]; i++)
    {
        if (viewtype==2){
            
            NSDictionary *dict=[arrCustomDrinks objectAtIndex:i];
            if ([dict valueForKey:@"option_groups"]) {
                
                NSMutableArray *subitemArray=[[arrCustomDrinks objectAtIndex:i] valueForKey:@"option_groups"];
                NSArray *arrytemp=[subitemArray valueForKey:@"options"];
                NSArray *filterarr=[arrytemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(selected == %@)",[NSNumber numberWithBool:true]]];
                for (NSDictionary *dictTemp in filterarr)
                {
                    floatTotalPrice+=[[dictTemp objectForKey:@"price"] floatValue];
                }
            }else{
                
                NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"options"]];
                NSArray *filterarr=[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(selected == %@)",[NSNumber numberWithBool:true]]];
                for (NSDictionary *dictTemp in filterarr)
                {
                    floatTotalPrice+=[[dictTemp objectForKey:@"price"] floatValue];
                }
                [arrTemp release];
                
            }

        }else{
            NSDictionary *dict=[arrCustomDrinks objectAtIndex:i];

            NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"options"]];
            NSArray *filterarr=[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(selected == %@)",[NSNumber numberWithBool:true]]];
            for (NSDictionary *dictTemp in filterarr)
            {
                floatTotalPrice+=[[dictTemp objectForKey:@"price"] floatValue];
            }
            [arrTemp release];
        }
    }
    UIButton *orderBtn=(UIButton*)[mainScroll viewWithTag:556];
   //  [orderBtn setTitle:[NSString stringWithFormat:@"%@-$%.2f",@"Add to order",floatTotalPrice] forState:UIControlStateNormal];
}

#pragma mark--------------Saving the Order Details
//Saving the Order details
-(void)Saving_Orderitems{
    
    
    NSMutableArray *arrMultiItemOrders=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"multiitemorders"]];
    
    //UITextField *txtFieldSpecialInstructions=(UITextField*)[mainScroll viewWithTag:559];
    // Saving the Locu menu order in UserDefaults
    if (viewtype==1)
    {
        NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:[arrMultiItemOrders objectAtIndex:arrIndex]];
        if (instructionfield.text.length>0) {
            [dictItem setObject:instructionfield.text forKey:@"specialInstructions"];
            
        }else{
            [dictItem setObject:@"" forKey:@"specialInstructions"];
        }
        [dictItem setObject:@"Menu" forKey:@"ItemType"];
        [arrMultiItemOrders replaceObjectAtIndex:arrIndex withObject:dictItem];
        
        [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        appDelegate.isCmgForShowingOrderUI=YES;
        
        [dictItem release];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (viewtype==2){
        // Saving the Locu Mixed Drink menu order in UserDefaults & showing on popup
        
        NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]init];
        
        float totalPrice = 0.0;
        NSMutableString *str_opt_description =[[NSMutableString alloc]init];

        for (NSDictionary *dictTemp in arrCustomDrinks) {
            
            if (![dictTemp valueForKey:@"options"]) {
                
                [dictItem setObject:arrCustomDrinks forKey:@"ArrayInfo"];

                NSArray *arrTemp=[dictTemp valueForKey:@"option_groups"];
                NSArray *filterarr=[[arrTemp valueForKey:@"options"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(selected == %@)",[NSNumber numberWithBool:true]]];

                for (NSDictionary *dict1Temp in filterarr)
                {
                    totalPrice+=[[dict1Temp valueForKey:@"price"] floatValue];
                    [str_opt_description appendFormat:@"%@,",[dict1Temp valueForKey:@"name"]];
                }
                [dictItem setObject:[dictTemp valueForKey:@"name"] forKey:@"name"];
                
            }else{
                NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:[dictTemp objectForKey:@"options"]];
                NSArray *filterarr=[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(selected == %@)",[NSNumber numberWithBool:true]]];
                
                for (NSDictionary *dictTemp in filterarr)
                {
                    
                    totalPrice+=[[dictTemp valueForKey:@"price"] floatValue];
                    [str_opt_description appendFormat:@"%@,",[dictTemp valueForKey:@"name"]];
                   
                }
                [arrTemp release];
            }
        }
       
        if ([str_opt_description length]>1) {
            [str_opt_description deleteCharactersInRange:NSMakeRange([str_opt_description length]-1, 1)];
        }
        [dictItem setObject:str_opt_description forKey:@"options_description"];
        [dictItem setObject:[NSNumber numberWithInt:2] forKey:@"Viewtype"];
        [dictItem setObject:[NSString stringWithFormat:@"%.2f",totalPrice] forKey:@"price"];

        if (instructionfield.text.length>0) {
            [dictItem setObject:instructionfield.text forKey:@"specialInstructions"];
        }else{
            [dictItem setObject:@"" forKey:@"specialInstructions"];
        }
        [dictItem setObject:@"Menu" forKey:@"ItemType"];
        if (!isEdit) {
            [arrMultiItemOrders addObject:dictItem];

        }else
            [arrMultiItemOrders replaceObjectAtIndex:arrIndex withObject:dictItem];
        
        if (totalPrice==0.0 ) {
            
            [dictItem release];
            [str_opt_description release];
            return;
        }
        [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        appDelegate.isCmgForShowingOrderUI=YES;
        
        [dictItem release];
        [str_opt_description release];
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(viewtype==4){
        NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]init];
        
        float totalPrice = 0.0;
        NSMutableString *str_opt_description =[[NSMutableString alloc]init];
        
        for (int x=0;x<arrCustomDrinks.count;x++) {
            
            NSDictionary *dictTemp =[arrCustomDrinks objectAtIndex:x];
            if (x==0) {
                [dictItem setObject:[dictTemp valueForKey:@"text"] forKey:@"name"];
                [dictItem setObject:arrCustomDrinks forKey:@"ArrayInfo"];

            }
                NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:[dictTemp objectForKey:@"options"]];
                NSArray *filterarr=[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(selected == %@)",[NSNumber numberWithBool:true]]];
                
                for (NSDictionary *dictTemp in filterarr)
                {
                    
                    totalPrice+=[[dictTemp valueForKey:@"price"] floatValue];
                    [str_opt_description appendFormat:@"%@,",[dictTemp valueForKey:@"name"]];
                    
                }
                [arrTemp release];
        }
       
        if ([str_opt_description length]>1) {
            [str_opt_description deleteCharactersInRange:NSMakeRange([str_opt_description length]-1, 1)];
        }
        [dictItem setObject:str_opt_description forKey:@"options_description"];
        [dictItem setObject:[NSNumber numberWithInt:4] forKey:@"Viewtype"];
        [dictItem setObject:[NSString stringWithFormat:@"%.2f",totalPrice] forKey:@"price"];
        
        if (instructionfield.text.length>0) {
            [dictItem setObject:instructionfield.text forKey:@"specialInstructions"];
            
        }else{
            [dictItem setObject:@"" forKey:@"specialInstructions"];
            
        }
        [dictItem setObject:@"Menu" forKey:@"ItemType"];
    //Checking for edit oder or new order
        if (!isEdit) {
            [arrMultiItemOrders addObject:dictItem];
        }else
            [arrMultiItemOrders replaceObjectAtIndex:arrIndex withObject:dictItem];
        
        if (totalPrice==0.0 ) {
            
            [dictItem release];
            [str_opt_description release];
            return;
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        appDelegate.isCmgForShowingOrderUI=YES;
    
        [dictItem release];
        [str_opt_description release];
        [self.navigationController popViewControllerAnimated:YES];

    }else if (viewtype==3){
        
        NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]init];
        
        float totalPrice = 0.0;
        NSMutableString *str_opt_description =[[NSMutableString alloc]init];
        
        for (int x=0;x<arrCustomDrinks.count;x++) {
            NSDictionary *dictTemp =[arrCustomDrinks objectAtIndex:x];
            if (x==0) {
                [dictItem setObject:[dictTemp valueForKey:@"name"] forKey:@"name"];
                
                [dictItem setObject:[dictTemp valueForKey:@"description"] forKey:@"description"];
                [dictItem setObject:arrCustomDrinks forKey:@"ArrayInfo"];
                
            }
                NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:[dictTemp objectForKey:@"options"]];
                NSArray *filterarr=[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(selected == %@)",[NSNumber numberWithBool:true]]];
                
                for (NSDictionary *dictTemp in filterarr)
                {
                    
                    totalPrice+=[[dictTemp valueForKey:@"price"] floatValue];
                    [str_opt_description appendFormat:@"%@,",[dictTemp valueForKey:@"name"]];
                    
                }
            
                [arrTemp release];
        }
        if (str_opt_description.length>1) {
            [str_opt_description deleteCharactersInRange:NSMakeRange([str_opt_description length]-1, 1)];
        }
        //[dictItem setObject:itemdescription forKey:@"name"];
        [dictItem setObject:str_opt_description forKey:@"options_description"];
        [dictItem setObject:[NSNumber numberWithInt:3] forKey:@"Viewtype"];
        [dictItem setObject:[NSString stringWithFormat:@"%.2f",totalPrice] forKey:@"price"];
        
        if (instructionfield.text.length>0) {
            [dictItem setObject:instructionfield.text forKey:@"specialInstructions"];
            
        }else{
            [dictItem setObject:@"" forKey:@"specialInstructions"];
            
        }
        [dictItem setObject:@"Menu" forKey:@"ItemType"];
        
        if (!isEdit)
            [arrMultiItemOrders addObject:dictItem];
        else
            [arrMultiItemOrders replaceObjectAtIndex:arrIndex withObject:dictItem];
        
        if (totalPrice==0.0 ) {
            
            [dictItem release];
            [str_opt_description release];
            return;
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:arrMultiItemOrders forKey:@"multiitemorders"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        appDelegate.isCmgForShowingOrderUI=YES;
       
        [dictItem release];
        [str_opt_description release];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    [arrMultiItemOrders release];

}

//Saving the favorite
-(void)SavingFavorites{
    
   // UITextField *txtFieldSpecialInstructions=(UITextField*)[mainScroll viewWithTag:559];

    NSMutableArray *arritemlist=[[NSMutableArray alloc]init];
    
        
        if (viewtype==1 ) {
            
          for (NSDictionary *dictTemp in arrCustomDrinks) {  
            NSMutableDictionary *dictitemlist=[[NSMutableDictionary alloc]init];
            NSArray *tempArray=[[NSArray alloc]init];
            [dictitemlist setObject:[dictTemp valueForKey:@"name"] forKey:@"itemName"];
            [dictitemlist setObject:[NSString stringWithFormat:@"%@",[dictTemp valueForKey:@"price"]] forKey:@"price"];
            [dictitemlist setObject:@"1" forKey:@"quantity"];
              if ([dictTemp valueForKey:@"id"]) {
                  [dictitemlist setObject:[dictTemp valueForKey:@"id"] forKey:@"itemId"];

              }else{
                  [dictitemlist setObject:@"" forKey:@"itemId"];
              }
            [dictitemlist setObject:[dictTemp valueForKey:@"name"] forKey:@"title"];
            if ([dictTemp valueForKey:@"description"] && ![[dictTemp valueForKey:@"description"] isKindOfClass:[NSNull class]]) {
                [dictitemlist setObject:[dictTemp valueForKey:@"description"] forKey:@"description"];
            }else{
                [dictitemlist setObject:@"" forKey:@"description"];
            }
            if ([dictTemp valueForKey:@"category"]) {
                [dictitemlist setObject:[dictTemp valueForKey:@"category"] forKey:@"category"];
            }
            if ([dictTemp valueForKey:@"instructions"]) {
                [dictitemlist setObject:[dictTemp valueForKey:@"instructions"] forKey:@"instructions"];
            }
            if ([dictTemp valueForKey:@"ingredients"]) {
                [dictitemlist setObject:[dictTemp valueForKey:@"ingredients"] forKey:@"ingredients"];
            }
              if ([dictTemp valueForKey:@"type"]) {
                  [dictitemlist setObject:[dictTemp valueForKey:@"type"] forKey:@"type"];
                  
              }
            [dictitemlist setObject:[NSString stringWithFormat:@"%@",[dictTemp valueForKey:@"price"]] forKey:@"order_price"];
            [dictitemlist setObject:tempArray forKey:@"option_groups"];
              if ([instructionfield.text length]>0) {
                  [dictitemlist setObject:instructionfield.text forKey:@"special_instructions"];

              }else
                  [dictitemlist setObject:@"" forKey:@"special_instructions"];

            [arritemlist addObject:dictitemlist];
            [dictitemlist release];
            [tempArray release];
          }
        }else if (viewtype==2){
            NSMutableArray *arrOptionGroup=[[NSMutableArray alloc]init];
            NSMutableDictionary *dictItemList=[[NSMutableDictionary alloc]init];
            NSMutableString *str_opt_description =[[NSMutableString alloc]init];

            float order_Price=0.0;
            for (int i=0;i<arrCustomDrinks.count;i++) {
                NSDictionary *dictTemp =[arrCustomDrinks objectAtIndex:i];
           /* NSMutableArray *arrTemp;NSArray *filterarr;
            if ([dictTemp objectForKey:@"option_groups"]) {
                //arrTemp=[[NSMutableArray alloc]initWithArray:[dictTemp objectForKey:@"option_groups"]];
               // NSArray *array2temp=[arrTemp objectAtIndex:0];
                //arrTemp=[[NSMutableArray alloc]initWithArray:[array2temp valueForKey:@"options"]];
                //filterarr=[[array2temp valueForKey:@"options"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
            }else{
            //arrTemp=[[NSMutableArray alloc]initWithArray:[dictTemp objectForKey:@"options"]];
            //filterarr=[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
            }*/
                //NSMutableDictionary *dictitem=[[NSMutableDictionary alloc]init];
           
    
                if ([dictTemp valueForKey:@"option_groups"]) {
                    
                    [dictItemList setObject:[dictTemp valueForKey:@"name"] forKey:@"name"];

                    
                   // [dictitem setObject:[dictTemp valueForKey:@"name"] forKey:@"title"];
                  //  [dictitem setObject:[dictTemp valueForKey:@"name"] forKey:@"itemName"];
                    if ([dictTemp valueForKey:@"price"]) {
                       // [dictitem setObject:[dictTemp valueForKey:@"price"] forKey:@"price"];
                        
                    }else{
                       // [dictitem setObject:@"0.0" forKey:@"price"];
                        
                    }
                    NSArray *arroptionsgrp=[dictTemp valueForKey:@"option_groups"];
                    
                    NSMutableDictionary *dictOptionItems=[[NSMutableDictionary alloc]init];
                    NSMutableArray *arrOptions=[[NSMutableArray alloc]init];
                    NSArray *arroptionTemp=[arroptionsgrp valueForKey:@"options"];
                    for (int k=0; k<arroptionTemp.count; k++) {
                        NSDictionary *dict3Temp=[arroptionTemp objectAtIndex:k];
                        NSMutableDictionary *dictsubItems=[[NSMutableDictionary alloc]init];
                        [dictsubItems setObject:[dict3Temp valueForKey:@"name"] forKey:@"name"];
                        [dictsubItems setObject:[dict3Temp valueForKey:@"price"] forKey:@"price"];
                        if ([[dict3Temp valueForKey:@"selected"] integerValue]==1 && [dict3Temp valueForKey:@"selected"]) {
                            order_Price+=[[dict3Temp valueForKey:@"price"] floatValue];
                            [str_opt_description appendFormat:@"%@,",[dict3Temp valueForKey:@"name"]];

                            [dictsubItems setObject:@"true" forKey:@"selected"];
                            
                        }else{
                            [dictsubItems setObject:@"false" forKey:@"selected"];
                            
                        }
                        
                        [arrOptions addObject:dictsubItems];
                        [dictsubItems release];
                        
                    }
                    [dictOptionItems setObject:[arroptionsgrp valueForKey:@"type"] forKey:@"type"];
                    [dictOptionItems setObject:[arroptionsgrp valueForKey:@"text"] forKey:@"text"];
                    [dictOptionItems setObject:arrOptions forKey:@"options"];
                    [arrOptionGroup addObject:dictOptionItems];
                    [arrOptions release];
                    [dictOptionItems release];
                } else {
                    NSMutableDictionary *dictOptionItems=[[NSMutableDictionary alloc]init];
                    NSMutableArray *arrOptions=[[NSMutableArray alloc]init];
                    NSArray *arroptionTemp=[dictTemp valueForKey:@"options"];
                    for (int k=0; k<arroptionTemp.count; k++) {
                        NSDictionary *dict3Temp=[arroptionTemp objectAtIndex:k];
                        NSMutableDictionary *dictsubItems=[[NSMutableDictionary alloc]init];
                        [dictsubItems setObject:[dict3Temp valueForKey:@"name"] forKey:@"name"];
                        if ([dict3Temp valueForKey:@"price"]) {
                            [dictsubItems setObject:[dict3Temp valueForKey:@"price"] forKey:@"price"];
                            
                        }else{
                            [dictsubItems setObject:@"0" forKey:@"price"];
                        }
                        if ([[dict3Temp valueForKey:@"selected"] integerValue]==1 && [dict3Temp valueForKey:@"selected"]) {
                            order_Price+=[[dict3Temp valueForKey:@"price"] floatValue];
                            [str_opt_description appendFormat:@"%@,",[dict3Temp valueForKey:@"name"]];

                            [dictsubItems setObject:@"true" forKey:@"selected"];
                            
                        }else{
                            [dictsubItems setObject:@"false" forKey:@"selected"];
                            
                        }
                        
                        [arrOptions addObject:dictsubItems];
                        [dictsubItems release];
                        
                    }
                    [dictOptionItems setObject:[dictTemp valueForKey:@"type"] forKey:@"type"];
                    [dictOptionItems setObject:[dictTemp valueForKey:@"text"] forKey:@"text"];
                    [dictOptionItems setObject:arrOptions forKey:@"options"];
                    [arrOptionGroup addObject:dictOptionItems];
                    [dictOptionItems release];
                    [arrOptions release];
                }
                
            }
            if (str_opt_description.length>1) {
                [str_opt_description deleteCharactersInRange:NSMakeRange([str_opt_description length]-1, 1)];
            }
            NSString *strsplInst;
            if ([instructionfield.text length]>0) {
                strsplInst=instructionfield.text;
            }else{
                strsplInst=@"";
            }
            [dictItemList setObject:strsplInst forKey:@"special_instructions"];
            [dictItemList setObject:str_opt_description forKey:@"options_description"];
            [dictItemList setObject:arrOptionGroup forKey:@"option_groups"];
            [dictItemList setObject:@"ITEM" forKey:@"type"];
            [dictItemList setObject:@"1" forKey:@"quantity"];
            [dictItemList setObject:[NSString stringWithFormat:@"%.2f",order_Price] forKey:@"order_price"];
            [arritemlist addObject:dictItemList];
            [arrOptionGroup release];
            [dictItemList release];
            NSLog(@"%@",arritemlist);
        }else if (viewtype==3){
            NSMutableArray *arrOptionGroup=[[NSMutableArray alloc]init];
            NSMutableDictionary *dictItemList=[[NSMutableDictionary alloc]init];
            NSMutableString *str_opt_description =[[NSMutableString alloc]init];
            float order_Price=0.0;
            for (int i=0;i<arrCustomDrinks.count;i++) {
                NSDictionary *dictTemp =[arrCustomDrinks objectAtIndex:i];
                
                NSMutableDictionary *dictOptionItems=[[NSMutableDictionary alloc]init];
                NSMutableArray *arrOptions=[[NSMutableArray alloc]init];
                NSArray *arroptionTemp=[dictTemp valueForKey:@"options"];
                for (int k=0; k<arroptionTemp.count; k++) {
                    NSDictionary *dict3Temp=[arroptionTemp objectAtIndex:k];
                    NSMutableDictionary *dictsubItems=[[NSMutableDictionary alloc]init];
                    [dictsubItems setObject:[dict3Temp valueForKey:@"name"] forKey:@"name"];
                    if ([dict3Temp valueForKey:@"price"]) {
                        [dictsubItems setObject:[dict3Temp valueForKey:@"price"] forKey:@"price"];
                    }else{
                        [dictsubItems setObject:@"0" forKey:@"price"];
                    }
                    if ([[dict3Temp valueForKey:@"selected"] integerValue]==1 && [dict3Temp valueForKey:@"selected"]) {
                        order_Price+=[[dict3Temp valueForKey:@"price"] floatValue];
                        [str_opt_description appendFormat:@"%@,",[dict3Temp valueForKey:@"name"]];
                        [dictsubItems setObject:@"true" forKey:@"selected"];
                        
                    }else{
                        [dictsubItems setObject:@"false" forKey:@"selected"];
                        
                    }
                    
                    [arrOptions addObject:dictsubItems];
                    [dictsubItems release];
                    
                }
                [dictOptionItems setObject:[dictTemp valueForKey:@"type"] forKey:@"type"];
                [dictOptionItems setObject:[dictTemp valueForKey:@"text"] forKey:@"text"];
                [dictOptionItems setObject:arrOptions forKey:@"options"];
                [arrOptionGroup addObject:dictOptionItems];
                [arrOptions release];
                [dictOptionItems release];

            }
            if (str_opt_description.length>1) {
                [str_opt_description deleteCharactersInRange:NSMakeRange([str_opt_description length]-1, 1)];
            }
            NSString *strsplInst;
            if ([instructionfield.text length]>0) {
                strsplInst=instructionfield.text;
            }else{
                strsplInst=@"";
            }
            [dictItemList setObject:strsplInst forKey:@"special_instructions"];
            [dictItemList setObject:str_opt_description forKey:@"options_description"];
            [dictItemList setObject:arrOptionGroup forKey:@"option_groups"];
            [dictItemList setObject:@"ITEM" forKey:@"type"];
            [dictItemList setObject:@"1" forKey:@"quantity"];
            [dictItemList setObject:[NSString stringWithFormat:@"%.2f",order_Price] forKey:@"order_price"];
            [arritemlist addObject:dictItemList];
            [arrOptionGroup release];
            [dictItemList release];
            NSLog(@"%@",arritemlist);
        }else if (viewtype==4){
            NSMutableArray *arrOptionGroup=[[NSMutableArray alloc]init];
            NSMutableDictionary *dictItemList=[[NSMutableDictionary alloc]init];
            NSMutableString *str_opt_description =[[NSMutableString alloc]init];

            float order_Price=0.0;
            for (int i=0;i<arrCustomDrinks.count;i++) {
                NSDictionary *dictTemp =[arrCustomDrinks objectAtIndex:i];
                
                NSMutableDictionary *dictOptionItems=[[NSMutableDictionary alloc]init];
                NSMutableArray *arrOptions=[[NSMutableArray alloc]init];
                NSArray *arroptionTemp=[dictTemp valueForKey:@"options"];
                for (int k=0; k<arroptionTemp.count; k++) {
                    NSDictionary *dict3Temp=[arroptionTemp objectAtIndex:k];
                    NSMutableDictionary *dictsubItems=[[NSMutableDictionary alloc]init];
                    [dictsubItems setObject:[dict3Temp valueForKey:@"name"] forKey:@"name"];
                    if ([dict3Temp valueForKey:@"price"]) {
                        [dictsubItems setObject:[dict3Temp valueForKey:@"price"] forKey:@"price"];
                        
                    }else{
                        [dictsubItems setObject:@"0" forKey:@"price"];
                    }
                    if ([[dict3Temp valueForKey:@"selected"] integerValue]==1 && [dict3Temp valueForKey:@"selected"]) {
                        order_Price+=[[dict3Temp valueForKey:@"price"] floatValue];
                        [str_opt_description appendFormat:@"%@,",[dict3Temp valueForKey:@"name"]];
                        [dictsubItems setObject:@"true" forKey:@"selected"];
                        
                    }else{
                        [dictsubItems setObject:@"false" forKey:@"selected"];
                        
                    }
                    
                    [arrOptions addObject:dictsubItems];
                    [dictsubItems release];
                    
                }
                
                [dictOptionItems setObject:[dictTemp valueForKey:@"type"] forKey:@"type"];
                [dictOptionItems setObject:[dictTemp valueForKey:@"text"] forKey:@"text"];
                [dictOptionItems setObject:arrOptions forKey:@"options"];
                [arrOptionGroup addObject:dictOptionItems];
                [arrOptions release];
                [dictOptionItems release];
                
            }
            if (str_opt_description.length>1) {
                [str_opt_description deleteCharactersInRange:NSMakeRange([str_opt_description length]-1, 1)];
            }
            NSString *strsplInst;
            if ([instructionfield.text length]>0) {
                strsplInst=instructionfield.text;
            }else{
                strsplInst=@"";
            }
            [dictItemList setObject:strsplInst forKey:@"special_instructions"];
            [dictItemList setObject:str_opt_description forKey:@"options_description"];
            [dictItemList setObject:arrOptionGroup forKey:@"option_groups"];
            [dictItemList setObject:@"ITEM" forKey:@"type"];
            [dictItemList setObject:@"1" forKey:@"quantity"];
            [dictItemList setObject:[NSString stringWithFormat:@"%.2f",order_Price] forKey:@"order_price"];
            [arritemlist addObject:dictItemList];
            [arrOptionGroup release];
            [dictItemList release];
            NSLog(@"%@",arritemlist);
        }
    
    
    
    NSString *strDescription;
    if ([instructionfield.text length]>0) {
        strDescription=instructionfield.text;
    }else{
        strDescription=@"";
    }
    isSaveFavorite=YES;
    [self createProgressViewToParentView:self.view withTitle:@"Saving your favorite drink..."];
    [self.sharedController saveFavoriteDrinkbyvenueID:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] bartsyID:[[NSUserDefaults standardUserDefaults]objectForKey:@"bartsyId"] description:strDescription specialinstruction:@"" itemlist:arritemlist delegate:self];
    [arritemlist release];
    
}
/*
-(void)Reset_Selection:(int)section{
        id dict=[arrCustomDrinks objectAtIndex:section];
        if ([dict valueForKey:@"option_groups"]) {
            NSMutableArray *subitemArray=[[arrCustomDrinks objectAtIndex:section] valueForKey:@"option_groups"];
            NSArray *arrytemp=[[NSMutableArray alloc]initWithArray:[subitemArray valueForKey:@"options"]];
            
            // NSMutableArray *arrytemp=[[NSMutableArray alloc]initWithArray:[subitemArray objectForKey:@"options"]];
            NSArray *filterarr=[arrytemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
            
            for (int i=0;i<[filterarr count];i++)
            {
                NSMutableDictionary *dict1Temp=[filterarr objectAtIndex:i];
                [dict1Temp setObject:@"0" forKey:@"Selected"];
            }
            [arrytemp release];
            [arrytemp release];
        }else{
            
            NSMutableArray *arrTemp=[dict objectForKey:@"options"];
            NSMutableArray *filterarr=(NSMutableArray*)[arrTemp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Selected == %@)",@"1"]];
            for (NSMutableDictionary *dictTemp in filterarr)
            {
                [dictTemp setObject:@"0" forKey:@"Selected"];
            }
            [arrTemp release];
        }
}*/

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
                    if (viewtype==1 ){
                        
                        if ([[dictContent valueForKey:@"name"] isEqualToString:[dictitemdetails valueForKey:@"name"] ]) {
                            
                            favoriteID=[[dictContent valueForKey:@"favorite_id"] integerValue];
                            UIButton *btnFav=(UIButton*)[mainScroll viewWithTag:557];
                            btnFav.selected=YES;
                        }
                    }else if (viewtype==2){
                        
                        for (int x=0;x<arrCustomDrinks.count; x++) {
                            if ([[dictContent valueForKey:@"name"] isEqualToString:[[arrCustomDrinks objectAtIndex:x] valueForKey:@"name"] ]) {
                                
                                favoriteID=[[dictContent valueForKey:@"FavID"] integerValue];
                                UIButton *btnFav=(UIButton*)[mainScroll viewWithTag:557];
                                btnFav.selected=YES;
                                
                            }
 
                        }
                    }else if (viewtype==4){
                        
                        for (int x=0;x<arrCustomDrinks.count; x++) {
                            if ([[dictContent valueForKey:@"name"] isEqualToString:[[arrCustomDrinks objectAtIndex:x] valueForKey:@"text"] ]) {
                                
                                favoriteID=[[dictContent valueForKey:@"favorite_id"] integerValue];
                                UIButton *btnFav=(UIButton*)[mainScroll viewWithTag:557];
                                btnFav.selected=YES;
                                NSLog(@"%d",favoriteID);
                            }
                        }

                    }else if (viewtype==3){
                        
                        for (int x=0;x<arrCustomDrinks.count; x++) {
                            if ([[dictContent valueForKey:@"name"] isEqualToString:[[arrCustomDrinks objectAtIndex:x] valueForKey:@"name"] ]) {
                                
                                favoriteID=[[dictContent valueForKey:@"favorite_id"] integerValue];
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
        
}
#pragma mark------------Webservice Delegates
-(void)controllerDidFinishLoadingWithResult:(id)result
{
    [self hideProgressView:nil];
    if (isSaveFavorite) {
        
        isSaveFavorite=NO;
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
        
        isDeleteFavorite=NO;
        
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
    if (viewtype==1) {
        [scrollview setContentOffset:CGPointMake(0, textField.frame.origin.y-90)];
    }else{
        [scrollview setContentOffset:CGPointMake(0, textField.frame.origin.y+60)];
    }
    
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
    [arrayEditInfo release];
    [arrCustomDrinks release];
    [mainScroll release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
