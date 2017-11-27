//
//  KGGMyWalletOrderDetailsModel.h
//  kuaigong
//
//  Created by Ding on 2017/11/27.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGMyWalletOrderDetailsModel : NSObject
/** 工地地址 */
@property (nonatomic,copy) NSString *address;
/** 发布者头像 */
@property (nonatomic,copy) NSString *avatarUrl;
/** 发布者昵称 */
@property (nonatomic,copy) NSString *contacts;
/** 发布者电话 */
@property (nonatomic,copy) NSString *contactsPhone;
/** 工作时长 */
@property (nonatomic,copy) NSString *days;
/** 滞纳金 */
@property (nonatomic,copy) NSString *lateFee;
/** 手续费 */
@property (nonatomic,assign) double  fee;
/** 总金额 */
@property (nonatomic,copy) NSString *totalAmount;
/** 用工单价 */
@property (nonatomic,assign) double  unitPrice;
/** 用工人数 */
@property (nonatomic,assign) NSUInteger  number;
/** 工种类型 */
@property (nonatomic,assign) NSUInteger type;
/** 工作时长 */
@property (nonatomic,copy) NSString *whenLong;
/** 车费 */
@property (nonatomic,assign) double  fare;
/** 开始时间 */
@property (nonatomic,copy) NSString *workStartTime;

//增加参数
/** 工种 */
@property (nonatomic,copy) NSString *workerType;
//发布者订单的参数
@property (nonatomic, copy) NSString *orderDetails;
//接单者的订单详情
@property (nonatomic, copy) NSString *searchOrderDetails;

@end
