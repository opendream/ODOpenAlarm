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

@interface ODAlarmServices : NSObject{
    NSArray *alarm;
    int alarmCount;
}

@property (nonatomic, assign) float counter;

+ (id)sharedAlarmServices;

@end
