//
//  KGGPublishHomeRequestManager.m
//  kuaigong
//
//  Created by Ding on 2017/10/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishHomeRequestManager.h"
#import "KGGWorkTypeModel.h"

@implementation KGGPublishHomeRequestManager

/**
 获取首页用工列表
 
       type 没有参数 接口类型
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishHomeWorkTypeCompletion:(void(^)(NSArray<KGGWorkTypeModel *>*response))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/workType/getList");
    [self requestWithURL:url httpMethod:GETHttpMethod params:nil progress:nil completion:^(KGGResponseObj *responseObj) {
        NSArray *responseDatasource;
        if (!responseObj) {
            
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }
        responseDatasource = [KGGWorkTypeModel mj_objectArrayWithKeyValuesArray:responseObj.data];
        if (completionHandler) {
            completionHandler(responseDatasource);
        }
    } aboveView:view inCaller:caller];
}

/**
 获取首页用工列表
 
 @  没有参数 接口类型
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishHomeWorkFeecompletion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/order/getFare");
    
    [self requestWithURL:url httpMethod:GETHttpMethod params:nil progress:nil completion:^(KGGResponseObj *responseObj) {
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
 获取首页共享信息接口
 
 @  没有参数 接口类型
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishHomeHeaderViewType:(NSString *)type Name:(NSString *)name Phome:(NSString *)phone Age:(NSString *)age Id_Card_Num:(NSString *)id_card_num Industry:(NSString *)industry NativePlace:(NSString *)nativePlace Address:(NSString *)address completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/shareUser/register");
//    url = @"http://192.168.50.40:8080/api/shareUser/register";
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"type"] = type;
    dic[@"name"] = name;
    dic[@"phone"] = phone;
    dic[@"age"] = age;
    dic[@"id_Card_Num"] = id_card_num;
    dic[@"industry"] = industry;
    dic[@"nativePlace"] = nativePlace;
    dic[@"address"] = address;
    
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
