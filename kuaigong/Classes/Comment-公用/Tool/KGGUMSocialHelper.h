//
//  KGGUMSocialHelper.h
//  kuaigong
//
//  Created by Ding on 2017/9/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

typedef NS_ENUM(NSUInteger,KGGShareType) {
    KGGShareInviteWebpageType,
    KGGShareWebpageType,
    KGGShareVideoType,
};

typedef void(^KGGShareCompletionHandler)(BOOL success,NSError *error);

@interface KGGUMSocialHelper : NSObject

/**
 初始化友盟
 */
+ (void)setUpUMSocial;

/**
 检查是否安装微信
 */
+ (BOOL)isWXAppInstalled;

/** 
 处理会掉url
 @param url <#url description#>
 @return <#return value description#>
 
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

/**
 分享
 
 @param platform 平台
 @param title 标题
 @param descr 文字
 @param thumImage 缩略图
 @param linkUrl 链接
 @param shareType 分享类型
 @param completion 完成回调
 */
+ (void)shareToPlatform:(UMSocialPlatformType)platform withTitle:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage linkUrl:(NSString *)linkUrl shareType:(KGGShareType)shareType completion:(KGGShareCompletionHandler)completion;

/**
 获取授权后的用户信息
 
 @param platform 平台
 @param currentViewController <#currentViewController description#>
 @param completionHandler <#completionHandler description#>
 */
+ (void)getUserInfoWithPlatform:(UMSocialPlatformType)platform currentViewController:(UIViewController *)currentViewController completion:(void(^)(UMSocialUserInfoResponse *userinfo))completionHandler;


@end
