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

@interface KGGSearchOrderController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) KGGSearchOrderHeaderView *headerView;
@end

@implementation KGGSearchOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.navigationItem.title = @"实时订单";
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    [self kgg_addButton];
}

#pragma mark - buttonAction
- (void)snh_sureOrderButtonClick:(UIButton *)sender
{
    KGGLog(@"接单的确认按钮");
}

#pragma mark- UITableViewDatasource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGSearchOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGSearchOrderViewCell searchOrderIdentifier]];
    return cell;
}

- (void)kgg_addButton
{
    weakSelf(self);
    UIButton *useButton = [self snh_creatButtonImage:@"bg_button" Title:@"接单"];
    [self.view addSubview:useButton];
    [useButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-KGGLoginButtonHeight-64) style:UITableViewStyleGrouped];
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
        _headerView.backgroundColor = [UIColor redColor];
    }
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    KGGLogFunc
}

@end
