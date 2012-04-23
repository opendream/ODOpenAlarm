//
//  ODMasterViewController.h
//  OpenAlarm
//
//  Created by Pirapa on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ODDetailViewController;

#import <CoreData/CoreData.h>

@interface ODMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) ODDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
