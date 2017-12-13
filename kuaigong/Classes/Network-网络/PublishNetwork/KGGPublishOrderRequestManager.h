//
//  KGGPublishOrderRequestManager.h
//  kuaigong
//
//  Created by Ding on 2017/10/11.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHTTPSessionManager.h"
#import "KGGPublishOrderParam.h"
#import "KGGOrderDetailsModel.h"

@class KGGOrderImageModel;
//@class KGGSearchUserModel;

typedef NS_ENUM(NSUInteger, KGGOrderRequestType) {
    KGGOrderRequestAllUndoType, // 全部未完成的订单
    KGGOrderRequestCompleteType, // 我已完成的订单
    KGGOrderRequestNotCompleteType, // 我未完成的订单
    KGGOrderRequestMyDoingType,//获取我的已接订单
    KGGOrderRequestDoPayType,//发单者已支付订单
};


@interface KGGPublishOrderRequestManager : KGGHTTPSessionManager
/**
 创建订单

 @param param 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishCreatOrderParam:(KGGPublishCreatParam *)param completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 取消订单
 
 @param orderId 请求对象为订单的id
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */

+ (void)publishCancelOrderId:(NSUInteger )orderId completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;
/**
 
 修改订单
 @param orderId 请求对象为订单的id number用工人数  days用工天数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */

+ (void)publishUpdateOrderId:(NSUInteger )orderId Number:(NSUInteger )number Days:(NSUInteger )days completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 获取订单信息列表或者完成 未完成
 @param type 接口类型
 @param page 页数  userId 用户id
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 
 */
+ (void)publishOrderListType:(KGGOrderRequestType)type Page:(NSUInteger )page UserId:(NSUInteger )userId Order:(NSUInteger )orderId Latitude:(CGFloat )latitude Longitude:(CGFloat )longitude completion:(void(^)(NSArray<KGGOrderDetailsModel *>*response))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 获取订单详情
 @param orderId 参数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishOrderDetailsMessageOrder:(NSUInteger )orderId completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 获取发照片的信息
 @param path 路径 timeStamp 时间戳 签名 signature 参数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishOrderUpdataImagePath:(NSString *)path TimeStamp:(NSString *)timeStamp Signature:(NSString *)signature completion:(void(^)(KGGOrderImageModel *imageModel))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 获取接单者的用户信息
 @param acceptId   参数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishOrderAcceptId:(NSInteger )acceptId completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

@end

