//
//  KGGRouteTableView.m
//  kuaigong
//
//  Created by Ding on 2017/11/6.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGRouteTableView.h"
#import "KGGRouteViewCell.h"
#import "KGGRouteHeaderView.h"
#import "KGGRouteFooterView.h"
#import "KGGOrderDetailsModel.h"
#import "KGGRouteModel.h"
#import "KGGPublishOrderRequestManager.h"
#import "KGGSearchUserModel.h"

@interface KGGRouteTableView ()<UITableViewDelegate,UITableViewDataSource,KGGRouteHeaderViewDelegate,KGGRouteFooterViewDelegate>

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) KGGRouteHeaderView *headerView;
@property (nonatomic, strong) KGGRouteFooterView *footerView;
@property (nonatomic, strong) KGGOrderDetailsModel *orderModel;
//@property (nonatomic, strong) KGGSearchUserModel *acceptModel;
/** 身份类型  BOSS or WORKER */
/**  */
@property (nonatomic,assign) NSUInteger  identifyType;

@end
@implementation KGGRouteTableView

- (instancetype)initWithFrame:(CGRect)frame OrderModel:(KGGOrderDetailsModel *)orderModel IdentifiyType:(NSUInteger)identifyType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.orderModel = orderModel;
        self.identifyType = identifyType;
        [self addSubview:self.tableView];
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
        KGGLog(@"RouteTableView模型:%@",self.orderModel)
        [self routeHeaderView];
        [self creatMessageDatasource];
    }
    return self;
}

#pragma mark - 获取数据
- (void)setupRequestOrderModel:(KGGOrderDetailsModel *)orderModel
{
    self.orderModel = orderModel;
    [self.datasource removeAllObjects];
    [self creatMessageDatasource];
    [self routeHeaderView];
}

- (void)setupRequestAcceptModel:(KGGSearchUserModel *)acceptModel
{
    [self.headerView routeHeaderViewAvatar:acceptModel.avatarUrl Name:acceptModel.nickname Phone:acceptModel.phone Address:self.orderModel.address TotalMoney:[NSString stringWithFormat:@"%.f",self.orderModel.totalAmount]];
}

#pragma mark - 创建模型
- (void)creatMessageDatasource
{
    KGGRouteModel *model = [[KGGRouteModel alloc]init];
    model.title = @"订单详情:";
    if (self.identifyType == 1) {
         model.subTitle = self.orderModel.orderDetails;
    }else{
        model.subTitle = self.orderModel.searchOrderDetails;
    }
    [self.datasource addObject:model];
    
    KGGRouteModel *model1 = [[KGGRouteModel alloc]init];
    model1.title = @"订单备注:";
    model1.subTitle = self.orderModel.remark;
    [self.datasource addObject:model1];
    
    KGGRouteModel *model2 = [[KGGRouteModel alloc]init];
    model2.title = @"用工时间:";
    model2.subTitle = self.orderModel.workStartTime;
    [self.datasource addObject:model2];
    [self.tableView reloadData];
    
    KGGRouteModel *model3 = [[KGGRouteModel alloc]init];
    model3.title = @"支付时间:";
    model3.subTitle = self.orderModel.payTime;
    [self.datasource addObject:model3];
    [self.tableView reloadData];

}

#pragma mark - 给headerView赋值
- (void)routeHeaderView{
    if (self.identifyType == 1 ) {
//        [self setupAcceptUserMessage];
//        [self.headerView routeHeaderViewAvatar:self.acceptModel.avatarUrl Name:self.acceptModel.nickname Phone:self.acceptModel.phone Address:self.orderModel.address TotalMoney:[NSString stringWithFormat:@"%.f",self.orderModel.totalAmount]];
    }else{
       [self.headerView routeHeaderViewAvatar:self.orderModel.avatarUrl Name:self.orderModel.contacts Phone:self.orderModel.contactsPhone Address:self.orderModel.address TotalMoney:[NSString stringWithFormat:@"%@",self.orderModel.differentPrice]];
    }
}

//#pragma mark -网络请求 获取接单方的用户信息
//- (void)setupAcceptUserMessage
//{
//    [KGGPublishOrderRequestManager publishOrderAcceptId:self.orderModel.acceptUser completion:^(KGGResponseObj *responseObj) {
//        if (responseObj.code == KGGSuccessCode) {
//            KGGSearchUserModel *userModel = [KGGSearchUserModel mj_objectWithKeyValues:responseObj.data];
//            [self.headerView routeHeaderViewAvatar:userModel.avatarUrl Name:userModel.nickname Phone:userModel.phone Address:self.orderModel.address TotalMoney:[NSString stringWithFormat:@"%.f",self.orderModel.totalAmount]];
//        }
//    } aboveView:nil inCaller:self];
//}

#pragma mark -KGGRouteHeaderViewDelegate
- (void)routeHeaderViewButtonClickTag:(UIButton *)buttonTag
{
    if ([self.routeDelegate respondsToSelector:@selector(routeRouteTableViewButtonClickTag:)]) {
        [self.routeDelegate routeRouteTableViewButtonClickTag:buttonTag];
    }
}
- (void)routeHeaderViewArrowButtonClick:(UIButton *)sender
{
    if (!sender.selected) {
        [self.datasource removeAllObjects];
    }else{
        [self creatMessageDatasource];
    }
    
    if ([self.routeDelegate respondsToSelector:@selector(routeRouteTableViewArrowButtonClick:)]) {
        [self.routeDelegate routeRouteTableViewArrowButtonClick:sender];
    }
    self.tableView.frame = CGRectMake(0, 0, self.xc_width, self.xc_height);
    [self.tableView reloadData];
}

#pragma mark -KGGRouteFooterViewDelegate
- (void)routeFooterViewButtonClickTag:(UIButton *)buttonTag
{
    if ([self.routeDelegate respondsToSelector:@selector(routeRouteTableViewButtonClickTag:)]) {
        [self.routeDelegate routeRouteTableViewButtonClickTag:buttonTag];
    }
}
- (void)routeFooterViewGoButtonClickTag:(UIButton *)buttonTag
{
    if ([self.routeDelegate respondsToSelector:@selector(routeRouteTableViewButtonClickTag:)]) {
        [self.routeDelegate routeRouteTableViewButtonClickTag:buttonTag];
    }
}

#pragma mark - UITableViewDeelgate  UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 || indexPath.row == 3) {
        return 25.f;
    }else{
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGRouteModel *model = self.datasource[indexPath.row];
    KGGRouteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGRouteViewCell identifierRouteView] forIndexPath:indexPath];
    cell.titleLabel.text = model.title;
    cell.subTitleLabel.text = model.subTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.xc_width,self.xc_height) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"KGGRouteViewCell"bundle:nil] forCellReuseIdentifier:[KGGRouteViewCell identifierRouteView]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (KGGRouteHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KGGRouteHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.xc_width, 106)];
        _headerView.headerDelegate = self;
    }
    return _headerView;
}

- (KGGRouteFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[KGGRouteFooterView alloc]initWithFrame:CGRectMake(0, 0, self.xc_width, 103)IdentifyType:self.identifyType];
        _footerView.footerDelegate = self;
    }
    return _footerView;
}

- (KGGOrderDetailsModel *)orderModel
{
    if (!_orderModel) {
        _orderModel = [[KGGOrderDetailsModel alloc]init];
    }
    return _orderModel;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}



@end
