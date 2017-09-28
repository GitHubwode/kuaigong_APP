//
//  AppDelegate+KGGRongCloud.m
//  kuaigong
//
//  Created by Ding on 2017/9/5.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "AppDelegate+KGGRongCloud.h"
#import "KGGRongCloudModel.h"
#import <RongIMKit/RongIMKit.h>

@implementation AppDelegate (KGGRongCloud)

- (void)setUpRongCloud{
    
    [KGGRongCloudModel kgg_initRongCloudAppkey];
    [KGGRongCloudModel kgg_initRongCloudLogin];
    
    [KGGNotificationCenter addObserver:self selector:@selector(accountOfflineNotification:) name:KGGConnectionStatusOffLine object:nil];
    // 连接融云的通知
    [KGGNotificationCenter addObserver:self selector:@selector(updateBadgeValueForTabBarItem) name:KGGConnectRongCloudSuccess object:nil];
    // 退出登录的通知
    [KGGNotificationCenter addObserver:self selector:@selector(logoutNoti) name:KGGUserLogoutNotifacation object:nil];
}

- (void)accountOfflineNotification:(NSNotification *)noti{
    
//    [SNHLoginRequestManager logout];
//    
//    NSString *obj = noti.object;
//    
//    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
//    UINavigationController *nav = (UINavigationController *)tabBarController.selectedViewController;
//    
//    [nav popToRootViewControllerAnimated:YES];
//    
//    UIViewController *currentVC = nav.visibleViewController;
//    SNHLoginViewController *login = [[SNHLoginViewController alloc]init];
//    if (obj.length) {
//        login.offline = 2;
//    }else{
//        login.offline = 1;
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [currentVC presentViewController:[[SNHNavigationController alloc]initWithRootViewController:login] animated:YES completion:nil];
//    });
    
}

- (void)updateBadgeValueForTabBarItem {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int count = [[RCIMClient sharedRCIMClient]
                     getTotalUnreadCount];
        if (count > 0) {
            [KGGNotificationCenter postNotificationName:KGGShowAlertNotifacation object:@"1"];
        } else {
            [KGGNotificationCenter postNotificationName:KGGHidenAlertNotifacation object:@"1"];
        }
    });
}

- (void)logoutNoti{
    [[RCIM sharedRCIM] disconnect:NO];
}

@end
