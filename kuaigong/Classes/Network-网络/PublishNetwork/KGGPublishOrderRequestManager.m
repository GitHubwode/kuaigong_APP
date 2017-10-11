//
//  KGGPublishOrderRequestManager.m
//  kuaigong
//
//  Created by Ding on 2017/10/11.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishOrderRequestManager.h"

@implementation KGGPublishOrderRequestManager

/**
 创建订单
 
 @param param 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishCreatOrderParam:(KGGPublishOrderParam *)param completion:(void(^)(KGGUserObj *user))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/order/create");
    //发送请求
    [self requestWithURL:url httpMethod:POSTHttpMethod params:[param mj_keyValues] progress:nil completion:^(KGGResponseObj *responseObj) {
        
    } aboveView:view inCaller:caller];
    
}

/**
 取消订单
 
 @param orderId 请求对象为订单的id
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */

+ (void)publishCancelOrderId:(NSUInteger )orderId completion:(void(^)(KGGUserObj *user))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/order/cancel");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"id"] = @(orderId);
    
    //发送请求
    [self requestWithURL:url httpMethod:POSTHttpMethod params:dic progress:nil completion:^(KGGResponseObj *responseObj) {
        
    } aboveView:view inCaller:caller];
}

/**
 
 修改订单
 @param orderId 请求对象为订单的id number用工人数  days用工天数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */

+ (void)publishUpdateOrderId:(NSUInteger )orderId Number:(NSUInteger )number Days:(NSUInteger )days completion:(void(^)(KGGUserObj *user))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/order/update");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"id"] = @(orderId);
    dic[@"number"] = @(number);
    dic[@"days"] = @(days);
    
    //发送请求
    [self requestWithURL:url httpMethod:POSTHttpMethod params:dic progress:nil completion:^(KGGResponseObj *responseObj) {
        
    } aboveView:view inCaller:caller];
}

/**
 
 获取订单信息 详情或者完成 未完成
 @param type 接口类型
 @param page 页数  userId 用户id
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishOrderListType:(KGGOrderRequestType)type Page:(NSUInteger )page UserId:(NSUInteger )userId completion:(void(^)(NSArray<KGGOrderDetailsModel *>*response))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url;
    switch (type) {
        case KGGOrderRequestUndoType:
            url = KGGURL(@"/api/order/getAllOrder");
            break;
        case KGGOrderRequestDetailsType:
            url = KGGURL(@"/api/order/get");
            break;
        case KGGOrderRequestCompleteType:
            url = KGGURL(@"/api/order/getComplete");
            break;
        case KGGOrderRequestNotCompleteType:
            url = KGGURL(@"/api/order/getUnComplete");
            break;
        default:
            break;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"userId"] = @(userId);
    dic[@"page"] = @(page);
    
    [self requestWithURL:url httpMethod:GETHttpMethod params:dic progress:nil completion:^(KGGResponseObj *responseObj) {
        
    } aboveView:view inCaller:caller];
    
}

@end
