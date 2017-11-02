//
//  KGGActionSheetController.m
//  kuaigong
//
//  Created by Ding on 2017/9/14.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGActionSheetController.h"
#import "KGGPaySheetViewCell.h"
#import "KGGPayChooseModel.h"
#import "KGGPaychooseHeaderView.h"
#import "KGGPayRequestManager.h"
#import "WXApi.h"


static CGFloat tableHeight = 280.f;
static CGFloat itemHeight = 61.f;

@interface KGGActionSheetController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *payTableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) KGGPaySheetViewCell *cell;
@property (nonatomic, strong)UIButton *payButton;
@property (nonatomic, strong)UIButton *dissButton;

@property (nonatomic, assign)NSIndexPath *selIndex;
@property (nonatomic, assign)NSInteger indexPay;
@property (nonatomic, strong) UIView *wrapperView;


@end


@implementation KGGActionSheetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self kgg_datasourceMessage];
    [self kgg_choosePayViewUI];
    [KGGNotificationCenter addObserver:self selector:@selector(weixinPayResulTMessage:) name:SNHPayWeiXinNotification object:nil];
}

- (void)kgg_choosePayViewUI
{
    self.wrapperView = [[UIView alloc] init];
    self.wrapperView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.wrapperView];
    [_wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(kMainScreenHeight-tableHeight+(3-self.datasource.count)*itemHeight);
    }];

    KGGPaychooseHeaderView *header = [[KGGPaychooseHeaderView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 48)];
    header.titleStateLabel.text = [NSString stringWithFormat:@"工资: ¥%@",self.moneyString];

    self.payTableView.tableHeaderView = header;
    self.payTableView.backgroundColor = [UIColor whiteColor];
    [_wrapperView addSubview:self.payTableView];

    [_wrapperView addSubview:self.payButton];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payTableView.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kMainScreenWidth));
        make.height.equalTo(@49);
    }];

    [self.view addSubview:self.dissButton];
    [self.dissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.bottom.equalTo(self.payTableView.mas_top);
    }];
}

#pragma mark - UITableView数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return itemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGPayChooseModel *model = self.datasource[indexPath.row];
    KGGPaySheetViewCell *cell= [tableView dequeueReusableCellWithIdentifier:[KGGPaySheetViewCell paySheetIdentifier]];
    self.cell = cell;
    [cell kgg_paySheetCellMessage:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPay = indexPath.row;
    self.payButton.selected = YES;
    [self.payButton setBackgroundColor:UIColorHex(0x43a437)];

    if (_selIndex == nil) {
        self.indexPay = indexPath.row;
    }else{
        self.indexPay = _selIndex.row;
    }
    
    KGGPayChooseModel *model = self.datasource[self.indexPay];
    KGGPaySheetViewCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
    celled.iconImageView.image = [UIImage imageNamed:model.iconImage];
    celled.statusImageView.image = [UIImage imageNamed:model.chooseImage];
    _selIndex = indexPath;
    
    KGGPayChooseModel *model1 = self.datasource[indexPath.row];
    KGGPaySheetViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.statusImageView.image = [UIImage imageNamed:model1.choosePressImage];
    cell.iconImageView.image = [UIImage imageNamed:model1.iconPressImage];
    
}

- (void)kgg_imPayButtonClick:(UIButton *)sender
{
    KGGLog(@"立即支付");
    if (sender.selected == NO) {
        [self.view showHint:@"请选择支付方式"];
        return;
    }else{
        [self.view showHint:@"跳转对应的支付页面"];
        
        KGGLog(@"%ld",(long)self.indexPay);
        [self setUpPayRequest];
    }
}

#pragma mark - 请求数据获取后台的签名
- (void)setUpPayRequest
{
    [KGGPayRequestManager payOrderDetailsMessageOrder:self.itemId completion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            KGGLog(@"%@",responseObj);
            [self kgg_weixinPay:responseObj.data];
        }
        
    } aboveView:self.view inCaller:self];
    
}

