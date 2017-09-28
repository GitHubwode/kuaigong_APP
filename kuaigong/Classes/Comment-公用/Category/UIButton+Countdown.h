//
//  UIButton+Countdown.h
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Countdown)

/**
 *  倒计时
 *
 *  @param startTime 倒计时总时间
 *  @param title    还没倒计时的title
 *  @param subTitle 倒计时中的子名字，如时、分
 *  @param normalColor   还没倒计时的颜色
 *  @param coundowntColor    倒计时中的颜色
 */
- (void)startWithTime:(NSInteger)startTime title:(NSString *)title subTitle:(NSString *)subTitle normalBackgroundColor:(UIColor *)normalColor coundownBackgroundColor:(UIColor *)coundowntColor completion:(void(^)())completionHandler;

@end
