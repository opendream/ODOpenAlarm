//
//  ODAddModalViewController.h
//  OpenAlarm
//
//  Created by Pirapa on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODTimeRepeatViewController.h"
@interface ODAddModalViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource> {
    IBOutlet UITableView *detailNewAlarm;
    IBOutlet UIDatePicker *datePicker;
    ODTimeRepeatViewController *timeRepeat;
}

- (IBAction)closeButton;
@end
