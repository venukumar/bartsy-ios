//
//  BaseViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 26/04/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
}

-(UIButton*)createUIButtonWithTitle:(NSString*)strTitle image:(UIImage*)image frame:(CGRect)frame tag:(NSInteger)intTag selector:(SEL)btnSelector target:(id)target
{
    UIButton *btnCustom=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCustom setTitle:strTitle forState:UIControlStateNormal];
    [btnCustom setBackgroundImage:image forState:UIControlStateNormal];
    [btnCustom addTarget:target action:btnSelector forControlEvents:UIControlEventTouchUpInside];
    btnCustom.tag=intTag;
    btnCustom.frame=frame;
    btnCustom.backgroundColor=[UIColor clearColor];
    return btnCustom;
}

-(UILabel*)createLabelWithTitle:(NSString*)strTitle frame:(CGRect)frame tag:(NSInteger)intTag font:(UIFont*)font color:(UIColor*)color numberOfLines:(NSInteger)intNoOflines
{
    UILabel *lbl=[[[UILabel alloc]initWithFrame:frame] autorelease];
    lbl.text=strTitle;
    lbl.font=font;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.textColor=color;
    lbl.numberOfLines=intNoOflines;
    return lbl;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
