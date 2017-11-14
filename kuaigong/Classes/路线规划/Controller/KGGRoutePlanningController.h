//
//  KGGRoutePlanningController.h
//  kuaigong
//
//  Created by Ding on 2017/11/6.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGOrderDetailsModel;

typedef void(^CallBackBlock)(NSString *code);

typedef NS_ENUM(NSUInteger, KGGRoutePlanningType) {
    KGGRoutePlanningBOSSType =1, // 发布方接单详情
    KGGRoutePlanningWORKERType =2, // 接单方接单详情
};

@interface KGGRoutePlanningController : UIViewController
@property (nonatomic,copy) CallBackBlock callCancelOrderBlock;

@property (nonatomic, strong)KGGOrderDetailsModel *orderDetails;
/** 发布方接单详情Or接单方接单详情 */
@property (nonatomic, assign) KGGRoutePlanningType planType;



@end
