//
//  KGGPayRequestManager.h
//  kuaigong
//
//  Created by Ding on 2017/11/1.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHTTPSessionManager.h"

@interface KGGPayRequestManager : KGGHTTPSessionManager

/**
 获取支付的签名
 @param orderId 参数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)payOrderDetailsMessageOrder:(NSString *)orderId TradeType:(NSString *)tradeType PayChannel:(NSString *)payChannel completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 获取VIP创建的信息
 @param type 参数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)creatVIPMessageVIPType:(NSString *)type completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 更新用户VIP的信息
 @param type 参数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)updataUserVIPMessageVIPType:(NSString *)type completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;


@end
