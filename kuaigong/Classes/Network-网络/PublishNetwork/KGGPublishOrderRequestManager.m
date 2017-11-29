//
//  KGGPublishOrderRequestManager.m
//  kuaigong
//
//  Created by Ding on 2017/10/11.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishOrderRequestManager.h"
#import "KGGOrderImageModel.h"
//#import "KGGSearchUserModel.h"

@implementation KGGPublishOrderRequestManager

/**
 创建订单
 
 @param param 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishCreatOrderParam:(KGGPublishCreatParam *)param completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/order/create");
    //发送请求
    [self postFormDataWithUrl:url form:[param mj_keyValues] completion:^(KGGResponseObj *responseObj) {
        if (!responseObj) {
            
        }
        if (completionHandler) {
            completionHandler(responseObj);
        }
     
    } aboveView:view inCaller:caller];
}

/**
 取消订单
 
 @param orderId 请求对象为订单的id
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */

+ (void)publishCancelOrderId:(NSUInteger )orderId completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/order/cancel");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"id"] = @(orderId);
    
    //发送请求
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
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
 
 修改订单
 @param orderId 请求对象为订单的id number用工人数  days用工天数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */

+ (void)publishUpdateOrderId:(NSUInteger )orderId Number:(NSUInteger )number Days:(NSUInteger )days completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/order/update");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"id"] = @(orderId);
    dic[@"number"] = @(number);
    dic[@"days"] = @(days);
    
    //发送请求
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
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
 
 获取订单信息 详情或者完成 未完成
 @param type 接口类型
 @param page 页数  userId 用户id
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishOrderListType:(KGGOrderRequestType)type Page:(NSUInteger )page UserId:(NSUInteger )userId Order:(NSUInteger )orderId Latitude:(CGFloat )latitude Longitude:(CGFloat )longitude completion:(void(^)(NSArray<KGGOrderDetailsModel *>*response))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    switch (type) {
        case KGGOrderRequestAllUndoType: // 全部未完成的订单
            url = KGGURL(@"/api/order/getAllOrder");
            dic[@"page"] = @(page);
            dic[@"acceptLongitude"] = @(longitude);
            dic[@"acceptLatitude"] = @(latitude);
            break;
        case KGGOrderRequestCompleteType: // 我已完成的订单
            url = KGGURL(@"/api/order/getComplete");
            dic[@"page"] = @(page);
            break;
        case KGGOrderRequestNotCompleteType: // 我未完成的订单
            url = KGGURL(@"/api/order/getUnComplete");
            dic[@"page"] = @(page);
            break;
        case KGGOrderRequestMyDoingType: //接单方获取我的已接订单 BOSS方会是正在进行的订单
            url = KGGURL(@"/api/order/getAcceptOrder");
            dic[@"page"] = @(page);
            break;
        default:
            break;
    }
    
    [self requestWithURL:url httpMethod:GETHttpMethod params:dic progress:nil completion:^(KGGResponseObj *responseObj) {
        NSArray *responseDatasource;
        if (!responseObj) {
//            return ;
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
//            return;
        }else{
            NSArray *recordList = [responseObj.data objectForKey:@"recordList"];
            responseDatasource = [KGGOrderDetailsModel mj_objectArrayWithKeyValuesArray:recordList];
        }
        if (completionHandler) {
            completionHandler(responseDatasource);
        }
        
        KGGLog(@"responseDatasource:%@",responseDatasource);
        
    } aboveView:nil inCaller:caller];
}

/**
 获取订单详情
 @param orderId 参数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishOrderDetailsMessageOrder:(NSUInteger )orderId completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/order/get");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"id"] = @(orderId);

    [self requestWithURL:url httpMethod:GETHttpMethod params:dic progress:nil completion:^(KGGResponseObj *responseObj) {

        if (!responseObj) {
            
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }else{
            if (completionHandler) {
                completionHandler(responseObj);
            }
        }
    } aboveView:nil inCaller:caller];
}

/**
 获取发照片的信息
 @param path 路径 timeStamp 时间戳 签名 signature 参数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishOrderUpdataImagePath:(NSString *)path TimeStamp:(NSString *)timeStamp Signature:(NSString *)signature completion:(void(^)(KGGOrderImageModel *imageModel))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/upload/getUploadSignature");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"path"] = path;
    dic[@"timestamp"] = timeStamp;
    dic[@"signature"] =signature;
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        if (!responseObj) {
            
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }
        KGGOrderImageModel *model = [KGGOrderImageModel mj_objectWithKeyValues:responseObj.data];
        if (completionHandler) {
            completionHandler(model);
        }
    } aboveView:view inCaller:caller];
}

/**
 获取接单者的用户信息
 @param acceptId   参数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishOrderAcceptId:(NSInteger )acceptId completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/user/findUserByID");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"id"] = @(acceptId);
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        
        if (!responseObj) {
            
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }
        if (completionHandler) {
            completionHandler(responseObj);
        }
        
    } aboveView:view inCaller:caller];
    
}


@end
