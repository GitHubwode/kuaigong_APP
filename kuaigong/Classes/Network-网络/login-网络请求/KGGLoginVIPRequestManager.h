//
//  KGGLoginVIPRequestManager.h
//  kuaigong
//
//  Created by Ding on 2017/10/13.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHTTPSessionManager.h"

@interface KGGLoginVIPRequestManager : KGGHTTPSessionManager

/**
 查询是否为会员
 
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param view HUD要添加的地方
 @param caller 方法调用者
 */
+ (void)loginWithRefeVIPcompletion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view inCaller:(id)caller;

@end
