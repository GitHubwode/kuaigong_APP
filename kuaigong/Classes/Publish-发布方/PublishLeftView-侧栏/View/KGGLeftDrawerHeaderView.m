//
//  KGGLeftDrawerHeaderView.m
//  kuaigong
//
//  Created by Ding on 2017/8/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLeftDrawerHeaderView.h"
#import "UIImageView+WebCache.h"

@interface KGGLeftDrawerHeaderView ()

@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIImageView *avatarImageView;

@end

@implementation KGGLeftDrawerHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        weakSelf(self);
        [self addSubview:self.nickLabel];
        [self addSubview:self.loginButton];
        [self addSubview:self.avatarImageView];
        
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakself.mas_centerX);
            make.top.equalTo(weakself.mas_top).offset(53);
            make.width.height.mas_equalTo(@72);
        }];
        
        [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakself.avatarImageView.mas_centerX);
            make.top.equalTo(weakself.avatarImageView.mas_bottom).offset(21);
            
        }];
        
//        self.loginButton.backgroundColor = [UIColor redColor];
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakself.avatarImageView.mas_centerX);
            make.top.equalTo(weakself.avatarImageView.mas_top);
            make.bottom.equalTo(weakself.nickLabel.mas_bottom);
            make.width.equalTo(@72);
        }];
        
        [self leftTableHeaderView];
        
    }
    return self;
}

#pragma mark - 侧栏赋值
- (void)leftTableHeaderView
{
    if ([KGGUserManager shareUserManager].logined) {
        self.nickLabel.text = [KGGUserManager shareUserManager].currentUser.nickname;
    }else{
        self.nickLabel.text = @"点击登录";
    }
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[KGGUserManager shareUserManager].currentUser.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    
}

- (void)avatarImageViewButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(kgg_avatarImageButtonClick)]) {
        [self.delegate kgg_avatarImageButtonClick];
    }
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
        [_loginButton setTitle:@"" forState:UIControlStateNormal];
        [_loginButton setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
        _loginButton.titleLabel.font = KGGLightFont(18);
        [_loginButton addTarget:self action:@selector(avatarImageViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 72/2;
        _avatarImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _avatarImageView;
}


@end
