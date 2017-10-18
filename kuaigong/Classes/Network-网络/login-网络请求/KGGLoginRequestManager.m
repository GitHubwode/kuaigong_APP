//
//  KGGLoginRequestManager.m
//  kuaigong
//
//  Created by Ding on 2017/10/9.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLoginRequestManager.h"
#import "KGGUserManager.h"
#import "KGGLoginVIPRequestManager.h"

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
    
    [self postFormDataWithUrl:url form:[param mj_keyValues] completion:^(KGGResponseObj *responseObj) {
        
        if (caller && responseObj) {
            completionHandler(responseObj);
        }
        
    } aboveView:view inCaller:caller];
    
}

/**
 登录请求
 
 @param param 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为SNHUserObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)loginWithParam:(KGGLoginParam *)param completion:(void(^)(KGGUserInfo *user))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    //拼接url
    NSString *url = KGGURL(@"/api/login/doLogin");
    
    [self postFormDataWithUrl:url form:[param mj_keyValues] completion:^(KGGResponseObj *responseObj) {
        
        KGGLog(@"%@",responseObj);

        if (!responseObj) return;
        
        if (KGGSuccessCode != responseObj.code) {
            [view showHint:responseObj.message];
            return;
        }
        
        if (completionHandler) {
            KGGUserInfo *userInfo = [KGGUserInfo mj_objectWithKeyValues:responseObj.data];
            userInfo.userInfo.token = userInfo.token;
            [[KGGUserManager shareUserManager]loginWithCurrentUser:userInfo.userInfo];
            
            [KGGLoginVIPRequestManager loginWithRefeVIPcompletion:^(KGGResponseObj *responseObj) {
                
                completionHandler(userInfo);
                
            } aboveView:view inCaller:self];
            
        }
        
    } aboveView:view inCaller:caller];
}

/**
 退出登录请求
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)loginOutWithcompletion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    //拼接url
    NSString *url = KGGURL(@"/api/login/logOut");
    //发送请求
    [self requestWithURL:url httpMethod:POSTHttpMethod params:nil progress:nil completion:^(KGGResponseObj *responseObj) {
        if (!responseObj)  return ;
        if (KGGSuccessCode != responseObj.code) {
            [view showHint:responseObj.message];
        }
        if (KGGSuccessCode == responseObj.code) {
            completionHandler(responseObj);
        }
        
    } aboveView:view inCaller:caller];
}

/**
 更改用户头像
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */

+ (void)updataUserAvatarString:(NSString *)avatarString completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/user/updateAvatar");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"base64"] = avatarString;
    
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        if (!responseObj) {
            [view showHint:KGGHttpNerworkErrorTip];
            
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }
        if (completionHandler) {
            
            KGGUserObj *userObj = [KGGUserObj mj_objectWithKeyValues:responseObj.data];
            [[KGGUserManager shareUserManager] updateCurrentUserAvatar:userObj.avatarUrl];
            [[KGGUserManager shareUserManager] synchronize];
            completionHandler(responseObj);
        }
    } aboveView:view inCaller:caller];
    
}


@end
