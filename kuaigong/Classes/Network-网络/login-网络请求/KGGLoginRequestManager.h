//
//  KGGLoginRequestManager.h
//  kuaigong
//
//  Created by Ding on 2017/10/9.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHTTPSessionManager.h"
#import "KGGUserObj.h"
#import "KGGLoginParam.h"

@interface KGGLoginRequestManager : KGGHTTPSessionManager

/**
 登录请求
 
 @param param 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为SNHUserObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)loginWithParam:(KGGLoginParam *)param completion:(void(^)(KGGUserInfo *user))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 微信登录请求
 
 @param param 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为SNHUserObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)WXloginWithParam:(KGGWXLoginParam *)param completion:(void(^)(KGGUserObj *user))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 注册请求
 
 @param param 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)registerWithParam:(KGGRegisterParam *)param completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 发送验证码
 
 @param param 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)sendVerificationCodeToCellParam:(KGGSMSCodeParam *)param  completion:(void(^)(KGGResponseObj *responseObj))completionHandler inCaller:(id)caller;


/**
 退出登录请求
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)loginOutWithcompletion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;


/**
 更改用户头像
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */

+ (void)updataUserAvatarString:(NSString *)avatarString completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

@end
