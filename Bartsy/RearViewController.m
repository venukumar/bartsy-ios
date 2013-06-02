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

#import "RearViewController.h"

#import "RevealController.h"
#import "FrontViewController.h"
#import "MapViewController.h"

@interface RearViewController()

// Private Properties:

// Private Methods:

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;
@synthesize arrCategories,navBar;

#pragma marl - UITableView Data Source

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:1.0];
    
    arrCategories=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Categories" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CategoriesList:) name:@"Categories" object:nil];
    
    _rearTableView.frame=CGRectMake(0, 43, 320, [UIScreen mainScreen].bounds.size.height);
}

-(void)CategoriesList:(NSNotification*)notification
{
    NSDictionary *dictTemp=[[NSDictionary alloc]initWithDictionary:notification.object];
    NSArray *arrIngredients=[[NSArray alloc]initWithArray:[dictTemp objectForKey:@"ingredients"]];
    
    navBar.topItem.title=[[arrIngredients objectAtIndex:0] objectForKey:@"typeName"];
    
    [arrCategories removeAllObjects];
    [arrCategories addObjectsFromArray:[[arrIngredients objectAtIndex:0] objectForKey:@"categories"]];
    [_rearTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [arrCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
	
    NSDictionary *dict=[arrCategories objectAtIndex:indexPath.row];
    cell.textLabel.textColor=[UIColor whiteColor];
	cell.textLabel.text=[dict objectForKey:@"categoryName"];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	// Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
	RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;

	// Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
	//if (indexPath.row == 0)
	//{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
		if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[FrontViewController class]])
		{
			FrontViewController *frontViewController = [[FrontViewController alloc] init];
            frontViewController.intIndex=indexPath.row;
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
			[revealController setFrontViewController:navigationController animated:NO];
			
		}
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CategoryClicked" object:[NSNumber numberWithInteger:indexPath.row]];
			[revealController revealToggle:self];
		}
	//}
	// ... and the second row (=1) corresponds to the "MapViewController".
//	else if (indexPath.row == 1)
//	{
//		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
//		if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[MapViewController class]])
//		{
//			MapViewController *mapViewController = [[MapViewController alloc] init];
//			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
//			[revealController setFrontViewController:navigationController animated:NO];
//		}
//		// Seems the user attempts to 'switch' to exactly the same controller he came from!
//		else
//		{
//			[revealController revealToggle:self];
//		}
//	}
//	else if (indexPath.row == 2)
//	{
//		[revealController hideFrontView];
//	}
//	else if (indexPath.row == 3)
//	{
//		[revealController showFrontViewCompletely:NO];
//	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end