
//
//  ODAlarmServices.m
//  OpenAlarm
//
//  Created by Pirapa on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODAlarmServices.h"
#import <AudioToolbox/AudioServices.h>

@implementation ODAlarmServices

NSString *alarmServicesWillAlert;

static ODAlarmServices *shareAlarmService = nil;

@synthesize alarms;

- (id)init
{
    self = [super init];
    if (self) {
        // notification center
        alarmServicesWillAlert = @"alarmServicesWillAlert";
        
        // timer
        [self fetchAllAlarms];

        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkAlarm) userInfo:nil repeats:YES];
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

- (BOOL)alarmTest:(Alarm *)alarm;
{
    // check whether alarm should be alert
    // alarmCheck, nowCheck -> in second
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents * componentsToday = [calendar components:(NSSecondCalendarUnit) 
                                                     fromDate:today];
    
    // check alert
    if (![alarm shouldAlert]) {
        return NO;
    }
    if (![self isAlarmEnable]) {
        return NO;
    }
    // check repeat
    NSString *repeatTimeFlags = [alarm repeatTimeFlag];
    NSString *repeatDayFlags = [alarm repeatDayFlag];
    
    BOOL isTimeRepeat = ![repeatTimeFlags isEqualToString:TIME_FLAG_DEFAULT];
    BOOL isDayRepeat = ![repeatDayFlags isEqualToString:DAY_FLAG_DEFAULT];
    
    // no repeat
    if (isTimeRepeat == NO && isDayRepeat == NO) {
        BOOL shouldAlert = [self isNowDateEqualToAlarmDate:alarm.fireDate];   
        if (shouldAlert) {
            alarm.repeatFlag = [NSNumber numberWithBool:NO];
            [APPDELEGATE saveContext];
            
            [self performSelector:@selector(repeatCooldown:) withObject:alarm afterDelay:60 - componentsToday.second];
        }
        return shouldAlert;
        
    } else {
    
        BOOL shouldAlert;
        if (isTimeRepeat && !isDayRepeat) {
            // time repeat
            shouldAlert = [self isNowDateEqualToAlarmDate:alarm.fireDate withTimePeriod:[alarm repeatTimeInMinutes]];
        } else if (isDayRepeat && !isTimeRepeat) {
            // day repeat
            BOOL isEqualToAlarmWeekday = [self isAlarmWeekdayEqualToCurrentDay:alarm];
            BOOL isEqualToNowTime =[ self isNowDateEqualToAlarmDate:alarm.fireDate];
            shouldAlert = isEqualToAlarmWeekday && isEqualToNowTime;
        } else {
            // time + day repeat
            BOOL isEqualToAlarmWeekday = [self isAlarmWeekdayEqualToCurrentDay:alarm];
            BOOL isEqualToNowDate = [self isNowDateEqualToAlarmDate:alarm.fireDate withTimePeriod:[alarm repeatTimeInMinutes]];
            shouldAlert = isEqualToAlarmWeekday && isEqualToNowDate;
        }
        
        if (shouldAlert) {
            
            alarm.repeatFlag = [NSNumber numberWithBool:NO];    
            [APPDELEGATE saveContext];
            
            [self performSelector:@selector(repeatCooldown:) withObject:alarm afterDelay:60 - componentsToday.second];
            return shouldAlert;
        }
    }
    
    return NO;
}

- (void)checkAlarm
{
    NSArray *allAlarms = [self fetchAllAlarms];
    
    for (Alarm *alarm in allAlarms) {
        
        BOOL shouldAlert = [self alarmTest:alarm];
        
        if (shouldAlert) {
            
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:alarm, @"kAlarm", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:alarmServicesWillAlert object:nil userInfo:userInfo];
        
            [self alertWithSoundString:[alarm sound]];
        }
    }    
}

- (void)repeatCooldown:(Alarm *)a
{
    a.repeatFlag = [NSNumber numberWithBool:YES];
    [APPDELEGATE saveContext];
    NSLog(@"cooldown for alarm %@", a.fireDate);
}

- (NSArray *)fetchAllAlarms
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"fireDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Alarm" 
                                              inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    
    
    // Query all alarms
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *allAlarms = [[APPDELEGATE managedObjectContext] executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"cannot fetch alarm objects from database.");
        return nil;
    }
    
    alarms = allAlarms;
    return allAlarms;
}

