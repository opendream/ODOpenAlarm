//
//  ODListAlarmViewController.h
//  OpenAlarm
//
//  Created by Pirapa on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODAppDelegate.h"
@interface ODListAlarmViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *alarmList;
    IBOutlet UIView *clockViewer;
    IBOutlet UILabel *date;
    IBOutlet UILabel *time;
    NSMutableArray *alarmListFromDB;
    int alarmCount;
    ODAppDelegate *appDelegate;
}
@property(strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@end
