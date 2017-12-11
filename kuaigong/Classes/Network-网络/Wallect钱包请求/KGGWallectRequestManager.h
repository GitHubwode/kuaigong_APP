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

@interface KGGWallectRequestManager : KGGHTTPSessionManager

/**
 获取收入明细
 @param page 页数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)myWalletOrderDetailsUserType:(NSString *)userType Page:(NSUInteger )page completion:(void(^)(NSArray<KGGMyWalletOrderDetailsModel *> *response, NSString *totalMoeny, NSString *drawAcount ))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 添加银行卡
 @ param realName 真实姓名
 @ param idCard 身份证号
 @ param bankPhone 预留手机号
 @ param bankCardNo 银行卡号
 @ param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @ caller 方法调用者
 */
+ (void)myWalletAddBankCardRealName:(NSString *)realName IdCard:(NSString *)idCard BankPhone:(NSString *)bankPhone BankCardNo:(NSString *)bankCardNo completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view idCaller:(id)caller;

/**
 提现
 @param withDrawAmount 提现金额
 @ param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @ caller 方法调用者
 */
+ (void)myWalletWithdrawDepositWithDrawAmount:(double)withDrawAmount completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view idCaller:(id)caller;

/**
 查询是否绑定银行卡
 
 */
+ (void)myWalletLookUpBandingCardCompletion:(void(^)(KGGMyWalletCardModel * cardModel))completionHandler aboveView:(UIView *)view idCaller:(id)caller;

@end




















