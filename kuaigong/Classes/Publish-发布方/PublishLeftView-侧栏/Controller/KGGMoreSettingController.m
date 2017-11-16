//
//  KGGMoreSettingController.m
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMoreSettingController.h"
#import "KGGMoreSetModel.h"
#include "KGGMoreSettingViewCell.h"
#import "KGGNewFeatureViewController.h"
#import "KGGForgetPasswordViewController.h"
#import "KGGLoginRequestManager.h"
#import "KGGRegardKGViewController.h"

@interface KGGMoreSettingController ()<UITableViewDelegate,UITableViewDataSource>
/**  */
@property (nonatomic,strong)UITableView *setTableView;
/**  */
@property (nonatomic,strong)NSMutableArray *datasource;

@property (nonatomic, strong) UIButton *useButton;



@end

@implementation KGGMoreSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.navigationItem.title = @"设置";
    [self.view addSubview:self.setTableView];
    
    if ([KGGUserManager shareUserManager].logined) {
        [self kgg_addButton];
    }
}

#pragma mark - UITabelViewDelegate and UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGMoreSetModel *model = self.datasource[indexPath.row];
    KGGMoreSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGMoreSettingViewCell moreSettingIdentifier]];
    cell.setModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGLog(@"点击墨一行");
    if (indexPath.row == 5) {
        KGGNewFeatureViewController *newFeatureVc = [[KGGNewFeatureViewController alloc] initWithNibName:NSStringFromClass([KGGNewFeatureViewController class]) bundle:[NSBundle mainBundle]];
        [self presentViewController:newFeatureVc animated:YES completion:nil];
    }else if (indexPath.row == 1){
        KGGLog(@"收费标准");
    }else if (indexPath.row == 2){
        KGGLog(@"忘记密码");
        KGGForgetPasswordViewController *forgrtVC = [[KGGForgetPasswordViewController alloc]init];
        forgrtVC.changetype = KGGUserChangePWDType;
        forgrtVC.forgetSuccessBlock = ^{
            [self kgg_loginOut];
        };
        [self presentViewController:forgrtVC animated:YES completion:nil];
    }else{
        KGGLog(@"关于快工");
        KGGRegardKGViewController *regardVC = [[KGGRegardKGViewController alloc]initWithNibName:NSStringFromClass([KGGRegardKGViewController class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:regardVC animated:YES];
    }
}

#pragma mark - 退出登录
-(void)snh_loginOutButtonClick:(UIButton *)sender
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        KGGLog(@"退出登录安妮");
        [self kgg_loginOut];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 退出登录网络请求
- (void)kgg_loginOut
{
    [KGGLoginRequestManager loginOutWithcompletion:^(KGGResponseObj *responseObj) {
        
        [[KGGUserManager shareUserManager] logout];
        [self.useButton removeFromSuperview];
        [KGGNotificationCenter postNotificationName:KGGUserLogoutNotifacation object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } aboveView:self.view inCaller:self];
}



#pragma mark-  懒加载

- (UITableView *)setTableView
{
    if (!_setTableView) {
        _setTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -37, kMainScreenWidth, 59*4+37) style:UITableViewStyleGrouped];
        _setTableView.scrollEnabled = NO;
        [_setTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGMoreSettingViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGMoreSettingViewCell moreSettingIdentifier]];
        _setTableView.rowHeight = 59.f;
        _setTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _setTableView.backgroundColor = [UIColor whiteColor];
        _setTableView.delegate = self;
        _setTableView.dataSource = self;
        
    }
    return _setTableView;
}
- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [KGGMoreSetModel mj_objectArrayWithFilename:@"KGGPublishSetting.plist"];
    }
    return _datasource;
}

- (void)kgg_addButton
{
    weakSelf(self);
    UIButton *useButton = [self snh_creatButtonImage:@"bg_button" Title:@"退出登录"];
    [self.view addSubview:useButton];
    self.useButton = useButton;
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
    [button addTarget:self action:@selector(snh_loginOutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
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
