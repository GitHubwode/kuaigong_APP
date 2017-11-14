//
//  KGGCancelOrderPayView.m
//  kuaigong
//
//  Created by Ding on 2017/11/14.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGCancelOrderPayView.h"

@interface KGGCancelOrderPayView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *cancel_Button;
@property (nonatomic, strong) UIButton *nowReButton;//立即充值
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *peopleImageView;
@property (nonatomic, strong) UIView      *middleView;

@end

@implementation KGGCancelOrderPayView


+ (instancetype)kgg_alertPromptApplyForViewKGGApplyButtonClick:(PayOrderButton)apply_Button KGGUnderstandButtonClick:(CancelButton)know_Button
{
    KGGCancelOrderPayView *payView = [[KGGCancelOrderPayView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    payView.backgroundColor = [UIColor clearColor];
    payView.sureButton = apply_Button;
    payView.cancelButton = know_Button;
    
    return payView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUIView];
    }
    return self;
}

#pragma mark - 初始化UI界面
-  (void)setUpUIView
{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    self.bgView = [[UIApplication sharedApplication].delegate window];
    
    weakSelf(self);
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    self.view1 = view1;
    view1.backgroundColor = KGGColorA(0, 0, 0, 75);
    [self.bgView addSubview:view1];
    
    UIView *topView = [UIView new];
    [view1 addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.centerY.equalTo(weakself.mas_centerY);
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
    
    self.peopleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic_cry"]];
    [self.bottomView addSubview:self.peopleImageView];
    [self.peopleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(topView.mas_top);
        make.width.equalTo(@(225/2));
        make.height.equalTo(@(348/2));
    }];
    
    [topView addSubview:self.cancel_Button];
    [self.cancel_Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-8);
        make.bottom.equalTo(weakself.bottomView.mas_top).offset(-10);
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
    
    self.middleView = [UIView new];
    [self.bottomView addSubview:self.middleView];
    [self.middleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.bottomView.mas_left);
        make.top.equalTo(weakself.peopleImageView.mas_bottom);
        make.bottom.equalTo(weakself.nowReButton.mas_top);
        make.width.equalTo(weakself.bottomView.mas_width);
    }];
    
    [self.middleView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.middleView.mas_centerX);
        make.centerY.equalTo(weakself.middleView.mas_centerY);
        make.height.equalTo(@(30));
    }];
    
}

#pragma mark - ButtonClick
- (void)kgg_nowReButtonClick:(UIButton *)sender
{
    KGGLog(@"立即充值");
    
    [self dismissSheetView];
    if (self.sureButton) {
        self.sureButton();
    }
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
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        
        
    } completion:^(BOOL finished) {
        [weakSelf.bottomView removeFromSuperview];
        [weakSelf.view1 removeFromSuperview];
        [weakSelf.cancel_Button removeFromSuperview];
        [weakSelf.bgView removeFromSuperview];
        [weakSelf.nowReButton removeFromSuperview];
        [weakSelf.nextButton removeFromSuperview];
        [weakSelf.messageLabel removeFromSuperview];
        [weakSelf.peopleImageView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - 懒加载
- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.font = KGGMediumFont(15);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = UIColorHex(0x333333);
        _messageLabel.text = @"接单超过两小时,取消需支付99元";
    }
    return _messageLabel;
}

- (UIButton *)nowReButton
{
    if (!_nowReButton) {
        _nowReButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nowReButton setBackgroundImage:[UIImage imageNamed:@"icon_btn"] forState:UIControlStateNormal];
        [_nowReButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_nowReButton setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
        _nowReButton.titleLabel.font = KGGFont(18);
        [_nowReButton addTarget:self action:@selector(kgg_nowReButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nowReButton;
}
- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"下次再说" forState:UIControlStateNormal];
        [_nextButton setTitleColor:UIColorHex(0x999999) forState:UIControlStateNormal];
        _nextButton.titleLabel.font = KGGFont(12);
        [_nextButton addTarget:self action:@selector(kgg_nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _nextButton;
}

- (UIButton *)cancel_Button
{
    if (!_cancel_Button) {
        _cancel_Button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancel_Button setBackgroundImage:[UIImage imageNamed:@"icon-x"] forState:UIControlStateNormal];
        [_cancel_Button addTarget:self action:@selector(kgg_cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancel_Button;
}
- (void)dealloc
{
    KGGLogFunc
}


@end
