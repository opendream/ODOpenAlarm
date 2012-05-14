//
//  OpenAlarmTests.m
//  OpenAlarmTests
//
//  Created by In|Ce Saiaram on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OpenAlarmTests.h"
#import <OCMock/OCMock.h>
#import "Alarm.h"
#import "ODAppDelegate.h"

@implementation OpenAlarmTests

- (void)setUp
{
    [super setUp];    
    
    alarmServices = [ODAlarmServices sharedAlarmServices];
    
    Alarm *alarm1 = [NSEntityDescription insertNewObjectForEntityForName:@"Alarm" inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    alarm1.fireDate = [NSDate dateWithTimeIntervalSinceNow:60];
    alarm1.title = @"wake up 60";
    alarm1.enable = [NSNumber numberWithBool:YES];
    [APPDELEGATE saveContext];
    
    Alarm *alarm2 = [NSEntityDescription insertNewObjectForEntityForName:@"Alarm" inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    alarm1.fireDate = [NSDate dateWithTimeIntervalSinceNow:30];
    alarm1.title = @"wake up 30";
    alarm1.enable = [NSNumber numberWithBool:NO];
    [APPDELEGATE saveContext];
    
    datasource = [NSArray arrayWithObjects:alarm1, alarm2, nil];
}

- (void)tearDown
{
    alarmServices = nil;
    
    for (Alarm *alarm in datasource) {
        [[APPDELEGATE managedObjectContext] deleteObject:alarm];
    }
    [APPDELEGATE saveContext];
    
    [super tearDown];
}

- (void)testFetchAlarm
{
    STAssertTrue([alarmServices fetchAlarm], @"Cannot fetch alarm from ODAlarmServices");
    
    NSArray *alarms = [alarmServices alarms];
    
    STAssertNotNil(alarms, @"Alarm objects is nil");
    
    NSLog(@"alarms %@", alarms);
}

@end
