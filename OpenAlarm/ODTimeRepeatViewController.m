//
//  ODTimeRepeatViewController.m
//  OpenAlarm
//
//  Created by Pirapa on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODTimeRepeatViewController.h"
#import "ODAlarmServices.h"

#define DAY_SECTION 7
#define TIME_SECTION 3

@implementation ODTimeRepeatViewController

@synthesize selectedDayRepeat, selectedTimeRepeat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    repeatTimeTableView.dataSource = self;
    repeatTimeTableView.delegate = self;
    
    NSString *repeatFlag[10];
    
    for (int i=0; i< DAY_SECTION; i++)
        repeatFlag[i] = @"0";
    
    self.selectedDayRepeat = [NSMutableArray arrayWithObjects:repeatFlag count:DAY_SECTION];
    self.selectedTimeRepeat = [NSMutableArray arrayWithObjects:repeatFlag count:TIME_SECTION];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View

- (NSString *)mappingTimeStringFromRepeatChoice:(NSInteger)choice
{
    NSString *t;
    switch (choice) {
        case 0:
            t = @"1 Minute";
            break;
        case 1:
            t = @"2 Minutes";
            break;
        case 2:
            t = @"1 Hour";
            break;
        default:
            t = @"Unknown";
            break;
    }
    return t;
}

- (NSString *)mappingDayStringFromRepeatChoice:(NSInteger)choice
{
    NSString *t;
    switch (choice) {
        case 99:
            t = @"Every 2 minute";
            break;
        case 98:
            t = @"Every Weekday";
            break;
        case 97:
            t = @"Every Weekend";
            break;
        case 0:
            t = @"Every Sunday";
            break;
        case 1:
            t = @"Every Monday";
            break;
        case 2:
            t = @"Every Tuesday";
            break;
        case 3:
            t = @"Every Wednesday";
            break;
        case 4:
            t = @"Every Thursday";
            break;
        case 5:
            t = @"Every Friday";
            break;
        case 6:
            t = @"Every Saturday";
            break;
        default:
            t = @"Unknown";
            break;
    }
    return t;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? TIME_SECTION : DAY_SECTION;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [self mappingTimeStringFromRepeatChoice:indexPath.row];
        
        if ([[self.selectedTimeRepeat objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [self mappingDayStringFromRepeatChoice:indexPath.row];
        
        if ([[self.selectedDayRepeat objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *textLabel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    textLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    
    if (section == 0) {
        label.text = @"Time";
    } else if (section == 1) {
        label.text = @"Day";
    }
    
    [textLabel addSubview:label];
    return textLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark; 
            [self.selectedTimeRepeat replaceObjectAtIndex:indexPath.row withObject:@"1"];
        } else {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [self.selectedTimeRepeat replaceObjectAtIndex:indexPath.row withObject:@"0"];
        }
    } else if (indexPath.section == 1) {
        if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark; 
            [self.selectedDayRepeat replaceObjectAtIndex:indexPath.row withObject:@"1"];
        } else {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [self.selectedDayRepeat replaceObjectAtIndex:indexPath.row withObject:@"0"];
        }
    }
}

@end
