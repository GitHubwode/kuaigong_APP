//
//  NSBundle+KGGExtension.m
//  kuaigong
//
//  Created by Ding on 2017/8/16.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "NSBundle+KGGExtension.h"

@implementation NSBundle (KGGExtension)

+ (NSString *)currentVersion
{
    return [self mainBundle].infoDictionary[@"CFBundleShortVersionString"];

}

@end
