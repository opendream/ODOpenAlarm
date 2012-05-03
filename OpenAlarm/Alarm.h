//
//  Alarm.h
//  OpenAlarm
//
//  Created by Pirapa on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Alarm : NSManagedObject

@property (nonatomic, retain) NSDate * fireDate;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * repeatPeriod;
@property (nonatomic, retain) NSNumber * snoozePeriod;
@property (nonatomic, retain) NSString * sound;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * video;

@end
