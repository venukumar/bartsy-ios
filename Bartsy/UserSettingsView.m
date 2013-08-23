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
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;

        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fathers_office-bg.png"]];
        cell.backgroundView = bg;
        [bg release];
        UIImageView *imgViewArrow=[[UIImageView alloc] initWithFrame:CGRectMake(268, 15, 13, 20)];
        UIImage *imgArrow = [UIImage imageNamed:@"listarrow.png"];
        imgViewArrow.image=imgArrow;
        cell.accessoryView=imgViewArrow;
        [imgViewArrow release];
        //UIView *bgColorView = [[UIView alloc] init];
        //bgColorView.backgroundColor = [UIColor redColor];
       // bgColorView.layer.masksToBounds = YES;
       // [cell setSelectedBackgroundView:bgColorView];
        //[bgColorView release];
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
                ProfileViewController *profileScreen=[[ProfileViewController alloc]init];
                profileScreen.isCmgFromGetStarted=NO;
                profileScreen.isCmgForEditProfile=YES;
                [self.navigationController pushViewController:profileScreen animated:YES];
                [profileScreen release];
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
