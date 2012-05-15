//
//  ODAlarmServices.h
//  OpenAlarm
//
//  Created by Pirapa on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"

extern NSString *alarmServicesWillAlert;

@interface ODAlarmServices : NSObject {
    NSArray *alarms;
}

@property (nonatomic, strong) NSArray *alarms;

+ (id)sharedAlarmServices;

- (NSArray *)fetchAllAlarms;

- (BOOL)alarmTest:(Alarm *)alarm;

- (BOOL)isAlarmEnable;
- (void)setEnableAlarm:(BOOL)enable;

- (void)alertWithSound:(NSString *)soundName withSoundType:(NSString *)soundType;

- (void)scheduleLocalNotificationsForAlarms:(NSArray *)scheduleAlarms;
- (void)scheduleLocalNotificationsForAllAlarms;
@end
