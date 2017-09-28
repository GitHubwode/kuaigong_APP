//
//  AppDelegate.m
//  kuaigong
//
//  Created by Ding on 2017/8/15.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "AppDelegate.h"
#import "KGGTabBarController.h"
#import "AppDelegate+KGGGuide.h"          
#import "KGGLoginViewController.h"
#import "KGGNavigationController.h"
#import "AppDelegate+KGGRongCloud.h"

//测试极光推送
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>


@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //停留多长时间
    [NSThread sleepForTimeInterval:1];
    
    //设置窗口的根控制器
    [self setUpRootViewControllver];
    //显示窗口
    [self.window makeKeyAndVisible];
    
    KGGLog(@"bundle id :%@",[[NSBundle mainBundle] bundleIdentifier]);
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:KGGJPushAPPKey
                          channel:@"kg-channel"
                 apsForProduction:YES
            advertisingIdentifier:advertisingId];
    //链接融云
    [self setUpRongCloud];
    
    
    
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 9.0以前调用支付宝客户端支付回调
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    KGGLog(@"%@",url);
    
//    if ([url.host isEqualToString:@"safepay"]) {
//        [self snh_aliPayResultHandle:url];
//        
//        [self snh_aliAutoCodeResultHandle:url];
//    }
//    
//    if ([url.host isEqualToString:@"platformapi"]) {
//        [self snh_aliAutoCodeResultHandle:url];
//    }
//    
//    
//    if ([[url scheme] isEqualToString:kWeiXinPayURLScheme]) {
//        return [WXApi handleOpenURL:url delegate:self];
//    }
    
    return YES;
}

#pragma mark -9.0以后调用支付宝客户端支付回调
- (BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        [self snh_aliPayResultHandle:url];
        [self snh_aliAutoCodeResultHandle:url];
    }
    
    if ([url.host isEqualToString:@"platformapi"]) {
        [self snh_aliAutoCodeResultHandle:url];
    }
//    
//    if ([[url scheme] isEqualToString:kWeiXinPayURLScheme]) {
//        return [WXApi handleOpenURL:url delegate:self];
//    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//    if ([[url scheme]isEqualToString:kWeiXinPayURLScheme]) {
//        return [WXApi handleOpenURL:url delegate:self];
//    }
    return NO;
}


#pragma mark - WXApiDelegate

//- (void)onResp:(BaseResp *)resp
//{
////    NSString *strTitle;
////    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
////        strTitle = [NSString stringWithFormat:@"发送媒体信息结果"];
////    }
////    if ([resp isKindOfClass:[PayResp class]]) {
////        NSString *code = [NSString stringWithFormat:@"%d",resp.errCode];
////        [SNHNotificationCenter postNotificationName:SNHPayWeiXinNotification object:code];
////    }
//}

#pragma mark - 请求调起支付宝支付的地方回调该方法
- (void)snh_aliPayResultHandle:(NSURL *)url
{
//    SNHLog(@"url:%@",url);
//    
//    [[AlipaySDK defaultService]processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//        SNHLog(@"resultDic:%@",resultDic);
//        [SNHNotificationCenter postNotificationName:SNHPayBlackNotification object:self userInfo:resultDic];
//    }];
}

#pragma mark - 授权跳转回调结果
- (void)snh_aliAutoCodeResultHandle:(NSURL *)url
{
//    [[AlipaySDK defaultService]processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//        SNHLog(@"认证的结果result = %@",resultDic);
//    }];
//    
//    //     授权跳转支付宝钱包进行支付，处理支付结果
//    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//        
//        SNHLog(@"result = %@",resultDic);
//        
//        SNHLog(@"%@",resultDic[@"memo"]);
//        
//        // 解析 auth code
//        NSString *result = resultDic[@"result"];
//        NSString *authCode = nil;
//        if (result.length>0) {
//            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//            for (NSString *subResult in resultArr) {
//                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                    authCode = [subResult substringFromIndex:10];
//                    break;
//                }
//            }
//        }
//        SNHLog(@"授权结果 authCode = %@", authCode?:@"");
//    }];
}




@end
