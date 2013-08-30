//
//  UserSettingsView.m
//  Bartsy
//
//  Created by Techvedika on 8/22/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "UserSettingsView.h"

@interface UserSettingsView ()

@end

@implementation UserSettingsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [tableview reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden=YES;
    
    
    tblArray_Obj = [[NSMutableArray alloc] init];
    
    [tblArray_Obj insertObject:[NSMutableArray arrayWithObjects:@"View Profile",@"Edit Profile",@"Payment Information",nil] atIndex:0];
    [tblArray_Obj insertObject:[NSMutableArray arrayWithObjects:@"Past Orders",@"Favorites",@"Notification",nil] atIndex:1];
    [tblArray_Obj insertObject:[NSMutableArray arrayWithObjects:@"Share Settings",@"Push Notification",@"Log Out",nil] atIndex:2];
    [tblArray_Obj insertObject:[NSMutableArray arrayWithObjects:@"About",@"Privacy Policy",@"Terms of Service",nil] atIndex:3];
    
   
}


#pragma mark-------------TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [tblArray_Obj count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
        
        return [[tblArray_Obj objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.

        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sectionBg.png"]];
        cell.backgroundView = bg;
        [bg release];
        UIImageView *imgViewArrow=[[UIImageView alloc] initWithFrame:CGRectMake(268, 15, 13, 20)];
        UIImage *imgArrow = [UIImage imageNamed:@"listarrow.png"];
        imgViewArrow.image=imgArrow;
        cell.accessoryView=imgViewArrow;
        [imgViewArrow release];
        //cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor darkGrayColor];
        cell.selectedBackgroundView = bgColorView;
        [bgColorView release];
    }

   
    cell.textLabel.text=[[tblArray_Obj objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
    cell.textLabel.font=[UIFont fontWithName:@"MuseoSans-300" size:15.0];

    return cell;
}

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            
            AccountInfoViewController *profileView=[[AccountInfoViewController alloc]initWithNibName:@"AccountInfoViewController" bundle:nil];
            [self.navigationController pushViewController:profileView animated:NO];
        }else if (indexPath.row==1){
            
                appDelegate.isLoginForFB=NO;
               /* ProfileViewController *profileScreen=[[ProfileViewController alloc]init];
                profileScreen.isCmgFromGetStarted=NO;
                profileScreen.isCmgForEditProfile=YES;
                [self.navigationController pushViewController:profileScreen animated:YES];
                [profileScreen release];*/
            UserProfileViewController *pview=[[UserProfileViewController alloc]initWithNibName:@"UserProfileViewController" bundle:nil];
            [self.navigationController pushViewController:pview animated:NO];
        
        }else if (indexPath.row==2){
            
            PaymentEditView *pView=[[PaymentEditView alloc]initWithNibName:@"PaymentEditView" bundle:nil];
            [self.navigationController pushViewController:pView animated:YES];
        }
    }else if(indexPath.section==1){
        
        if (indexPath.row==0) {
            PastOrderView *pview = [[PastOrderView alloc] init];
            [self.navigationController pushViewController:pview animated:YES];
        }else if (indexPath.row==1){
            FavouriteViewController *fview = [[FavouriteViewController alloc] init];
           
            [self.navigationController pushViewController:fview animated:YES];
        }else if (indexPath.row==2){
            
            NotificationsViewController *nview = [[NotificationsViewController alloc] init];
            nview.NotifViewType=2;
            [self.navigationController pushViewController:nview animated:YES];
        }
    }else if(indexPath.section==2){
        
        if (indexPath.row==2) {
                            
                NSDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"VenueDetails"];
                NSString *strMsg=nil;
                
                if(appDelegate.intOrderCount)
                {
                    strMsg=[NSString stringWithFormat:@"You have open orders placed at %@. If you logout they will be cancelled and you will still be charged for it.Do you want to logout from %@",[dict objectForKey:@"venueName"],[dict objectForKey:@"venueName"]];
                }
                else
                {
                    strMsg=[NSString stringWithFormat:@"Do you want to logout"];
                }
                [self createAlertViewWithTitle:@"" message:strMsg cancelBtnTitle:@"No" otherBtnTitle:@"Yes" delegate:self tag:225];

        }
        
    }else if (indexPath.section==3){
        
        if (indexPath.row==0) {
            
            
            [self createAlertViewWithTitle:@"" message:@"Version : 1.0\n Release Date :" cancelBtnTitle:nil otherBtnTitle:@"OK" delegate:self tag:0];
            
        }else if (indexPath.row==1) {
            WebViewController *obj=[[WebViewController alloc]init];
            obj.viewtype=2;
            obj.strTitle=[NSString stringWithFormat:@"%@",@"Privacy Policy"];
            obj.strHTMLPath=[NSString stringWithFormat:@"%i",3];
            [self.navigationController pushViewController:obj animated:YES];
            [obj release];
        }else if (indexPath.row==2){
            WebViewController *obj=[[WebViewController alloc]init];
            obj.viewtype=2;
            obj.strTitle=[NSString stringWithFormat:@"%@",@"Terms of Service"];
            obj.strHTMLPath=[NSString stringWithFormat:@"%i",4];
            [self.navigationController pushViewController:obj animated:YES];
            [obj release];
        }

    }
    
}

#pragma mark---------------AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==225&&buttonIndex==1)
    {
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"]!=nil)
        {
            self.sharedController=[SharedController sharedController];
            [self.sharedController checkOutAtBartsyVenueWithId:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] delegate:nil];
            
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"CheckInVenueId"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"OrdersTimedOut"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"bartsyId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"logOut" object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
