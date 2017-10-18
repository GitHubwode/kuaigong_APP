//
//  KGGOrderCorrectViewController.m
//  kuaigong
//
//  Created by Ding on 2017/10/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGOrderCorrectViewController.h"
#import "KGGOrderCorrectViewCell.h"
#import "KGGHomePublishModel.h"
#import "KGGPublishOrderRequestManager.h"
#import "KGGOrderCorrectModel.h"

@interface KGGOrderCorrectViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *peopleImageView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *VIPButton;
@property (nonatomic, strong) UIButton *nowReButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) KGGOrderCorrectViewCell *homeCell;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation KGGOrderCorrectViewController
{
    UIView      *_middleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatDatsource];
    [self setUpView];
}

- (void)creatDatsource
{
    KGGOrderCorrectModel *model1 = [[KGGOrderCorrectModel alloc]init];
    model1.title = @"用工人数";
    model1.subTitle = [NSString stringWithFormat:@"%lu",(unsigned long)self.detailsModel.number];
    [self.datasource addObject:model1];

    KGGOrderCorrectModel *model2 = [[KGGOrderCorrectModel alloc]init];
    model2.title = @"用工天数";
    model2.subTitle = [NSString stringWithFormat:@"%lu",(unsigned long)self.detailsModel.days];
    [self.datasource addObject:model2];
}

#pragma mark - UITableViewDelegate  UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGOrderCorrectModel *model = self.datasource[indexPath.row];
    KGGOrderCorrectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGOrderCorrectViewCell ordeCorrectIdentifier] forIndexPath:indexPath];
    self.homeCell = cell;
    cell.correntModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[cell correctTextField] becomeFirstResponder];
}

#pragma mark - 初始化页面
- (void)setUpView
{
    weakSelf(self);
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    self.view1 = view1;
    view1.backgroundColor = KGGColorA(0, 0, 0, 75);
    [self.view addSubview:view1];
    
    UIView *topView = [UIView new];
    [view1 addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.centerY.equalTo(weakself.view.mas_centerY);
        make.width.equalTo(@(kMainScreenWidth-KGGAdaptedWidth(60)));
        make.height.equalTo(@(kMainScreenHeight-KGGAdaptedHeight(254)));
    }];
    
    self.bottomView = [UIView new];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.layer.masksToBounds = NO;
    self.bottomView.layer.cornerRadius = 25.f;
    [view1 addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left);
        make.bottom.equalTo(topView.mas_bottom);
        make.top.equalTo(topView.mas_top).offset(KGGAdaptedHeight(80));
        make.width.equalTo(topView.mas_width);
    }];
    
    self.peopleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-man"]];
    [self.bottomView addSubview:self.peopleImageView];
    [self.peopleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(topView.mas_leading);
        make.top.equalTo(topView.mas_top);
    }];
    
    [topView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-8);
        make.bottom.equalTo(weakself.bottomView.mas_top).offset(-10);
    }];
    
    [self.bottomView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.peopleImageView.mas_bottom);
        make.centerX.equalTo(weakself.bottomView.mas_centerX).offset(20);
    }];
    
    [self.bottomView addSubview:self.VIPButton];
    [self.VIPButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.messageLabel.mas_centerX);
        make.top.equalTo(weakself.bottomView.mas_top).offset(23);
    }];
    
    [self.bottomView addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.bottomView.mas_centerX);
        make.bottom.equalTo(weakself.bottomView.mas_bottom).offset(-10);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];
    
    [self.bottomView addSubview:self.nowReButton];
    [self.nowReButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.bottomView.mas_centerX);
        make.bottom.equalTo(weakself.nextButton.mas_top).offset(-10);
        make.width.equalTo(@200);
        make.height.equalTo(@45);
    }];
    
    _middleView = [UIView new];
    _middleView.backgroundColor = [UIColor redColor];
    [self.bottomView addSubview:_middleView];
    [_middleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.bottomView.mas_left);
        make.top.equalTo(weakself.peopleImageView.mas_bottom);
        make.bottom.equalTo(weakself.nowReButton.mas_top);
        make.width.equalTo(weakself.bottomView.mas_width);
    }];
    
    [_middleView addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_middleView.mas_centerX);
        make.centerY.equalTo(_middleView.mas_centerY);
        make.width.equalTo(_middleView.mas_width);
        make.height.equalTo(_middleView.mas_height);
    }];
}

#pragma mark - ButtonClick
- (void)kgg_nowReButtonClick:(UIButton *)sender
{
    KGGLog(@"立即充值");
    
    KGGLog(@"%@",self.datasource);
    KGGOrderCorrectModel *model = self.datasource[0];
    KGGOrderCorrectModel *model1 = self.datasource[1];
    
    KGGLog(@"%@ %@",model.subTitle,model1.subTitle);
    
    [KGGPublishOrderRequestManager publishUpdateOrderId:self.detailsModel.orderId Number:[model.subTitle integerValue] Days:[model1.subTitle integerValue] completion:^(KGGResponseObj *responseObj) {
        
        if (responseObj.code == KGGSuccessCode) {
            if (self.backBlock) {
                self.backBlock(200);
            }
        }
        [self dismissSheetView];
        
    } aboveView:self.view inCaller:self];
}

- (void)kgg_nextButtonClick:(UIButton *)sender
{
    KGGLog(@"下次再说");
    [self dismissSheetView];
}

- (void)kgg_cancelButtonClick:(UIButton *)sender
{
    KGGLog(@"取消按钮");
    [self dismissSheetView];
}

//消失
- (void)dismissSheetView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 懒加载
- (UIButton *)nowReButton
{
    if (!_nowReButton) {
        _nowReButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nowReButton setBackgroundImage:[UIImage imageNamed:@"icon_btn"] forState:UIControlStateNormal];
        [_nowReButton setTitle:@"确认修改" forState:UIControlStateNormal];
        [_nowReButton setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
        _nowReButton.titleLabel.font = KGGFont(18);
        [_nowReButton addTarget:self action:@selector(kgg_nowReButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nowReButton;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.font = KGGFont(14);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = UIColorHex(0x333333);
        _messageLabel.text = @"";
    }
    return _messageLabel;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"取消" forState:UIControlStateNormal];
        [_nextButton setTitleColor:UIColorHex(0x999999) forState:UIControlStateNormal];
        _nextButton.titleLabel.font = KGGFont(12);
        [_nextButton addTarget:self action:@selector(kgg_nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _nextButton;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"icon-x"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(kgg_cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)VIPButton
{
    if (!_VIPButton) {
        _VIPButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_VIPButton setImage:[UIImage imageNamed:@"icon-vip"] forState:UIControlStateNormal];
        //        _VIPButton.enabled = NO;
        [_VIPButton setTitle:@" 用户" forState:UIControlStateNormal];
        [_VIPButton setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
        _VIPButton.titleLabel.font = KGGFont(24);
        
    }
    return _VIPButton;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth-60, 100) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor yellowColor];
        [_tableView registerNib:[UINib nibWithNibName:@"KGGOrderCorrectViewCell" bundle:nil] forCellReuseIdentifier:[KGGOrderCorrectViewCell ordeCorrectIdentifier]];
        _tableView.rowHeight = KGGAdaptedHeight(40.f);
        _tableView.separatorStyle = UITableViewCellStyleDefault;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)dealloc
{
    KGGLogFunc
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
