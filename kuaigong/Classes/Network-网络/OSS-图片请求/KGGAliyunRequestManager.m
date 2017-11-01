//
//  KGGAliyunRequestManager.m
//  kuaigong
//
//  Created by Ding on 2017/10/30.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGAliyunRequestManager.h"
#import "KGGPictureMetadata.h"
#import "KGGShowFeedApiItem.h"
#import "KGGOrderImageModel.h"


#ifdef DEBUG
NSString * const SNHBucketName = @"kuaigong0001";
NSString * const SNHEndPoint = @"https://oss-cn-hangzhou.aliyuncs.com";
NSString * const SNHImageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/order/";
#else
NSString * const SNHBucketName = @"kuaigong0001";
NSString * const SNHEndPoint = @"https://oss-cn-hangzhou.aliyuncs.com";
NSString * const SNHImageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/order/";
#endif


NSString * const SNHAccessKey = @"LTAIkAyeAEmsShJP";
NSString * const SNHSecretKey = @"9o1gchHblzRwRONYnCIEwJ3tl2NoUG";

@implementation KGGAliyunRequestManager


+ (NSString *)getFileName{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 10000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@-%i", date,last];
    KGGLog(@"%@", timeNow);
    return timeNow;
}

+ (OSSClient *)getOSSClient{
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式参考后面链接给出的官网完整文档的`访问控制`章节
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:SNHAccessKey secretKey:SNHSecretKey];
    return [[OSSClient alloc] initWithEndpoint:SNHEndPoint credentialProvider:credential];
}



+ (void)asynUploadImageDatas:(NSArray<KGGPictureMetadata *> *)images complete:(void(^)(NSArray<NSString *> *responseObj))completionHandler inCaller:(id)caller
{
    weakSelf(caller);
    // 检查是否有网络
    if (![self isReachable] || !images.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler && weakcaller) {
                completionHandler(nil);
            }
        });
        return;
    }
    
    OSSClient *client = [self getOSSClient];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 3;
    
    NSMutableArray *callBackNames = [NSMutableArray array];
    
    for (KGGPictureMetadata *meta in images) {
        if (!meta) continue;
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            //任务执行
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            put.bucketName = SNHBucketName;
            NSString *imageName = [[self getFileName] stringByAppendingString:@".jpg"];
            put.objectKey = [NSString stringWithFormat:@"kuaigong_help/order/%@",imageName];
            put.uploadingData = meta.data;
            
            OSSTask * putTask = [client putObject:put];
            
            [putTask waitUntilFinished]; // 阻塞直到上传完成
            
            if (!putTask.error) {
                KGGLog(@"upload object success!");
                meta.url = [SNHImageUrl stringByAppendingString:imageName];
                [callBackNames addObject:meta.url];
                
            }else{
                [queue cancelAllOperations];
                KGGLog(@"upload object failed, error: %@" , putTask.error);
                if (completionHandler && weakcaller) {
                    completionHandler(nil);
                }
            }
            
            if (meta == images.lastObject) {
                KGGLog(@"upload object finished!");
                
                if (completionHandler) {
                    completionHandler([NSArray arrayWithArray:callBackNames]);
                }
            }
            
        }];
        if (queue.operations.count != 0) {
            [operation addDependency:queue.operations.lastObject];
        }
        [queue addOperation:operation];
        
    }
}






+ (void)asynUploadImageDatas:(NSArray *)images ImageModel:(KGGOrderImageModel *)imageModel complete:(void(^)(NSArray<NSString *> *responseObj))completionHandler inCaller:(id)caller
{

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    for (NSData *meta in images) {
//        if (!meta) continue;
//
//        NSString *url = imageModel.host;
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//
//        NSString *imageName = [[self getFileName] stringByAppendingString:@".jpg"];
//        dic[@"name"] = imageName;
//        dic[@"key"] = [NSString stringWithFormat:@"%@%@",imageModel.dir,imageName];
//        dic[@"policy"] =imageModel.policy;
//        dic[@"OSSAccessKeyId"] = imageModel.accessid;
//        dic[@"signature"] = imageModel.signature;
//        dic[@"file"] = meta;
//
//    [self postFormImageDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
//
//        if (!responseObj) {
//
//        }else if (responseObj.code != KGGSuccessCode){
//            [MBProgressHUD showMessag:responseObj.message];
//        }
//        KGGLog(@"%@",responseObj);
////        if (completionHandler) {
////            completionHandler(responseObj);
////        }
//    } aboveView:nil inCaller:caller];
//
//    }
////
}


@end
