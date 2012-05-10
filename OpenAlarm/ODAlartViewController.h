//
//  ODAlartViewController.h
//  OpenAlarm
//
//  Created by Pirapa on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODAlartViewController : UIViewController {
    IBOutlet UILabel *alertMessege;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *timeLabel;
}

@property(strong, nonatomic) UILabel *alertMessege;
@property(strong, nonatomic) UILabel *dateLabel;
@property(strong, nonatomic) UILabel *timeLabel;

- (IBAction)hideView:(id)sender;
@end
