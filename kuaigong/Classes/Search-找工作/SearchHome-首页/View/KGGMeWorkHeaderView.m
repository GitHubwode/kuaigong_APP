//
//  KGGMeWorkHeaderView.m
//  kuaigong
//
//  Created by Ding on 2017/8/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMeWorkHeaderView.h"

@interface KGGMeWorkHeaderView ()

@property (nonatomic, strong) UIView *avatarWraperView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
/** 登录/注册按钮 */
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation KGGMeWorkHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self creatHeaderUI];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}


#pragma mark - event
- (void)loginButtonAction{
//    [self.window.rootViewController isLogined];
    KGGLog(@"登录按钮...");
}

- (void)removeSubViews
{
    if (_nickLabel) {
        [_nickLabel removeFromSuperview];
        _nickLabel = nil;
    }
    
    if (_phoneLabel) {
        [_phoneLabel removeFromSuperview];
        _phoneLabel = nil;
    }
    
    if (_loginButton) {
        [_loginButton removeFromSuperview];
        _loginButton = nil;
    }
}

#pragma mark - 创建顶部视图
- (void)creatHeaderUI
{
    weakSelf(self);
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@""];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = self.frame;
    [self addSubview:imageView];
    
    [imageView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView.mas_centerX);
        make.top.equalTo(imageView.mas_top).offset(30);
        make.width.height.mas_equalTo(@72);
    }];
    
    self.nickLabel = [self creatLabel];
    [imageView addSubview:self.nickLabel];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(19);
    }];
    
    self.phoneLabel = [self creatLabel];
    [imageView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView.mas_centerX);
        make.top.equalTo(weakself.nickLabel.mas_bottom).offset(25);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_avatarImageView.mas_bottom).with.offset(30.f);
    }];
    
}

#pragma mark - lazy
- (UIView *)avatarWraperView{
    if (!_avatarWraperView) {
        _avatarWraperView = [[UIView alloc] init];
        [self addSubview:_avatarWraperView];
    }
    return _avatarWraperView;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.userInteractionEnabled = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = 72/2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.image = [UIImage imageNamed:@"icon_touxiang"];
        [_avatarWraperView addSubview:_avatarImageView];
    }
    return _avatarImageView;
}

- (UILabel *)creatLabel
{
    UILabel *label = [UILabel new];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = KGGFont(15);
    return label;
}

- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setImage:[UIImage imageNamed:@"icon_btn_login"] forState:UIControlStateNormal];
        _loginButton.adjustsImageWhenHighlighted = NO;
        [_loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loginButton];
    }
    return _loginButton;
}



@end
