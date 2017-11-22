//
//  KGGRouteTableView.h
//  kuaigong
//
//  Created by Ding on 2017/11/6.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGOrderDetailsModel;
@class KGGSearchUserModel;

@protocol KGGRouteTableViewDelegate <NSObject>

- (void)routeRouteTableViewButtonClickTag:(UIButton *)buttonTag;
- (void)routeRouteTableViewArrowButtonClick:(UIButton *)sender;

@end

@interface KGGRouteTableView : UIView

- (instancetype)initWithFrame:(CGRect)frame OrderModel:(KGGOrderDetailsModel *)orderModel IdentifiyType:(NSUInteger)identifyType;
@property (nonatomic, weak)id<KGGRouteTableViewDelegate>routeDelegate;
@property (nonatomic, strong) UITableView *tableView;

#pragma mark - 获取数据
- (void)setupRequestOrderModel:(KGGOrderDetailsModel *)orderModel;
- (void)setupRequestAcceptModel:(KGGSearchUserModel *)acceptModel;


@end
