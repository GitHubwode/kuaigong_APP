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
 微信注册请求
 
 @param openId 请求对象， platform 平台类型 userType 用户类型 请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 KGGResponseObj 为responseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)WXRegisterWithOpenId:(NSString *)openId Platform:(NSString *)platform UserType:(NSString *)userType Sex:(NSString *)sex vatarUrl:(NSString *)avatarUrl Nickname:(NSString *)nickname completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 第三方登录
 @param openId 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为SNHUserObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 
 */
+ (void)WXloginWithOpenId:(NSString *)openId completion:(void(^)(KGGUserInfo *user))completionHandler aboveView:(UIView *)view inCaller:(id)caller;


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

/**
 更改用户昵称 和性别
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)updataUserNameNickString:(NSString *)nameNick Sex:(NSString *)sex completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 更改用户登录密码
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)updataUserPhoneWord:(NSString *)phoneword Code:(NSString *)code completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 找回用户登录密码
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)lookForUserPhone:(NSString *)phone Code:(NSString *)code completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 绑定用户手机号
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)updataUserPhoneNum:(NSString *)phoneNum Code:(NSString *)code completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 获取融云链接的Token
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */

+ (void)setupUserRongTokencompletion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

@end
