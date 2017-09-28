//
//  KGGSliderMenuTool.h
//  kuaigong
//
//  Created by Ding on 2017/8/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGSliderMenuTool : NSObject

/**
 显示侧边栏
 */
+ (void)showWithRootViewController:(UIViewController *)rootViewController contentViewController:(UIViewController *)contentViewController;

/**
 隐藏侧边栏
 */
+ (void)kgg_Sliderdismiss;


@end
