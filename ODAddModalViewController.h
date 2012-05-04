//
//  ODAddModalViewController.h
//  OpenAlarm
//
//  Created by Pirapa on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODTimeRepeatViewController.h"

@protocol ODAddViewControllerDelegate;

@class Alarm;

@interface ODAddModalViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource> {
    IBOutlet UITableView *detailNewAlarm;
    IBOutlet UIDatePicker *datePicker;
    ODTimeRepeatViewController *timeRepeat;
    BOOL isUpdate;
    __unsafe_unretained id <ODAddViewControllerDelegate> delegate;
//    Alarm *updateAlarm;
}

@property (unsafe_unretained) id <ODAddViewControllerDelegate> delegate;
@property (weak) Alarm *updateAlarm;

- (IBAction)closeButton;
- (id)initWithNibName:(NSString *)nibNameOrNil withAlarm:(Alarm *)alarm bundle:(NSBundle *)nibBundleOrNil;
@end

@protocol ODAddViewControllerDelegate <NSObject>

- (void)addViewController:(ODAddModalViewController *)controller didInsertAlarm:(Alarm *)alarm;
- (void)addViewController:(ODAddModalViewController *)controller didUpdateAlarm:(Alarm *)alarm;
@end
