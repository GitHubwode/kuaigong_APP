//
//  KGGPublishHomeRequestManager.h
//  kuaigong
//
//  Created by Ding on 2017/10/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHTTPSessionManager.h"

@class KGGWorkTypeModel;

@interface KGGPublishHomeRequestManager : KGGHTTPSessionManager

/**
 获取首页用工列表
 
 @  没有参数 接口类型
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishHomeWorkTypeCompletion:(void(^)(NSArray<KGGWorkTypeModel *>*response))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 获取首页用工列表
 
 @  没有参数 接口类型
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishHomeWorkFeecompletion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 获取首页共享信息接口
 
 @  没有参数 接口类型
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)publishHomeHeaderViewType:(NSString *)type Name:(NSString *)name Phome:(NSString *)phone Age:(NSString *)age Id_Card_Num:(NSString *)id_card_num Industry:(NSString *)industry NativePlace:(NSString *)nativePlace Address:(NSString *)address completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

@end
