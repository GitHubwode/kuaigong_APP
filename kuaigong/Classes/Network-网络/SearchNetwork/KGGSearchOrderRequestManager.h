//
//  KGGSearchOrderRequestManager.h
//  kuaigong
//
//  Created by Ding on 2017/10/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHTTPSessionManager.h"
#import "KGGOrderDetailsModel.h"


typedef NS_ENUM(NSUInteger, KGGSearchOrderRequestType) {
    KGGSearchOrderRequestCompleteType, // 我已完成的订单
    KGGSearchOrderRequestMyDoingType,//获取我的已接订单
};

@interface KGGSearchOrderRequestManager : KGGHTTPSessionManager

/**
 接单
 
 @param orderId 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)searchReciveParam:(NSMutableDictionary *)param completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 获取订单信息列表或者完成 进行中
 @param type 接口类型
 @param page 页数  userId 用户id
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 
 */
+ (void)searchOrderListType:(KGGSearchOrderRequestType)type Page:(NSUInteger )page UserId:(NSUInteger )userId Order:(NSUInteger )orderId completion:(void(^)(NSArray<KGGOrderDetailsModel *>*response))completionHandler aboveView:(UIView *)view inCaller:(id)caller;


@end
