//
//  KGGSearchOrderRequestManager.m
//  kuaigong
//
//  Created by Ding on 2017/10/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGSearchOrderRequestManager.h"

@implementation KGGSearchOrderRequestManager

/**
 接单
 @param orderId 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */

+ (void)searchReciveParam:(NSMutableDictionary *)param completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller{
    NSString *url = KGGURL(@"/api/order/accept");
    [self postFormDataWithUrl:url form:param completion:^(KGGResponseObj *responseObj) {
        if (!responseObj) {
            
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }
        if (completionHandler) {
            completionHandler(responseObj);
        }
    } aboveView:view inCaller:caller];
}

/**
 获取订单信息列表或者完成 进行中
 @param type 接口类型
 @param page 页数  userId 用户id
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 
 */
+ (void)searchOrderListType:(KGGSearchOrderRequestType)type Page:(NSUInteger )page Longitude:(CGFloat )longitude Latitude:(CGFloat )latitude completion:(void(^)(NSArray<KGGOrderDetailsModel *>*response))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    switch (type) {
        case KGGSearchOrderRequestMyDoingType: // 我未完成的订单
            url = KGGURL(@"/api/order/getMyAcceptUnComplete");
            dic[@"page"] = @(page);
//            dic[@""] = @(longitude);
//            dic[@""] = @(latitude);
            break;
        case KGGSearchOrderRequestCompleteType: // 我已完成的订单
            url = KGGURL(@"/api/order/getMyAcceptComplete");
            dic[@"page"] = @(page);
            break;
        case KGGSearchOrderRequestNotPay: //未支付
            url = KGGURL(@"/api/order/getUnCompleteNoPay");
            dic[@"page"] = @(page);
        default:
            break;
    }
    
    [self requestWithURL:url httpMethod:GETHttpMethod params:dic progress:nil completion:^(KGGResponseObj *responseObj) {
        
        NSArray *responseDatasource;
        if (!responseObj) {
            
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }else{
            NSArray *recordList = [responseObj.data objectForKey:@"recordList"];
            responseDatasource = [KGGOrderDetailsModel mj_objectArrayWithKeyValuesArray:recordList];
            if (completionHandler) {
                completionHandler(responseDatasource);
            }
        }
        
    } aboveView:nil inCaller:caller];
}

/**
 取消订单  接单方接单取消订单 发布方接单取消订单
 @param userType 接口类型
 @param orderId 订单ID
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)cancelOrderMessageUserOrderId:(NSUInteger )orderId completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/order/postAcceptedCancel");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"id"] = @(orderId);
    
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        if (!responseObj) {
            
        }else{
            if (completionHandler) {
                completionHandler(responseObj);
            }
        }
    } aboveView:view inCaller:caller];
}

/**
 工人方 确认出发
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)workerSureGoOrderId:(NSUInteger )orderId completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/order/confirmStartWork");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"id"] = @(orderId);
    [self requestWithURL:url httpMethod:GETHttpMethod params:dic progress:nil completion:^(KGGResponseObj *responseObj) {
        if (!responseObj) {
            [view showHint:KGGHttpNerworkErrorTip];
            return ;
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }
        if (completionHandler) {
            completionHandler(responseObj);
        }
        
    } aboveView:view inCaller:caller];
}
@end
