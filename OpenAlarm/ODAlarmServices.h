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
    NSArray *alarms;
    int alarmCount;
}

@property (nonatomic, strong) NSArray *alarms;
@property (nonatomic, assign) float counter;

+ (id)sharedAlarmServices;

- (BOOL)fetchAlarm;
- (BOOL)alarmTest:(Alarm *)a;

- (BOOL)isAlarmEnable;
- (void)setEnableAlarm:(BOOL)enable;
@end

////////////////////////// TODO ////////////////////////////
// - Move saveAlarmToDB and updateAlarmToDB to services
// - Create alarm's label or message view
// - Add photo/sound/video
