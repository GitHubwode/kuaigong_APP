//
//  KGGHTTPSessionManager.m
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHTTPSessionManager.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "NSBundle+KGGExtension.h"


@implementation KGGResponseObj
@end

@implementation KGGResultListObj
@end

@implementation KGGHTTPSessionManager

/**
 单例获取管理者对象
 
 @return 单例对象
 */

+ (AFHTTPSessionManager *)sharedHTTPSessionManager
{
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [AFHTTPSessionManager manager];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",@"text/json", @"text/javascript", nil];
        
    });
    
    return instance;
}

/**
 获取请求头
 
 @return 请求头
 */
 + (NSDictionary *)getHeaderFieldValueDictionary
{
    NSMutableDictionary *headerFieldValueDictionary = [NSMutableDictionary dictionary];
//    KGGUserManager *mgr = [KGGUserManager shareUserManager].currentUser;
    //版本号
//    headerFieldValueDictionary[@"appVersion"] = [NSBundle currentVersion];
    //token
    NSString *token = [KGGUserManager shareUserManager].currentUser.token;
    if (token.length) {
        headerFieldValueDictionary[@"x-token"] = token;
    }
    return headerFieldValueDictionary;
}

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
+ (void)requestWithURL:(NSString *)url httpMethod:(HttpMethod)httpMethod params:(NSMutableDictionary *)params progress:(progressHandler)progressHandler completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    //检查是否有网络
    if (![self isReachable]) {
        //没有网络
        weakSelf(caller);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler && weakcaller) {
                completionHandler(nil);
            }
            [MBProgressHUD showSuYaError:@"哎呦,网络貌似没有打开呦~" toView:view];
        });
        return;
    }
    
    NSDictionary *headerFieldValueDictionary = [self getHeaderFieldValueDictionary];
    //设置请求头
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
        NSString *value = headerFieldValueDictionary[httpHeaderField];
        [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
    }
    [self sharedHTTPSessionManager].requestSerializer = requestSerializer;
    
    KGGLog(@"%@-%@-%@",url,params,headerFieldValueDictionary);
    if (POSTHttpMethod == httpMethod) {
        
        [self POST:url params:params progress:progressHandler completion:completionHandler aboveView:view inCaller:caller];
        
    }else if (GETHttpMethod == httpMethod){
        [self GET:url params:params progress:progressHandler completion:completionHandler aboveView:view inCaller:caller];
    }
}

/**
 检查网络是否打开
 
 @return YES 网络打开 NO 网络没有打开
 */
+ (BOOL)isReachable
{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    return [r currentReachabilityStatus] != NotReachable;
}

/**
 POST 方式获取数据
 
 @param url 请求地址
 @param params 请求参数
 @param progressHandler 监听进度响应的回调
 @param completionHandler 请求完成的回调
 */
