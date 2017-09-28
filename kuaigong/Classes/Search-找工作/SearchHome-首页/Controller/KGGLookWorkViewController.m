//
//  KGGLookWorkViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLookWorkViewController.h"
#import "KGGLookWorkViewCell.h"


@interface KGGLookWorkViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) NSUInteger pageNum;
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
    
}


#pragma mark - UITableViewDelegate  UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 162;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGLookWorkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGLookWorkViewCell lookWorkIdentifier] forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
