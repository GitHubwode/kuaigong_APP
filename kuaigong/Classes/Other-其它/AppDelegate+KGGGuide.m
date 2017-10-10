//
//  AppDelegate+KGGGuide.m
//  kuaigong
//
//  Created by Ding on 2017/8/16.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "AppDelegate+KGGGuide.h"
#import "KGGTabBarController.h"
#import "KGGTabBarWorkController.h"
#import "KGGNewFeatureViewController.h"

#import "KGGLoginViewController.h"
#import "KGGNavigationController.h"

static NSString *const KGGLastVersionKey = @"KGGLastVersion";


@implementation AppDelegate (KGGGuide)

- (void)setUpRootViewControllver
{
    UIViewController *rootVc;
    // 定义一个窗口的根控制器
    if ([[KGGUserManager shareUserManager].currentUser.type isEqualToString:@"BOSS"]) {
        rootVc = [[KGGTabBarController alloc] init];
        self.window.rootViewController  = rootVc;
    }else{
        rootVc = [[KGGTabBarWorkController alloc] init];
        self.window.rootViewController  = rootVc;
    }

    // 获取当前的最新版本号 2.0
//    NSString *curVersion =  [NSBundle currentVersion];
    
    // 获取上一次的版本号  1.0.1
    NSString *oldVersion = [NSUserDefaults objectForKey:KGGLastVersionKey];
    
    if (![KGGUserManager shareUserManager].logined) {
    
//        [NSUserDefaults setObject:curVersion forKey:KGGLastVersionKey];
        
        KGGNewFeatureViewController *newFeatureVc = [[KGGNewFeatureViewController alloc] initWithNibName:NSStringFromClass([KGGNewFeatureViewController class]) bundle:[NSBundle mainBundle]];
        
        newFeatureVc.view.frame = [UIScreen mainScreen].bounds;
        [rootVc.view addSubview:newFeatureVc.view];
        [rootVc addChildViewController:newFeatureVc];
    }
    
}

@end
