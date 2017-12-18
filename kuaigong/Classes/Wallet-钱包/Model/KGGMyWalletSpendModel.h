//
//  KGGMyWalletSpendModel.h
//  kuaigong
//
//  Created by Ding on 2017/12/15.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGMyWalletSpendModel : NSObject

/** 总金额 */
@property (nonatomic,assign)double  balance;
/** 可提现接 */
@property (nonatomic,assign)double drawAmount;
/** 用户id */
@property (nonatomic,copy)NSString * userId;
/** 订单No */
@property (nonatomic,copy) NSString *orderNo;
/** 创建时间 */
@property (nonatomic,copy) NSString *createDate;

@end
