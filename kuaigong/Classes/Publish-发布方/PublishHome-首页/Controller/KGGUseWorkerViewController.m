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
#import "KGGUseWorkerFooterView.h"
#import "KGGActionSheetController.h"
#import "KGGHomePublishModel.h"
#import "KGGApplyVIPView.h"
#import "KGGPublishOrderRequestManager.h"
#import "KGGPublishOrderParam.h"
#import "KGGWorkTypeModel.h"
#import "KGGEditPublishViewController.h"
#import "KGGPayRequestManager.h"
#import "KGGLoginVIPRequestManager.h"
#import "KGGPublishPostedViewController.h"

@interface KGGUseWorkerViewController ()<UITableViewDelegate,UITableViewDataSource,KGGUseWorkerHeaderViewDelegate,KGGUseWorkerFooterViewDelegate>

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KGGUseWorkerHeaderView *headerView;
@property (nonatomic, strong) KGGUseWorkerFooterView *footerView;
@property (nonatomic, strong) KGGApplyVIPView *vipView;
/** 用工人数 */
@property (nonatomic, copy) NSString *peopleNum;
/** 天数 */
@property (nonatomic, copy) NSString *daysNum;
/** 车费每辆每天 */
@property (nonatomic, copy) NSString *carMoney;
/** 手续费 */
@property (nonatomic,assign) double  fee;
/** 备注成为第一响应者 */
@property (nonatomic,assign) BOOL  Isfirst;
/** 点击的备注 */
@property (nonatomic,copy) NSString *clickString;
/** 图片的url */
@property (nonatomic,copy) NSString *orderUrl;
@property (nonatomic, strong)UIButton *useButton;

@end

@implementation KGGUseWorkerViewController

- (void)viewDidAppear:(BOOL)animated {
    [JANALYTICSService startLogPageView:@"KGGUseWorkerViewController"];
}
- (void)viewDidDisappear:(BOOL)animated {
    [JANALYTICSService stopLogPageView:@"KGGUseWorkerViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationItem.title = @"用工信息";
    self.clickString = @"";
    self.headerView = [[KGGUseWorkerHeaderView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 360-95-33)];
    self.headerView.headerDelegate = self;
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    [self kgg_addButton];
    KGGLog(@"%@",self.publishDatasource);
    [self useWorkerMessage];
    
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - header的代理  备注 和选择图片
- (void)kgg_userworkFooterPhoneButtonClick
{
    KGGLog(@"选择照片");
    
    KGGEditPublishViewController *publish = [[KGGEditPublishViewController alloc]init];
    publish.imageBlock = ^(NSArray *imageListArray) {
        KGGLog(@"图片地址:%@",imageListArray);
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.headerView setUpHeaderViewImageViewList:imageListArray];
            self.footerView.imageArray = [imageListArray mutableCopy];
        });
    };
    [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:publish] animated:YES completion:nil];
}

- (void)kgg_userworkHeaderOrderRemarkMessage:(NSString *)message
{
    KGGLog(@"%@备注信息",message);
    self.clickString = message;
}

#pragma mark - 用工信息赋值
- (void)useWorkerMessage
{
    for ( KGGHomePublishModel *publishModel in self.publishDatasource) {
        if ([publishModel.title isEqualToString:@"用工人数"]) {
            self.peopleNum = publishModel.subtitle;
        }else if ([publishModel.title isEqualToString:@"用工天数"]){
            self.daysNum = publishModel.subtitle;
        }else if([publishModel.title isEqualToString:@"底价/天"]){
            self.peoplePrice = publishModel.subtitle;
        }
    }
    
    self.carMoney = [NSString stringWithFormat:@"%d",self.catTotal];
    int allFee ;//总计费用
    allFee = [self.peoplePrice intValue]*[self.daysNum intValue]*[self.peopleNum intValue]+[self.carMoney intValue]*[self.daysNum intValue];
    
    self.headerView.orderTotalLabel.text = [NSString stringWithFormat:@"用工总价:%d元",allFee];
    
    if ([self.carMoney isEqualToString:@"0"] || self.carMoney.length == 0) {
        self.headerView.orderDetailLabel.text = [NSString stringWithFormat:@"订单详情: 需要%@%@人,工作%@天,每天%@元。",self.workType.name,self.peopleNum,self.daysNum,self.peoplePrice];
    }else{
        self.headerView.orderDetailLabel.text = [NSString stringWithFormat:@"订单详情: 需要%@%@人,工作%@天,每天%@元,车费%@元。",self.workType.name,self.peopleNum,self.daysNum,self.peoplePrice,self.carMoney];
    }
}