- (void)scheduleLocalNotificationsForAlarms:(NSArray *)scheduleAlarms
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents * componentsToday = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | 
                                                               NSDayCalendarUnit | NSWeekdayCalendarUnit | 
                                                               NSHourCalendarUnit | NSMinuteCalendarUnit | 
                                                               NSSecondCalendarUnit) 
                                                     fromDate:today];
    
    for (Alarm *alarm in scheduleAlarms) {
        if ([self shouldAlertLocalNotification:alarm] == YES) {
            NSDateComponents * componentsfireDate = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | 
                                                                          NSDayCalendarUnit | NSWeekdayCalendarUnit | 
                                                                          NSHourCalendarUnit | NSMinuteCalendarUnit | 
                                                                          NSSecondCalendarUnit) 
                                                                        fromDate:alarm.fireDate];
            [componentsfireDate setYear:componentsToday.year];
            [componentsfireDate setMonth:componentsToday.month];
            [componentsfireDate setDay:componentsToday.day];
            [componentsfireDate setWeekday:componentsToday.weekday];
            
            NSDate *fireDate = [calendar dateFromComponents:componentsfireDate];
            
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            localNotif.alertBody = alarm.title;
            localNotif.alertAction = NSLocalizedString(@"View Details", nil);
            localNotif.fireDate = fireDate;
            
            NSArray *object = [[NSArray alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@",alarm.fireDate]];
            NSArray *key = [[NSArray alloc]initWithContentsOfFile:@"notif"];
            localNotif.userInfo = [[NSDictionary alloc]initWithObjects:object forKeys:key];
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
            
        }
    }
}

- (void)scheduleLocalNotificationsForAllAlarms
{
    if ([self isAlarmEnable]) {
        [self scheduleLocalNotificationsForAlarms:alarms];
    }
}

- (BOOL)shouldAlertLocalNotification :(Alarm *)a
{
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents * componentsToday = [calendar components:(NSWeekdayCalendarUnit | NSHourCalendarUnit 
                                                               | NSMinuteCalendarUnit | NSSecondCalendarUnit) 
                                                     fromDate:today];
    
    NSDateComponents * componentsAlarm = [calendar components:(NSWeekdayCalendarUnit |  NSHourCalendarUnit 
                                                               | NSMinuteCalendarUnit) 
                                                     fromDate:a.fireDate];
    
    NSInteger nowCheck = ( componentsToday.hour * 60 ) + componentsToday.minute;
    NSInteger alarmCheck = ( componentsAlarm.hour * 60 ) + componentsAlarm.minute;
    
    return nowCheck < alarmCheck;
}

- (void)setAlarmUptoDate
{
    NSArray *allAlarms = [self fetchAllAlarms];
    
    for (Alarm *alarm in allAlarms) {
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *nowDateComps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | 
                                                            NSDayCalendarUnit | NSWeekCalendarUnit |
                                                            NSHourCalendarUnit | NSMinuteCalendarUnit
                                                            | NSSecondCalendarUnit) 
                                                  fromDate:nowDate];
        
        NSDateComponents *fireDateComps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | 
                                                            NSDayCalendarUnit | NSWeekCalendarUnit |
                                                            NSHourCalendarUnit | NSMinuteCalendarUnit
                                                            | NSSecondCalendarUnit) 
                                                            fromDate:alarm.fireDate];
        [fireDateComps setYear:nowDateComps.year];

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

#pragma mark - AudioToolBox

- (void)alertWithSound:(NSString *)soundName withSoundType:(NSString *)soundType
{
    // Create the URL for the source audio file. The URLForResource:withExtension: method is
    //    new in iOS 4.0.
    NSFileManager *fm = [NSFileManager defaultManager];

    NSURL *tapSound   = [[NSBundle mainBundle] URLForResource:soundName withExtension:soundType]; //@"tap.aif"
    
    NSLog(@"url for sound %@", tapSound);
    
    if (![fm fileExistsAtPath:[tapSound path]]) {
        NSLog(@"File does not exist at path %@", [tapSound path]);
        tapSound   = [[NSBundle mainBundle] URLForResource:@"tap" withExtension:@"aif"]; //@"tap.aif"
    }    
    
    CFURLRef		soundFileURLRef;
    SystemSoundID	soundFileObject;
    // Store the URL as a CFURLRef instance
    soundFileURLRef = (__bridge CFURLRef)tapSound;
    
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (soundFileURLRef, &soundFileObject);
    
    AudioServicesPlayAlertSound (soundFileObject);
    
    [self performSelector:@selector(vibratePhone) withObject:nil afterDelay:0];
    [self performSelector:@selector(vibratePhone) withObject:nil afterDelay:1.0];
}

- (void)alertWithSoundString:(NSString *)soundString
{
    NSArray *soundArray = [soundString componentsSeparatedByString:@"."];
    
    if ([soundArray count] > 1)
        [self alertWithSound:[soundArray objectAtIndex:0] withSoundType:[soundArray objectAtIndex:1]];
    else
        NSLog(@"split string error!");
    
}

- (void)vibratePhone
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
