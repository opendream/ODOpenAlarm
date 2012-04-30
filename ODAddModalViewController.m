//
//  ODAddModalViewController.m
//  OpenAlarm
//
//  Created by Pirapa on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODAddModalViewController.h"
#import "ODTimeRepeatViewController.h"

@interface ODAddModalViewController ()

@end

@implementation ODAddModalViewController

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
    detailNewAlarm.delegate = self;
    detailNewAlarm.dataSource = self;

    
    
    UIBarButtonItem *backToCameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToAlarmListPage)];
    self.navigationItem.LeftBarButtonItem = backToCameraButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60.0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UILabel *leftLabel; 
    UILabel *rightLabel;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        
        
        leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        [cell addSubview:leftLabel];
       
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 10, 100, 20)];
        [cell addSubview:rightLabel];

    }
    switch (indexPath.row) {
        case 0:
            leftLabel.text = @"Repeat";
            rightLabel.text = @"Every 2 hour";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            leftLabel.text = @"Sound";
            rightLabel.text = @"Default";
            break;
        case 2:
            leftLabel.text = @"Label";
            rightLabel.text = @"Alarm!";
            break;
        case 3:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            leftLabel.text = @"Alarm Photo";
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ODTimeRepeatViewController *timeRepeat = [[ODTimeRepeatViewController alloc] init];
        [self.navigationController pushViewController:timeRepeat animated:YES];
    } else if (indexPath.row == 1) {
        ODTimeRepeatViewController *timeRepeat = [[ODTimeRepeatViewController alloc] init];
        [self.navigationController pushViewController:timeRepeat animated:YES];
    } else if (indexPath.row == 2) {
        ODTimeRepeatViewController *timeRepeat = [[ODTimeRepeatViewController alloc] init];
        [self.navigationController pushViewController:timeRepeat animated:YES];
    }
    
}





- (void)backToAlarmListPage
{
    NSLog(@"close");
    [self dismissModalViewControllerAnimated:YES];
    
}


@end
