//
//  NSObject+swizzle.m
//  kuaigong
//
//  Created by Ding on 2017/9/5.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "NSObject+swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (swizzle)

void xc_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)   {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
