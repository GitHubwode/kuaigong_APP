//
//  KGGWallectRequestManager.h
//  kuaigong
//
//  Created by Ding on 2017/11/27.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHTTPSessionManager.h"

@class KGGMyWalletOrderDetailsModel;
@interface KGGWallectRequestManager : KGGHTTPSessionManager

/**
 获取收入明细
 @param page 页数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)myWalletOrderDetailsUserType:(NSString *)userType Page:(NSUInteger )page completion:(void(^)(NSArray<KGGMyWalletOrderDetailsModel *> *response, NSString *totalMoeny))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

@end
