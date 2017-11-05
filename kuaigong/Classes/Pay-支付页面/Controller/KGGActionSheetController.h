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
/** 对于打赏栏目的 Id 驿站 id 或者活动 id商品的订单id */
@property (nonatomic, copy) NSString * itemId;
/** 发布方 or 接单方 */
@property (nonatomic, assign) BOOL isPublish;
/** 支付 USERVIP or ORDER */
@property (nonatomic,copy) NSString *tradeType;

@end
