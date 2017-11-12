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
    [RCIM sharedRCIM].disableMessageAlertSound = YES;
    [RCIM sharedRCIM].enableTypingStatus = YES;
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
}

+ (void)kgg_initRongCloudLogin
{
    
    [KGGLoginRequestManager setupUserRongTokencompletion:^(KGGResponseObj *responseObj) {
        
    } aboveView:nil inCaller:self];
    
    
    
    [[RCIM sharedRCIM]connectWithToken:@"" success:^(NSString *userId) {
        KGGLog(@"融云登录成功");
    } error:^(RCConnectErrorCode status) {
        KGGLog(@"融云登录失败");
    } tokenIncorrect:^{
        KGGLog(@"token过期");
    }];
}

@end
