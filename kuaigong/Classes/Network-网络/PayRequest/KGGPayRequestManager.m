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
+ (void)payOrderDetailsMessageOrder:(NSUInteger )orderId completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/pay/pay");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"orderId"] = @(orderId);
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

@end
