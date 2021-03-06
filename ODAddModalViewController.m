//
//  ODAddModalViewController.m
//  OpenAlarm
//
//  Created by Pirapa on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODAddModalViewController.h"

#import "ODEditLabelViewController.h"
#import "ODSoundListViewController.h"

#import "Alarm.h"
#import "ODSound.h"

@interface ODAddModalViewController() {
    ODEditLabelViewController *editViewController;
    ODSoundListViewController *soundListViewController;
    BOOL isAlarmOn;
    ODSound *selectedSound;
}
@end


@implementation NSString(MergingStringFromArray)

+ (NSString *)mergeStringFromArray:(NSArray *)mergeArray
{
    __block NSMutableString *mergeString = [[NSMutableString alloc] init];
    [mergeArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [mergeString appendString: (NSString *)obj];
    }];
    
    return mergeString;
}

@end


@implementation ODAddModalViewController

@synthesize delegate;
@synthesize updateAlarm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        timeRepeat = [[ODTimeRepeatViewController alloc] initWithNibName:@"ODTimeRepeatViewController" bundle:nil];
        editViewController = [[ODEditLabelViewController alloc] initWithNibName:@"ODEditLabelViewController" bundle:nil];
        isUpdate = NO;
        saveTextLabel = [[NSString alloc]init];
        saveTextLabel = @"Walk outside";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil withAlarm:(Alarm *)alarm bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.updateAlarm = alarm;
        isUpdate = YES;
        saveTextLabel = updateAlarm.title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    detailNewAlarm.delegate = self;
    detailNewAlarm.dataSource = self;

    if (isUpdate)
        datePicker.date = updateAlarm.fireDate;

    UIBarButtonItem *backToCameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                        target:self action:@selector(backToAlarmListPage)];
    self.navigationItem.LeftBarButtonItem = backToCameraButton;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *saveToDB = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                              target:self action:@selector(doneButton)];
    self.navigationItem.rightBarButtonItem = saveToDB;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [detailNewAlarm reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellLabelIdentifier = @"LabelCell";
    static NSString *CellStatusIdentifier = @"StatusCell";
    
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0: { //label
            cell = [tableView dequeueReusableCellWithIdentifier:CellLabelIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellLabelIdentifier];
            }
            cell.textLabel.text = @"Label";
            
            cell.detailTextLabel.text = saveTextLabel;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 1: { //status
            UILabel *leftLabel;
            UISwitch *statusSwitch;
            cell = [tableView dequeueReusableCellWithIdentifier:CellStatusIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellStatusIdentifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
                [cell.contentView addSubview:leftLabel];
                
                statusSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(220, 10, 100, 30)];
               
                [statusSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                if (self.updateAlarm != nil) {
                    [statusSwitch setOn:[updateAlarm enable].boolValue];
                    isAlarmOn = statusSwitch.isOn;
                } else {
                    [statusSwitch setOn:YES];
                    isAlarmOn = YES;
                }
                [cell.contentView addSubview:statusSwitch];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            leftLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
            leftLabel.text = @"Status";
            break;
        }
        case 2: {   //sound
            cell = [tableView dequeueReusableCellWithIdentifier:CellLabelIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellLabelIdentifier];
            }
            cell.textLabel.text = @"Sound";
            
            if (selectedSound == nil) {
                cell.detailTextLabel.text = @"No sound";
            } else {
                cell.detailTextLabel.text = [selectedSound.name capitalizedString];
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (updateAlarm != nil) {
        [timeRepeat setRepeatTimeFlag:updateAlarm.repeatTimeFlag];
        [timeRepeat setRepeatDayFlag:updateAlarm.repeatDayFlag];
    }
    
    switch (indexPath.row) {
        case 0: {
            editViewController = [[ODEditLabelViewController alloc] initWithNibName:@"ODEditLabelViewController" bundle:nil];
            editViewController.delegate = self;
            if (self.updateAlarm != nil) {
                editViewController.textLabel.text = updateAlarm.title;
            }
            editViewController.currentName = saveTextLabel;
            [self.navigationController pushViewController:editViewController animated:YES];
            break;
        }
        case 2: { //sound
            soundListViewController = [[ODSoundListViewController alloc] init];
            soundListViewController.delegate = self;
            [self.navigationController pushViewController:soundListViewController animated:YES];
            break;        
        }
    }
}

- (void)backToAlarmListPage
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)switchChanged:(UISwitch *)sender
{
    isAlarmOn = sender.on;
}

- (void)doneButton
{
    if(isUpdate)
        [self updateAlarmToDB];
    else
        [self saveAlarmToDB];
}

- (NSString *)mergeStringFromArray:(NSArray *)sArray
{
    __block NSMutableString *mergeString = [[NSMutableString alloc] init];
    [sArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [mergeString appendString: (NSString *)obj];
    }];

    return mergeString;
}

