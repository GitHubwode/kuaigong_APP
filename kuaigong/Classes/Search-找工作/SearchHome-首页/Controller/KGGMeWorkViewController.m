//
//  KGGMeWorkViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMeWorkViewController.h"
#import "KGGMeWorkHeaderView.h"
#import "KGGMeWorkViewCell.h"
#import "KGGMoreSettingController.h"
#import "KGGMyWalletViewController.h"
#import "KGGMyWorkViewController.h"
#import "KGGLoginViewController.h"


@interface KGGMeWorkViewController ()<UITableViewDelegate,UITableViewDataSource,KGGMeWorkHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) KGGMeWorkHeaderView *headerView;
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation KGGMeWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    [self.headerView updataUserMessageLogin:[KGGUserManager shareUserManager].logined];
    [self addCollectButton];
    [KGGNotificationCenter addObserver:self selector:@selector(loginSuccess) name:KGGUserLoginNotifacation object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(loginOutSuccess) name:KGGUserLogoutNotifacation object:nil];
}

- (void)loginSuccess
{
    KGGLog(@"登录成功");
    [self.headerView updataUserMessageLogin:[KGGUserManager shareUserManager].logined];
}

- (void)loginOutSuccess
{
    KGGLog(@"登出成功");
    [self.headerView updataUserMessageLogin:[KGGUserManager shareUserManager].logined];
}



#pragma mark - UITableViewDelegate  UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGMeWorkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGMeWorkViewCell meWorkViewIdentifier] forIndexPath:indexPath];
    cell.titleLabel.text = self.datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        KGGMoreSettingController *setVC = [[KGGMoreSettingController alloc]init];
        [self.navigationController pushViewController:setVC animated:YES];
    }
    
    if (indexPath.row == 0) {
        KGGMyWalletViewController *walletVC = [[KGGMyWalletViewController alloc]initWithNibName:NSStringFromClass([KGGMyWalletViewController class]) bundle:[NSBundle mainBundle]];
        
        [self.navigationController pushViewController:walletVC animated:YES];
    }
    if (indexPath.row ==1) {
        KGGMyWorkViewController *myVC = [[KGGMyWorkViewController alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    KGGLog(@"第几行 %ld",(long)indexPath.row);
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [UIView new];
//    view.backgroundColor = KGGViewBackgroundColor;
//    return view;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 10.f;
//}

#pragma mark -KGGMeWorkHeaderViewDelegate
- (void)kggMeWorkHeaderViewButtonClick
{
    BOOL login = [KGGUserManager shareUserManager].logined;
    if (login) {
        KGGLog(@"已登录");
    }else{
        [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLoginViewController alloc]init]] animated:YES completion:nil];
    }
}

#pragma mark - 确认收款按钮
- (void)snh_sureCollectButtonClick:(UIButton *)sender
{
    KGGLog(@"确认收款按钮");
}

- (void)addCollectButton
{
    weakSelf(self);
    UIButton *useButton = [self snh_creatButtonImage:@"bg_button" Title:@"确认收款"];
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
    [button addTarget:self action:@selector(snh_sureCollectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}



#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-50-64-KGGLoginButtonHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGMeWorkViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGMeWorkViewCell meWorkViewIdentifier]];
        _tableView.rowHeight = 59.f;
        _tableView.backgroundColor = KGGViewBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (KGGMeWorkHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KGGMeWorkHeaderView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 200)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray arrayWithObjects:@"钱包",@"我的工作",@"客服中心",@"设置", nil];
    }
    return _datasource;
}

-(void)dealloc
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
