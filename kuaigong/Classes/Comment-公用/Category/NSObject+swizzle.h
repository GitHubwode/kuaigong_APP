//
//  NSObject+swizzle.h
//  kuaigong
//
//  Created by Ding on 2017/9/5.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (swizzle)
void xc_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector);

@end
