//
//  ODListAlarmTableViewCell.h
//  OpenAlarm
//
//  Created by Pirapa on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alarm.h"

@interface ODListAlarmTableViewCell : UITableViewCell
{
    UILabel *timeLabel;
    UILabel *detailLabel;
    UISwitch *alarmSwitch;
    UIImageView *imageViewInCell;
}

@property (nonatomic, weak) Alarm *alarm;

@property (nonatomic, strong) UISwitch *alarmSwitch;
@property (nonatomic, strong) UIImageView *imageViewInCell;

@end
