//
//  CustomDrinksViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 31/05/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "CustomDrinksViewController.h"

@interface CustomDrinksViewController ()

@end

@implementation CustomDrinksViewController
@synthesize intCurrentPosition;

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
    appDelegate.delegateForCurrentViewController=self;
    
    UIBarButtonItem *btnBack=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backBtn_TouchUpInside)];
    self.navigationItem.backBarButtonItem=btnBack;
    
    arrIngridents=[[NSMutableArray alloc]init];
    arrCategories=[[NSMutableArray alloc]init];
    
    intCurrentPosition=0;
    
    self.view.backgroundColor=[UIColor blackColor];
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, 320, 353)];
    scrollView.tag=111;
    scrollView.delegate=self;
    scrollView.pagingEnabled=YES;
    [self.view addSubview:scrollView];
    [scrollView release];
     
    
    UIPageControl *pgControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 400, 320, 10)];
    pgControl.tag=222;
    [pgControl addTarget:self action:@selector(pgControl_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pgControl];
    
    self.sharedController=[SharedController sharedController];
    
    [self createProgressViewToParentView:self.view withTitle:@"Loading..."];
    [self.sharedController getIngredientsListWithVenueId:[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInVenueId"] delegate:self];
}


-(void)backBtn_TouchUpInside
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pgControl_ValueChanged:(UIPageControl*)pgControl
{
    intCurrentPosition=pgControl.currentPage;
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:111];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [scrollView setContentOffset:CGPointMake(intCurrentPosition*320, 0) animated:YES];
    [UIView commitAnimations];

}

- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
	CGPoint offset = aScrollView.contentOffset;
    UIPageControl *pgControl=(UIPageControl*)[self.view viewWithTag:222];
	pgControl.currentPage = offset.x / 320.0f;
}

-(void)loadScreenWithCategories
{    
    self.navigationItem.title=[[arrIngridents objectAtIndex:0] objectForKey:@"typeName"];
    
    UIScrollView *scrollView=(UIScrollView*)[self.view viewWithTag:111];
    scrollView.contentSize=CGSizeMake(320*[arrCategories count], 340);
    scrollView.scrollEnabled=YES;
    
    UIPageControl *pgControl=(UIPageControl*)[self.view viewWithTag:222];
    pgControl.numberOfPages=[arrCategories count];
    
    for (int i=0; i<[arrCategories count]; i++)
    {
        UITableView *tblViewCategory=[[UITableView alloc]initWithFrame:CGRectMake((320*i),0, 320, 353) style:UITableViewStylePlain];
        tblViewCategory.delegate=self;
        tblViewCategory.dataSource=self;
        tblViewCategory.tag=9*(i+1);
        [scrollView addSubview:tblViewCategory];
        [tblViewCategory release];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger intTag=(tableView.tag/9)-1;
	return [[[arrCategories objectAtIndex:intTag] objectForKey:@"ingredients"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
    NSInteger intTag=(tableView.tag/9)-1;
    NSDictionary *dict=[[[arrCategories objectAtIndex:intTag] objectForKey:@"ingredients"] objectAtIndex:indexPath.row];
	cell.textLabel.text=[dict objectForKey:@"name"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"$%@",[dict objectForKey:@"price"]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)controllerDidFinishLoadingWithResult:(id)result
{
    [self hideProgressView:nil];
    
    if([[result objectForKey:@"errorCode"] integerValue]==1)
    {
        [self createAlertViewWithTitle:@"" message:[result objectForKey:@"errorMessage"] cancelBtnTitle:@"OK" otherBtnTitle:nil delegate:self tag:0];
    }
    else
    {
        [arrIngridents removeAllObjects];
        [arrIngridents addObjectsFromArray:[result objectForKey:@"ingredients"]];
        [arrCategories removeAllObjects];
        [arrCategories addObjectsFromArray:[[arrIngridents objectAtIndex:0] objectForKey:@"categories"]];
        NSLog(@"Categories is %@",arrCategories);
        
        [self loadScreenWithCategories];
        
    }
}

-(void)controllerDidFailLoadingWithError:(NSError*)error
{
    [self hideProgressView:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
