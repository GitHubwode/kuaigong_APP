//
//  KGGRongCloudModel.m
//  kuaigong
//
//  Created by Ding on 2017/9/12.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGRongCloudModel.h"
#import <RongIMKit/RongIMKit.h>
#import "KGGLoginRequestManager.h"

@implementation KGGRongCloudModel

+ (void)kgg_initRongCloudAppkey
{
    [[RCIM sharedRCIM]initWithAppKey:KGGRongCloudAppKey];
    [RCIM sharedRCIM].disableMessageAlertSound = NO;
    [RCIM sharedRCIM].enableTypingStatus = YES;
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
}

+ (void)kgg_initRongCloudLogin
{
    
    [KGGLoginRequestManager setupUserRongTokencompletion:^(KGGResponseObj *responseObj) {
        if (!responseObj) {

        }else if (responseObj.code != KGGSuccessCode){
        }
        KGGLog(@"%@",responseObj);

    } aboveView:nil inCaller:self];
    
    //15026418284
//    7mc68nwRCcMDub2MUt63sH1/S5zOApPZBJhB7ukD1fPZq6Zf88PXXFMP7dhlOd5827oTsK2dS1Qwbg0qirBKAg==
    
//    7gAWadktAO3HRa6MPpST7n1/S5zOApPZBJhB7ukD1fPZq6Zf88PXXNEsZzKKHHG427oTsK2dS1Qwbg0qirBKAg==
    
    //13072903631
//4bI0RgHws8E9k4V/L8dRrt608W41isz5GpRxM+zMWE7srBTbX9oBnP97RcWKfffOocMgBn5Ckro=
    
//    TywfnN0oy8VYP1VTdEqPWn1/S5zOApPZBJhB7ukD1fPZq6Zf88PXXEKB6ylNqBoh6CAoHw3fgHYwbg0qirBKAg==
    
//    NSString *token;
//    NSString *phone = [KGGUserManager shareUserManager].currentUser.phone;
//    if ([phone isEqualToString:@"15026418284"]) {
//        token = @"7mc68nwRCcMDub2MUt63sH1/S5zOApPZBJhB7ukD1fPZq6Zf88PXXFMP7dhlOd5827oTsK2dS1Qwbg0qirBKAg==";
//    }
//    if ([phone isEqualToString:@"13072903631"]) {
//        token = @"4bI0RgHws8E9k4V/L8dRrt608W41isz5GpRxM+zMWE7srBTbX9oBnP97RcWKfffOocMgBn5Ckro=";
//    }
//    if ([phone isEqualToString:@"18158761229"]) {
//        token = @"7mc68nwRCcMDub2MUt63sH1/S5zOApPZBJhB7ukD1fPZq6Zf88PXXFMP7dhlOd5827oTsK2dS1Qwbg0qirBKAg==";
//    }
//    
//    [[RCIMClient sharedRCIMClient]connectWithToken:token success:^(NSString *userId) {
//        KGGLog(@"融云登录成功");
//
//    } error:^(RCConnectErrorCode status) {
//        KGGLog(@"融云登录失败");
//
//    } tokenIncorrect:^{
//        KGGLog(@"token过期");
//
//    }];
    
//    [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
//        KGGLog(@"融云登录成功");
//    } error:^(RCConnectErrorCode status) {
//        KGGLog(@"融云登录失败");
//    } tokenIncorrect:^{
//        KGGLog(@"token过期");
//    }];
}

- (void)dealloc
{
    KGGLogFunc;
}

@end
