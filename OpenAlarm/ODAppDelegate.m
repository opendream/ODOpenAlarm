//
//  ODAppDelegate.m
//  OpenAlarm
//
//  Created by Pirapa on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODListAlarmViewController.h"
#import "ODAlarmServices.h"
#import "ODAlartViewController.h"
@implementation ODAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController = _navigationController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    ODListAlarmViewController *masterViewController = [[ODListAlarmViewController alloc] initWithNibName:@"ODListAlarmViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    alertViewController = [[ODAlartViewController alloc] initWithNibName:@"ODAlartViewController" bundle:nil];
    [ODAlarmServices sharedAlarmServices];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAlartView:) name:@"alarmServicesWillAlert" object:nil];

    //[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkCounter) userInfo:nil repeats:YES];
    //[self pushAlartView];
////    NSPredicate * predicate;
////    predicate = [NSPredicate predicateWithFormat:@"self.title > %@"];
////    
////    
////    NSSortDescriptor * sort = [[NSortDescriptor alloc] initWithKey:@"title"];
////    NSArray * sortDescriptors = [NSArray arrayWithObject: sort];
//    
//    NSEntityDescription    * entity   = [NSEntityDescription entityForName:@"Alarm" inManagedObjectContext:[self managedObjectContext]];
//    
//    
//    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
//    [fetch setEntity: entity];
////    [fetch setPredicate: predicate];
////    [fetch setSortDescriptors: sortDescriptors];
//    
//    NSArray * results = [[self managedObjectContext] executeFetchRequest:fetch error:nil];
//    NSLog(@"%@", results);
//    
//    
//    NSManagedObject *newAlarm = [NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:self.managedObjectContext];
//    [newAlarm setValue:@"talk a walk!" forKey:@"title"];
//    
//    //save context
//    [[self managedObjectContext] save:NULL];
//    dispatch_queue_t q_background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    dispatch_async(q_background, ^{
//        [self methodToRepeatEveryOneSecond];
//    });
    UIDevice* device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)])
        backgroundSupported = device.multitaskingSupported;
    
    
    return YES;
}
- (void)methodToRepeatEveryOneSecond
{
    // Do your thing here
    
//    NSLog(@"Log using GCD");
//    
//    // Call this method again using GCD 
//    dispatch_queue_t q_background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    double delayInSeconds = 1.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, q_background, ^(void){
//        [self methodToRepeatEveryOneSecond];
//    });
}

- (void)pushAlartView:(NSNotification *)n
{
    NSLog(@"%@",[n.userInfo valueForKey:@"kAlarm"]);
    __block CGRect rect = alertViewController.view.frame;
    rect.origin.y = 400;
    alertViewController.view.frame = rect;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSString *stringFromDate = [formatter stringFromDate:[(Alarm *)[n.userInfo valueForKey:@"kAlarm"] fireDate]];
    
    alertViewController.alertMessege.text = stringFromDate;
    [self.navigationController.view addSubview:alertViewController.view];
    [UIView animateWithDuration:0.5 animations:^{
        rect = alertViewController.view.frame;
        rect.origin.y = 0;
        alertViewController.view.frame = rect;
    }];
}

- (void)hideAlertView
{
//    [self.navigationController.view 
    [alertViewController.view removeFromSuperview];
}
- (void)checkCounter
{
    //NSLog(@"alarmService[%d] counter : %f",[ODAlarmServices sharedAlarmServices],[[ODAlarmServices sharedAlarmServices] counter]);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    __block UIBackgroundTaskIdentifier taskIdentifier;
    taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background task ran out of time and was terminated.");
        [[UIApplication sharedApplication] endBackgroundTask: taskIdentifier];
        taskIdentifier = UIBackgroundTaskInvalid;
    }];
    NSLog(@"taskIdentifier: %d",taskIdentifier);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
//        if ([[DBSession sharedSession] isLinked])
//        {
//            NSLog(@"is linked in didFinishPickingMediaWithInfo");
//            NSData *data = UIImageJPEGRepresentation(self.image, 1.0);
//            NSString *path = [[self documentsDirectory] stringByAppendingPathComponent: @"img.jpg"];
//            [data writeToFile: path atomically: YES];
//            NSString *filename = @"image.jpg";
//            NSString *destPath = @"/";
//            
//            [[self restClient] uploadFile: filename toPath:destPath withParentRev:nil fromPath: path];
//        }
        
//        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fetchAlarm) userInfo:nil repeats:YES];
        NSLog(@"Finishing background task");
        [[UIApplication sharedApplication] endBackgroundTask: taskIdentifier];
        taskIdentifier = UIBackgroundTaskInvalid;
    });
}







- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceiveLocalNotification notification");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification userInfo");
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"OpenAlarm" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"OpenAlarm.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
