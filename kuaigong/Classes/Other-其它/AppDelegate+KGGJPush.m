//
//  AppDelegate+KGGJPush.m
//  kuaigong
//
//  Created by Ding on 2017/9/13.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "AppDelegate+KGGJPush.h"

@implementation AppDelegate (KGGJPush)

- (void)setupJPush:(NSDictionary *)launchOptions
{
    if (launchOptions) {
        NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
//        NSString *uri = remoteNotification[@"uri"];
        
        
        
    }
}

@end
