/* 
 
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Philip Kluz, 'zuui.org' nor the names of its contributors may 
 be used to endorse or promote products derived from this software 
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PHILIP KLUZ BE LIABLE FOR ANY DIRECT, 
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import "FrontViewController.h"
#import "AppDelegate.h"
#import "MixerViewController.h"

@interface FrontViewController()
{
    UIBarButtonItem *btnAddMixer;
}
// Private Methods:
- (IBAction)pushExample:(id)sender;

@end

@implementation FrontViewController
@synthesize intIndex;

#pragma mark - View lifecycle

/*
 * The following lines are crucial to understanding how the ZUUIRevealController works.
 *
 * In this example, the FrontViewController is contained inside of a UINavigationController.
 * And the UINavigationController is contained inside of a ZUUIRevealController. Thus the
 * following hierarchy is created:
 *
 * - ZUUIRevealController is parent of:
 * - - UINavigationController is parent of:
 * - - - FrontViewController
 *
 * If you don't want the UINavigationController in between (which is totally fine) all you need to
 * do is to adjust the if-condition below in a way to suit your needs. If the hierarchy were to look 
 * like this:
 *
 * - ZUUIRevealController is parent of:
 * - - FrontViewController
 * 
 * Without a UINavigationController in between, you'd need to change:
 * self.navigationController.parentViewController TO: self.parentViewController
 *
 * Note that self.navigationController is equal to self.parentViewController. Thus you could generalize
 * the code even more by calling self.parentViewController.parentViewController. In order to make 
 * the code easier to understand I decided to go with self.navigationController.
 *
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.delegateForCurrentViewController=self;
    
    arrCategories=[[NSMutableArray alloc]init];
    arrIngridents=[[NSMutableArray alloc]init];
    self.sharedController=[SharedController sharedController];
    
    self.view.backgroundColor=[UIColor lightGrayColor];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    [self.sharedController getIngredientsListWithVenueId:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] delegate:self];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CategoryClicked" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CategoriesClicked:) name:@"CategoryClicked" object:nil];

    
	if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
        
        UIButton *btnSlider = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
        [btnSlider addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [btnSlider setBackgroundImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
        UIBarButtonItem *barBtnSlider = [[UIBarButtonItem alloc] initWithCustomView:btnSlider];
		self.navigationItem.leftBarButtonItem =barBtnSlider;
	}
    
    UIBarButtonItem *btnHome=[[UIBarButtonItem alloc]initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(pushExample:)];
    
    btnAddMixer=[[UIBarButtonItem alloc]initWithTitle:@"Add Mixer" style:UIBarButtonItemStylePlain target:self action:@selector(addMixer)];
    btnAddMixer.enabled=NO;

    NSArray *buttonArray = [NSArray arrayWithObjects:btnHome,btnAddMixer, nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
    
    
    //self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(pushExample:)];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 2, 320, 366+50)];
    scrollView.tag = 111;
    [self.view addSubview:scrollView];
    [scrollView release];
}

-(void)addMixer
{
    MixerViewController *obj=[[MixerViewController alloc]init];
    obj.arrMixers=[[[[arrCategories objectAtIndex:1] objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"ingredients"];

    [self.navigationController pushViewController:obj animated:YES];
    [obj release];
}

-(void)loadScrollViewWithDrinks
{
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:111];
    
    if ([arrIngridents count]%2 == 0)
    {
        scrollView.contentSize=CGSizeMake(320, (([arrIngridents count]/2)+0.1)*200+10);
    }
    else
        scrollView.contentSize=CGSizeMake(320, (([arrIngridents count]/2)+1)*200+10);
    
    scrollView.scrollEnabled = YES;
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

    for (int i=0; i<[arrIngridents count]; i++)
    {
        NSDictionary *dictIngrident = [arrIngridents objectAtIndex:i];
        UIView *viewBg=[[UIView alloc]initWithFrame:CGRectMake((i%2)*160+(i%2)*2, (i/2)*200+(i/2)*2, 159, 200)];
        viewBg.backgroundColor = [UIColor blackColor];
        [scrollView addSubview:viewBg];
        
        //NSString *strimage = [[dictSubCategory objectForKey:@"product_imagepath"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIImageView *imgSub = [[UIImageView alloc] initWithFrame:CGRectMake(30, 37, 90, 90)];
        //[imgSub setImageWithURL:[NSURL URLWithString:strimage]];
        [imgSub setImage:[UIImage imageNamed:@"bottle.png"]];
        [[imgSub layer] setShadowOffset:CGSizeMake(0, 1)];
        [[imgSub layer] setShadowColor:[[UIColor blackColor] CGColor]];
        [[imgSub layer] setShadowRadius:3.0];
        [[imgSub layer] setShadowOpacity:0.8];
        [viewBg addSubview:imgSub];
        [imgSub release];
        
        UIButton *btnImag = [UIButton buttonWithType:UIButtonTypeCustom];
        btnImag.frame = CGRectMake(30,37,100,90);
        btnImag.tag = 100*(i+1);
        [btnImag addTarget:self action:@selector(btnImage_touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [viewBg addSubview:btnImag];
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(3,135,145,30)];
        lblName.font = [UIFont systemFontOfSize:13];
        lblName.numberOfLines = 2;
        lblName.textAlignment = NSTextAlignmentCenter;
        lblName.text=[dictIngrident objectForKey:@"name"];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.textColor=[UIColor whiteColor];
        [viewBg addSubview:lblName];
        [lblName release];
        
        UILabel *lblPriseCost = [[UILabel alloc] initWithFrame:CGRectMake(3,170,145,30)];
        lblPriseCost.text = [NSString stringWithFormat:@"$%@",[dictIngrident objectForKey:@"price"]];
        lblPriseCost.backgroundColor = [UIColor clearColor];
        lblPriseCost.textAlignment = NSTextAlignmentCenter;
        lblPriseCost.textColor=[UIColor whiteColor];
        [viewBg addSubview:lblPriseCost];
        [lblPriseCost release];
        
        UIButton *btnAddToCart = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAddToCart setFrame:CGRectMake(125,110,25,25)];
        btnAddToCart.tag = 9*(i+1);
        [btnAddToCart addTarget:self action:@selector(addToCart_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [btnAddToCart setBackgroundImage:[UIImage imageNamed:@"radio_btn.png"] forState:UIControlStateNormal];
        [btnAddToCart setBackgroundColor:[UIColor clearColor]];
        [viewBg addSubview:btnAddToCart];
        [viewBg release];
    }
}

-(void)btnImage_touchUpInside:(UIButton*)sender
{
    
}


-(void)addToCart_TouchUpInside:(UIButton*)sender
{
    NSInteger intTag=(sender.tag/9)-1;
    
    NSMutableDictionary *dictIngrident=[arrIngridents objectAtIndex:intTag];
    [dictIngrident setValue:[NSNumber numberWithBool:![[dictIngrident objectForKey:@"Checked"] boolValue]] forKey:@"Checked"];
    
    [arrIngridents replaceObjectAtIndex:intTag withObject:dictIngrident];

    if([[dictIngrident objectForKey:@"Checked"] boolValue])
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"radio_btn_selected.png"] forState:UIControlStateNormal]; 
    }
    else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"radio_btn.png"] forState:UIControlStateNormal];
    }
    
    NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:arrIngridents];
    [arrTemp filterUsingPredicate:[NSPredicate predicateWithFormat:@"Checked==1"]];

    if([arrTemp count])
    {
        btnAddMixer.enabled=YES;
    }
    else
    {
        btnAddMixer.enabled=NO;
    }

}

-(void)CategoriesClicked:(NSNotification*)notification
{
    intIndex=[notification.object integerValue];
    
    [arrIngridents removeAllObjects];
    
    [arrIngridents addObjectsFromArray:[[[[arrCategories objectAtIndex:0] objectForKey:@"categories"] objectAtIndex:intIndex] objectForKey:@"ingredients"]];
    
    
    
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"available ==[c] 'true'"];
    
    [arrIngridents filterUsingPredicate:pred];
    
    NSLog(@"Ingridents %@",arrIngridents);
    
    [arrIngridents setValue:@"NO" forKey:@"Checked"];
    
    self.title=[[[[arrCategories objectAtIndex:0] objectForKey:@"categories"] objectAtIndex:intIndex] objectForKey:@"categoryName"];
    
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:111];
    
    for (UIView *subview in scrollView.subviews)
    {
        [subview removeFromSuperview];
    }
    
    if([arrIngridents count])
    [self loadScrollViewWithDrinks];

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
        [arrCategories removeAllObjects];
        [arrCategories addObjectsFromArray:[result objectForKey:@"ingredients"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Categories" object:result];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CategoryClicked" object:[NSNumber numberWithInteger:0]];
    }
}

-(void)controllerDidFailLoadingWithError:(NSError*)error
{
    [self hideProgressView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Example Code

- (IBAction)pushExample:(id)sender
{
	[[NSNotificationCenter defaultCenter]postNotificationName:@"Back" object:nil];
}

@end