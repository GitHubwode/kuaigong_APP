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
#import "KGGJPushManager.h"


@interface KGGRongCloudModel ()

@end

@implementation KGGRongCloudModel

+ (void)kgg_initRongCloudAppkey
{
    [[RCIM sharedRCIM]initWithAppKey:KGGRongCloudAppKey];
    [RCIM sharedRCIM].disableMessageAlertSound = NO;
    [RCIM sharedRCIM].enableTypingStatus = YES;
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
}

+ (void)kgg_initRongCloudLogin
{
    NSString *identityString;
    if ([KGGUserManager shareUserManager].logined) {
        identityString = [KGGUserManager shareUserManager].currentUser.type;
    }else{
        identityString = @"WORKER";
    }
    NSString *isJPush;
    isJPush = [NSUserDefaults objectForKey:KGGJPushType];
    
    NSSet * set = [[NSSet alloc] initWithObjects:identityString, nil];

    [KGGLoginRequestManager setupUserRongTokencompletion:^(KGGResponseObj *responseObj) {
        
        if (!responseObj) {
            
        }else if ([responseObj.data isKindOfClass:[NSString  class]]){
            
            if ([isJPush isEqualToString:@"NO"]) {
            }else{
                [[KGGJPushManager shareJPushManager] cmd_registerAliasPhone:[KGGUserManager shareUserManager].currentUser.phone];
                //注册标签
                [[KGGJPushManager shareJPushManager] cmd_registerTags:set];
            }

            [[RCIMClient sharedRCIMClient]connectWithToken:responseObj.data success:^(NSString *userId) {
                KGGLog(@"融云登录成功");
                RCUserInfo *userInfo = [[RCUserInfo alloc]init];
                userInfo.name = [KGGUserManager shareUserManager].currentUser.nickname;
                userInfo.userId = [KGGUserManager shareUserManager].currentUser.userId;
                userInfo.portraitUri = [KGGUserManager shareUserManager].currentUser.avatarUrl;
                [[RCIM sharedRCIM] setCurrentUserInfo:userInfo];
                [[RCIM sharedRCIM]setEnableMessageAttachUserInfo:YES];
            } error:^(RCConnectErrorCode status) {
                KGGLog(@"融云登录失败");
                
            } tokenIncorrect:^{
                KGGLog(@"token过期");
                
            }];
        }
        
    } aboveView:nil inCaller:self];
}

- (void)dealloc
{
    KGGLogFunc;
}


@end
