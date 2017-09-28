//
//  UIButton+Countdown.m
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "UIButton+Countdown.h"

@implementation UIButton (Countdown)

/**
 *  倒计时
 *
 *  @param startTime 倒计时总时间
 *  @param title    还没倒计时的title
 *  @param subTitle 倒计时中的子名字，如时、分
 *  @param normalColor   还没倒计时的颜色
 *  @param coundowntColor    倒计时中的颜色
 */
- (void)startWithTime:(NSInteger)startTime title:(NSString *)title subTitle:(NSString *)subTitle normalBackgroundColor:(UIColor *)normalColor coundownBackgroundColor:(UIColor *)coundowntColor completion:(void(^)())completionHandler{
    
    //倒计时时间
    __block NSInteger timeOut = startTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = normalColor;
                [self setTitle:title forState:UIControlStateNormal];
                [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
                if (completionHandler) {
                    completionHandler();
                }
            });
        } else {
            int allTime = (int)startTime + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = coundowntColor;
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                [self setTitleColor:KGGTitleTextColor forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}


@end
