//
//  ODListAlarmViewController.h
//  OpenAlarm
//
//  Created by Pirapa on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODAppDelegate.h"
#import "ODAddModalViewController.h"
@interface ODListAlarmViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, ODAddViewControllerDelegate> {

    IBOutlet UITableView *alarmList;
    IBOutlet UILabel *time;
    
    __weak IBOutlet UISwitch *enableAlarmSwitch;
}

//@property(strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
