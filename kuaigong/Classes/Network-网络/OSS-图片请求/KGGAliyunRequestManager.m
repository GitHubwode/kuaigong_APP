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

+ (OSSClient *)getOSSClientTokenModel:(KGGOrderImageModel *)tokenModel
{
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc]initWithAccessKeyId:tokenModel.accessid secretKeyId:tokenModel.signature securityToken:tokenModel.policy];

    
    return [[OSSClient alloc] initWithEndpoint:[NSString stringWithFormat:@"%@",tokenModel.host] credentialProvider:credential];
}

+ (void)asynUploadImageDatas:(NSArray<KGGPictureMetadata *> *)images ImageModel:(KGGOrderImageModel *)imageModel complete:(void(^)(NSArray<NSString *> *responseObj))completionHandler inCaller:(id)caller
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
    
    OSSClient *client =  [self getOSSClientTokenModel:imageModel];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 3;
    
    NSMutableArray *callBackNames = [NSMutableArray array];
    for (KGGPictureMetadata *meta in images) {
        if (!meta)  continue;
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
           //执行任务
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            NSString *imageName = [[self getFileName] stringByAppendingString:@".jpg"];
            put.objectKey = [NSString stringWithFormat:@"%@%@",imageModel.dir,imageName];
            put.bucketName = @"kuaigong0001";
            put.uploadingData = meta.data;
            OSSTask * putTask = [client putObject:put];
            
            [putTask waitUntilFinished]; // 阻塞直到上传完成
            
            if (!putTask.error) {
                KGGLog(@"upload object success!");
                meta.url = [imageModel.host stringByAppendingString:imageModel.dir];
                
                [callBackNames addObject:[meta mj_JSONString]];
                
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


@end
