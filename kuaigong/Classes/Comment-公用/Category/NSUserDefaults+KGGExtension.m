//
//  NSUserDefaults+KGGExtension.m
//  kuaigong
//
//  Created by Ding on 2017/8/16.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "NSUserDefaults+KGGExtension.h"

@implementation NSUserDefaults (KGGExtension)

+ (void)setObject:(id)value forKey:(NSString *)defaultName{
    [[self standardUserDefaults] setObject:value forKey:defaultName];
}

+ (id)objectForKey:(NSString *)defaultName{
    return   [[self standardUserDefaults] objectForKey:defaultName];
}

+ (BOOL)synchronize{
    return [[self standardUserDefaults] synchronize];
}

+ (void)removeObjectForKey:(NSString *)defaultName{
    [[self standardUserDefaults] removeObjectForKey:defaultName];
}

@end
