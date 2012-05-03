//
//  ODTimeRepeatViewController.h
//  OpenAlarm
//
//  Created by Pirapa on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NUMBEROFROWINSECTION 10

@interface ODTimeRepeatViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *repeatTimeTableView;
    NSMutableArray *selectedDayRepeat;

}

@property (strong, nonatomic) NSMutableArray *selectedDayRepeat;

@end
