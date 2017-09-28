//
//  KGGUseWorkerViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/23.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGUseWorkerViewController.h"
#import "KGGCustomInfoItem.h"
#import "KGGUseWorkerViewCell.h"
#import "KGGPayTimeChooseViewCell.h"
#import "KGGUseWorkerHeaderView.h"
#import "KGGActionSheetController.h"

@interface KGGUseWorkerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KGGUseWorkerHeaderView *headerView;

@end

@implementation KGGUseWorkerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    //增减通知
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationItem.title = @"用工信息";
    self.headerView = [[KGGUseWorkerHeaderView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 194.5)];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    [self kgg_addButton];
}

#pragma mark - 键盘显示隐藏
- (void)keyboardWillShow:(NSNotification *)notification{
    
    
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([self.headerView.textView resignFirstResponder]) {
        
    }else{
        CGFloat offset = self.headerView.xc_height+33 + 63.f * (self.datasource.count) - keyboardBounds.size.height;
        
        [self.tableView setContentOffset:CGPointMake(0, offset) animated:NO];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [self.tableView setContentOffset:CGPointZero animated:NO];
}

#pragma mark - UITableViewDelegate UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGCustomInfoItem *item = self.datasource[indexPath.row];
    
    if (indexPath.row == 3) {
        
        KGGPayTimeChooseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGPayTimeChooseViewCell payTimeIdentifier]];
        cell.infoItem = item;
        return cell;
    }else{
        KGGUseWorkerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGUseWorkerViewCell cellIdentifier]];
        cell.infoItem = item;
        
        if ([item.title isEqualToString:@"姓名"]) {
            //        cell.infoModel = self.model;
            //        [cell snh_UserName:self.model.name];
            return cell;
        }else if ([item.title isEqualToString:@"电话"]){
            //        [cell snh_UserTel:self.model.mobile];
            return cell;
        }
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [UILabel new];
    label.text = @"    订单联系人资料";
    label.font = KGGFont(14);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = UIColorHex(0x333333);
    label.backgroundColor = KGGViewBackgroundColor;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 33.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *label = [UILabel new];
    label.text = @"为保证双方权益,务必严格按照劳动法支付工人工资";
    label.font = KGGFont(13);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorHex(0x34a1dc);
    label.backgroundColor = KGGViewBackgroundColor;
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KGGCustomInfoItem *item = self.datasource[indexPath.row];
    KGGLog(@"%@",item);
    
    if (!item.enabled) return;
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[cell textField] becomeFirstResponder];
}


- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [KGGCustomInfoItem mj_objectArrayWithFilename:@"KGCreatAddress.plist"];
    }
    return _datasource;
}

- (void)kgg_addButton
{
    weakSelf(self);
    UIButton *useButton = [self snh_creatButtonImage:@"bg_button" Title:@"确认支付"];
    [self.view addSubview:useButton];
    [useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.bottom.equalTo(weakself.view.mas_bottom);
        make.height.equalTo(@(KGGLoginButtonHeight));
        make.width.equalTo(@(kMainScreenWidth));
    }];
}

#pragma mark - buttonClick
- (void)snh_sureMessageButtonClick:(UIButton *)sender
{
    KGGLog(@"确认支付");
    
    KGGActionSheetController *sheetVC = [[KGGActionSheetController alloc]init];
    //    sheetVC.moneyString = [NSString stringWithFormat:@"%.2f",_headerView.model.fee];
    sheetVC.receiverId = @"";
    sheetVC.tradeType = 1;
    sheetVC.payFrom = 22;
    sheetVC.isPublish = YES;
    sheetVC.itemId = 11;
    __weak typeof(self) weakSelf = self;
    sheetVC.callPaySuccessBlock = ^(NSString *code){
        if ([code isEqualToString:@"200"]) {
            KGGLog(@"付费成功");
        }
    };
    sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:sheetVC animated:YES completion:nil];
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-49) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = KGGViewBackgroundColor;
        _tableView.separatorStyle = UITableViewCellStyleDefault;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGUseWorkerViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGUseWorkerViewCell cellIdentifier]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGPayTimeChooseViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGPayTimeChooseViewCell payTimeIdentifier]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 63.f;
    }
    return _tableView;
}


#pragma mark - lazyButton
- (UIButton *)snh_creatButtonImage:(NSString *)image Title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(snh_sureMessageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
