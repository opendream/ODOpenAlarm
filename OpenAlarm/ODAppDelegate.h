//
//  ODAppDelegate.h
//  OpenAlarm
//
//  Created by Pirapa on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODAlartViewController.h"
#define APPDELEGATE (ODAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface ODAppDelegate : UIResponder <UIApplicationDelegate>
{
    ODAlartViewController *alertViewController;
     __block UIBackgroundTaskIdentifier bgTask;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSString *title;

@end
