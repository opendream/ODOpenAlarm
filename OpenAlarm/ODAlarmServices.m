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
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Alarm" inManagedObjectContext:[APPDELEGATE managedObjectContext]];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entity];
        alarm = [[APPDELEGATE managedObjectContext] executeFetchRequest:request error:nil];

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
    //NSLog(@"checkAlarm");

    for (int i=0; i<alarm.count; i++) {
        
        NSString *title = [[alarm objectAtIndex:i] valueForKey:@"title"];
        NSDate *dateAlarm = [[alarm objectAtIndex:i] valueForKey:@"fireDate"];
        NSDate *today = [NSDate date] ;
//        NSLog(@"%@",dateAlarm);
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents * componentsToday = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:today];
        NSDateComponents * componentsAlarm = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:dateAlarm];
        NSArray *key = [[NSArray alloc]initWithObjects:@"fireDate", @"title",nil];
        NSArray *object = [[NSArray alloc]initWithObjects:dateAlarm,title,nil];
        
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:object forKeys:key];
        
        
        if ( componentsAlarm.minute == componentsToday.minute && componentsAlarm.hour == componentsToday.hour ) {
            alarmCount++;
            if (alarmCount == 1) {
                NSLog(@"%@  ==  %@", today, dateAlarm);
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"title" message:@"message" delegate:self cancelButtonTitle:@"Snooze" otherButtonTitles:@"OK", nil];
//                [alert show];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:alarmServicesWillAlert object:nil userInfo:userInfo];
                
            }
            else if (alarmCount >= 60) {
                alarmCount = 0;
            }
        }
    }
    
    self.counter += 2;
    
    if (self.counter == 20) {
        //[[NSNotificationCenter defaultCenter] postNotificationName:alarmServicesWillAlert object:nil];
    }
}
- (void)fetchAlarm{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Alarm" inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    alarm = [[APPDELEGATE managedObjectContext] executeFetchRequest:request error:nil];
}
@end
