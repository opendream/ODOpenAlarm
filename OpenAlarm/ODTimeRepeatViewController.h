//
//  ODTimeRepeatViewController.h
//  OpenAlarm
//
//  Created by Pirapa on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODTimeRepeatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *selectedDayRepeat, *selectedTimeRepeat;    
    IBOutlet UITableView *repeatTimeTableView;
}

@property (strong, nonatomic) NSMutableArray *selectedDayRepeat;
@property (strong, nonatomic) NSMutableArray *selectedTimeRepeat;

- (void)setRepeatTimeFlag:(NSString *)stringFlag;
- (void)setRepeatDayFlag:(NSString *)stringFlag;

@end
