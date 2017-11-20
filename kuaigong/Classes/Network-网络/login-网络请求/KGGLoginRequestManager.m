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
#import "KGGRongCloudModel.h"
#import <RongIMKit/RongIMKit.h>


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
            userInfo.userInfo.isRegister = [userInfo.nowPlaceRegisterVip isEqualToString:@"N"] ? NO : YES;
            [[KGGUserManager shareUserManager]loginWithCurrentUser:userInfo.userInfo];
            
            [KGGLoginVIPRequestManager loginWithRefeVIPcompletion:^(KGGResponseObj *responseObj) {
                
                completionHandler(userInfo);
                [KGGRongCloudModel kgg_initRongCloudLogin];
                [KGGNotificationCenter postNotificationName:KGGUserLoginNotifacation object:nil];
                
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

/**
 更改用户昵称 和性别
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)updataUserNameNickString:(NSString *)nameNick Sex:(NSString *)sex completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/user/updateUser");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"nickname"] = nameNick;
    dic[@"sex"] = sex;
    
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        if (!responseObj) {
            [view showHint:KGGHttpNerworkErrorTip];
            
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }
        if (completionHandler) {
            KGGUserObj *userObj = [KGGUserObj mj_objectWithKeyValues:responseObj.data];
            if (nameNick == nil) {
                [[KGGUserManager shareUserManager] updateCurrentUserSex:userObj.sex];
            }else{
                [[KGGUserManager shareUserManager] updateCurrentUserName:userObj.nickname];
            }
            [[KGGUserManager shareUserManager] synchronize];
            completionHandler(responseObj);
        }
    } aboveView:view inCaller:caller];
    
}

/**
 微信注册请求
 
 @param openId 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 KGGResponseObj 为responseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)WXRegisterWithOpenId:(NSString *)openId Platform:(NSString *)platform UserType:(NSString *)userType Sex:(NSString *)sex vatarUrl:(NSString *)avatarUrl Nickname:(NSString *)nickname completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/user/thirdPartyRegister");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"openID"] = openId;
    dic[@"userType"] = userType;
    dic[@"platform"] = @"WECHAT";
    dic[@"sex"] = sex;
    dic[@"nickname"] = nickname;
    dic[@"avatarUrl"] = avatarUrl;
    
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        if (!responseObj) {
            return ;
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
//            return ;
        }
//        else{
            KGGLog(@"注册:%@",responseObj);
            if (completionHandler) {
                completionHandler(responseObj);
            }
//        }
    } aboveView:view inCaller:caller];
}

/**
 第三方登录
 @param openId 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为SNHUserObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 
 */
+ (void)WXloginWithOpenId:(NSString *)openId completion:(void(^)(KGGUserInfo *user))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/login/thirdPartyLogin");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"openId"] = openId;
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        
        if (!responseObj) return ;
        if (responseObj.code != KGGSuccessCode) {
            [view showHint:responseObj.message];
            return;
        }
        if (completionHandler) {
            KGGUserInfo *userObj = [KGGUserInfo mj_objectWithKeyValues:responseObj.data];
            userObj.userInfo.token = userObj.token;
            userObj.userInfo.isRegister = [userObj.nowPlaceRegisterVip isEqualToString:@"N"] ? NO : YES;
            [[KGGUserManager shareUserManager]loginWithCurrentUser:userObj.userInfo];
            [KGGLoginVIPRequestManager loginWithRefeVIPcompletion:^(KGGResponseObj *responseObj) {
                completionHandler(userObj);
            } aboveView:view inCaller:self];
        }
    } aboveView:view inCaller:caller];
}

/**
 更改用户登录密码
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)updataUserPhoneWord:(NSString *)phoneword Code:(NSString *)code completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/user/updateLoginPwd");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"password"] = phoneword;
    dic[@"code"] = code;
    
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        if (!responseObj) {
            return ;
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
            return ;
        }else{
            KGGLog(@"注册:%@",responseObj);
            if (completionHandler) {
                completionHandler(responseObj);
            }
        }
        
    } aboveView:view inCaller:caller];
}

/**
 绑定用户手机号 输入密码
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)updataUserPhoneNum:(NSString *)phoneNum Code:(NSString *)code completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/user/updatePhone");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"phone"] = phoneNum;
    dic[@"code"] = code;
    
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        if (!responseObj) {
            return ;
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
            return ;
        }else{
            
            KGGLog(@"修改手机号:%@",responseObj);
            if (completionHandler) {
                
                KGGUserObj *userObj = [KGGUserObj mj_objectWithKeyValues:responseObj.data];
                [[KGGUserManager shareUserManager] updateCurrentUserMobile:userObj.phone];
                [[KGGUserManager shareUserManager] synchronize];
                completionHandler(responseObj);
            }
        }
        
    } aboveView:view inCaller:caller];
}

/**
 找回用户登录密码
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)lookForUserPhone:(NSString *)phone Code:(NSString *)code completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/user/findSelfPwd");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"phone"] = phone;
    dic[@"code"] = code;
    
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        
        if (!responseObj) {
            return ;
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
            return ;
        }else{
            KGGLog(@"注册:%@",responseObj);
            if (completionHandler) {
                completionHandler(responseObj);
            }
        }
        
    } aboveView:view inCaller:caller];
}

/**
 获取融云链接的Token
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */

+ (void)setupUserRongTokencompletion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/chat/getRongToken");
    [self postFormDataWithUrl:url form:nil completion:^(KGGResponseObj *responseObj) {
        
        if (!responseObj) {
            return ;
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
            return ;
        }else{
            KGGLog(@"获取融云Token:%@",responseObj);
            if (completionHandler) {
                completionHandler(responseObj);
            }
        }
        
    } aboveView:view inCaller:caller];
}

+ (void)logout{
    // 清除内存和本地保存的用户信息
    [[KGGUserManager shareUserManager] logout];
    // 解除第三方的授权
    [[RCIM sharedRCIM] disconnect:NO];
    // 退出融云
    [KGGNotificationCenter postNotificationName:KGGUserLogoutNotifacation object:nil];
}


@end
