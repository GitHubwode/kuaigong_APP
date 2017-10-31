//
//  KGGCenterHeaderView.m
//  kuaigong
//
//  Created by Ding on 2017/10/31.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGCenterHeaderView.h"

@implementation KGGCenterHeaderView

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
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_logo"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.top.equalTo(weakself.mas_top).offset(KGGAdaptedHeight(35));
        make.width.equalTo(@(KGGAdaptedWidth(110)));
        make.height.equalTo(@(KGGAdaptedHeight(81)));
    }];
    
    UILabel *label = [UILabel new];
    label.textColor = UIColorHex(0x333333);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = KGGFont(18);
    [self addSubview:label];
    NSString *curVersion =  [NSBundle currentVersion];
    label.text = [NSString stringWithFormat:@"快工 %@",curVersion];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(KGGAdaptedHeight(15));
    }];
    
}

@end
