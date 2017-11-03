//
//  KGGLeftTableController.m
//  kuaigong
//
//  Created by Ding on 2017/10/27.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLeftTableController.h"
#import "KGGLeftDrawerCell.h"
#import "KGGLeftDrawerModel.h"
#import "KGGLeftDrawerHeaderView.h"

#define ImageviewWidth    18
#define Frame_Width       self.frame.size.width//200

@interface KGGLeftTableController ()<UITableViewDataSource,UITableViewDelegate,KGGLeftDrawerHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<KGGLeftDrawerModel *> *dataArray;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) KGGLeftDrawerHeaderView *headerView;

@end

@implementation KGGLeftTableController

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView.tableHeaderView = self.headerView;
        [self addSubview:self.tableView];
        [self kgg_addsubViewBottom];
        [KGGNotificationCenter addObserver:self selector:@selector(login) name:KGGUserLoginNotifacation object:nil];
        [KGGNotificationCenter addObserver:self selector:@selector(loginOut) name:KGGUserLogoutNotifacation object:nil];
    }
    return self;
}

#pragma mark -  添加底部图标
- (void)kgg_addsubViewBottom
{
    UIImageView *bottonImageView = [[UIImageView alloc]init];
    bottonImageView.image = [UIImage imageNamed:@"logo"];
    [self addSubview:bottonImageView];
    weakSelf(self);
    [bottonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.tableView.mas_centerX);
        make.bottom.equalTo(weakself.tableView.mas_bottom).offset(-14);
        make.height.equalTo(@25);
        make.width.equalTo(@97);
    }];
}

- (void)login
{
    KGGLog(@"登录成功");
    [self.headerView leftTableHeaderView];
    [self.tableView reloadData];
}
- (void)loginOut
{
    [self.headerView leftTableHeaderView];
}

- (void)changeUserAvatarIamge
{
    [self.headerView leftTableHeaderView];

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
//    Class class = NSClassFromString(model.linkVC);
//    [self.navigationController pushViewController:[class new] animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.customDelegate respondsToSelector:@selector(LeftMenuViewClick: Drawer:)]){
        [self.customDelegate LeftMenuViewClick:indexPath.row Drawer:model.linkVC];
    }
}

#pragma mark - KGGLeftDrawerHeaderViewDelegate
- (void)kgg_avatarImageButtonClick
{
    if([self.customDelegate respondsToSelector:@selector(LeftMenuViewClick: Drawer:)]){
        [self.customDelegate LeftMenuViewClick:1000 Drawer:nil];
    }
    KGGLog(@"点击头像跳转到个人信息");
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KGGAdaptedWidth(kMainScreenWidth*0.68), kMainScreenHeight) style:UITableViewStylePlain];
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
        _headerView = [[KGGLeftDrawerHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.xc_width, 185.5)];
        _headerView.delegate = self;
        
    }
    return _headerView;
}

-(void)dealloc
{
    [KGGNotificationCenter removeObserver:self];
    KGGLogFunc;
}


@end
