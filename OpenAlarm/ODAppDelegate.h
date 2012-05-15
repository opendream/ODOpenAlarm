//
//  ODAppDelegate.h
//  OpenAlarm
//
//  Created by Pirapa on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODAlertViewController.h"

#define TIME_FLAG_DEFAULT @"000"
#define DAY_FLAG_DEFAULT @"0000000"

#define kSoundName @"kSoundWav"
#define kSoundType @"kSoundType"

#define APPDELEGATE (ODAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface ODAppDelegate : UIResponder <UIApplicationDelegate, ODAlertViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UINavigationController *navigationController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
