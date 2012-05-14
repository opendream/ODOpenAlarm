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

- (BOOL)isNowDateEqualToAlarmDate:(NSDate *)fireDate withTimePeriod:(NSInteger)period
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents * componentsToday = [calendar components:(NSWeekdayCalendarUnit | NSHourCalendarUnit 
                                                               | NSMinuteCalendarUnit | NSSecondCalendarUnit) 
                                                     fromDate:today];
    
    NSDateComponents * componentsAlarm = [calendar components:(NSWeekdayCalendarUnit |  NSHourCalendarUnit 
                                                               | NSMinuteCalendarUnit) 
                                                     fromDate:fireDate];
    
    NSInteger nowCheck = ( componentsToday.hour * 60 ) + componentsToday.minute;
    NSInteger alarmCheck = ( componentsAlarm.hour * 60 ) + componentsAlarm.minute;
    
    // check time interval
    if ((alarmCheck - nowCheck) % period == 0) {
        // should not alert for future
        if (nowCheck - alarmCheck >= 0) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isAlarmWeekdayEqualToCurrentDay:(Alarm *)a
{
    if([a.repeatDayFlag characterAtIndex:MAX([a currentWeekDay] - 1,0)] == '1') {
        return YES;
    }
    
    return NO;
}

- (BOOL)isNowDateEqualToAlarmDate:(NSDate *)fireDate
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * componentsToday = [calendar components:(NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:today];
    NSDateComponents * componentsAlarm = [calendar components:(NSWeekdayCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:fireDate];
    
    if (componentsToday.hour == componentsAlarm.hour && componentsToday.minute == componentsAlarm.minute) {
        return YES;
    }
    
    return NO;
}

- (BOOL)alarmTest:(Alarm *)a
{
    // check whether alarm should be alert
    // alarmCheck, nowCheck -> in second
    
    // check alert
    if (![a shouldAlert]) {
        return NO;
    }
    
    // check repeat
    NSString *repeatTimeFlags = [a repeatTimeFlag];
    NSString *repeatDayFlags = [a repeatDayFlag];
    
    BOOL isTimeRepeat = ![repeatTimeFlags isEqualToString:TIME_FLAG_DEFAULT];
    BOOL isDayRepeat = ![repeatDayFlags isEqualToString:DAY_FLAG_DEFAULT];
    
    // no repeat
    if (isTimeRepeat == NO && isDayRepeat == NO) {
        BOOL shouldAlert = [self isNowDateEqualToAlarmDate:a.fireDate];   
        if (shouldAlert) {
            a.repeatFlag = [NSNumber numberWithBool:NO];
            [APPDELEGATE saveContext];
        }
        return shouldAlert;
        
    } else {
    
        BOOL shouldAlert;
        if (isTimeRepeat && !isDayRepeat) {
            // time repeat
            shouldAlert = [self isNowDateEqualToAlarmDate:a.fireDate withTimePeriod:[a repeatTimeInMinutes]];
        } else if (isDayRepeat && !isTimeRepeat) {
            // day repeat
            BOOL isEqualToAlarmWeekday = [self isAlarmWeekdayEqualToCurrentDay:a];
            BOOL isEqualToNowTime =[ self isNowDateEqualToAlarmDate:a.fireDate];
            shouldAlert = isEqualToAlarmWeekday && isEqualToNowTime;
        } else {
            // time + day repeat
            BOOL isEqualToAlarmWeekday = [self isAlarmWeekdayEqualToCurrentDay:a];
            BOOL isEqualToNowDate = [self isNowDateEqualToAlarmDate:a.fireDate withTimePeriod:[a repeatTimeInMinutes]];
            shouldAlert = isEqualToAlarmWeekday && isEqualToNowDate;
        }
        
        if (shouldAlert) {
            
            a.repeatFlag = [NSNumber numberWithBool:NO];
            [APPDELEGATE saveContext];
            
            [self performSelector:@selector(repeatCooldown:) withObject:a afterDelay:60];
            return shouldAlert;
        }
    }
    
    return NO;
}

- (void)checkAlarm
{
    if (![self fetchAlarm]) return;

    for (Alarm *alarmObject in alarms) {
        
        BOOL shouldAlert = [self alarmTest:alarmObject];
        
        if (shouldAlert) {
            
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:alarmObject, @"kAlarm", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:alarmServicesWillAlert object:nil userInfo:userInfo];
            [APPDELEGATE saveContext];
        }
    }    
}

- (void)repeatCooldown:(Alarm *)a
{
    a.repeatFlag = [NSNumber numberWithBool:YES];
    [APPDELEGATE saveContext];
    NSLog(@"cooldown for alarm %@", a.fireDate);
}

- (BOOL)fetchAlarm
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Alarm" 
                                              inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    
    // Query all alarms
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    
    NSError *error;
    alarms = [[APPDELEGATE managedObjectContext] executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"cannot fetch alarm objects from database.");
        return NO;
    }
    
    return [alarms count] > 0 ? YES : NO;
}

#warning should not use setAlarm for method name
- (void)setAlarm 
{
    for (int i=0; i<alarms.count; i++) {
        
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];

        Alarm *localNotifFireDate = [alarms objectAtIndex:i];

        localNotif.alertBody = localNotifFireDate.title;
        localNotif.alertAction = NSLocalizedString(@"View Details", nil);
        localNotif.fireDate = localNotifFireDate.fireDate;
        NSLog(@"%@",localNotifFireDate.fireDate);

        NSArray *object = [[NSArray alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@",localNotifFireDate.fireDate]];
        NSArray *key = [[NSArray alloc]initWithContentsOfFile:@"notif"];
        localNotif.userInfo = [[NSDictionary alloc]initWithObjects:object forKeys:key];
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
}

#define ALARMFILE @"ALARMFILE"
- (BOOL)isAlarmEnable
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *documentsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentsDir lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:ALARMFILE];
    
    BOOL fileExisted = [fm fileExistsAtPath:filePath];
    
    if (fileExisted) {
        // Read from file
        NSError *error;
        NSString *contentAlarm = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"contentAlarm");
        
        if ([contentAlarm isEqualToString:@"1"]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)setEnableAlarm:(BOOL)enable
{
    NSArray *documentsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentsDir lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:ALARMFILE];
    
    NSString *boolFlag = enable ? @"1" : @"0";
    
    NSError *error;
    BOOL writeFlag = [boolFlag writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (writeFlag) {
        NSLog(@"Write successful");
    }
}

@end
