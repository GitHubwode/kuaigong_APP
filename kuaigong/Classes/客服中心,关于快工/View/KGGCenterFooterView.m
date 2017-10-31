//
//  KGGCenterFooterView.m
//  kuaigong
//
//  Created by Ding on 2017/10/31.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGCenterFooterView.h"

@implementation KGGCenterFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KGGViewBackgroundColor;
        [self setUpHeaderView];
    }
    return self;
}

- (void)setUpHeaderView
{
    weakSelf(self);
    UILabel *label = [self creatLabel];
    label.text = @"快工版权所有";
    [self addSubview:label];
    
    UILabel *label1 = [self creatLabel];
    label1.text = @"Copyright@2017  kuaigongapp.com All Right Reserved";
    [self addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.bottom.equalTo(weakself.mas_bottom).offset(-12);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.bottom.equalTo(label1.mas_top).offset(-10);
    }];
}
- (UILabel *)creatLabel
{
    UILabel *label = [UILabel new];
    label.textColor = UIColorHex(0x333333);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = KGGFont(10);
    return label;
}
@end
