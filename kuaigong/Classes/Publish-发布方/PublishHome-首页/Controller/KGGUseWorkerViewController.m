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
#import "KGGStartWorkTimeViewCell.h"
#import "KGGUseWorkerHeaderView.h"
#import "KGGActionSheetController.h"
#import "KGGHomePublishModel.h"
#import "KGGApplyVIPView.h"
#import "KGGPublishOrderRequestManager.h"
#import "KGGPublishOrderParam.h"

@interface KGGUseWorkerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KGGUseWorkerHeaderView *headerView;
@property (nonatomic, strong) KGGApplyVIPView *vipView;
/** 用工人数 */
@property (nonatomic, copy) NSString *peopleNum;
/** 天数 */
@property (nonatomic, copy) NSString *daysNum;
/** 车费每人 */
@property (nonatomic, copy) NSString *carMoney;
/** 每小时单价 */
@property (nonatomic, copy) NSString *priceNum;
/** 手续费 */
@property (nonatomic,assign) double  fee;


/** 备注成为第一响应者 */
@property (nonatomic,assign) BOOL  Isfirst;

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
    KGGLog(@"%@",self.publishDatasource);
    [self useWorkerMessage];
}

#pragma mark - 用工信息赋值
- (void)useWorkerMessage
{
    for ( KGGHomePublishModel *publishModel in self.publishDatasource) {
        if ([publishModel.title isEqualToString:@"用工人数"]) {
            self.peopleNum = publishModel.subtitle;
        }else if ([publishModel.title isEqualToString:@"用工天数"]){
            self.daysNum = publishModel.subtitle;
        }else if ([publishModel.title isEqualToString:@"车辆/每人"]){
            self.carMoney = publishModel.subtitle;
        }else{
            self.priceNum = publishModel.subtitle;
        }
    }
    
    NSString *worker;
    switch (self.workerType) {
        case 0:
            worker = @"木工";
            break;
        case 1:
            worker = @"钢筋工";
            break;
        case 2:
            worker = @"内架子工";
            break;
        case 3:
            worker = @"外架子工";
            break;
        case 4:
            worker = @"泥工";
            break;
        case 5:
            worker = @"水电工";
            break;
        case 6:
            worker = @"电焊工";
            break;
        case 7:
            worker = @"小工";
            break;
        default:
            break;
    }
    int allFee ;//总计费用
   allFee = [self.priceNum intValue]*[self.daysNum intValue]*9*[self.peopleNum intValue]+[self.peopleNum intValue]*[self.carMoney intValue]*[self.daysNum intValue];
    
    if ([self.carMoney isEqualToString:@"0"] || self.carMoney.length == 0) {
        self.headerView.orderDetailLabel.text = [NSString stringWithFormat:@"订单详情: 需要%@%@人,工作%@天,每小时%@元。",worker,self.peopleNum,self.daysNum,self.priceNum];
    }else{
        self.headerView.orderDetailLabel.text = [NSString stringWithFormat:@"订单详情: 需要%@%@人,工作%@天,每小时%@元,车费每人%@元。",worker,self.peopleNum,self.daysNum,self.priceNum,self.carMoney];
    }
}

#pragma mark - 键盘显示隐藏
- (void)keyboardWillShow:(NSNotification *)notification{
    
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (self.Isfirst == NO) {

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
    }else if (indexPath.row == 2){
        KGGStartWorkTimeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGStartWorkTimeViewCell workStartIdentifier]];
        cell.infoItem = item;
        return cell;
    }else{
        KGGUseWorkerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGUseWorkerViewCell cellIdentifier]];
        cell.infoItem = item;
        if ([item.title isEqualToString:@"电话:"]){
            [cell kgg_UserTel:[KGGUserManager shareUserManager].currentUser.phone];
            return cell;
        }
        
        if ([item.title isEqualToString:@"姓名:"]) {
            [cell kgg_UserName:[KGGUserManager shareUserManager].currentUser.nickname];
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
    self.Isfirst = YES;
    KGGCustomInfoItem *item = self.datasource[indexPath.row];
    KGGLog(@"%@",item);
    
    if (!item.enabled) return;
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 3) {
        [[cell timeTextField] becomeFirstResponder];
    }else if (indexPath.row == 2){
        
    }else{
     [[cell textField] becomeFirstResponder];
    }
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
    UIButton *useButton = [self snh_creatButtonImage:@"bg_button" Title:@"发布订单"];
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
    KGGLog(@"确认发布");
    
//    self.vipView = [KGGApplyVIPView kgg_alertPromptApplyForViewKGGApplyButtonClick:^(NSString *money) {
//        KGGLog(@"支付会员费:%@",money);
//    } KGGUnderstandButtonClick:^{
//
//    }];
    
    NSString *name;
    NSString *time;
    NSString *payTime;
    
    for (KGGCustomInfoItem *item in self.datasource) {
        KGGLog(@"%@",item.subtitle);
        
        if ([item.title isEqualToString:@"姓名:"] && item.subtitle.length != 0) {
            name = item.subtitle;
        }else if ([item.title isEqualToString:@"工作时间:"] && item.subtitle.length != 0){
            time = item.subtitle;
        }else if ([item.title isEqualToString:@"支付时间:"] && item.subtitle.length != 0){
            payTime = item.subtitle;
        }
    }
    
    if (name.length == 0 || time.length == 0 || payTime.length == 0) {
        [self.view showHint:@"用工数据不能为空"];
        return;
    }
    
    NSUInteger userId = [[KGGUserManager shareUserManager].currentUser.userId integerValue];
    NSString *contactsPhone = [KGGUserManager shareUserManager].currentUser.phone;
    //车费
    double carFare = [self.carMoney intValue]*[self.peopleNum intValue] *[self.daysNum intValue];
    
    KGGPublishCreatParam *param = [[KGGPublishCreatParam alloc]initWithUserId:userId Name:name Type:self.workerType Number:[self.peopleNum integerValue] Days:[self.daysNum integerValue] UnitPrice:[self.priceNum integerValue] Fare:carFare Remark:self.headerView.headerTextView.text WorkStartTime:time PayTime:payTime Longitude:self.latitudeMap Latitude:self.longitudeMap Address:self.address WhenLong:nil Contacts:name ContactsPhone:contactsPhone];
    
    [KGGPublishOrderRequestManager publishCreatOrderParam:param completion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            KGGLog(@"创建订单成功");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } aboveView:self.view inCaller:self];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-49) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = KGGViewBackgroundColor;
        _tableView.separatorStyle = UITableViewCellStyleDefault;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGUseWorkerViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGUseWorkerViewCell cellIdentifier]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGStartWorkTimeViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGStartWorkTimeViewCell workStartIdentifier]];
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

- (void)dealloc
{
    [KGGNotificationCenter removeObserver:self];
    KGGLogFunc
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
