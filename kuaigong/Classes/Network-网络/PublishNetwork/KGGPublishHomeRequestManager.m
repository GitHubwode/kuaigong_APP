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
@end
