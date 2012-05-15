//
//  ODAddModalViewController.h
//  OpenAlarm
//
//  Created by Pirapa on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODTimeRepeatViewController.h"
#import "ODEditLabelViewController.h"
#import "ODSoundListViewController.h"

@protocol ODAddViewControllerDelegate;

@class Alarm;

@interface ODAddModalViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, ODEditLabelViewControllerDelegate, ODSoundListViewControllerDelegate> {
    
    __unsafe_unretained id <ODAddViewControllerDelegate> delegate;
    
    ODTimeRepeatViewController *timeRepeat;
    
    BOOL isUpdate;
    
    IBOutlet UITableView *detailNewAlarm;
    IBOutlet UIDatePicker *datePicker;
    
    NSString *saveTextLabel;
}

@property (unsafe_unretained) id <ODAddViewControllerDelegate> delegate;
@property (weak) Alarm *updateAlarm;

- (id)initWithNibName:(NSString *)nibNameOrNil withAlarm:(Alarm *)alarm bundle:(NSBundle *)nibBundleOrNil;

@end

@protocol ODAddViewControllerDelegate <NSObject>
- (void)addViewController:(ODAddModalViewController *)controller didInsertAlarm:(Alarm *)alarm;
- (void)addViewController:(ODAddModalViewController *)controller didUpdateAlarm:(Alarm *)alarm;
@optional
- (void)addViewController:(ODAddModalViewController *)controller didFailInsertAlarm:(Alarm *)alarm;
@end


@interface NSString(MergingStringFromArray)

+ (NSString *)mergeStringFromArray:(NSArray *)mergeArray;

@end