#pragma mark - 键盘显示隐藏
- (void)keyboardWillShow:(NSNotification *)notification{
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    if (self.Isfirst == NO) {
//    }else{
        CGFloat offset = self.headerView.xc_height+33 + 63.f * (self.datasource.count) - keyboardBounds.size.height;
        [self.tableView setContentOffset:CGPointMake(0, offset) animated:NO];
//    }
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
    
    if (indexPath.row == 1) {
        
        KGGPayTimeChooseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGPayTimeChooseViewCell payTimeIdentifier]];
        cell.infoItem = item;
        return cell;
    }else if (indexPath.row == 0){
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
    if (indexPath.row == 1) {
        [[cell timeTextField] becomeFirstResponder];
    }else if (indexPath.row == 0){
        [[cell workTextField] becomeFirstResponder];
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
    self.useButton = [self snh_creatButtonImage:@"bg_button" Title:@"发布订单"];
    [self.view addSubview:self.useButton];
    [self.useButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
    BOOL isVIP = [KGGUserManager shareUserManager].currentUser.hasVIP;
    NSUInteger vipEndTime = [[KGGUserManager shareUserManager].currentUser.vipEndTime integerValue];
    NSUInteger nowTime = [[NSString publishSetUpNowTime] integerValue];
    if (isVIP) {
        if (vipEndTime > nowTime) {
            [self creatOrderMessage];
        }else{
            //            [self jumpVIPView];
            [self creatOrderMessage];
        }
    }else{
        //        [self jumpVIPView];
        [self creatOrderMessage];
    }
}

#pragma mark - 跳出VIP页面
- (void)jumpVIPView
{
    self.vipView = [KGGApplyVIPView kgg_alertPromptApplyForViewKGGApplyButtonClick:^(NSString *money) {
        KGGLog(@"支付会员费:%@",money);
        [self creatVIPMessage:money];
    } KGGUnderstandButtonClick:^{
        
    }];
}

#pragma mark - 获取VIP价位的信息
- (void)creatVIPMessage:(NSString *)money
{
    NSString *type;
    if ([money isEqualToString:@"399"]) {
        type = @"ONE_MONTHS";
    }else{
        type = @"ONE_YEAR";
    }
    [KGGPayRequestManager creatVIPMessageVIPType:type completion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            NSString *price = [responseObj.data objectForKey:@"price"];
            NSString *orderNo = [responseObj.data objectForKey:@"orderNo"];
            [self jumpPayViewMoney:price OrderNo:orderNo];
        }
    } aboveView:self.view inCaller:self];
}

#pragma mark - 跳转支付页面 申请会员
- (void)jumpPayViewMoney:(NSString *)money OrderNo:(NSString *)orderNo
{
    KGGActionSheetController *sheetVC = [[KGGActionSheetController alloc]init];
    sheetVC.tradeType = @"USERVIP";
    sheetVC.itemId = orderNo;
    sheetVC.moneyString = [NSString stringWithFormat:@"会员费: ¥%@",money];
    __weak typeof(self) weakSelf = self;
    sheetVC.callPaySuccessBlock = ^(NSString *code){
        if ([code isEqualToString:@"200"]) {
            KGGLog(@"付费成功");
            [weakSelf changeUserVIP];
        }
    };
    sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:sheetVC animated:YES completion:nil];
}

