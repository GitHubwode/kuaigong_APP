//
//  KGGPublishHomeFootView.m
//  kuaigong
//
//  Created by Ding on 2017/8/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishHomeFootView.h"
#import "SDCycleScrollView.h"

@interface KGGPublishHomeFootView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleTitleView;

@end

@implementation KGGPublishHomeFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatFootView];
    }
    return self;
}

#pragma mark - 创建底部视图
- (void)creatFootView
{
    weakSelf(self);
    [self addSubview:self.carLabel];
    [self.carLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left);
        make.top.equalTo(weakself.mas_top);
        make.width.equalTo(@(kMainScreenWidth));
        make.height.equalTo(@(KGGAdaptedHeight(32)));
    }];
    
    [self addSubview:self.cycleTitleView];
    [self.cycleTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left);
        make.top.equalTo(weakself.carLabel.mas_bottom).offset(KGGAdaptedHeight(10));
        make.width.equalTo(@(kMainScreenWidth));
        make.height.equalTo(@(KGGAdaptedHeight(32)));
    }];
    
    UIView *line1 = [self creatLineView];
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left);
        make.top.equalTo(weakself.cycleTitleView.mas_bottom).offset(1);
        make.width.equalTo(@(kMainScreenWidth));
        make.height.equalTo(@(KGGOnePixelHeight));
    }];
    
    [self addSubview:self.locationButton];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left);
        make.top.equalTo(line1.mas_bottom);
        make.width.equalTo(@(kMainScreenWidth));
        make.height.equalTo(@(KGGAdaptedHeight(54)));
    }];
    
    UIView *line2 = [self creatLineView];
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left);
        make.top.equalTo(weakself.locationButton.mas_bottom).offset(2);
        make.width.equalTo(@(kMainScreenWidth));
        make.height.equalTo(@(KGGOnePixelHeight));
    }];
    
}

#pragma mark - 定位
- (void)locationButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(kgg_publishHomeFootViewLocationButtonClick)]) {
        [self.delegate kgg_publishHomeFootViewLocationButtonClick];
    }
    KGGLog(@"定位功能");
}


- (UIView *)creatLineView
{
    UIView *lineView = [UIView new];
    lineView.backgroundColor = KGGSeparatorColor;
    return lineView;
}


- (UIButton *)locationButton
{
    if (!_locationButton) {
        _locationButton = [[UIButton alloc]init];
        [_locationButton setImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
        [_locationButton setTitle:@" 请点击选择用工地址" forState:UIControlStateNormal];
        [_locationButton setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
        [_locationButton addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _locationButton.titleLabel.font = KGGFont(14);
    }
    return _locationButton;
}

- (SDCycleScrollView *)cycleTitleView
{
    if (!_cycleTitleView) {
        _cycleTitleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, 28) delegate:self placeholderImage:nil];
        _cycleTitleView.autoScrollTimeInterval = 1.5f;
        _cycleTitleView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _cycleTitleView.onlyDisplayText = YES;
        _cycleTitleView.titleLabelTextColor = UIColorHex(0x333333);
        _cycleTitleView.titleLabelBackgroundColor = [UIColor whiteColor];
        _cycleTitleView.titleLabelTextAlignment = NSTextAlignmentCenter;
        NSMutableArray *titlesArray = [NSMutableArray new];
        [titlesArray addObject:@"注:每天用工9小时"];
        [titlesArray addObject:@"明天每个工时费为35元/小时"];
        _cycleTitleView.titlesGroup = [titlesArray copy];
    }
    return _cycleTitleView;
}

- (UILabel *)carLabel
{
    if (!_carLabel) {
        _carLabel = [UILabel new];
        _carLabel.text = @"车费:10辆*210元";
        _carLabel.textAlignment = NSTextAlignmentCenter;
        _carLabel.textColor = UIColorHex(0x333333);
        _carLabel.font = KGGFont(14);
    }
    return _carLabel;
}

@end
