//
//  KGGLeftDrawerHeaderView.m
//  kuaigong
//
//  Created by Ding on 2017/8/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLeftDrawerHeaderView.h"

@interface KGGLeftDrawerHeaderView ()

@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation KGGLeftDrawerHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        weakSelf(self);
        [self addSubview:self.avatarButton];
        [self addSubview:self.nickLabel];
        [self addSubview:self.loginButton];
        
        [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakself.mas_centerX);
            make.top.equalTo(weakself.mas_top).offset(53);
            make.width.height.mas_equalTo(@72);
        }];
        
//        self.nickLabel.text = @"34567890";
        [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakself.avatarButton.mas_centerX);
            make.top.equalTo(weakself.avatarButton.mas_bottom).offset(21);
            
        }];
        
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakself.avatarButton.mas_centerX);
            make.top.equalTo(weakself.avatarButton.mas_bottom).offset(21);
        }];
        
    }
    return self;
}

- (void)kgg_avatarImageViewButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(kgg_avatarImageButtonClick)]) {
        [self.delegate kgg_avatarImageButtonClick];
    }
}

- (void)loginButtonClick:(UIButton *)sender
{
    KGGLog(@"点击登录");
}


- (UILabel *)nickLabel
{
    if (!_nickLabel) {
        _nickLabel = [UILabel new];
        _nickLabel.textColor = UIColorHex(0x333333);
        _nickLabel.textAlignment = NSTextAlignmentCenter;
        _nickLabel.font = KGGLightFont(18);
        
    }
    return _nickLabel;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]init];
        [_loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
        _loginButton.titleLabel.font = KGGLightFont(18);
        [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}


- (UIButton *)avatarButton
{
    if (!_avatarButton) {
        _avatarButton = [[UIButton alloc]init];
        _avatarButton.xc_size = CGSizeMake(72, 72);
        _avatarButton.layer.masksToBounds = YES;
        _avatarButton.layer.cornerRadius = 72/2;
        [_avatarButton addTarget:self action:@selector(kgg_avatarImageViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_avatarButton setBackgroundImage:[UIImage imageNamed:@"icon_touxiang"] forState:UIControlStateNormal];
    }
    return _avatarButton;
}

@end
