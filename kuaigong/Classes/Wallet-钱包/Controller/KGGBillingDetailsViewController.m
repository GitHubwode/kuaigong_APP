//
//  KGGBillingDetailsViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/14.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGBillingDetailsViewController.h"
#import "KGGBillingDetailsViewCell.h"

@interface KGGBillingDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *billTableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation KGGBillingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账单明细";
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:self.billTableView];
    
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
    [self.billTableView.mj_header endRefreshing];
}



#pragma makr - UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGBillingDetailsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGBillingDetailsViewCell billIdentifier]];
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
