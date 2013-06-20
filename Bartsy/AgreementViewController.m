//
//  AgreementViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 20/06/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "AgreementViewController.h"
#import "WebViewController.h"
@interface AgreementViewController ()

@end

@implementation AgreementViewController

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
	// Do any additional setup after loading the view.
    self.title=@"User Acceptance";
    
    isSelected=NO;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    arrAgreements=[[NSArray alloc]initWithObjects:@"Bartsy Beta Participant Agreement - 2013-06-11",@"Bartsy EULA - 2013-06-16",@"Bartsy Terms of Use - 2013-06-11",@"Bartsy Privacy Policy - 2013-06-11", nil];
    
    UILabel *lblMsg=[self createLabelWithTitle:@"Please confirm that you have read and understand the following agreements:" frame:CGRectMake(0, 10, 320, 40) tag:0 font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] numberOfLines:2];
    lblMsg.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblMsg];
    
    UIButton *btnAgreement1=[self createUIButtonWithTitle:@"Beta Participant Agreement ->" image:nil frame:CGRectMake(30, 80, 260, 40) tag:111 selector:@selector(btnBeta_TouchUpInside:) target:self];
    btnAgreement1.titleLabel.font=[UIFont systemFontOfSize:18];
    btnAgreement1.titleLabel.textColor=[UIColor blackColor];
    btnAgreement1.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:btnAgreement1];
    

    UIButton *btnAgreement2=[self createUIButtonWithTitle:@"End User Licence Agreement ->" image:nil frame:CGRectMake(30, 140, 260, 40) tag:222 selector:@selector(btnBeta_TouchUpInside:) target:self];
    btnAgreement2.titleLabel.font=[UIFont systemFontOfSize:18];
    btnAgreement2.titleLabel.textColor=[UIColor blackColor];
    btnAgreement2.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:btnAgreement2];
    
    UIButton *btnAgreement3=[self createUIButtonWithTitle:@"Terms of Use ->" image:nil frame:CGRectMake(30, 200, 260, 40) tag:333 selector:@selector(btnBeta_TouchUpInside:) target:self];
    btnAgreement3.titleLabel.font=[UIFont systemFontOfSize:18];
    btnAgreement3.titleLabel.textColor=[UIColor blackColor];
    btnAgreement3.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:btnAgreement3];
    
    UIButton *btnAgreement4=[self createUIButtonWithTitle:@"Privacy Policy ->" image:nil frame:CGRectMake(30, 260, 260, 40) tag:444 selector:@selector(btnBeta_TouchUpInside:) target:self];
    btnAgreement4.titleLabel.font=[UIFont systemFontOfSize:18];
    btnAgreement4.titleLabel.textColor=[UIColor blackColor];
    btnAgreement4.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:btnAgreement4];
    
    UIButton *btnCheckbox=[self createUIButtonWithTitle:@"" image:[UIImage imageNamed:@"uncheck.png"] frame:CGRectMake(10, 325, 20, 20) tag:0 selector:@selector(btnCheckbox_TouchUpInside:) target:self];
    [self.view addSubview:btnCheckbox];
    
    UILabel *lblProfile=[self createLabelWithTitle:@"By checking this box I verify that I have read and agree to be bound by the above agreements." frame:CGRectMake(40, 320, 260, 60) tag:0 font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] numberOfLines:3];
    lblProfile.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:lblProfile];
    

    
    UIButton *btnCancel=[self createUIButtonWithTitle:@"Quit" image:nil frame:CGRectMake(40, 400, 100, 40) tag:0 selector:@selector(btnCancel_TouchUpInside) target:self];
    btnCancel.titleLabel.font=[UIFont systemFontOfSize:18];
    btnCancel.titleLabel.textColor=[UIColor blackColor];
    btnCancel.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:btnCancel];
    
    UIButton *btnAccept=[self createUIButtonWithTitle:@"Accept" image:nil frame:CGRectMake(180, 400, 100, 40) tag:143225 selector:@selector(btnAccept_TouchUpInside) target:self];
    btnAccept.enabled=NO;
    btnAccept.titleLabel.font=[UIFont systemFontOfSize:18];
    [btnAccept setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    btnAccept.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:btnAccept];
    
}

-(void)btnCancel_TouchUpInside
{
    exit(0);
}

-(void)btnCheckbox_TouchUpInside:(UIButton*)sender
{
    isSelected=!isSelected;
    
    UIButton *btnAccept=(UIButton*)[self.view viewWithTag:143225];
    if(isSelected)
    {
        [sender setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        btnAccept.enabled=YES;
        [btnAccept setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnAccept setTitle:@"Accept" forState:UIControlStateNormal];
        btnAccept.backgroundColor=[UIColor lightGrayColor];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        btnAccept.enabled=NO;
        [btnAccept setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];

    }
}

-(void)btnAccept_TouchUpInside
{
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isNDAAccepted"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)btnBeta_TouchUpInside:(UIButton*)sender
{
    WebViewController *obj=[[WebViewController alloc]init];
    obj.strTitle=[NSString stringWithFormat:@"%@",sender.titleLabel.text];
    obj.strHTMLPath=[NSString stringWithFormat:@"%i",sender.tag/111];
    [self.navigationController pushViewController:obj animated:YES];
    [obj release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
