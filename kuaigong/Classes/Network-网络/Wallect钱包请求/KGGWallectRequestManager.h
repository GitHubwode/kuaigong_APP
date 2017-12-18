//
//  KGGWallectRequestManager.h
//  kuaigong
//
//  Created by Ding on 2017/11/27.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHTTPSessionManager.h"

@class KGGMyWalletOrderDetailsModel;
@class KGGMyWalletCardModel;
@class KGGMyWalletSpendModel;


//typedef NS_ENUM(NSUInteger, KGGMyWalletOrderRequestType) {
//    KGGMyWalletOrderIncomeRequestType, // 收入
//    KGGMyWalletOrderSpendingRequestType,//支出
//};

@interface KGGWallectRequestManager : KGGHTTPSessionManager

/**
 获取收入明细
 @param page 页数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)myWalletOrderDetailsUserType:(NSString *)userType Page:(NSUInteger )page completion:(void(^)(NSArray<KGGMyWalletOrderDetailsModel *> *response, NSString *totalMoeny, NSString *drawAcount ))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 获取支出明细
 @param page 页数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)myWalletOrderSpendingPage:(NSUInteger )page completion:(void(^)(NSArray<KGGMyWalletSpendModel *> *response))completionHandler aboveView:(UIView *)view inCaller:(id)caller;


/**
 添加银行卡
 @ param realName 真实姓名
 @ param idCard 身份证号
 @ param bankPhone 预留手机号
 @ param bankCardNo 银行卡号
 @ param balance 总金额
 @ param drawBalance 可提现金额
 @ param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @ caller 方法调用者
 */
+ (void)myWalletAddBankCardWithParam:(NSMutableDictionary *)param completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view idCaller:(id)caller;

/**
 提现
 @param withDrawAmount 提现金额
 @ param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @ caller 方法调用者
 */
+ (void)myWalletWithdrawDepositWithDrawAmount:(double)withDrawAmount PassWord:(NSString *)password completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view idCaller:(id)caller;

/**
 查询是否绑定银行卡
 
 */
+ (void)myWalletLookUpBandingCardCompletion:(void(^)(KGGMyWalletCardModel * cardModel,NSString *isHas))completionHandler aboveView:(UIView *)view idCaller:(id)caller;

/**
 查询银行卡所属银行
 */
+ (void)myWalletInquireBankCarNameCarNum:(NSString *)carNum completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view idCaller:(id)caller;

/**
 删除银行卡
 */
+ (void)myWalletDeleteBankCardCompletion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view idCaller:(id)caller;

/**
 修改提现密码
 @ param code 短信验证码
 @ param phone 电话号码
 @ param password 新的提现密码
 */
+ (void)myWalletWithUpdataPwdCode:(NSString *)code Phone:(NSString *)phone PassWord:(NSString *)password completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view idCaller:(id)caller;


@end




















