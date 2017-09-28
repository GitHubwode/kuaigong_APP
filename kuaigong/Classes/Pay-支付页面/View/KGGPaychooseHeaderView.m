//
//  KGGPaychooseHeaderView.m
//  kuaigong
//
//  Created by Ding on 2017/9/14.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPaychooseHeaderView.h"

@interface KGGPaychooseHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation KGGPaychooseHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self kgg_paySheetHeaderUI];

    }
    return self;
}
- (void)kgg_paySheetHeaderUI
{
    [self addSubview:self.titleStateLabel];
    weakSelf(self);
    [self.titleStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.centerY.equalTo(weakself.mas_centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@(kMainScreenWidth));
    }];
    
}

#pragma mark - 懒加载
- (UILabel *)titleStateLabel
{
    if (!_titleStateLabel) {
        _titleStateLabel = [UILabel new];
        _titleStateLabel.textAlignment = NSTextAlignmentCenter;
        _titleStateLabel.textColor = UIColorHex(0x333333);
        _titleStateLabel.font = KGGMediumFont(20);
    }
    return _titleStateLabel;
}



@end
