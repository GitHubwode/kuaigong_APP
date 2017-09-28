//
//  KGGSliderMenuTool.m
//  kuaigong
//
//  Created by Ding on 2017/8/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGSliderMenuTool.h"
#import "KGGNavigationController.h"
#import "KGGLeftDrawerViewController.h"

static UIWindow *window;

@implementation KGGSliderMenuTool

/**
 显示侧边栏
 */
+ (void)showWithRootViewController:(UIViewController *)rootViewController contentViewController:(UIViewController *)contentViewController {
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.hidden = NO;
    window.backgroundColor = [UIColor clearColor];
    
    KGGLeftDrawerViewController *vc = [[KGGLeftDrawerViewController alloc] initWithRootViewController:rootViewController contentViewController:contentViewController];
    
    KGGNavigationController *nav = [[KGGNavigationController alloc] initWithRootViewController:vc];
    window.rootViewController = nav;
    [window addSubview:vc.view];
}


/**
 隐藏侧边栏
 */
+ (void)kgg_Sliderdismiss {
    window.hidden = YES;
    window.rootViewController = nil;
    window = nil;
}

@end
