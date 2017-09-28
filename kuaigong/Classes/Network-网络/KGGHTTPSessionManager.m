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
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript", nil];
        
    });
    
    return instance;
}

/**
 获取请求头
 
 @return 请求头
 */
// + (NSDictionary *)getHeaderFieldValueDictionary
//{
//    NSMutableDictionary *headerFieldValueDictionary = [NSMutableDictionary dictionary];
//    
//}

@end





































