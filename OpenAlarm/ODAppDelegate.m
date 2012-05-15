//
//  ODAppDelegate.m
//  OpenAlarm
//
//  Created by Pirapa on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODListAlarmViewController.h"
#import "ODAlarmServices.h"

@interface ODAppDelegate()
{
    NSMutableArray *alertControllers;
}

@end

@implementation ODAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    alertControllers = [NSMutableArray new];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [ODAlarmServices sharedAlarmServices];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(pushAlertView:) 
                                                 name:@"alarmServicesWillAlert" 
                                               object:nil];
    
    
//    alertViewController = [[ODAlertViewController alloc] initWithNibName:@"ODAlertViewController" bundle:nil];
//    alertViewController.delegate = self;
    
    [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    ODListAlarmViewController *masterViewController = [[ODListAlarmViewController alloc] initWithNibName:@"ODListAlarmViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)pushAlertView:(NSNotification *)n
{
    ODAlertViewController *alertViewController = [[ODAlertViewController alloc] initWithNibName:@"ODAlertViewController" bundle:nil];
    alertViewController.delegate = self;
    [alertControllers addObject:alertViewController];
    
    NSLog(@"%@",[n.userInfo valueForKey:@"kAlarm"]);
    
    __block CGRect rect = alertViewController.view.frame;
    rect.origin.y = 400;
    
    alertViewController.view.frame = rect;
    
    NSString *labelString = [(Alarm *)[n.userInfo valueForKey:@"kAlarm"] title];
    alertViewController.alertMessege.text = labelString;
    alertViewController.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",(arc4random()%5)+1]];
    
    [self.navigationController.view addSubview:alertViewController.view];
    
    [UIView animateWithDuration:0.5 animations:^{
        rect = alertViewController.view.frame;
        rect.origin.y = 0;
        alertViewController.view.frame = rect;
    }];
}

- (void)hideAlertView:(ODAlertViewController *)alertViewController
{
    __block CGRect rect = alertViewController.view.frame;
    rect.origin.y = 0;
    alertViewController.view.frame = rect;
    
    [UIView animateWithDuration:0.5 animations:^{
        rect = alertViewController.view.frame;
        rect.origin.y = 480;
        alertViewController.view.frame = rect;
    } completion:^(BOOL finished){
        [alertControllers removeObject:alertViewController];
    }];
//    [UIView animateWithDuration:0.4 animations:^{
//        alertViewController.view.alpha = 0.0;
//    }];
}

- (void)alertViewDidStopAlarm:(ODAlertViewController *)controller
{
    [self hideAlertView:controller];
//    [alertViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[ODAlarmServices sharedAlarmServices] scheduleLocalNotificationsForAllAlarms];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
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
