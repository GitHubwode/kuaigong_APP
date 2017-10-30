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

//+ (void)asyncUploadSingleVideo:(NSString *)path completion:(void(^)(NSString *resultUrl))completionHandler aboveView:(UIView *)view inCaller:(id)caller;
//
//+ (void)asynUploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray<NSString *> *responseObj))completionHandler inCaller:(id)caller;

+ (void)asynUploadImageDatas:(NSArray<KGGPictureMetadata *> *)images ImageModel:(KGGOrderImageModel *)imageModel complete:(void(^)(NSArray<NSString *> *responseObj))completionHandler inCaller:(id)caller;

@end
