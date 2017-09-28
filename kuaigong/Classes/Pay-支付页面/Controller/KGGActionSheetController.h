//
//  KGGActionSheetController.h
//  kuaigong
//
//  Created by Ding on 2017/9/14.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackBlock)(NSString *successCode);

@interface KGGActionSheetController : UIViewController

@property (nonatomic,copy) CallBackBlock callPaySuccessBlock;
/** 支付多少钱 */
@property (nonatomic, copy) NSString *moneyString;
/** 被支付的 Id */
@property (nonatomic, copy) NSString *receiverId;
/** 类型 0充值 1支付 2 扣费 3 退款 4 体现 6商品类型*/
@property (nonatomic, assign) NSInteger tradeType;
/** 支付类型 0 支付宝 1 微信  2 余额 */
@property (nonatomic, assign) NSInteger mode;
/** 1课堂 2 驿站 3素女秀 4导师 5 活动 6直播 7商品 9未知 21 承办活动 22 课程购买*/
@property (nonatomic, assign) NSInteger payFrom;
/** 对于打赏栏目的 Id 驿站 id 或者活动 id商品的订单id */
@property (nonatomic, assign) NSInteger itemId;
/** 发布方 or 接单方 */
@property (nonatomic, assign) BOOL isPublish;

@end
