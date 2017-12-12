//
//  KGGConst.m
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGConst.h"

@implementation KGGConst

//#ifdef DEBUG
//NSString * const KGGBasicURL = @"https://api.zjkgwl.com";
//
//#else
//NSString * const KGGBasicURL = @"https://api.zjkgwl.com";
//NSString * const KGGBasicURL = @"http://192.168.50.40:8080";
NSString * const KGGBasicURL = @"https://api.dev.zjkgwl.com";
//#endif

/** 正式环境储存后台分配的aesKey的key */
//NSString * const KGGAesKey = @"USGzksAv^4yjMOsiiH#hN^KTS@ir%cg7MpOrA#xBAhHzSKUQXdtF^vRx&AkdRIdj";

/** 测试环境环境储存后台分配的aesKey的key */
NSString * const KGGAesKey = @"I0*!TwulnX0f1pyd#Kbw$2Pe4AUerBXlylQPl5^RBG0wITGBC#VN5fZZ8n@3D#I9";

/** 测试 融云的appkey */
NSString *const KGGRongCloudAppKey = @"pvxdm17jpicmr";
/** 正式 融云的appkey */
//NSString *const KGGRongCloudAppKey = @"uwd1c0sxuvrc1";

/** 百度APPID */
NSString * const KGGBaiDuAPPID = @"10196479";
/** 保存用户的类型 */
NSString * const KGGUserType = @"KGGUserType";
/** 存储用户是否上工 */
NSString *const KGGJPushType = @"KGGJPushType";
/** Itnues上的地址 */
NSString * const KGGAppItnuesURL = @"https://itunes.apple.com/app/id1299000005";
/** 储存后台分配的deviceId的key */
NSString * const KGGDeviceIdKey = @"KGGDeviceIdKey";
/** 推送的appkey */
NSString * const KGGJPushAPPKey = @"dad3761a709164767b06958e";
/** 百度地图的key */
NSString *const KGGAMApKey = @"0f36c68b1fd0ac66da53bf33d7b12797";
//设备在别处登录
NSString *const KGGConnectionStatusOffLine = @"KGG_KICKED_OFFLINE_BY_OTHER_CLIENT";
//接收到消息 融云或者其他的
NSString *const KGGRongYunReceiedNotifacation = @"KGGRongYunReceiedNotifacation";
/** 显示红点的通知 */
NSString * const KGGShowAlertNotifacation = @"KGGShowAlertNotifacation";
/** 隐藏红点的通知 */
NSString * const KGGHidenAlertNotifacation = @"KGGHidenAlertNotifacation";
/** 手机号码最大长度 */
NSUInteger const KGGCellphoneMaxLength = 11;
/** 验证码最大长度 */
NSUInteger const KGGVerificationCodeMaxLength = 4;
/** 密码最大长度 */
NSUInteger const KGGPasswordMaxLength = 16;
/** 密码最小长度 */
NSUInteger const KGGPasswordMinLength = 6;
/** 昵称最大长度 */
NSUInteger const KGGNicknameMaxLength = 8;
/** 用户登录的通知 */
NSString * const KGGUserLoginNotifacation = @"KGGUserLoginNotifacation";
/** 用户登出的通知 */
NSString * const KGGUserLogoutNotifacation = @"KGGUserLogoutNotifacation";
/** 通用的间距值 */
CGFloat const KGGMargin = 10;
/** 通用的小间距值 */
CGFloat const KGGSmallMargin = KGGMargin * 0.5;
/** 通用的左间距值 */
CGFloat const KGGLeftPadding = 15.f;
/** 通用的右间距值 */
CGFloat const KGGRightPadding = KGGLeftPadding;
/** 通用的item高度 */
CGFloat const KGGItemHeight = 44.f;
/** 通用的Item高度 */
CGFloat const KGGOtherItemHeight = 36.f;
/** 通用的登录流程按钮的高度 */
CGFloat const KGGLoginButtonHeight = 49.f;
/** 通用的图像尺寸 */
CGSize const KGGSmallAvatarSize = {35.f, 35.f};
CGSize const KGGMiddleAvatarSize = {44.f, 44.f};
CGSize const KGGBigAvatarSize = {50.f, 50.f};

CGSize const KGGUploadAvatarSize = {500.f, 500.f};

/** 发表时文字的最大长度 */
NSUInteger const KGGComposeTextMaxLength = 1000;
/** 用户更改头像的通知 */
NSString * const KGGUpdateUserAvatarNotifacation = @"KGGUpdateUserAvatarNotifacation";
/** 用户绑定手机号的通知 */
NSString * const KGGBindCellphoneNotifacation = @"KGGBindCellphoneNotifacation";
/** 储存银行卡的key */
NSString * const KGGBankNumKey = @"KGGBankNumKey";
/** 持卡人 */
NSString * const KGGCardholderKey = @"KGGCardholderKey";
/** 开户行 */
NSString * const KGGBankOfDepositKey = @"KGGBankOfDepositKey";
/** 绑定银行卡时 总金额 */
NSString * const KGGBalanceMoneyKey = @"KGGBalanceMoneyKey";
/** 绑定银行卡 可提现金额 */
NSString * const KGGDrawBalanceMoneyKey = @"KGGDrawBalanceMoneyKey";

/** 用户添加银行卡成功的通知 */
NSString * const KGGAddBankCardSuccessNotifacation = @"KGGAddBankCardSuccessNotifacation";
/** 用户申请提现成功的通知 */
NSString * const KGGApplyWithdrawSuccessNotifacation = @"KGGApplyWithdrawSuccessNotifacation";
/** 用户申请充值成功的通知 */
NSString * const KGGApplyRechargeSuccessNotifacation = @"KGGApplyRechargeSuccessNotifacation";
/** 提交编辑驿站的申请的通知 */
NSString * const KGGSubmitStageInfoNotifacation = @"KGGSubmitStageInfoNotifacation";
/** 用户申请信物付费成功的通知 */
NSString * const KGGApplyKeepsakeSuccessNotifacation = @"KGGApplyKeepsakeSuccessNotifacation";
/** 用户输入车辆数改变车费 */
NSString * const KGGInputCarNumNotifacation = @"KGGInputCarNumNotifacation";
//微信
NSString *const KGGWeiXinPayURLScheme = @"wx8dd9d756d12032a3";
//微信Secret
NSString *const KGGWeiXinAppSecret = @"da1f19a8e4a507845dbb7dd441ccdef2";
//支付宝
NSString *const KGGAliPayURLScheme = @"sn2088821472320245";
//友盟
NSString *const KGGUMSocialAppKey = @"582199e0b27b0a5d6c001e64";

//支付宝
NSString *const KGGPayBlackNotification = @"payBackInformation";
//微信
NSString *const SNHPayWeiXinNotification = @"weixinInfomation";
//支付成功
NSString *const SNHPaySuccessNotification = @"paySuccessNotification";

@end
