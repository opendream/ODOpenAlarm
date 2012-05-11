//
//  Alarm.m
//  OpenAlarm
//
//  Created by In|Ce Saiaram on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Alarm.h"


@implementation Alarm

@dynamic fireDate;
@dynamic image;
@dynamic message;
@dynamic nextFireDate;
@dynamic repeatPeriod;
@dynamic snoozePeriod;
@dynamic sound;
@dynamic title;
@dynamic video;
@dynamic repeatFlag;
@dynamic alarmPeriod;

- (BOOL)shouldAlert
{
    if (self.repeatFlag) {
        return YES;
    }
    return NO;
}
@end
