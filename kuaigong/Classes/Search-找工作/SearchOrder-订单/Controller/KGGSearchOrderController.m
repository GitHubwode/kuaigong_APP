//
//  KGGSearchOrderController.m
//  kuaigong
//
//  Created by Ding on 2017/9/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGSearchOrderController.h"
#import "KGGSearchOrderViewCell.h"
#import "KGGSearchOrderHeaderView.h"
#import "KGGPublishOrderRequestManager.h"
#import "KGGSearchOrderRequestManager.h"
#import "KGGRoutePlanningController.h"
#import "KGGLocationHelper.h"
#import "KGGForgetPasswordViewController.h"
#import "KGGCenterViewController.h"
#import "KGGLoginViewController.h"

@interface KGGSearchOrderController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KGGSearchOrderHeaderView *headerView;
@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, copy) NSString *acceptLatitude;
@property (nonatomic, copy) NSString *acceptLongitude;
@property (nonatomic, strong) KGGLocationHelper *locationHelper;
@end

@implementation KGGSearchOrderController

- (void)viewDidAppear:(BOOL)animated {
    [JANALYTICSService startLogPageView:@"KGGSearchOrderController"];
}
- (void)viewDidDisappear:(BOOL)animated {
    [JANALYTICSService stopLogPageView:@"KGGSearchOrderController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.navigationItem.title = @"实时订单";
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    [self kgg_addButton];
    [self searceHeaderView];
}

#pragma mark - 给headerView赋值
- (void)searceHeaderView
{
    [self.headerView orderMessageAvatar:self.orderDetails.avatarUrl Content:self.orderDetails.contacts ContentPhone:self.orderDetails.hidePhone];
}

#pragma mark - buttonAction
- (void)snh_sureOrderButtonClick:(UIButton *)sender
{
    if (![KGGUserManager shareUserManager].logined) {
         [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLoginViewController alloc]init]] animated:YES completion:nil];
        return;
    }
    
    if ([KGGUserManager shareUserManager].currentUser.phone.length == 0) {
        [self.view showHint:@"你没有绑定电话"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请绑定手机号" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            KGGLog(@"绑定手机号");
            KGGForgetPasswordViewController *forgrtVC = [[KGGForgetPasswordViewController alloc]init];
            forgrtVC.changetype = KGGUserChangeBindPhoneType;
            [self presentViewController:[[KGGNavigationController alloc] initWithRootViewController:forgrtVC] animated:YES completion:nil];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];

    }else{
        KGGLog(@"有电话 可以接单");
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"id"] = @(self.orderDetails.orderId);
        KGGLog(@"接单的确认按钮");
        __block CGFloat longitude;
        __block CGFloat latitude;
        weakSelf(self);
        [self.locationHelper getUserCurrentLocation:^(CLLocation *location) {
            
            [weakself.locationHelper clearLocationDelegate];
            weakself.locationHelper = nil;
            
            CLLocationCoordinate2D coordinate = location.coordinate;
            longitude = coordinate.longitude;
            latitude = coordinate.latitude;
            
            param[@"acceptLongitude"] = @(longitude);
            param[@"acceptLatitude"] = @(latitude);
            param[@"phone"] = [KGGUserManager shareUserManager].currentUser.phone;
            
            [weakself setupUserLocationParam:param];
        }];
    }
}

- (void)setupUserLocationParam:(NSMutableDictionary *)param
{
    [KGGSearchOrderRequestManager searchReciveParam:param completion:^(KGGResponseObj *responseObj) {
        
        if (responseObj.code == 617) {
            KGGLog(@"联系我们");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                KGGCenterViewController *centerVC = [[KGGCenterViewController alloc]init];
                [self.navigationController pushViewController:centerVC animated:YES];
            });
            [self.view showHint:responseObj.message];
        }
        if (responseObj.code == KGGSuccessCode) {
            [self.view showHint:@"接单成功,请按时出单"];
            [self.orderButton setTitle:@"已接单" forState:UIControlStateNormal];
            self.orderButton.enabled = NO;
            [self jumpRoutePlanning];
        }
    } aboveView:self.view inCaller:self];
}

#pragma mark - 跳转到路线规划
- (void)jumpRoutePlanning
{
    KGGRoutePlanningController *routeVC = [[KGGRoutePlanningController alloc]init];
    routeVC.orderDetails = self.orderDetails;
    routeVC.planType = KGGRoutePlanningWORKERType;
//    routeVC.callCancelOrderBlock = ^(NSString *code) {
//        [self ]
//    }
    [self.navigationController pushViewController:routeVC animated:YES];
    
}

#pragma mark- UITableViewDatasource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderDetails.imageArray) {
        return 410+132;
    }else{
        return 410;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGSearchOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGSearchOrderViewCell searchOrderIdentifier]];
    cell.orderDetails = self.orderDetails;
    return cell;
}

- (void)kgg_addButton
{
    weakSelf(self);
    self.orderButton = [self snh_creatButtonImage:@"bg_button" Title:@"接单"];
    [self.view addSubview:self.orderButton];
    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.bottom.equalTo(weakself.view.mas_bottom);
        make.height.equalTo(@(KGGLoginButtonHeight));
        make.width.equalTo(@(kMainScreenWidth));
    }];
}

#pragma mark - lazyButton
- (UIButton *)snh_creatButtonImage:(NSString *)image Title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(snh_sureOrderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-KGGLoginButtonHeight-64) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGSearchOrderViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGSearchOrderViewCell searchOrderIdentifier]];
        _tableView.delegate = self;
        _tableView.dataSource = self;        
    }
    return _tableView;
}

- (KGGSearchOrderHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KGGSearchOrderHeaderView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 70)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (KGGLocationHelper *)locationHelper{
    if (!_locationHelper) {
        _locationHelper = [[KGGLocationHelper alloc] init];
    }
    return _locationHelper;
}

- (void)dealloc
{
    KGGLogFunc
}

@end
