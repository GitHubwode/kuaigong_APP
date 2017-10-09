//
//  KGGLoginRequestManager.m
//  kuaigong
//
//  Created by Ding on 2017/10/9.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLoginRequestManager.h"

@implementation KGGLoginRequestManager

/**
 发送验证码
 
 @param param 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为SNHUserObj
 @param caller 方法调用者
 */
+ (void)sendVerificationCodeToCellParam:(KGGSMSCodeParam *)param  completion:(void(^)(KGGResponseObj *responseObj))completionHandler inCaller:(id)caller
{
    //拼接URL
    NSString *url = KGGURL(@"/api/sms/applySMSCode");
    //发送请求
    [self postFormDataWithUrl:url form:[param mj_keyValues]completion:^(KGGResponseObj *responseObj) {
        if (caller && responseObj) {
            completionHandler(responseObj);
            }
    } aboveView:nil inCaller:caller];
}

/**
 注册请求
 
 @param param 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为SNHUserObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)registerWithParam:(KGGRegisterParam *)param completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    //拼接url
    NSString *url = KGGURL(@"/api/user/register");
    //发送请求
    [self requestWithURL:url httpMethod:POSTHttpMethod params:[param mj_keyValues] progress:nil completion:^(KGGResponseObj *responseObj) {
        if (caller && responseObj) {
            completionHandler(responseObj);
        }
        
    } aboveView:view inCaller:caller];    
    
}

@end
