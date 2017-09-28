//
//  AppDelegate+KGGUMSocial.m
//  kuaigong
//
//  Created by Ding on 2017/9/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "AppDelegate+KGGUMSocial.h"
#import "NSObject+swizzle.h"
#import "KGGUMSocialHelper.h"

@implementation AppDelegate (KGGUMSocial)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setUpAppDelegateHook];
    });
}
+ (void)setUpAppDelegateHook{
    
    Class class = [self class];
    xc_swizzleMethod(class, @selector(application:didFinishLaunchingWithOptions:), @selector(KGG_Application:didFinishLaunchingWithOptions:));
    xc_swizzleMethod(class, @selector(application:openURL:sourceApplication:annotation:), @selector(KGG_Application:openURL:sourceApplication:annotation:));
    
    xc_swizzleMethod(class, @selector(application:openURL:options:), @selector(KGG_Application:openURL:options:));
}

#pragma mark - Method Swizzling
- (BOOL)KGG_Application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [KGGUMSocialHelper setUpUMSocial];
    
    return [self KGG_Application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)KGG_Application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    
    if ([url.host isEqualToString:@"pay"]) {
        return [self KGG_Application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    
    
    BOOL result = [KGGUMSocialHelper handleOpenURL:url];
    
    if (!result) {
        // 其他如支付等SDK的回调
        return [self KGG_Application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    
    return result;
    
}

- (BOOL)KGG_Application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    
    if ([url.host isEqualToString:@"pay"]) {
        return [self KGG_Application:app openURL:url options:options];
    }
    
    
    BOOL result = [KGGUMSocialHelper handleOpenURL:url];
    KGGLog(@"%@",url.host);
    
    if (!result) {
        // 其他如支付等SDK的回调
        return [self KGG_Application:app openURL:url options:options];
    }
    
    
    return result;
}



@end
