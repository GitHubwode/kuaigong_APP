//
//  KGGBillingDetailsViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/14.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGBillingDetailsViewController.h"
#import "KGGBillingDetailsViewCell.h"
#import "KGGMyWalletOrderDetailsModel.h"
#import "KGGWallectRequestManager.h"

@interface KGGBillingDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *billTableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) KGGMyWalletOrderDetailsModel *walletModel;
/** 用户类型 */
@property (nonatomic,copy)NSString *requestType;;

@end

@implementation KGGBillingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账单明细";
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:self.billTableView];
    if ([[KGGUserManager shareUserManager].currentUser.type isEqualToString:@"BOSS"]) {
        self.requestType = @"postContent";
    }else{
        self.requestType = @"acceptContent";
    }
    
    self.billTableView.mj_header = [KGGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(RefreshNewMessag)];
    self.billTableView.mj_footer = [KGGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadAddMoreMessage)];
    [self.billTableView.mj_header beginRefreshing];
}

-(void)RefreshNewMessag
{
    self.pageNum = 1;
    [self kgg_billingDetailsList:YES];
}

- (void)LoadAddMoreMessage
{
    [self kgg_billingDetailsList:NO];
}

- (void)kgg_billingDetailsList:(BOOL)refresh
{
    [KGGWallectRequestManager myWalletOrderDetailsUserType:self.requestType Page:self.pageNum completion:^(NSArray < KGGMyWalletOrderDetailsModel *> *response,NSString *totalMoeny) {
        if (!response) {
            if (refresh) {
                [self.billTableView.mj_header endRefreshing];
            }else{
                [self.billTableView.mj_footer endRefreshing];
            }
            
        }else{//有数据
            self.pageNum ++;
            if (refresh) {
                [self.billTableView.mj_header endRefreshing];
                [self.datasource removeAllObjects];
            }else{
                [self.billTableView.mj_footer endRefreshing];
            }
            [self.datasource addObjectsFromArray: response];
        }
        [self.billTableView reloadData];
        if (self.datasource.count < 10) {
            [self.billTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (self.datasource.count == 0) {
            [self.billTableView showBusinessErrorViewWithError:@"这里还没有内容" yOffset:100.f];
        }
    } aboveView:self.view inCaller:self];
}

#pragma makr - UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGMyWalletOrderDetailsModel *detailsModel = self.datasource[indexPath.row];
    KGGBillingDetailsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGBillingDetailsViewCell billIdentifier]];
    cell.detailsModel = detailsModel;
    return cell;
}

#pragma mark - lazy
- (UITableView *)billTableView
{
    if (!_billTableView) {
        _billTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _billTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_billTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGBillingDetailsViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[KGGBillingDetailsViewCell billIdentifier]];
        _billTableView.delegate = self;
        _billTableView.dataSource = self;
        _billTableView.rowHeight = 79.f;
    }
    return _billTableView;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