+ (void)POST:(NSString *)url params:(NSMutableDictionary *)params progress:(progressHandler)progressHandler completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller{
    //添加遮盖
    if (view) [view showHUD];
    
    weakSelf(caller);
    weakSelf(view);
    
    //发送请求
    [[self sharedHTTPSessionManager] POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        KGGLog(@"%@",weakcaller);
        //移除遮盖
        if (weakview && progressHandler) [weakview hideHUD];
        //如果调用者不存在就不往下执行
        if (progressHandler && weakcaller) {
            CGFloat progress = uploadProgress.completedUnitCount / uploadProgress.totalUnitCount *1.0f;
            
            progressHandler(progress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        KGGLog(@"%@- %@",url,responseObject);
        //移除遮盖
        if (weakview) [weakview hideHUD];
        //如果调用者不存在就不往下执行
        if (completionHandler && weakcaller) {
            KGGResponseObj *obj = [KGGResponseObj mj_objectWithKeyValues:responseObject];
            
//            if (KGGExpiredTokenCode == obj.code) {
////                [KGGNotificationCenter postNotificationName:KGGConnectionStatusOffLine object:nil];
//            }
            
            completionHandler(obj);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        KGGLog(@"%@",error);
        // 移除遮罩
        if (weakview) {
            [weakview hideHUD];
            [MBProgressHUD showMessag:KGGHttpNerworkErrorTip toView:view];
        }
        // 如果调用者已经不存在，就不用继续往下执行
        if (completionHandler && weakcaller) {
            completionHandler(nil);
        }
        
    }];
    
}


/**
 GET 方式获取数据
 
 @param url 请求地址
 @param params 请求参数
 @param progressHandler 监听进度响应的回调
 @param completionHandler 请求完成的回调
 @param view HUD要添加的地方
 @param caller 方法调用者
 */


+ (void)GET:(NSString *)url params:(NSMutableDictionary *)params progress:(progressHandler)progressHandler completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller{
    //添加遮盖
    if (view) [view showHUD];
    
    weakSelf(caller);
    weakSelf(view);
    
    //发送请求
    [[self sharedHTTPSessionManager] GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        KGGLog(@"%@",weakcaller);
        
        //移除遮盖
        if (weakview && progressHandler) [weakview hideHUD];
        //如果调用者不存在就不用往下执行
        if (progressHandler && weakcaller) {
            
            CGFloat progress = downloadProgress.completedUnitCount / downloadProgress.totalUnitCount * 1.0f;
            
            progressHandler(progress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        KGGLog(@"%@",responseObject);
        // 移除遮罩
        if (weakview) [weakview hideHUD];
        // 如果调用者已经不存在，就不用继续往下执行
        if (completionHandler && weakcaller) {
            
            KGGResponseObj *obj = [KGGResponseObj mj_objectWithKeyValues:responseObject];
            
//            if (KGGExpiredTokenCode == obj.code) {
////                [KGGNotificationCenter postNotificationName:KGGConnectionStatusOffLine object:nil];
//            }
            
            completionHandler(obj);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        KGGLog(@"%@",error);
        
        // 移除遮罩
        if (weakview) {
            [weakview hideHUD];
            [MBProgressHUD showMessag:KGGHttpNerworkErrorTip toView:view];
        }
        // 如果调用者已经不存在，就不用继续往下执行
        if (completionHandler && weakcaller) {
            completionHandler(nil);
        }
        
    }];
    
}

/**
 以POST form表单的形式提交数据
 
 @param url <#url description#>
 @param form <#form description#>
 @param completionHandler <#completionHandler description#>
 @param view <#view description#>
 @param caller <#caller description#>
 */
+ (void)postFormDataWithUrl:(NSString *)url form:(NSMutableDictionary *)form  completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    // 检查是否有网络
    if (![self isReachable]) {
        // 没有网络
        weakSelf(caller);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler && weakcaller) {
                completionHandler(nil);
            }
            [MBProgressHUD showSuYaError:@"哎哟，网络貌似没有打开哟~" toView:view];
        });
        return;
    }
    
    NSDictionary *headerFieldValueDictionary = [self getHeaderFieldValueDictionary];
    // 设置请求头信息
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    
    for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
        NSString *value = headerFieldValueDictionary[httpHeaderField];
        [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
    }
    
    [self sharedHTTPSessionManager].requestSerializer = requestSerializer;
    
    if (view) [view showHUD];
    
    weakSelf(caller);
    weakSelf(view);
    
    [[self sharedHTTPSessionManager] POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSArray *keys = form.allKeys;
        for (NSString *key in keys) {
            
            id value = form[key];
            NSData *data;
            
            if ([value isKindOfClass:[NSNumber class]]) {
                NSNumber *number = value;
                data = [number.stringValue dataUsingEncoding:NSUTF8StringEncoding];
            }else if ([value isKindOfClass:[NSString class]]){
                data = [form[key] dataUsingEncoding:NSUTF8StringEncoding];
            }
            
            [formData appendPartWithFormData:data name:key];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        KGGLog(@"%@",responseObject);
        // 移除遮罩
        if (weakview) [weakview hideHUD];
        // 如果调用者已经不存在，就不用继续往下执行
        KGGResponseObj *obj = [KGGResponseObj mj_objectWithKeyValues:responseObject];
        
//        if (KGGExpiredTokenCode == obj.code) {
////            [KGGNotificationCenter postNotificationName:KGGConnectionStatusOffLine object:nil];
//        }
        
        completionHandler(obj);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        KGGLog(@"%@",error);
        // 移除遮罩
        if (weakview) {
            [weakview hideHUD];
            [MBProgressHUD showMessag:KGGHttpNerworkErrorTip toView:view];
        }
        // 如果调用者已经不存在，就不用继续往下执行
        if (completionHandler && weakcaller) {
            completionHandler(nil);
        }
    }];
}

@end


