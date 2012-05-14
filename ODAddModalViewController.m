//
//  ODAddModalViewController.m
//  OpenAlarm
//
//  Created by Pirapa on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODAddModalViewController.h"
#import "Alarm.h"

@implementation ODAddModalViewController

@synthesize delegate;
@synthesize updateAlarm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        timeRepeat = [[ODTimeRepeatViewController alloc] init];
        isUpdate = false;
    }
        return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil withAlarm:(Alarm *)alarm bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        timeRepeat = [[ODTimeRepeatViewController alloc] init];
        isUpdate = YES;
        
        self.updateAlarm = alarm;
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
    
    UIBarButtonItem *saveToDB = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                              target:self action:@selector(doneButton)];
    self.navigationItem.rightBarButtonItem = saveToDB;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

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
            leftLabel.text = @"Label";
            rightLabel.text = @"Every 2 hour";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryNone;
            leftLabel.text = @"Status";
            
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (updateAlarm != nil) {
        [timeRepeat setRepeatTimeFlag:updateAlarm.repeatTimeFlag];
        [timeRepeat setRepeatDayFlag:updateAlarm.repeatDayFlag];
    }
    [self.navigationController pushViewController:timeRepeat animated:YES];
}

- (void)backToAlarmListPage
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doneButton
{
    if(isUpdate)
        [self updateAlarmToDB];
    else
        [self saveAlarmToDB];
}

- (void)updateAlarmToDB
{
    __block NSMutableString *selectedDayRepeatString = [[NSMutableString alloc] init];
    [timeRepeat.selectedDayRepeat enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [selectedDayRepeatString appendString: (NSString *)obj];
    }];
    
    __block NSMutableString *selectedTimeRepeatString = [[NSMutableString alloc] init];
    [timeRepeat.selectedTimeRepeat enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [selectedTimeRepeatString appendString: (NSString *)obj];
    }];
    self.updateAlarm.fireDate = datePicker.date;
    self.updateAlarm.repeatDayFlag = selectedDayRepeatString;
    self.updateAlarm.repeatTimeFlag = selectedTimeRepeatString;
    [APPDELEGATE saveContext];
    
    [self.delegate addViewController:self didUpdateAlarm:self.updateAlarm];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)saveAlarmToDB
{
    __block NSMutableString *selectedDayRepeatString = [[NSMutableString alloc] init];
    
    [timeRepeat.selectedDayRepeat enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [selectedDayRepeatString appendString: (NSString *)obj];
    }];
    
    __block NSMutableString *selectedTimeRepeatString = [[NSMutableString alloc] init];
    [timeRepeat.selectedTimeRepeat enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [selectedTimeRepeatString appendString: (NSString *)obj];
    }];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Alarm" inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    
    Alarm *newAlarm = [NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    
    newAlarm.repeatDayFlag = selectedDayRepeatString;
    newAlarm.repeatTimeFlag = selectedTimeRepeatString;
    
    newAlarm.repeatPeriod = selectedDayRepeatString;
    newAlarm.title = @"wake up";
    newAlarm.fireDate = datePicker.date;

    newAlarm.alarmPeriod = [NSNumber numberWithInt:1];
    [APPDELEGATE saveContext];

    if (![newAlarm isFault]) {
        [self.delegate addViewController:self didInsertAlarm:(Alarm *)newAlarm];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
