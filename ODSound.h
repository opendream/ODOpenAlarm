//
//  ODSound.h
//  OpenAlarm
//
//  Created by Methuz Kaewsai-kao on 5/14/55 BE.
//  Copyright (c) 2555 joinstick.net@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODSound : NSObject
{
    NSString *name;
    NSString *type;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;

+ (id)soundName:(NSString *)name andType:(NSString *)type;

@end
