//
//  KGGOrderDetailsModel.h
//  kuaigong
//
//  Created by Ding on 2017/10/11.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGOrderDetailsModel : NSObject

/** 订单id */
@property (nonatomic,assign) NSUInteger  orderId;
/** 用户id */
@property (nonatomic,assign) NSUInteger  userId;
/** 订单名称 */
@property (nonatomic,copy) NSString *name;
/** 类型 */
@property (nonatomic,assign) NSUInteger type;
/** 用工人数 */
@property (nonatomic,assign) NSUInteger  number;
/** 用工天数 */
@property (nonatomic,assign) NSUInteger  days;
/** 用工单价 */
@property (nonatomic,assign) double  unitPrice;
/** 车费 */
@property (nonatomic,assign) double  fare;
/** 经度 */
@property (nonatomic,copy) NSString *longitude;
/** 维度 */
@property (nonatomic,copy) NSString *latitude;
/** 状态 */
@property (nonatomic,assign) NSUInteger  status;
/** 项目地址 */
@property (nonatomic,copy) NSString *address;
/** 项目时长 */
@property (nonatomic,copy) NSString *whenLong;
/** 手续费 */
@property (nonatomic,assign) double  fee;
/** 联系人名称 */
@property (nonatomic,copy) NSString *contacts;
/** 联系人电话 */
@property (nonatomic,copy) NSString *contactsPhone;
/** 绑卡订单信息 */
@property (nonatomic,copy) NSString *orderMessage;
/** 订单详情 */
@property (nonatomic,copy) NSString *orderContent;
/** 是否优先派单 0为否 1为是 */
@property (nonatomic,assign) NSUInteger  firstDispatch;
/** 备注 */
@property (nonatomic,copy) NSString *remark;
/** 创建时间 */
@property (nonatomic,copy) NSString *createTime;
/** 更新时间 */
@property (nonatomic,copy) NSString *updateTime;
/** 接单时间 */
@property (nonatomic,copy) NSString *accpetTime;
/** 删除 */
@property (nonatomic,assign) NSUInteger  deleted;
/** 订单总金额 */
@property (nonatomic,assign) double  totalAmount;
/** 接单用户的id */
@property (nonatomic,assign) NSUInteger  acceptUser;
/** 订单号 */
@property (nonatomic,copy) NSString * orderNo;
/** 开始时间 */
@property (nonatomic,copy) NSString *workStartTime;
/** 支付时间 */
@property (nonatomic,copy) NSString *payTime;
/** 发布方头像 */
@property (nonatomic,copy) NSString *avatarUrl;
/** 工地图片 */
@property (nonatomic,copy) NSString *orderUrl;
/** 接单者的纬度 */
@property (nonatomic,copy) NSString *acceptLatitude;
/** 接单者的经度 */
@property (nonatomic,copy) NSString *acceptLongitude;
/** 两地距离 */
@property (nonatomic,copy) NSString *instance;

//增加的参数
@property (nonatomic, copy) NSString *orderDetails;
//接单者的订单详情
@property (nonatomic, copy) NSString *searchOrderDetails;

/** 工作类型 木工 钢筋工 */
@property (nonatomic, copy) NSString *workerType;
/** 接单方显示的金额 */
@property (nonatomic, copy) NSString *differentPrice;
/** 隐藏电话号码 */
@property (nonatomic, copy) NSString *hidePhone;
@property (nonatomic, strong) NSMutableArray *imageArray;


@end
