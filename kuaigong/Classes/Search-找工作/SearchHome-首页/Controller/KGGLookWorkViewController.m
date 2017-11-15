//
//  KGGLookWorkViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLookWorkViewController.h"
#import "KGGLookWorkViewCell.h"
#import "KGGOrderDetailsModel.h"
#import "KGGSearchOrderController.h"
#import "KGGLocationHelper.h"
#import "KGGCancelOrderPayView.h"

@interface KGGLookWorkViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) NSUInteger pageNum;
@property (nonatomic, strong) KGGLocationHelper *locationHelper;
@property (nonatomic, strong) KGGCancelOrderPayView *payView;

@end

@implementation KGGLookWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [KGGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(RefreshNewMessag)];
    self.tableView.mj_footer = [KGGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadAddMoreMessage)];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 请求数据
- (void)RefreshNewMessag
{
    self.pageNum = 1;
    [self kgg_hostLiveLocation:YES];
}

- (void)LoadAddMoreMessage
{
    [self kgg_hostLiveLocation:NO];
}

- (void)kgg_hostLiveLocation:(BOOL)refresh
{
    __block CGFloat longitude;
    __block CGFloat latitude;
    weakSelf(self);
    [self.locationHelper getUserCurrentLocation:^(CLLocation *location) {
        
        [weakself.locationHelper clearLocationDelegate];
        weakself.locationHelper = nil;
        
        CLLocationCoordinate2D coordinate = location.coordinate;
        longitude = coordinate.longitude;
        latitude = coordinate.latitude;        
        [weakself setupUserLongitude:longitude Latitude:latitude Refresh:refresh];
    }];
}

#pragma mark - 获取经纬度
- (void)setupUserLongitude:(CGFloat )longitude Latitude:(CGFloat)latitude Refresh:(BOOL)refresh
{
    [KGGPublishOrderRequestManager publishOrderListType:self.requestType Page:self.pageNum UserId:[[KGGUserManager shareUserManager].currentUser.userId integerValue] Order:0 Latitude:latitude Longitude:longitude completion:^(NSArray<KGGOrderDetailsModel *> *response) {
        if (!response) {
            if (refresh) {
                [self.tableView.mj_header endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{ //有数据
            self.pageNum ++;
            if (refresh) {
                [self.tableView.mj_header endRefreshing];
                [self.datasource removeAllObjects];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            [self.datasource addObjectsFromArray:response];
        }
        [self.tableView reloadData];
        if (self.datasource.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (self.datasource.count == 0) {
            [self.tableView showBusinessErrorViewWithError:@"这里还没有内容" yOffset:100.f];
        }
        
    } aboveView:self.view inCaller:self];
    
}


#pragma mark - UITableViewDelegate  UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGOrderDetailsModel *model = self.datasource[indexPath.row];
    KGGLookWorkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGLookWorkViewCell lookWorkIdentifier] forIndexPath:indexPath];
    cell.detailsModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGLog(@"订单详情");
    KGGOrderDetailsModel *model = self.datasource[indexPath.row];
    KGGSearchOrderController *orderVC = [[KGGSearchOrderController alloc]init];
    orderVC.orderDetails = model;
    [self.navigationController pushViewController:orderVC animated:YES];
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, kMainScreenHeight-64-50) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"KGGLookWorkViewCell" bundle:nil] forCellReuseIdentifier:[KGGLookWorkViewCell lookWorkIdentifier]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
