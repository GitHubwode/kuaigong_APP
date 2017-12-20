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
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import <RongIMKit/RongIMKit.h>
#import "KGGJPushManager.h"
#import "KGGTabBarWorkController.h"
#import <AdSupport/AdSupport.h>


@interface AppDelegate ()<WXApiDelegate>
{
    BMKMapManager *mapManager;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[KGGUserManager shareUserManager] autoLogin];

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //停留多长时间
//    [NSThread sleepForTimeInterval:1];
    mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
  BOOL success = [mapManager start:@"LGBN4AOWr6jWp9rAY9bgixQ4RgenEfxU"  generalDelegate:nil];
    if (success) {
        KGGLog(@"百度地图定位成功");
    }

    //设置窗口的根控制器
    [self setUpRootViewControllver];
    //显示窗口
    [self.window makeKeyAndVisible];
    
    KGGLog(@"bundle id :%@",[[NSBundle mainBundle] bundleIdentifier]);

//    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[KGGJPushManager shareJPushManager]cdm_setupWithOption:launchOptions appKey:KGGJPushAPPKey channel:@"kg-channel" apsForProduction:NO advertisingIdentifier:advertisingId];
    [[KGGJPushManager shareJPushManager] cdm_getRegisterIDCallBack:^(NSString *registerID) {
        KGGLog(@"%@",registerID);
    }];
    [[KGGJPushManager shareJPushManager] cdm_setBadge:0];
    //链接融云
    [self setUpRongCloud];
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[KGGJPushManager shareJPushManager] cdm_registerDeviceToken:deviceToken];
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    KGGLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler

{
    [[KGGJPushManager shareJPushManager] cdm_handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);

}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    KGGLog(@"哈哈:%@",userInfo);
    [[KGGJPushManager shareJPushManager] cdm_handleRemoteNotification:userInfo];
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
    
    if ([url.host isEqualToString:@"safepay"]) {
        [self snh_aliPayResultHandle:url];
        
        [self snh_aliAutoCodeResultHandle:url];
    }
    
    if ([url.host isEqualToString:@"platformapi"]) {
        [self snh_aliAutoCodeResultHandle:url];
    }
    
    
    if ([[url scheme] isEqualToString:KGGWeiXinPayURLScheme]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
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
    
    if ([[url scheme] isEqualToString:KGGWeiXinPayURLScheme]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[url scheme]isEqualToString:KGGWeiXinPayURLScheme]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return NO;
}


#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp
{
    NSString *strTitle;
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体信息结果"];
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        NSString *code = [NSString stringWithFormat:@"%d",resp.errCode];
        [KGGNotificationCenter postNotificationName:SNHPayWeiXinNotification object:code];
    }
}

#pragma mark - 请求调起支付宝支付的地方回调该方法
- (void)snh_aliPayResultHandle:(NSURL *)url
{
    KGGLog(@"url:%@",url);
    
    [[AlipaySDK defaultService]processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        KGGLog(@"resultDic:%@",resultDic);
        [KGGNotificationCenter postNotificationName:KGGPayBlackNotification object:self userInfo:resultDic];
    }];
}

#pragma mark - 授权跳转回调结果
- (void)snh_aliAutoCodeResultHandle:(NSURL *)url
{
//    [[AlipaySDK defaultService]processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//        SNHLog(@"认证的结果result = %@",resultDic);
//    }];
//    
//    //     授权跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        
        KGGLog(@"result = %@",resultDic);
        
        KGGLog(@"%@",resultDic[@"memo"]);
        
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        KGGLog(@"授权结果 authCode = %@", authCode?:@"");
    }];
}

@end
