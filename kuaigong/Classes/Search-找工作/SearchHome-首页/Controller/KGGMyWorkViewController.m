//
//  KGGMyWorkViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/20.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMyWorkViewController.h"
#import "KGGMyWorkViewCell.h"
#import "KGGWorkDetailsViewController.h"
#import "KGGOrderDetailsModel.h"
#import "KGGPublishOrderViewCell.h"
#import "KGGRoutePlanningController.h"
#import "KGGLocationHelper.h"

@interface KGGMyWorkViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) NSUInteger pageNum;
@property (nonatomic, assign) CGFloat acceptLatitude;
@property (nonatomic, assign) CGFloat acceptLongitude;
@property (nonatomic, strong) KGGLocationHelper *locationHelper;

@end

@implementation KGGMyWorkViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self doneRefreshMessage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的工作";
    self.view.backgroundColor = KGGViewBackgroundColor;
    [self.view addSubview:self.orderTableView];
    self.orderTableView.mj_header = [KGGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(doneRefreshMessage)];
    self.orderTableView.mj_footer = [KGGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(doneLoadAddMoreMessage)];
    [self.orderTableView.mj_header beginRefreshing];
}

#pragma mark - 刷新

- (void)doneRefreshMessage
{
    self.pageNum = 1;
    if (!self.acceptLongitude) {
         [self setupUserPositionRefresh:YES];
    }else{
        [self setupUserLocation:self.acceptLongitude Latitude:self.acceptLatitude Refresh:YES];
    }
}

- (void)doneLoadAddMoreMessage
{
    if (!self.acceptLongitude) {
        [self setupUserPositionRefresh:NO];
    }else{
        [self setupUserLocation:self.acceptLongitude Latitude:self.acceptLatitude Refresh:NO];
    }
}

#pragma mark - 添加经纬度
- (void)setupUserPositionRefresh:(BOOL)refresh
{
    KGGLog(@"有电话 可以接单");
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
        self.acceptLatitude = coordinate.latitude;
        self.acceptLongitude = coordinate.longitude;
        [weakself setupUserLocation:longitude Latitude:latitude Refresh:refresh];
    }];
}

- (void)setupUserLocation:(CGFloat)longitude Latitude:(CGFloat)latitude Refresh:(BOOL)refresh
{
    [KGGSearchOrderRequestManager searchOrderListType:self.requestType Page:self.pageNum Longitude:longitude Latitude:latitude  completion:^(NSArray<KGGOrderDetailsModel *> *response) {
        
        if (!response) {
            if (refresh) {
                [self.orderTableView.mj_header endRefreshing];
            }else{
                [self.orderTableView.mj_footer endRefreshing];
            }
        }else{ //有数据
            self.pageNum ++;
            if (refresh) {
                [self.orderTableView.mj_header endRefreshing];
                [self.datasource removeAllObjects];
            }else{
                [self.orderTableView.mj_footer endRefreshing];
            }
            [self.datasource addObjectsFromArray:response];
        }
        [self.orderTableView reloadData];
        
//        if (self.datasource.count == 0) {
//            [self.orderTableView showBusinessErrorViewWithError:@"这里还没有内容" yOffset:100.f];
//        }
        
    } aboveView:self.view inCaller:self];
}

#pragma mark - UITableViewDelegate  UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGOrderDetailsModel *model = self.datasource[indexPath.row];
    KGGPublishOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGPublishOrderViewCell publishOrderIdentifier] forIndexPath:indexPath];
    cell.orderDetailsLabel.textColor = UIColorHex(0x666666);
    cell.orderDetailsLabel.text = model.searchOrderDetails;
    if (self.requestType == KGGSearchOrderRequestMyDoingType) {
        cell.statusImageView.image = [UIImage imageNamed:@"icon_nof"];
    }else if(self.requestType == KGGSearchOrderRequestCompleteType) {
        cell.statusImageView.image = [UIImage imageNamed:@"icon_finash"];
    }else{
        cell.statusImageView.image = [UIImage imageNamed:@"pic_noPay"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGLog(@"点击我的工作进入工作详情");
    KGGOrderDetailsModel *model = self.datasource[indexPath.row];
    if (self.requestType == KGGSearchOrderRequestMyDoingType) {
        KGGRoutePlanningController *routeVC = [[KGGRoutePlanningController alloc]init];
        routeVC.orderDetails = model;
        routeVC.planType = KGGRoutePlanningWORKERType;
        routeVC.callCancelOrderBlock = ^(NSString *code) {
            [self doneRefreshMessage];
        };
        routeVC.doWorkBlock = ^{
            [self doneRefreshMessage];
        };
        [self.navigationController pushViewController:routeVC animated:YES];
    }else{
        KGGWorkDetailsViewController *workVC = [[KGGWorkDetailsViewController alloc]initWithNibName:NSStringFromClass([KGGWorkDetailsViewController class]) bundle:[NSBundle mainBundle]];
        workVC.searchOrderModel = model;
        workVC.requestType = self.requestType;
        [self.navigationController pushViewController:workVC animated:YES];
    }
}

#pragma mark - lazy
- (UITableView *)orderTableView
{
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-47-64) style:UITableViewStylePlain];
        _orderTableView.backgroundColor = UIColorHex(0xd9d9d9);
        [_orderTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGPublishOrderViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGPublishOrderViewCell publishOrderIdentifier]];
        _orderTableView.rowHeight = 95.f;
        _orderTableView.separatorStyle = UITableViewCellStyleDefault;
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
    }
    return _orderTableView;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
