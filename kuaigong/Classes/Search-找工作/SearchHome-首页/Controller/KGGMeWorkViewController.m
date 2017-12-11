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
#import "KGGMyWorkBaseViewController.h"
#import "KGGLoginViewController.h"
#import "KGGCenterViewController.h"
#import "KGGPersonalMessageController.h"
#import "KGGMeWorkModel.h"

@interface KGGMeWorkViewController ()<UITableViewDelegate,UITableViewDataSource,KGGMeWorkHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) KGGMeWorkHeaderView *headerView;
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation KGGMeWorkViewController

- (void)viewDidAppear:(BOOL)animated {
    [JANALYTICSService startLogPageView:@"KGGMeWorkViewController"];
}
- (void)viewDidDisappear:(BOOL)animated {
    [JANALYTICSService stopLogPageView:@"KGGMeWorkViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.navigationItem.title = @"我的";
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    [self.headerView updataUserMessageLogin:[KGGUserManager shareUserManager].logined];
    [KGGNotificationCenter addObserver:self selector:@selector(loginSuccess) name:KGGUserLoginNotifacation object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(loginOutSuccess) name:KGGUserLogoutNotifacation object:nil];
    [self addMessage];
}

- (void)addMessage
{
    KGGMeWorkModel *model1 = [[KGGMeWorkModel alloc]init];
    model1.meName = @"钱包";
    model1.iconString = @"icon_qianbao";
    [self.datasource addObject:model1];
    
    KGGMeWorkModel *model2 = [[KGGMeWorkModel alloc]init];
    model2.meName = @"我的工作";
    model2.iconString = @"icon_work";
    [self.datasource addObject:model2];
    
    KGGMeWorkModel *model3 = [[KGGMeWorkModel alloc]init];
    model3.meName = @"客服中心";
    model3.iconString = @"icon_dainhua";
    [self.datasource addObject:model3];
    
    KGGMeWorkModel *model4 = [[KGGMeWorkModel alloc]init];
    model4.meName = @"设置";
    model4.iconString = @"icon_shezhi";
    [self.datasource addObject:model4];
}

- (void)loginSuccess
{
    KGGLog(@"登录成功");
    [self.headerView updataUserMessageLogin:[KGGUserManager shareUserManager].logined];
}

- (void)loginOutSuccess
{
    KGGLog(@"退出登录");
    [self.headerView updataUserMessageLogin:[KGGUserManager shareUserManager].logined];
}

/** 中间 */
- (void)KGG_CycleCollectionViewMeWorkDidSelectItemAtIndex:(NSInteger)index
{
    KGGLog(@"找工作中间:%ld",index);
    if (index == 0) {
        
    }
}

#pragma mark - UITableViewDelegate  UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGMeWorkModel *model = self.datasource[indexPath.row];
    KGGMeWorkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGMeWorkViewCell meWorkViewIdentifier] forIndexPath:indexPath];
    cell.titleLabel.text = model.meName;
    cell.iconImageView.image = [UIImage imageNamed:model.iconString];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        KGGMyWalletViewController *walletVC = [[KGGMyWalletViewController alloc]initWithNibName:NSStringFromClass([KGGMyWalletViewController class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:walletVC animated:YES];
    }
    if (indexPath.row ==1) {
        KGGMyWorkBaseViewController *myVC = [[KGGMyWorkBaseViewController alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    
    if (indexPath.row == 2) {
        KGGCenterViewController *centerVC = [[KGGCenterViewController alloc]init];
        [self.navigationController pushViewController:centerVC animated:YES];
    }
    if (indexPath.row == 3) {
        KGGMoreSettingController *setVC = [[KGGMoreSettingController alloc]init];
        [self.navigationController pushViewController:setVC animated:YES];
    }
    KGGLog(@"第几行 %ld",(long)indexPath.row);
}

#pragma mark -KGGMeWorkHeaderViewDelegate
- (void)kggMeWorkHeaderViewButtonClick
{
    BOOL login = [KGGUserManager shareUserManager].logined;
    if (login) {
        KGGLog(@"已登录");
        KGGPersonalMessageController *personalVC = [[KGGPersonalMessageController alloc]init];
        personalVC.editInfoSuccessBlock = ^{
            [self loginSuccess];
        };
        [self.navigationController pushViewController:personalVC animated:YES];
    }else{
        [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLoginViewController alloc]init]] animated:YES completion:nil];
    }
}

//#pragma mark - 确认收款按钮
//- (void)snh_sureCollectButtonClick:(UIButton *)sender
//{
//    KGGLog(@"确认收款按钮");
//}
//
////- (void)addCollectButton
////{
////    weakSelf(self);
////    UIButton *useButton = [self snh_creatButtonImage:@"bg_button" Title:@"确认收款"];
////    [self.view addSubview:useButton];
////    [useButton mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.centerX.equalTo(weakself.view.mas_centerX);
////        make.bottom.equalTo(weakself.view.mas_bottom);
////        make.height.equalTo(@(KGGLoginButtonHeight));
////        make.width.equalTo(@(kMainScreenWidth));
////    }];
////}
//
//#pragma mark - lazyButton
//- (UIButton *)snh_creatButtonImage:(NSString *)image Title:(NSString *)title
//{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(snh_sureCollectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}



#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGMeWorkViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGMeWorkViewCell meWorkViewIdentifier]];
        _tableView.rowHeight = 59.f;
        _tableView.showsVerticalScrollIndicator = NO;
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
        _headerView = [[KGGMeWorkHeaderView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 270)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
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
