//
//  KGGLeftTableController.m
//  kuaigong
//
//  Created by Ding on 2017/8/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLeftTableController.h"
#import "KGGLeftDrawerCell.h"
#import "KGGLeftDrawerModel.h"
#import "KGGLeftDrawerHeaderView.h"
#import "KGGNavigationController.h"
#import "KGGLoginViewController.h"
#import "KGGPersonalMessageController.h"

@interface KGGLeftTableController ()<UITableViewDelegate,UITableViewDataSource,KGGLeftDrawerHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<KGGLeftDrawerModel *> *dataArray;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) KGGLeftDrawerHeaderView *headerView;
@end

@implementation KGGLeftTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    [self kgg_addsubViewBottom];
}

#pragma mark -  添加底部图标
- (void)kgg_addsubViewBottom
{
    UIImageView *bottonImageView = [[UIImageView alloc]init];
    bottonImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:bottonImageView];
    weakSelf(self);
    [bottonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.tableView.mas_centerX);
        make.bottom.equalTo(weakself.tableView.mas_bottom).offset(-14);
        make.height.equalTo(@25);
        make.width.equalTo(@97);
    }];
}

#pragma mark - UITableViewDeelgate  UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGLeftDrawerModel *model = self.dataArray[indexPath.row];
    
    KGGLeftDrawerCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGLeftDrawerCell leftIdentifierClass] forIndexPath:indexPath];
    
    cell.iconImageView.image = [UIImage imageNamed:model.icon];
    cell.iconLabel.text = model.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGLeftDrawerModel *model = self.dataArray[indexPath.row];
    Class class = NSClassFromString(model.linkVC);
    [self.navigationController pushViewController:[class new] animated:YES];
}

#pragma mark - KGGLeftDrawerHeaderViewDelegate
- (void)kgg_avatarImageButtonClick
{
    KGGLog(@"点击头像跳转到个人信息");
//    [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLoginViewController alloc]init]] animated:YES completion:nil];
    
    KGGPersonalMessageController *personalVC = [[KGGPersonalMessageController alloc]init];
    [self.navigationController pushViewController:personalVC animated:YES];
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth*0.68, kMainScreenHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"KGGLeftDrawerCell"bundle:nil] forCellReuseIdentifier:[KGGLeftDrawerCell leftIdentifierClass]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray<KGGLeftDrawerModel *> *)dataArray
{
    if (!_dataArray) {
        
        _dataArray = [KGGLeftDrawerModel mj_objectArrayWithFilename:@"KGGLeftDrawer.plist"];
    }
    return _dataArray;
}

- (KGGLeftDrawerHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KGGLeftDrawerHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.xc_width, 185.5)];
        _headerView.delegate = self;
        
    }
    return _headerView;
}

-(void)dealloc
{
    KGGLogFunc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
