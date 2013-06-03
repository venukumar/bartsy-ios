//
//  MixerViewController.m
//  Bartsy
//
//  Created by Sudheer Palchuri on 03/06/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "MixerViewController.h"

@interface MixerViewController ()

@end

@implementation MixerViewController
@synthesize arrMixers;

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
    
    self.title=@"Mixers";
    
    UIBarButtonItem *btnContinue=[[UIBarButtonItem alloc]initWithTitle:@"Continue" style:UIBarButtonItemStylePlain target:self action:@selector(btnContinue_TouchUpInside)];
    self.navigationItem.rightBarButtonItem=btnContinue;

    NSPredicate *pred=[NSPredicate predicateWithFormat:@"available ==[c] 'true'"];
    
    [arrMixers filterUsingPredicate:pred];
    [arrMixers setValue:@"NO" forKey:@"Checked"];

    UITableView *tblView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
    tblView.dataSource=self;
    tblView.delegate=self;
    [self.view addSubview:tblView];
    [tblView release];
    
}

-(void)btnContinue_TouchUpInside
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [arrMixers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
    NSDictionary *dict=[arrMixers objectAtIndex:indexPath.row];
    cell.textLabel.textColor=[UIColor blackColor];
	cell.textLabel.text=[dict objectForKey:@"name"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"$%@",[dict objectForKey:@"price"]];
    
    if([[dict objectForKey:@"Checked"] integerValue])
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dictMixer=[arrMixers objectAtIndex:indexPath.row];
    [dictMixer setValue:[NSNumber numberWithBool:![[dictMixer objectForKey:@"Checked"] boolValue]] forKey:@"Checked"];
    
    [arrMixers replaceObjectAtIndex:indexPath.row withObject:dictMixer];
    
    [tableView reloadData];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
