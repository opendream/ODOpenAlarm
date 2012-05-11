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
#import "ODListAlarmTableViewCell.h"

@interface ODListAlarmViewController ()

@end

@implementation ODListAlarmViewController
@synthesize managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        alarmList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

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
    
    //creat left navigation button (delete button)
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
    // set clock
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTime) userInfo:nil repeats:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alarmService) name:@"alarmServicesWillAlert" object:nil];
} 
 
 - (void)alarmService
{
    NSLog(@"Alarm fire!");
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];

}

- (void)insertnewAlarm
{
    ODAddModalViewController *modalViewAdd = [[ODAddModalViewController alloc] initWithNibName:@"ODAddModalViewController" bundle:nil];
    modalViewAdd.delegate = self;
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
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    ODListAlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ODListAlarmTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
    }
    
    Alarm *alarmItem = (Alarm *)[self.fetchedResultsController objectAtIndexPath:indexPath];    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    cell.timeLabel.text = [formatter stringFromDate: alarmItem.fireDate];
    cell.detailLabel.text = alarmItem.title;
    
    return cell;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate 
{
    [super setEditing:editing animated:animate];
    [alarmList setEditing:editing animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select");
    Alarm *updateAlarm = (Alarm *)[self.fetchedResultsController objectAtIndexPath:indexPath];  
    ODAddModalViewController *modalViewAdd = [[ODAddModalViewController alloc] initWithNibName:@"ODAddModalViewController" withAlarm:updateAlarm bundle:nil];

    modalViewAdd.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:modalViewAdd];
    [self presentModalViewController:navController animated:YES];
    
    
}
-(void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"edit");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // click delete button
    // delete from Database
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *toDeleteRow = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[self.fetchedResultsController managedObjectContext] deleteObject:toDeleteRow];
        [[self.fetchedResultsController managedObjectContext] save:nil];
        NSLog(@"delete from commit");
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

    date.text = dateString;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Alarm" inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20]; 
    
    // Edit the sort key as appropriate.
    NSArray *sortDescriptors = [NSArray arrayWithObjects:nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[APPDELEGATE managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}  

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [alarmList beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [alarmList insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [alarmList deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = alarmList;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"insert from Fetch");
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"delete from Fetch");
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            NSLog(@"update from Fetch");
            [self configureCell:[alarmList cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [alarmList endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"fireDate"] description];
}

- (void)addViewController:(ODAddModalViewController *)controller didInsertAlarm:(Alarm *)alarm
{
    [alarmList reloadData];
}

- (void)addViewController:(ODAddModalViewController *)controller didUpdateAlarm:(Alarm *)alarm
{
    [alarmList reloadData];
}

@end
