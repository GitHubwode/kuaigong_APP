//
//  KGGSearchOrderHeaderView.m
//  kuaigong
//
//  Created by Ding on 2017/9/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGSearchOrderHeaderView.h"
#import "UIImageView+WebCache.h"

@interface KGGSearchOrderHeaderView ()
@property (nonatomic, strong) UIImageView *orderIamgeView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@end

@implementation KGGSearchOrderHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - 给headerView赋值
- (void)orderMessageAvatar:(NSString *)avatar Content:(NSString *)content ContentPhone:(NSString *)contentPhone
{
    [self.orderIamgeView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    self.nickLabel.text = content;
    self.phoneLabel.text = contentPhone;
}

- (void)setup{
    
    weakSelf(self);
    [self addSubview:self.orderIamgeView];
    [self.orderIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.mas_centerY);
        make.left.equalTo(weakself.mas_left).offset(30);
        make.width.height.mas_equalTo(@46);
    }];
    
    self.nickLabel = [self kgg_creatLabel];
    self.nickLabel.text = @"";
    [self addSubview:self.nickLabel];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.orderIamgeView.mas_right).offset(20);
        make.topMargin.equalTo(weakself.orderIamgeView.mas_topMargin);
    }];
    
    self.phoneLabel = [self kgg_creatLabel];
    self.phoneLabel.text = @"";
    [self addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.orderIamgeView.mas_right).offset(20);
        make.bottomMargin.equalTo(weakself.orderIamgeView.mas_bottomMargin);
    }];
    
}


- (UIImageView *)orderIamgeView
{
    if (!_orderIamgeView) {
        _orderIamgeView = [[UIImageView alloc]init];
        _orderIamgeView.image = [UIImage imageNamed:@"icon_touxiang"];
        _orderIamgeView.contentMode = UIViewContentModeScaleAspectFill;
        _orderIamgeView.layer.masksToBounds = YES;
        _orderIamgeView.layer.cornerRadius = 23.f;
    }
    return _orderIamgeView;
}

- (UILabel *)kgg_creatLabel
{
    UILabel *label = [UILabel new];
    label.textColor = UIColorHex(0x333333);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = KGGFont(14);
    return label;
}


@end
