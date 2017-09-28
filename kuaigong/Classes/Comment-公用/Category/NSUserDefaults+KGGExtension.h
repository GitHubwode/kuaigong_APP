//
//  NSUserDefaults+KGGExtension.h
//  kuaigong
//
//  Created by Ding on 2017/8/16.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (KGGExtension)

+ (void)setObject:(id)value forKey:(NSString *)defaultName;
+ (id)objectForKey:(NSString *)defaultName;
+ (BOOL)synchronize;
+ (void)removeObjectForKey:(NSString *)defaultName;

@end
