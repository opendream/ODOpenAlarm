//
//  ODAlarmServicesTest.m
//  OpenAlarm
//
//  Created by In|Ce Saiaram on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODAlarmServicesTest.h"
#import "Alarm.h"
@implementation ODAlarmServicesTest

- (void)setUp
{
    alarmServices = [ODAlarmServices sharedAlarmServices];
    [alarmServices fetchAlarm];
}

- (void)testCheckAlarm
{
    Alarm *alarm = [[Alarm alloc] init];
    
    alarm.fireDate = [NSDate date];
    alarm.title = @"DSFSDF";
    alarm.repeatFlag = [NSNumber numberWithBool:YES];
    
    STAssertTrue([alarmServices alarmTest:alarm], @"AlarmTest Failed");
}

@end
