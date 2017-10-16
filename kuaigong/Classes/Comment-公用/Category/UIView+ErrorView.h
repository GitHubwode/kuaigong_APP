//
//  UIView+ErrorView.h
//  泡吧
//
//  Created by jiang on 16/8/15.
//  Copyright © 2016年 paoba. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 ErrorView分为两种：
 1.服务器数据错误的View（网络错误）
 2.业务数据错误的View（业务错误）
 */
@interface UIView (ErrorView)

///*!
// 网络错误
// */
//- (void)showNetworkErrorViewWithRetryBlock:(void (^)(void))retryBlock;
///*!
// 网络错误
// */
//- (void)showNetworkErrorViewWithyOffset:(CGFloat)yOffset retryBlock:(void (^)(void))retryBlock;


/*!
 业务错误
 */
- (void)showBusinessErrorViewWithError:(NSString *)error;
/*!
 业务错误
 */
- (void)showBusinessErrorViewWithError:(NSString *)error yOffset:(CGFloat)yOffset;


- (void)removeErrorView;



@end
