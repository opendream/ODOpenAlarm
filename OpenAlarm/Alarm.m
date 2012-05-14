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

@dynamic repeatPeriod;
@dynamic snoozePeriod;
@dynamic sound;
@dynamic title;
@dynamic video;
@dynamic repeatFlag;
@dynamic alarmPeriod;
@dynamic enable;

@dynamic repeatDayFlag;
@dynamic repeatTimeFlag;

- (BOOL)shouldAlert
{
    if (self.repeatFlag.boolValue == YES && self.enable.boolValue == YES) {
        return YES;
    }
    return NO;
}

- (NSInteger)currentWeekDay
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * componentsToday = [calendar components:(NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:today];
    
    NSLog(@"componentsToday.weekday %i", componentsToday.weekday);
    return componentsToday.weekday;
}

- (NSInteger)repeatTimeInMinutes
{
    if ([self.repeatTimeFlag characterAtIndex:0] == '1') {
        return 1;
    } else if ([self.repeatTimeFlag characterAtIndex:1] == '1') {
        return 2;
    }  else if ([self.repeatTimeFlag characterAtIndex:2] == '1') {
        return 5;
    }
    
    return 0;
}

@end
