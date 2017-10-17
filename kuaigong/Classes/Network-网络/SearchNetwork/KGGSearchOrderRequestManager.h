//
//  KGGSearchOrderRequestManager.h
//  kuaigong
//
//  Created by Ding on 2017/10/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHTTPSessionManager.h"

@interface KGGSearchOrderRequestManager : KGGHTTPSessionManager

/**
 接单
 
 @param orderId 请求对象，请求参数封装为对象的属性
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)searchReciveOrderId:(NSUInteger )orderId completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;


@end
