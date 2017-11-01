//
//  KGGAliyunRequestManager.h
//  kuaigong
//
//  Created by Ding on 2017/10/30.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHTTPSessionManager.h"
#import <AliyunOSSiOS/OSSService.h>

@class KGGPictureMetadata;
@class KGGOrderImageModel;

typedef NS_ENUM(NSUInteger, KGGUploadAliyunState) {
    KGGUploadAliyunSuccess,
    KGGUploadAliyunFailure,
};

@interface KGGAliyunRequestManager : KGGHTTPSessionManager

//+ (void)asynUploadImageDatas:(NSArray *)images ImageModel:(KGGOrderImageModel *)imageModel complete:(void(^)(NSArray<NSString *> *responseObj))completionHandler inCaller:(id)caller;

+ (void)asynUploadImageDatas:(NSArray<KGGPictureMetadata *> *)images complete:(void(^)(NSArray<NSString *> *responseObj))completionHandler inCaller:(id)caller;

@end
