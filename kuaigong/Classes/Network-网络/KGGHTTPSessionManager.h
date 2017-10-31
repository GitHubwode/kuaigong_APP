//
//  KGGHTTPSessionManager.h
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define KGGURL(string) [KGGBasicURL stringByAppendingString:string]

static NSString *KGGHttpNerworkErrorTip = @"网络不给力呀，请稍后再试~";

/**
 请求方法
 
 - POSTHttpMethod: POST 请求
 - GETHttpMethod: GET 请求
 */
typedef NS_ENUM(NSUInteger, HttpMethod) {
    POSTHttpMethod,
    GETHttpMethod,
};

typedef NS_ENUM(NSUInteger, KGGErrorCode) {
    KGGSuccessCode = 200,
    KGGExpiredTokenCode = 402,
    KGGFailureCode,
    KGGNoPayCode = 268, //未付款的状态
};

@interface KGGResponseObj : NSObject
@property (nonatomic, assign) KGGErrorCode code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) id data;
@end

@interface KGGResultListObj : NSObject
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, assign) NSUInteger totalPage;
@property (nonatomic, strong) NSArray *dataList;
@end

/** 请求成功的回调，以下说明仅仅值调用requestWithURL:httpMethod:params:progress:completion...方法
 * 1、responseObj类型为KGGResponseObj
 * 2、responseObj = nil 表示网络错误
 * 3、responseObj != nil,responseObj.code != SNHSuccessCode 表示业务错误
 */
typedef void(^completionHandler)(id responseObj);

/** 监听进度响应的回调 */
typedef void (^progressHandler)(CGFloat progress);

@interface KGGHTTPSessionManager : NSObject

#pragma mark - 底层共用
/**
 最底层的请求方式
 
 @param url 请求地址
 @param httpMethod 请求方法 POST GET
 @param params 请求参数
 @param progressHandler 监听进度响应的回调
 @param completionHandler 请求完成的回调
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)requestWithURL:(NSString *)url httpMethod:(HttpMethod)httpMethod params:(NSMutableDictionary *)params progress:(progressHandler)progressHandler completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 获取请求头信息
 
 @return 请求头
 */
+ (NSDictionary *)getHeaderFieldValueDictionary;

/**
 检查是网络是否打开
 
 @return YES 网络打开 NO 网络没有打开
 */
+ (BOOL)isReachable;

/**
 以POST form表单的形式提交数据
 
 @param url <#url description#>
 @param form <#form description#>
 @param completionHandler <#completionHandler description#>
 @param view <#view description#>
 @param caller <#caller description#>
 */
+ (void)postFormDataWithUrl:(NSString *)url form:(NSMutableDictionary *)form  completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 以POST form表单的形式提交数据图片
 
 @param url <#url description#>
 @param form <#form description#>
 @param completionHandler <#completionHandler description#>
 @param view <#view description#>
 @param caller <#caller description#>
 */
+ (void)postFormImageDataWithUrl:(NSString *)url form:(NSMutableDictionary *)form  completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

/**
 评分的请求
 @param url 请求地址
 @param httpMethod 请求方法 POST GET
 @param params 请求参数
 @param progressHandler 监听进度响应的回调
 @param completionHandler 请求完成的回调
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
//+ (void)snh_requestWithURL:(NSString *)url httpMethod:(HttpMethod)httpMethod params:(id )params progress:(progressHandler)progressHandler completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

@end



