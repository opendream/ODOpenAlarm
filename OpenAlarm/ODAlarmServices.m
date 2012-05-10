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

- (id)init
{
    self = [super init];
    if (self) {
        self.counter = 10;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkAlarm) userInfo:nil repeats:YES];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fetchAlarm) userInfo:nil repeats:YES];
        alarmServicesWillAlert = @"alarmServicesWillAlert";
        alarmCount = 0;
        
        [self fetchAlarm];
        [self setAlarm];
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

- (void)checkAlarm
{
//    NSLog(@"checkAlarm");

    for (int i=0; i<alarm.count; i++) {
        
        NSString *title = [[alarm objectAtIndex:i] valueForKey:@"title"];
        NSDate *dateAlarm = [[alarm objectAtIndex:i] valueForKey:@"fireDate"];
        NSString *repeatPeriod = [[alarm objectAtIndex:i] valueForKey:@"repeatPeriod"];
        NSDate *today = [NSDate date] ;
//        NSLog(@"%@",dateAlarm);
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents * componentsToday = [calendar components:(NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:today];
        NSDateComponents * componentsAlarm = [calendar components:(NSWeekdayCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:dateAlarm];
        NSArray *key = [[NSArray alloc]initWithObjects:@"fireDate", @"title",nil];
        NSArray *object = [[NSArray alloc]initWithObjects:dateAlarm,title,nil];
        
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:object forKeys:key];
        
//        NSLog(@"repeat Period ::  %@", repeatPeriod);
        char checkRepeatPeriod;
        int counterRepeat = 0;
        for(int i = 0;i<[repeatPeriod length];i++)
        {
            checkRepeatPeriod = [repeatPeriod characterAtIndex:i];
            if (checkRepeatPeriod == '1') {
                switch (i) {
                    case 0:
                        
                        
                        
                        //NSLog(@"%d", i);
                        if ( componentsAlarm.minute == componentsToday.minute && componentsAlarm.hour == componentsToday.hour ) {
                            alarmCount++; 
                            if (alarmCount == 1) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:alarmServicesWillAlert object:nil userInfo:userInfo];
                            }
                            else if (alarmCount >= 60) {
                                alarmCount = 0;
                            }
                        }                
                        break;
                    case 1:
                        //NSLog(@"%d", i);
                        break;
                    case 2:
                        //NSLog(@"%d", i);
                        break;
                    case 3:
                        //NSLog(@"%d", i);
                        break;
                    case 4:
                        //NSLog(@"%d", i);
                        break;
                    case 5:
                        //NSLog(@"%d", i);
                        break;
                    case 6:
                        //NSLog(@"%d", i);
                        break;
                    case 7:
                        //NSLog(@"%d", i);
                        break;
                    case 8:
                        //NSLog(@"%d", i);
                        break;
                    case 9:
                        //NSLog(@"%d", i);
                        break;
                    default:
                        break;
                }
            }else if (checkRepeatPeriod == '0') {
                counterRepeat++;
            }
        }
        if (counterRepeat == [repeatPeriod length]) {
            if ( componentsAlarm.minute == componentsToday.minute && componentsAlarm.hour == componentsToday.hour ) {
                alarmCount++;
                if (alarmCount == 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:alarmServicesWillAlert object:nil userInfo:userInfo];
                }
                else if (alarmCount >= 60) {
                    alarmCount = 0;
                }
            }
        }
    NSLog(@"%d",alarmCount);
      
    }
}

- (void)fetchAlarm{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Alarm" inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    alarm = [[APPDELEGATE managedObjectContext] executeFetchRequest:request error:nil];
}

- (void)setAlarm {
    for (int i=0; i<alarm.count; i++) {
        
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        Alarm *localNotifFireDate = [alarm objectAtIndex:i];
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
