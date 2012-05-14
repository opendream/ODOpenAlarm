//
//  ODTimeRepeatViewController.m
//  OpenAlarm
//
//  Created by Pirapa on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODTimeRepeatViewController.h"

#define DAY_SECTION 7
#define TIME_SECTION 3
@interface ODTimeRepeatViewController()
{
    NSIndexPath *lastIndexPath;
}
@end
@implementation ODTimeRepeatViewController

@synthesize selectedDayRepeat, selectedTimeRepeat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setRepeatTimeFlag:TIME_FLAG_DEFAULT andRepeatDayFlag:DAY_FLAG_DEFAULT];
    }
    return self;
}

- (void)setRepeatTimeFlag:(NSString *)stringFlag
{
    NSString *repeatFlag[TIME_SECTION];
    
    for (int i = 0; i < TIME_SECTION; i++) {
        repeatFlag[i] = [NSString stringWithFormat:@"%c" , [stringFlag characterAtIndex:i]];
    }
    self.selectedTimeRepeat = [NSMutableArray arrayWithObjects:repeatFlag count:TIME_SECTION];
}

- (void)setRepeatDayFlag:(NSString *)stringFlag
{
    NSString *repeatFlag[DAY_SECTION];
    
    for (int i = 0; i < DAY_SECTION; i++) {
        repeatFlag[i] = [NSString stringWithFormat:@"%c" , [stringFlag characterAtIndex:i]];
    }
    self.selectedDayRepeat = [NSMutableArray arrayWithObjects:repeatFlag count:DAY_SECTION];
}

- (void)setRepeatTimeFlag:(NSString *)timeFlag andRepeatDayFlag:(NSString *)dayFlag
{
    [self setRepeatTimeFlag:timeFlag];
    [self setRepeatDayFlag:dayFlag];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    repeatTimeTableView.dataSource = self;
    repeatTimeTableView.delegate = self;
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
    static NSString *CellDayIdentifier = @"CellDayIdentifier";
    static NSString *CellTimeIdentifier = @"CellTimeIdentifier";
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:CellTimeIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTimeIdentifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            cell.textLabel.text = [self mappingTimeStringFromRepeatChoice:indexPath.row];
            
            if ([[self.selectedTimeRepeat objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            break;
        }
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:CellDayIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellDayIdentifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            cell.textLabel.text = [self mappingDayStringFromRepeatChoice:indexPath.row];
            
            if ([[self.selectedDayRepeat objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
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
    
    [label removeFromSuperview];
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
    
    switch (indexPath.section) {
        case 0: {
            UITableViewCell* newCell = [tableView cellForRowAtIndexPath:indexPath]; 
            int newRow = [indexPath row]; 
            int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1; 
            
            if(newRow != oldRow) 
            { 
                newCell.accessoryType = UITableViewCellAccessoryCheckmark; 
                UITableViewCell* oldCell = [tableView cellForRowAtIndexPath:lastIndexPath]; 
                oldCell.accessoryType = UITableViewCellAccessoryNone;
                [self.selectedTimeRepeat replaceObjectAtIndex:newRow withObject:@"1"];
                if (oldRow != -1)
                    [self.selectedTimeRepeat replaceObjectAtIndex:oldRow withObject:@"0"];
                lastIndexPath = indexPath; 
            } else {
                if (newCell.accessoryType == UITableViewCellAccessoryCheckmark){
                    newCell.accessoryType = UITableViewCellAccessoryNone;
                    [self.selectedTimeRepeat replaceObjectAtIndex:newRow withObject:@"0"];
                    lastIndexPath = indexPath;
                }else {
                    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    [self.selectedTimeRepeat replaceObjectAtIndex:newRow withObject:@"1"];
                    lastIndexPath = indexPath;
                }
            }
            break;
        }
        case 1: {
            if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark; 
                [self.selectedDayRepeat replaceObjectAtIndex:indexPath.row withObject:@"1"];
            } else {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [self.selectedDayRepeat replaceObjectAtIndex:indexPath.row withObject:@"0"];
            }
            break;
        }
    }
}

@end
