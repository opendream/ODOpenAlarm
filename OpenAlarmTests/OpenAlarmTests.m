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

@implementation OpenAlarmTests

- (void)setUp
{
    [super setUp];
    id mockAlarm1 = [OCMockObject mockForClass:[Alarm class]];
    [mockAlarm1 setObject:@"mock title" forKey:@"title"];
    [mockAlarm1 setObject:[NSDate new] forKey:@"firedate"];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{

}

@end
