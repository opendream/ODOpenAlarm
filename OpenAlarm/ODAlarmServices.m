//
//  ODAlarmServices.m
//  OpenAlarm
//
//  Created by Pirapa on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODAlarmServices.h"

@implementation ODAlarmServices

NSString *alarmServicesWillAlert;

static ODAlarmServices *shareAlarmService = nil;

@synthesize counter;
@synthesize alarms;

- (id)init
{
    self = [super init];
    if (self) {
        // notification center
        alarmServicesWillAlert = @"alarmServicesWillAlert";
        
        // timer
        [self fetchAlarm];
        [self setAlarm];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fetchAlarm) userInfo:nil repeats:YES];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkAlarm) userInfo:nil repeats:YES];
        alarmCount = 0;
    }
    return self;
}

+ (id)sharedAlarmServices
{
    @synchronized(self) {
        if (shareAlarmService == nil)
            shareAlarmService = [[self alloc] init];
    }
    return shareAlarmService;
}

- (BOOL)calculateFireTime:(Alarm *)a
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * componentsToday = [calendar components:(NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:today];
    NSDateComponents * componentsAlarm = [calendar components:(NSWeekdayCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:a.nextFireDate];
    
    NSInteger nowCheck = ( componentsToday.hour * 60 ) + componentsToday.minute;
    NSInteger alarmCheck = ( componentsAlarm.hour * 60 ) + componentsAlarm.minute;
    
    return (alarmCheck - nowCheck) % a.alarmPeriod.intValue == 0;
}

- (BOOL)alarmTest:(Alarm *)a
{
    // check whether alarm should be alert
    // alarmCheck, nowCheck -> in second
    
    if ([a shouldAlert] && [self calculateFireTime:a]) {
        
        a.repeatFlag = [NSNumber numberWithBool:NO];
        [self performSelector:@selector(repeatAlarmCheck:) withObject:a afterDelay:(60)];
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:a, @"kAlarm", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:alarmServicesWillAlert object:nil userInfo:userInfo];
    } 
    
    return YES;
}

- (void)checkAlarm
{
    for (Alarm *alarmObject in alarms) {
        
        [self alarmTest:alarmObject];
        [APPDELEGATE saveContext];
    }
    
}

- (void)repeatAlarmCheck:(Alarm *)a
{
    NSLog(@"line 76 repeatAlarmCheck  %@",a);
    a.repeatFlag = [NSNumber numberWithBool:YES];
    [APPDELEGATE saveContext];
}

- (void)fetchAlarm
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Alarm" inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    alarms = [[APPDELEGATE managedObjectContext] executeFetchRequest:request error:nil];
}

- (void)setAlarm {
    for (int i=0; i<alarms.count; i++) {
        
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        Alarm *localNotifFireDate = [alarms objectAtIndex:i];
        //NSLog(@"%@ fire alarm",localNotifFireDate.fireDate);
        localNotif.alertBody = localNotifFireDate.title;
        localNotif.alertAction = NSLocalizedString(@"View Details", nil);
        localNotif.fireDate = localNotifFireDate.fireDate;
        NSLog(@"%@",localNotifFireDate.fireDate);

        NSArray *object = [[NSArray alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@",localNotifFireDate.fireDate]];
        NSArray *key = [[NSArray alloc]initWithContentsOfFile:@"notif"];
        localNotif.userInfo = [[NSDictionary alloc]initWithObjects:object forKeys:key];
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        
        //[[UIApplication sharedApplication] cancelLocalNotification:[UILocalNotification ];
        
    }
}

- (void)threadMain
{
    // The application uses garbage collection, so no autorelease pool is needed.
    NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
    
    // Create a run loop observer and attach it to the run loop.
    
    CFRunLoopObserverContext  context = {0, nil, NULL, NULL, NULL};
    CFRunLoopObserverRef    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                               kCFRunLoopAllActivities, YES, 0, NULL, &context);
    
    if (observer)
    {
        CFRunLoopRef    cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
    
    NSInteger    loopCount = 5;
    do
    {
        // Run the run loop 10 times to let the timer fire.
        [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        loopCount--;
        NSLog(@"%d",loopCount);
    }
    while (loopCount);
    NSLog(@"fire");
    
    
    
}
@end
