//
//  KGGJPushManager.m
//  kuaigong
//
//  Created by Ding on 2017/11/22.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGJPushManager.h"
#import "JPUSHService.h"
#import <RongIMKit/RongIMKit.h>
#import "JANALYTICSService.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface KGGJPushManager()<JPUSHRegisterDelegate>

@end

@implementation KGGJPushManager

+ (KGGJPushManager *)shareJPushManager
{
    static KGGJPushManager *JPushTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JPushTool = [[KGGJPushManager alloc]init];
    });
    return JPushTool;
}

// 在应用启动的时候调用
- (void)cdm_setupWithOption:(NSDictionary *)launchingOption
                     appKey:(NSString *)appKey
                    channel:(NSString *)channel
           apsForProduction:(BOOL)isProduction
      advertisingIdentifier:(NSString *)advertisingId
{
    
    JANALYTICSLaunchConfig *config = [[JANALYTICSLaunchConfig alloc]init];
    config.appKey = appKey;
    config.channel = channel;
    [JANALYTICSService setupWithConfig:config];
    [JANALYTICSService crashLogON];
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        
        JPUSHRegisterEntity * entity =[[JPUSHRegisterEntity alloc]init];
        entity.types = (UNAuthorizationOptionAlert|UNAuthorizationOptionBadge| UNAuthorizationOptionSound);
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
//    如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
        [JPUSHService setupWithOption:launchingOption appKey:appKey
                              channel:channel
                     apsForProduction:isProduction
                advertisingIdentifier:advertisingId];
    return;
    
}
// 在appdelegate注册设备处调用
- (void)cdm_registerDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    KGGLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    [[RCIMClient sharedRCIMClient]setDeviceToken:token];
    return;
}

//设置角标
- (void)cdm_setBadge:(int)badge
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    [JPUSHService setBadge:badge];
}

//获取注册ID
- (void)cdm_getRegisterIDCallBack:(void(^)(NSString *registerID))completionHandler
{
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if (resCode == 0) {
            
            KGGLog(@"registrationID获取成功：%@",registrationID);
            
            completionHandler(registrationID);
        }
    }];
}

//处理推送信息
- (void)cdm_handleRemoteNotification:(NSDictionary *)remoteInfo
{
    [JPUSHService handleRemoteNotification:remoteInfo];
    KGGLog(@"%@",remoteInfo);
    [self cdm_setBadge:0];
}

#pragma mark JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler
{
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self cdm_handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self cdm_handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);  // 系统要求执行这个方法
}

//注册别名
- (void)cmd_registerAliasPhone:(NSString *)phone
{
    [JPUSHService setAlias:phone completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (iResCode == 0) {
            KGGLog(@"设置别名%ld %@",(long)iResCode,iAlias);
        }
        
    } seq:200];
}

//删除别名
- (void)cmd_deleteAliasPhone:(NSString *)phone
{
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (iResCode == 0) {
            KGGLog(@"删除别名%ld %@",(long)iResCode,iAlias);
        }
    } seq:200];
}

//注册标签
- (void)cmd_registerTags:(NSSet *)tags
{
    [JPUSHService setTags:tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        if (iResCode == 0) {
            KGGLog(@"设置标签%ld %@",(long)iResCode,iTags);
        }
    } seq:200];
}

//删除标签
- (void)cmd_deleteTags:(NSSet *)tags
{
    [JPUSHService deleteTags:tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        if (iResCode == 0) {
            KGGLog(@"删除标签%ld %@",(long)iResCode,iTags);
        }
        
    } seq:200];
}

@end