#pragma mark - 微信支付
- (void)kgg_weixinPay:(id )result
{
    KGGLog(@"%@",result);
    PayReq *request = [[PayReq alloc]init];
    request.partnerId = @"1490727912";
    request.prepayId = [result objectForKey:@"prepayId"];
//    request.package = [result objectForKey:@"package2"];
    request.nonceStr = [result objectForKey:@"nonceStr"];
//    request.timeStamp = (UInt32)[[result objectForKey:@"timestamp"] intValue];
    request.sign = [result objectForKey:@"sign"];
    [WXApi sendReq:request];
}

#pragma mark - 微信成功的回调
- (void)weixinPayResulTMessage:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"0"]) {
        KGGLog(@"支付成功");
        [self.view showHint:@"支付成功"];
        [KGGNotificationCenter postNotificationName:SNHPaySuccessNotification object:self userInfo:nil];
        NSString *code = @"200";
        [self dismissViewControllerAnimated:YES completion:^{
            self.callPaySuccessBlock(code);
        }];
    }else if ([notification.object isEqualToString:@"-1"]){
        [self.view showHint:@"支付失败"];
    }else if ([notification.object isEqualToString:@"-2"]){
        [self.view showHint:@"用户点击取消并返回"];
    }else if ([notification.object isEqualToString:@"-3"]){
        [self.view showHint:@"发送失败"];
    }else if ([notification.object isEqualToString:@"-4"]){
        [self.view showHint:@"授权失败"];
    }else if ([notification.object isEqualToString:@"-5"]){
        [self.view showHint:@"微信不支持"];
    }
}



#pragma mark - 创建数据类型
- (void)kgg_datasourceMessage
{
    KGGPayChooseModel *model1 = [[KGGPayChooseModel alloc]init];
    model1.iconImage = @"icon_zfb_h";
    model1.iconPressImage = @"con_zfb";
    model1.title = @"支付宝支付";
    model1.chooseImage = @"icon_c_h";
    model1.choosePressImage = @"icon_c";
    [self.datasource addObject:model1];
    
    KGGPayChooseModel *model2 = [[KGGPayChooseModel alloc]init];
    model2.iconImage = @"icon_wx_h";
    model2.iconPressImage = @"icon_wx";
    model2.title = @"微信支付";
    model2.chooseImage = @"icon_c_h";
    model2.choosePressImage = @"icon_c";
    [self.datasource addObject:model2];
    
    if (_isPublish == YES) return;
//    KGGPayChooseModel *model3 = [[KGGPayChooseModel alloc]init];
//    model3.iconImage = @"icon_xianjin";
//    model3.iconPressImage = @"icon_xianjin_p";
//    model3.title = @"现金支付";
//    model3.chooseImage = @"icon_c_h";
//    model3.choosePressImage = @"icon_c";
//    [self.datasource addObject:model3];
}

- (UITableView *)payTableView
{
    if (!_payTableView) {
        _payTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, itemHeight*self.datasource.count+48) style:UITableViewStyleGrouped];
        [_payTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGPaySheetViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGPaySheetViewCell paySheetIdentifier]];
        _payTableView.delegate = self;
        _payTableView.dataSource = self;
        _payTableView.separatorStyle = UITableViewCellStyleDefault;
        _payTableView.scrollEnabled = NO;
    }
    return _payTableView;
}

-(void)kgg_dissButtonClick
{
    KGGLog(@"取消按钮");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (UIButton *)payButton
{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setBackgroundColor:UIColorHex(0x9b9b9b)];
        [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payButton setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(kgg_imPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _payButton.selected = NO;
    }
    return _payButton;
}

- (UIButton *)dissButton
{
    if (!_dissButton) {
        _dissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dissButton.backgroundColor = KGGColorA(0, 0, 0, 178);
        [_dissButton addTarget:self action:@selector(kgg_dissButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dissButton;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    KGGLogFunc
}


@end
