//
//  KGGCenterViewController.m
//  kuaigong
//
//  Created by Ding on 2017/10/31.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGCenterViewController.h"
#import "KGGCenterViewCell.h"
#import "KGGCenterModel.h"
#import "KGGCenterHeaderView.h"
#import "KGGCenterFooterView.h"

@interface KGGCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) KGGCenterHeaderView *headerView;
@property (nonatomic, strong) KGGCenterFooterView *footerView;
@end

@implementation KGGCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    [self reatViewFootView];
}

- (void)reatViewFootView
{
    weakSelf(self);
    self.footerView = [[KGGCenterFooterView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.footerView];
    [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.view.mas_left);
        make.top.equalTo(weakself.tableView.mas_bottom);
        make.right.equalTo(weakself.view.mas_right);
        make.bottom.equalTo(weakself.view.mas_bottom);
    }];
}

#pragma mark - UITableViewDeelgate  UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGCenterModel *model = self.datasource[indexPath.row];
    KGGCenterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGCenterViewCell identifierCenterCell] forIndexPath:indexPath];
    cell.titleLabel.text = model.title;
    cell.subtitleLabel.text = model.subTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGCenterModel *model = self.datasource[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark  - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kMainScreenWidth, 59*5+KGGAdaptedHeight(180)) style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"KGGCenterViewCell"bundle:nil] forCellReuseIdentifier:[KGGCenterViewCell identifierCenterCell]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
    
    _datasource = [KGGCenterModel mj_objectArrayWithFilename:@"KGGCenter.plist"];

    }
    return _datasource;
}

- (KGGCenterHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KGGCenterHeaderView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, KGGAdaptedHeight(180))];
    }
    return _headerView;
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
