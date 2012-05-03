//
//  ODListAlarmViewController.m
//  OpenAlarm
//
//  Created by Pirapa on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODListAlarmViewController.h"
#import "ODAddModalViewController.h"
#import "ODAppDelegate.h"
#import "Alarm.h"
@interface ODListAlarmViewController ()

@end

@implementation ODListAlarmViewController
@synthesize managedObjectContext;
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
    alarmCount = 0;
    alarmList.delegate = self;
    alarmList.dataSource = self;
    
    //creat right navigation button (add button)
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertnewAlarm)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //creat left navigation button (delete button)
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
    // set clock
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTime) userInfo:nil repeats:YES];
    // set fireAlarm
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fireAlarm) userInfo:nil repeats:YES];
    
    //call alarm
    [self setAlarm];

    
    // fetch data from DB
    appDelegate = [[ODAppDelegate alloc] init];  
//    managedObjectContext =[[NSManagedObjectContext alloc]init];
    NSEntityDescription    * entity   = [NSEntityDescription entityForName:@"Alarm" inManagedObjectContext:[appDelegate managedObjectContext]];

        
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity: entity];
//    [fetch setPredicate: predicate];
//    [fetch setSortDescriptors: sortDescriptors];
//    alarmListFromDB = [[NSMutableArray alloc]init];
    alarmListFromDB =[NSMutableArray arrayWithArray:[[appDelegate managedObjectContext] executeFetchRequest:fetch error:nil]];
    NSLog(@"Database");
    NSLog(@"%@", alarmListFromDB);
    
//    Alarm *alarm = [[Alarm alloc] initWithEntity:entity insertIntoManagedObjectContext:[appDelegate managedObjectContext]];


}

- (void)viewWillAppear:(BOOL)animated{
//    appDelegate = [[ODAppDelegate alloc] init];  
//    //    managedObjectContext =[[NSManagedObjectContext alloc]init];
//    NSEntityDescription    * entity   = [NSEntityDescription entityForName:@"Alarm" inManagedObjectContext:[appDelegate managedObjectContext]];
//    
//    
//    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
//    [fetch setEntity: entity];
//    //    [fetch setPredicate: predicate];
//    //    [fetch setSortDescriptors: sortDescriptors];
//    //    alarmListFromDB = [[NSMutableArray alloc]init];
//    alarmListFromDB =[NSMutableArray arrayWithArray:[[appDelegate managedObjectContext] executeFetchRequest:fetch error:nil]];
//    [alarmList reloadData];
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
    return alarmListFromDB.count;
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
//    NSDictionary *dictionary = [alarmListFromDB objectAtIndex:indexPath.row];
//    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];
//    Alarm *alarm = [NSEntityDescription insertNewObjectForEntityForName:@"Alarm" inManagedObjectContext:context];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSManagedObject *alarmItem = [alarmListFromDB objectAtIndex:indexPath.row];
        
        UIImageView *imageViewInCell = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 70, 70)];
        [cell addSubview:imageViewInCell];
        imageViewInCell.image = [UIImage imageNamed:@"Icon.png"];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageViewInCell.frame.size.width + 20, cell.frame.origin.y + 10, 100, 20)];
        [cell addSubview:timeLabel];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        
        timeLabel.text = [formatter stringFromDate: [alarmItem valueForKey:@"fireDate"]];
        
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageViewInCell.frame.size.width + 20, cell.frame.origin.y + 30, 100, 20)];
        [cell addSubview:detailLabel];
        detailLabel.text = [alarmItem valueForKey:@"title"];
        
        UISwitch *alarmSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(detailLabel.frame.origin.x + 130, cell.frame.origin.y + 20, 30, 30)];
        [cell addSubview:alarmSwitch];
    }
    

    return cell;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate 
{
    [super setEditing:editing animated:animate];
    [alarmList setEditing:editing animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
// click delete button
    // delete from Database
    if(editingStyle == UITableViewCellEditingStyleDelete){
    NSManagedObject *toDeleteRow = [alarmListFromDB objectAtIndex:indexPath.row];
        [[appDelegate managedObjectContext] deleteObject:toDeleteRow];
        [[appDelegate managedObjectContext] save:nil];
        
    // delete from tableview cell        
        [alarmListFromDB removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
    
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
- (void) fireAlarm {
    NSManagedObject *managedObject;
    NSDate *dateAlarm;
    for (int i=0; i<alarmListFromDB.count; i++) {
        managedObject = [alarmListFromDB objectAtIndex:i];//
        dateAlarm = [managedObject valueForKey:@"fireDate"];
//        NSLog(@"%@", [managedObject valueForKey:@"fireDate"]);
        NSDate *today = [NSDate date] ;
        
        
//        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
//        [timeFormat setDateFormat:@"HH:mm"];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents * componentsToday = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:today];
        NSDateComponents * componentsAlarm = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:dateAlarm];
        if (componentsAlarm.minute == componentsToday.minute && componentsAlarm.hour == componentsToday.hour ) {
            alarmCount++;
            if (alarmCount == 1) {
                NSLog(@"%@  ==  %@", today, dateAlarm);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"title" message:@"message" delegate:self cancelButtonTitle:@"Snooze" otherButtonTitles:@"OK", nil];
                [alert show];
            }
        else if(alarmCount >= 60){
            alarmCount=0;
        }
            
            
            
            
        }   
//            else if (dateDiff == NSOrderedAscending) {
//            NSLog(@"%@  ASCEN  %@", today, dateAlarm);
////            NSLog(@"ASCEN");
//        } else if (dateDiff == NSOrderedDescending) {
//            NSLog(@"%@  DECEN  %@", today, dateAlarm);
////            NSLog(@"Desen");
//        }
//        NSlog(@"%@", dateDiff);
        
//        
//        if([NSDate date] < [managedObject valueForKey:@"fireDate"]){
//            NSLog(@"%d",i);
//        }
        
        
        
    }
}

- (void) setAlarm {
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
