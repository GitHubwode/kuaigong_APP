//
//  KGGConst.h
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KGGConst : NSObject

extern NSString * const KGGBasicURL;

/** Itnues上的地址 */
extern NSString * const KGGAppItnuesURL;
/** 储存后台分配的deviceId的key */
extern NSString * const KGGDeviceIdKey;
/** 储存后台分配的aesKey的key，暂时不用 */
extern NSString * const KGGAesKey;
/** 手机号码最大长度 */
extern NSUInteger const KGGCellphoneMaxLength;
/** 验证码最大长度 */
extern NSUInteger const KGGVerificationCodeMaxLength;
/** 密码最大长度 */
extern NSUInteger const KGGPasswordMaxLength;
/** 密码最小长度 */
extern NSUInteger const KGGPasswordMinLength;
/** 昵称最大长度 */
extern NSUInteger const KGGNicknameMaxLength;
/** 用户登录的通知 */
extern NSString * const KGGUserLoginNotifacation;
/** 用户登出的通知 */
extern NSString * const KGGUserLogoutNotifacation;
//设备在别处登录
extern NSString *const KGGConnectionStatusOffLine;

/** 显示红点的通知 */
extern NSString * const KGGShowAlertNotifacation;
/** 隐藏红点的通知 */
extern NSString * const KGGHidenAlertNotifacation;


/** 通用的间距值 */
extern CGFloat const KGGMargin;
/** 通用的小间距值 */
extern CGFloat const KGGSmallMargin;
/** 通用的左间距值 */
extern CGFloat const KGGLeftPadding;
/** 通用的右间距值 */
extern CGFloat const KGGRightPadding;
/** 通用的Item高度 */
extern CGFloat const KGGItemHeight;
/** 通用的Item高度 */
extern CGFloat const KGGOtherItemHeight;
/** 通用的登录流程按钮的高度 */
extern CGFloat const KGGLoginButtonHeight;
/** 推送的key */
extern NSString *const KGGJPushAPPKey;
/** 高德地图的key */
extern NSString *const KGGAMApKey;
/** 融云的appkey */
extern NSString *const KGGRongCloudAppKey;

/** 储存银行卡的key */
extern NSString *const KGGBankNumKey;
/** 持卡人 */
extern NSString * const KGGCardholderKey;
/** 开户行 */
extern NSString * const KGGBankOfDepositKey;

@end
