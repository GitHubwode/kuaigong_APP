//
//  KGGRouteFooterView.m
//  kuaigong
//
//  Created by Ding on 2017/11/6.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGRouteFooterView.h"

@interface KGGRouteFooterView ()

@property (nonatomic, strong) UIButton *contactButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation KGGRouteFooterView

- (instancetype)initWithFrame:(CGRect)frame IdentifyType:(NSUInteger)identifyType IsSart:(NSString *)isStart
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatFooterViewUIType:identifyType IsStart:isStart];
    }
    return self;
}

- (void)creatFooterViewUIType:(NSUInteger )type IsStart:(NSString *)isStart
{
    weakSelf(self);
    CGFloat buttonWidth = (kMainScreenWidth-2-30)/3;
    CGFloat buttonHeight = 37.f;
    UIView *topView = [UIView new];
    topView.frame = CGRectMake(0, 0, self.xc_width, 38);
    topView.backgroundColor = UIColorHex(0xf1f1f1);
    [self addSubview:topView];
    self.contactButton = [self creatButtonTitle:@"联系客服" Tag:10000];
    [topView addSubview:self.contactButton];
    [self.contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left);
        make.top.equalTo(topView.mas_top);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    self.cancelButton = [self creatButtonTitle:@"取消订单" Tag:10001];
    [topView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.contactButton.mas_centerY);
        make.left.equalTo(weakself.contactButton.mas_right).offset(1);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];

    self.moreButton = [self creatButtonTitle:@"更多" Tag:10002];
    [topView addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.contactButton.mas_centerY);
        make.left.equalTo(weakself.cancelButton.mas_right).offset(1);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(topView.mas_left);
        make.right.equalTo(topView.mas_right);
        make.bottom.equalTo(weakself.mas_bottom);
    }];
    
    [bottomView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_left).offset(15);
    }];
    
    [bottomView addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.right.equalTo(bottomView.mas_right).offset(KGGAdaptedWidth(-20));
        make.height.equalTo(@(buttonHeight));
        make.width.equalTo(@(KGGAdaptedWidth(115)));
    }];
    
    if (type == 1) {
        [self.cancelButton setTitle:@"修改订单" forState:UIControlStateNormal];
        self.messageLabel.text = @"如果工作已完成,请支付工资";
        [self.sureButton setTitle:@"支付订单" forState:UIControlStateNormal];
    }else{
        if ([isStart isEqualToString:@"N"]) {
            self.sureButton.enabled = NO;
            [self.sureButton setTitle:@"已确认出工" forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 按钮的点击事件
- (void)footerButtonClick:(UIButton *)sender
{
//    KGGLog(@"%ld",(long)sender.tag);
    if ([self.footerDelegate respondsToSelector:@selector(routeFooterViewButtonClickTag:)]) {
        [self.footerDelegate routeFooterViewButtonClickTag:sender];
    }
}
- (void)sureButtonClick:(UIButton *)sender
{
    KGGLog(@"确认出工");
    if ([self.footerDelegate respondsToSelector:@selector(routeFooterViewGoButtonClickTag:)]) {
        [self.footerDelegate routeFooterViewGoButtonClickTag:sender];
    }
}

#pragma mark - 懒加载
- (UIButton *)creatButtonTitle:(NSString *)title Tag:(NSInteger )tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button setBackgroundImage:[UIImage imageNamed:@"icon_button_default"] forState:UIControlStateNormal];
    button.titleLabel.font = KGGFont(12);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(footerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setBackgroundImage:[UIImage imageNamed:@"bg_button"] forState:UIControlStateNormal];
        _sureButton.tag = 10003;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 5.f;
        _sureButton.titleLabel.font = KGGFont(12);
        [_sureButton setTitle:@"确认干活" forState:UIControlStateNormal];
        [_sureButton setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.text = @"如果你已出发,请点击确认出工";
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = KGGFont(12);
        _messageLabel.textColor = UIColorHex(0x333333);
    }
    return _messageLabel;
}

- (void)dealloc{
    KGGLogFunc
}


@end