#pragma mark - 更新用户VIP身份
- (void)changeUserVIP
{
    [KGGLoginVIPRequestManager  loginWithRefeVIPcompletion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            [self.view showHint:@"已成为会员可以发单"];
        }
    } aboveView:self.view inCaller:self];
}

#pragma mark - 是VIP老板 发单成功
- (void)creatOrderMessage
{
    
    NSString *name;
    NSString *time;
    NSString *payTime;
    NSString *lastPayTime;
    
    for (KGGCustomInfoItem *item in self.datasource) {
        KGGLog(@"%@",item.subtitle);
        
        if ([item.title isEqualToString:@"姓名:"] && item.subtitle.length != 0) {
            name = item.subtitle;
        }else if ([item.title isEqualToString:@"工作时间:"] && item.subtitle.length != 0){
            time = item.subtitle;
        }else if ([item.title isEqualToString:@"支付时间:"] && item.subtitle.length != 0){
            payTime = item.subtitle;
            lastPayTime = item.subtitle;
        }
    }
    
    if (name.length == 0 || time.length == 0 || payTime.length == 0) {
        [self.view showHint:@"用工数据不能为空"];
        return;
    }
    
    NSUInteger userId = [[KGGUserManager shareUserManager].currentUser.userId integerValue];
    NSString *contactsPhone = [KGGUserManager shareUserManager].currentUser.phone;
    //车费
    double carFare = [self.carMoney intValue]*[self.daysNum intValue];
    time = [NSString getWorkBeginTime:time];
    payTime = [NSString payTime:time WorkTime:self.daysNum PayTime:payTime];
    
    time = [NSString PublishWorkTimeStamp:time];
    payTime = [NSString PublishWorkTimeStamp:payTime];
    //备注
    
    self.clickString = [NSString stringWithFormat:@"%@%@",self.headerView.headerTextView.text,self.clickString];
    
    KGGLog(@"开始时间:%@ 支付时间:%@",time,payTime);
    self.orderUrl = [self.headerView.imageArray componentsJoinedByString:@","];
    
    KGGPublishCreatParam *param = [[KGGPublishCreatParam alloc]initWithUserId:userId Name:name Type:self.workType.type Number:[self.peopleNum integerValue] Days:[self.daysNum integerValue] UnitPrice:[self.peoplePrice integerValue] Fare:carFare Remark:self.clickString OrderUrl:self.orderUrl WorkStartTime:time PayTime:payTime LastPayTime:payTime Longitude:self.longitudeMap Latitude:self.latitudeMap Address:self.address AvatarUrl:[KGGUserManager shareUserManager].currentUser.avatarUrl WhenLong:self.workType.whenLong Contacts:name ContactsPhone:contactsPhone];
    
    KGGLog(@"工种类型:%@",self.workType.type);
    KGGLog(@"%@",param);
    
    [self.view showHint:@"正在发布订单..."];
    self.useButton.enabled = NO;
    [KGGPublishOrderRequestManager publishCreatOrderParam:param completion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            KGGLog(@"创建订单成功");
            [self.view hideHUD];
            [self.useButton setTitle:@"已发布" forState:UIControlStateNormal];
            KGGOrderDetailsModel *model = [KGGOrderDetailsModel mj_objectWithKeyValues:responseObj.data];
            [self jumpPostedControllerModel:model];
        }else if (responseObj.code == 100){
            [self jumpVIPView];
        }
    } aboveView:nil inCaller:self];
}

#pragma mark - 创建订单成功
- (void)jumpPostedControllerModel:(KGGOrderDetailsModel *)detailsModel
{
    KGGPublishPostedViewController *postVC = [[KGGPublishPostedViewController alloc]init];
    postVC.detailsModel = detailsModel;
    postVC.type = 1;
    [self.navigationController pushViewController:postVC animated:YES];
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
    button.titleLabel.font = KGGFont(17);
    [button setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(snh_sureMessageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (KGGWorkTypeModel *)workType
{
    if (!_workType) {
        _workType = [[KGGWorkTypeModel alloc]init];
    }
    return _workType;
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
