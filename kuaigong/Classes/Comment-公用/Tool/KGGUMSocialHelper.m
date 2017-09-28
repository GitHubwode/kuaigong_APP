//
//  KGGUMSocialHelper.m
//  kuaigong
//
//  Created by Ding on 2017/9/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGUMSocialHelper.h"
#import <UShareUI/UShareUI.h>
#import "NSBundle+KGGExtension.h"
#import "AppDelegate.h"
#import "NSObject+swizzle.h"

static NSString *const KGGUMSocialAppKey = @"582199e0b27b0a5d6c001e64";

static NSString *const KGGWXAppKey = @"wxd6f50383b24095d6";
static NSString *const KGGWXAppSecret = @"f6eb19b732bf404d45dd16fb5ddcde11";

@implementation KGGUMSocialHelper
/**
 初始化友盟
 */
+ (void)setUpUMSocial
{
    //设置app版本号
    [MobClick setAppVersion:[NSBundle currentVersion]];
    //初始化统计
    UMConfigInstance.appKey = KGGUMSocialAppKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    //设置是否打印sdk的log信息
#if DEBUG
    [MobClick setLogEnabled:YES];
#else
    [MobClick setLogEnabled:NO];
#endif
    
    //大开调试日志
    [[UMSocialManager defaultManager]openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager]setUmSocialAppkey:KGGUMSocialAppKey];
    
    [self setUpUMSocialConfig];
}

+ (void)setUpUMSocialConfig{
    //安装微信
    if ([self isWXAppInstalled]) {
        //设置微信的appkey和appSecret
        [[UMSocialManager defaultManager]setPlaform:UMSocialPlatformType_WechatSession appKey:KGGWXAppKey appSecret:KGGWXAppSecret redirectURL:nil];
    }

}

/**
 检查是否安装微信
 */
+ (BOOL)isWXAppInstalled
{
    return [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]];
}

/**
 处理会掉url
 @param url <#url description#>
 @return <#return value description#>
 
 */
+ (BOOL)handleOpenURL:(NSURL *)url
{
    return [[UMSocialManager defaultManager]handleOpenURL:url];
}

+ (void)shareImageToPlatform:(UMSocialPlatformType)platform withTitle:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage webpageUrl:(NSString *)webpageUrl completion:(KGGShareCompletionHandler)completion{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    //    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:thumImage];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        BOOL success = !error;
        if (completion) {
            completion(success, error);
        }
    }];
}



/**
 分享网页
 
 @param platform 分享平台
 @param title 分享的标题(分享到朋友圈时只有标题)
 @param descr 分享的文字
 @param thumImage 分享的缩略图地址或者UIImage
 @param webpageUrl 分享的网页地址
 @param completion 分享完成后的回调
 */
+ (void)shareWebpageToPlatform:(UMSocialPlatformType)platform withTitle:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage webpageUrl:(NSString *)webpageUrl completion:(KGGShareCompletionHandler)completion{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumImage];
    //设置网页地址
    shareObject.webpageUrl = webpageUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        BOOL success = !error;
        if (completion) {
            completion(success, error);
        }
    }];
}

/**
 分享视频
 
 @param platform 分享平台
 @param title 分享的标题(分享到朋友圈时只有标题)
 @param descr 分享的文字
 @param thumImage 分享的缩略图地址
 @param videoUrl 视频网页播放地址
 @param completion 分享完成后的回调
 */
+ (void)shareVideoToPlatform:(UMSocialPlatformType)platform withTitle:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage videoUrl:(NSString *)videoUrl completion:(KGGShareCompletionHandler)completion{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建视频内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:descr thumImage:thumImage];
    //设置视频网页播放地址
    shareObject.videoUrl = videoUrl;
    //            shareObject.videoStreamUrl = @"这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        BOOL success = !error;
        if (completion) {
            completion(success, error);
        }
    }];
}


+ (void)shareToPlatform:(UMSocialPlatformType)platform withTitle:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage linkUrl:(NSString *)linkUrl shareType:(KGGShareType)shareType completion:(KGGShareCompletionHandler)completion
{
    if (KGGShareWebpageType == shareType) {
        [self shareWebpageToPlatform:platform withTitle:title descr:descr thumImage:thumImage webpageUrl:linkUrl completion:completion];
    }else if (KGGShareVideoType == shareType){
        [self shareVideoToPlatform:platform withTitle:title descr:descr thumImage:thumImage videoUrl:linkUrl completion:completion];
    }else if (KGGShareInviteWebpageType == shareType){
        [self shareImageToPlatform:platform withTitle:title descr:descr thumImage:thumImage webpageUrl:linkUrl completion:completion];
    }
}

/**
 获取授权后的用户信息
 @param platform 平台
 @param currentViewController <#currentViewController description#>
 @param completionHandler <#completionHandler description#>
 */
+ (void)getUserInfoWithPlatform:(UMSocialPlatformType)platform currentViewController:(UIViewController *)currentViewController completion:(void(^)(UMSocialUserInfoResponse *userinfo))completionHandler
{
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platform currentViewController:currentViewController completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *userinfo = result;
        if (completionHandler) {
            completionHandler(userinfo);
        }
    }];
}

@end