- (void)updateAlarmToDB
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | 
                                                        NSDayCalendarUnit | NSWeekCalendarUnit |
                                                        NSHourCalendarUnit | NSMinuteCalendarUnit
                                                        | NSSecondCalendarUnit) 
                                              fromDate:datePicker.date];
    [dateComps setSecond:0];
    NSDate *saveDate = [calendar dateFromComponents:dateComps];
    self.updateAlarm.fireDate = saveDate; // set to DB
    self.updateAlarm.title = saveTextLabel;
    self.updateAlarm.enable = [NSNumber numberWithBool:isAlarmOn];
    self.updateAlarm.sound = [NSString stringWithFormat:@"%@.%@", selectedSound.name, selectedSound.type];
    
    self.updateAlarm.repeatDayFlag = [NSString mergeStringFromArray:timeRepeat.selectedDayRepeat];
    self.updateAlarm.repeatTimeFlag = [NSString mergeStringFromArray:timeRepeat.selectedTimeRepeat];
    
    [APPDELEGATE saveContext];
    
    [self.delegate addViewController:self didUpdateAlarm:self.updateAlarm];
}

- (void)saveAlarmToDB
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Alarm" inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    
    Alarm *newAlarm = [NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    newAlarm.title = saveTextLabel;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |
                                                        NSHourCalendarUnit | NSMinuteCalendarUnit
                                                        | NSSecondCalendarUnit) 
                                                        fromDate:datePicker.date];
    [dateComps setSecond:0];
    NSDate *saveDate = [calendar dateFromComponents:dateComps];
    newAlarm.fireDate = saveDate; // set to DB
    newAlarm.enable = [NSNumber numberWithBool:isAlarmOn];
    newAlarm.repeatDayFlag = [self mergeStringFromArray:timeRepeat.selectedDayRepeat];
    newAlarm.repeatTimeFlag = [self mergeStringFromArray:timeRepeat.selectedTimeRepeat];
    newAlarm.sound = [NSString stringWithFormat:@"%@.%@", selectedSound.name, selectedSound.type];;
    [APPDELEGATE saveContext];
    
    if ([newAlarm isFault]) {
        if ([self.delegate respondsToSelector:@selector(addViewController:didFailInsertAlarm:)]) {
            [self.delegate addViewController:self didFailInsertAlarm:nil];
        }
    } else {
        [self.delegate addViewController:self didInsertAlarm:(Alarm *)newAlarm];
    }
}

- (void)shouldSaveTextLabel:(ODEditLabelViewController *)controller withString:(NSString *)text
{
    if (text != nil) {
        saveTextLabel = text;
        [detailNewAlarm reloadData];
    }
    
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - ODSoundListViewViewControllerDelegate

- (void)soundController:(ODSoundListViewController *)controller didSelectSound:(ODSound *)sound
{
    selectedSound = sound;
    [controller.navigationController popViewControllerAnimated:YES];
}

@end
