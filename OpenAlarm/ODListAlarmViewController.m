//
//  ODListAlarmViewController.m
//  OpenAlarm
//
//  Created by Pirapa on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODListAlarmViewController.h"
#import "ODAddModalViewController.h"

@interface ODListAlarmViewController ()

@end

@implementation ODListAlarmViewController

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
    alarmList.delegate = self;
    alarmList.dataSource = self;
    
    //creat right navigation button (add button)
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertnewAlarm)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
        // set timer
    //[NSTimer timerWithTimeInterval:100 target:self selector:@selector(setTime) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTime) userInfo:nil repeats:YES];
    
    
    //call alarm
    [self setAlarm];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)insertnewAlarm
{
    ODAddModalViewController *modalViewAdd = [[ODAddModalViewController alloc] initWithNibName:@"ODAddModalViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:modalViewAdd];
    [self presentModalViewController:navController animated:YES];
                                    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIImageView *imageViewInCell = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 70, 70)];
        [cell addSubview:imageViewInCell];
        imageViewInCell.image = [UIImage imageNamed:@"Icon.png"];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageViewInCell.frame.size.width + 20, cell.frame.origin.y + 10, 100, 20)];
        [cell addSubview:timeLabel];
        timeLabel.text = @"12:04";
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageViewInCell.frame.size.width + 20, cell.frame.origin.y + 30, 100, 20)];
        [cell addSubview:detailLabel];
        detailLabel.text = @"Take a walk!";
        
        UISwitch *alarmSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(detailLabel.frame.origin.x + 130, cell.frame.origin.y + 20, 30, 30)];
        [cell addSubview:alarmSwitch];
        

        
    }
    return cell;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate {
    [super setEditing:editing animated:animate];
    [alarmList setEditing:editing animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



#pragma mark - Clock View

- (void)setTime{
    
    NSDate *today = [NSDate date];
//    NSDate *dateShow= [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];

    NSCalendar * calendar = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * components =
    [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:today];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger sec = [components second];
    
//    NSInteger day = [components day];
//    NSInteger month = [components month];
//    NSInteger year = [components year];
    
        

    
    time.text = [NSString stringWithFormat:@"%i:%i:%i", hour, minute, sec];
//    date.text = [NSString stringWithFormat:@"%i %i %i", day, month, year];
    date.text = dateString;
}

- (void)setAlarm {
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    NSDate *itemDate = [NSDate date];
    
    localNotif.alertBody = @"eating";
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    localNotif.fireDate = [itemDate addTimeInterval:5];
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
//    localNotif.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    


}

@end
