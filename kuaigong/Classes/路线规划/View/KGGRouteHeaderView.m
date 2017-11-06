//
//  KGGRouteHeaderView.m
//  kuaigong
//
//  Created by Ding on 2017/11/6.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGRouteHeaderView.h"

@interface KGGRouteHeaderView ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *addressButton;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UIButton *phoneButton;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UILabel *totalLabel;


@end

@implementation KGGRouteHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatHeaderView];
    }
    return self;
}

#pragma mark - 创建UI页面
- (void)creatHeaderView
{
    weakSelf(self);
    
    [self addSubview:self.arrowButton];
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.top.equalTo(weakself.mas_top).offset(8);
        make.width.equalTo(@(38));
        make.height.equalTo(@(22));
    }];
    
    [self addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left).offset(15);
        make.top.equalTo(weakself.mas_top).offset(30);
        make.width.height.mas_equalTo(@(34));
    }];
    
    self.nameLabel = [self creatRouteTitlltie:@"" TitleFont:KGGMediumFont(15)];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.avatarImageView.mas_centerY);
        make.left.equalTo(weakself.avatarImageView.mas_right).offset(20);
    }];
    
    self.phoneLabel = [self creatRouteTitlltie:@"15026418284" TitleFont:KGGFont(12)];
    [self addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.avatarImageView.mas_left);
        make.top.equalTo(weakself.avatarImageView.mas_bottom).offset(KGGAdaptedHeight(12));
    }];
    
    self.phoneButton = [self creatHeaderViewButtonBackImage:@"icon_tel" ButtonTag:1000 Title:nil Image:nil Enabled:YES];
    [self addSubview:self.phoneButton];
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.phoneLabel.mas_right).offset(28);
        make.top.equalTo(weakself.nameLabel.mas_bottom).offset(15);
        make.width.height.mas_equalTo(@(20));
    }];
    
    self.addressButton = [self creatHeaderViewButtonBackImage:nil ButtonTag:1001 Title:@"余杭区文一西路恒生科技园" Image:@"icon_location" Enabled:NO];
    [self addSubview:self.addressButton];
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.avatarImageView.mas_left);
        make.bottom.equalTo(weakself.mas_bottom).offset(-10);
        make.width.equalTo(@(150));
        make.height.equalTo(@(24));
    }];
    
    self.totalLabel = [self creatRouteTitlltie:@"2100¥" TitleFont:KGGMediumFont(15)];
    self.totalLabel.textColor = KGGGoldenThemeColor;
    [self addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.mas_right).offset(KGGAdaptedWidth(-24));
        make.bottom.equalTo(weakself.mas_bottom).offset(-10);
    }];
    
    self.messageButton = [self creatHeaderViewButtonBackImage:@"icon_chat" ButtonTag:1002 Title:nil Image:nil Enabled:YES];
    [self addSubview:self.messageButton];
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.mas_right).offset(-24);
        make.centerX.equalTo(weakself.avatarImageView.mas_centerX);
        make.width.height.mas_equalTo(@(18));
    }];
}

#pragma mark - 按钮的点击时间
- (void)routeButtonClick:(UIButton *)sender
{
    KGGLog(@"按钮的点击时间");
}
- (void)arrowButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
#pragma mark - 懒加载
- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 17;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImageView;
}

- (UILabel *)creatRouteTitlltie:(NSString *)title TitleFont:(UIFont *)titleFont
{
    UILabel *label = [UILabel new];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = titleFont;
    label.textColor = UIColorHex(0x333333);
    return label;
}

- (UIButton *)creatHeaderViewButtonBackImage:(NSString *)backIamge ButtonTag:(NSUInteger)buttonTag Title:(NSString *)title Image:(NSString *)image Enabled:(BOOL)enable
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = buttonTag;
    button.enabled = enable;
    [button setBackgroundImage:[UIImage imageNamed:backIamge] forState:UIControlStateNormal];
    [button setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(routeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIButton *)arrowButton
{
    if (!_arrowButton) {
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowButton setBackgroundImage:[UIImage imageNamed:@"icon_arrow_top"] forState:UIControlStateNormal];
        [_arrowButton setBackgroundImage:[UIImage imageNamed:@"icon_arrow"] forState:UIControlStateSelected];
        [_arrowButton addTarget:self action:@selector(arrowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowButton;
}

@end
