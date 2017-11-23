//
//  KGGPayRequestManager.m
//  kuaigong
//
//  Created by Ding on 2017/11/1.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPayRequestManager.h"

@implementation KGGPayRequestManager

/**
 获取支付的签名
 @param orderId 参数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)payOrderDetailsMessageOrder:(NSString *)orderId TradeType:(NSString *)tradeType PayChannel:(NSString *)payChannel completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/pay/pay");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"orderNo"] = orderId;
    dic[@"tradeType"] = tradeType;
    dic[@"payChannel"] = payChannel;
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        if (!responseObj){
            
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }
        if (completionHandler) {
            completionHandler(responseObj);
        }
        
    } aboveView:view inCaller:caller];
}

/**
 获取VIP创建的信息
 @param type 参数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)creatVIPMessageVIPType:(NSString *)type completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/user/create");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"type"] = type;
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        if (!responseObj){
            
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }
        if (completionHandler) {
            completionHandler(responseObj);
        }
    } aboveView:view inCaller:caller];
}

/**
 更新用户VIP的信息
 @param type 参数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)updataUserVIPMessageVIPType:(NSString *)type completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"type"] = type;
    
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        
        if (!responseObj) {
        }
        BOOL isVIP = false;
        NSString *endTime;
        if (responseObj.code == KGGSuccessCode) {
            NSInteger isActive = [[responseObj.data objectForKey:@"isActive"] integerValue];
            
            if (isActive==1) {
                isVIP = YES;
            }else{
                isVIP = NO;
            }
            
            if ([[responseObj.data objectForKey:@"userVipInfo"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = [responseObj.data objectForKey:@"userVipInfo"];
                endTime = [dic objectForKey:@"endTime"];
            }
        }
        KGGUserObj *userInfo = [KGGUserManager shareUserManager].currentUser;
        userInfo.hasVIP = isVIP;
        userInfo.vipEndTime = endTime;
        [[KGGUserManager shareUserManager] synchronize];
        if (completionHandler) {
            completionHandler(responseObj);
        }
        
    } aboveView:view inCaller:caller];
}

@end
