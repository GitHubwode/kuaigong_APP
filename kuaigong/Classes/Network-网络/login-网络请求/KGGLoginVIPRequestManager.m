//
//  KGGLoginVIPRequestManager.m
//  kuaigong
//
//  Created by Ding on 2017/10/13.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLoginVIPRequestManager.h"

@implementation KGGLoginVIPRequestManager

/**
 查询是否为会员
 
 @param completionHandler 请求完成的回调 responseObj 为SNHUserObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)loginWithRefeVIPcompletion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    //拼接url
    NSString *url = KGGURL(@"/api/user/getCurrnetUserVipInfo");
    //发送请求
    [self requestWithURL:url httpMethod:POSTHttpMethod params:nil progress:nil completion:^(KGGResponseObj *responseObj) {
        if (!responseObj) {
            
        }
        BOOL isVIP = false;
        if (responseObj.code == 100) {
            isVIP = NO;
        }
        if (responseObj.code == KGGSuccessCode) {
            isVIP = YES;
        }
        KGGUserObj *userInfo = [KGGUserManager shareUserManager].currentUser;
        userInfo.hasVIP = isVIP;
        [[KGGUserManager shareUserManager] synchronize];
        if (completionHandler) {
            completionHandler(responseObj);
        }
        
    } aboveView:nil inCaller:caller];
    
}

@end
