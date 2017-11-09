//
//  KGGUndoneOrderController.m
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGUndoneOrderController.h"
#import "KGGPublishOrderViewCell.h"
#import "KGGPublishPayViewController.h"
#import "KGGRoutePlanningController.h"

@interface KGGUndoneOrderController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) NSUInteger pageNum;

@end

@implementation KGGUndoneOrderController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    KGGLog(@"我的我我弟弟爱打打");
}


- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self kgg_loadData:YES];
}

- (void)doneLoadAddMoreMessage
{
    [self kgg_loadData:NO];
}

- (void)kgg_loadData:(BOOL)refresh{
    
    [KGGPublishOrderRequestManager publishOrderListType:self.requestType Page:self.pageNum UserId:[[KGGUserManager shareUserManager].currentUser.userId integerValue] Order:0 completion:^(NSArray<KGGOrderDetailsModel *> *response) {
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
        if (self.datasource.count < 10) {
            [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (self.datasource.count == 0) {
            [self.orderTableView showBusinessErrorViewWithError:@"这里还没有内容" yOffset:100.f];
        }
        
    } aboveView:self.view inCaller:self];
}

#pragma mark - UITableViewDelegate  UITableViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGOrderDetailsModel *model = self.datasource[indexPath.row];
    KGGPublishOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGPublishOrderViewCell publishOrderIdentifier] forIndexPath:indexPath];
    cell.orderDetailsLabel.text = model.orderDetails;
    if (self.requestType == KGGOrderRequestMyDoingType) {
        cell.statusImageView.image = [UIImage imageNamed:@"icon_load"];
    }else{
        cell.statusImageView.image = [UIImage imageNamed:@"icon_nof"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGOrderDetailsModel *model = self.datasource[indexPath.row];
//    KGGPublishPayViewController *payVC = [[KGGPublishPayViewController alloc]initWithNibName:NSStringFromClass([KGGPublishPayViewController class]) bundle:[NSBundle mainBundle]];
//    payVC.requestType = self.requestType;
//    payVC.detailsModel = model;
//    [self.navigationController pushViewController:payVC animated:YES];
    KGGRoutePlanningController *routeVC = [[KGGRoutePlanningController alloc]init];
    routeVC.orderDetails = model;
    routeVC.planType = KGGRoutePlanningBOSSType;
    [self.navigationController pushViewController:routeVC animated:YES];
}

- (UITableView *)orderTableView
{
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStyleGrouped];
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

- (void)dealloc
{
    KGGLogFunc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
