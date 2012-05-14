//
//  ODSound.m
//  OpenAlarm
//
//  Created by Methuz Kaewsai-kao on 5/14/55 BE.
//  Copyright (c) 2555 joinstick.net@gmail.com. All rights reserved.
//

#import "ODSound.h"

@implementation ODSound
@synthesize name, type;

- (id)initWithSoundName:(NSString *)n andType:(NSString *)t
{
    self = [super init];
    if (self) {
        name = n;
        type = t;
    }
    return self;
}

+ (id)soundName:(NSString *)n andType:(NSString *)t
{
    return [[ODSound alloc] initWithSoundName:n andType:t];
}

@end
