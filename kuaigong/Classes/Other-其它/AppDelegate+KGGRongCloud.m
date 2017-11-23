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

@interface AppDelegate()<RCIMReceiveMessageDelegate, RCIMConnectionStatusDelegate>


@end

@implementation AppDelegate (KGGRongCloud)

- (void)setUpRongCloud{
    
    [KGGRongCloudModel kgg_initRongCloudAppkey];
    [KGGRongCloudModel kgg_initRongCloudLogin];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
}

- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left
{
    // 收到消息的通知
    [self updateBadgeValueForTabBarItem];
    KGGLog(@"融云接收到消息通知");
}

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status
{
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        [KGGNotificationCenter postNotificationName:KGGConnectionStatusOffLine object:nil userInfo:nil];
    }
}

- (void)updateBadgeValueForTabBarItem {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int count = [[RCIMClient sharedRCIMClient]
                     getTotalUnreadCount];
        if (count > 0) {
            [KGGNotificationCenter postNotificationName:KGGShowAlertNotifacation object:nil];
        } else {
            [KGGNotificationCenter postNotificationName:KGGHidenAlertNotifacation object:nil];
        }
    });
}

- (void)logoutNoti{
    [[RCIM sharedRCIM] disconnect:NO];
}

@end
