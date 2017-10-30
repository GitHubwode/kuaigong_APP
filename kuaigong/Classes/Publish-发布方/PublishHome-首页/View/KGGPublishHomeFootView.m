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
    
    UIView *addView = [UIView new];
    addView.backgroundColor = KGGViewBackgroundColor;
    addView.layer.masksToBounds = YES;
    addView.layer.cornerRadius = 5;
    [self addSubview:addView];
    [addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.top.equalTo(weakself.cycleTitleView.mas_bottom).offset(1);
        make.width.equalTo(@(KGGAdaptedWidth(307)));
        make.height.equalTo(@(KGGAdaptedHeight(56)));
    }];
    UIView *dotView = [UIView new];
    dotView.backgroundColor = KGGGoldenThemeColor;
    dotView.layer.masksToBounds = YES;
    dotView.layer.cornerRadius = 5;
    [addView addSubview:dotView];
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addView.mas_centerY);
        make.left.equalTo(addView.mas_left).offset(KGGAdaptedWidth(20));
        make.width.height.mas_equalTo(@(10));
    }];
    
    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_dingwei"]];
    [addView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dotView.mas_centerY);
        make.right.equalTo(addView.mas_right).offset(KGGAdaptedWidth(-20));
        make.width.equalTo(@(18));
        make.height.equalTo(@(23));
    }];
    
    [addView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dotView.mas_centerY);
        make.left.equalTo(dotView.mas_right).offset(KGGAdaptedWidth(20));
        make.right.equalTo(imageview.mas_left).offset(KGGAdaptedWidth(-20));
    }];
    
    [addView addSubview:self.locationButton];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addView.mas_centerY);
        make.centerX.equalTo(addView.mas_centerX);
        make.width.equalTo(addView.mas_width);
        make.height.equalTo(addView.mas_height);
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
        [_locationButton addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locationButton;
}

- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [UILabel new];
        _locationLabel.text = @"请点击选择用工地址";
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = KGGFont(14);
        _locationLabel.textColor = UIColorHex(0x333333);
    }
    return _locationLabel;
}

- (SDCycleScrollView *)cycleTitleView
{
    if (!_cycleTitleView) {
        _cycleTitleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, 28) delegate:self placeholderImage:nil];
        _cycleTitleView.autoScrollTimeInterval = 1.5f;
        _cycleTitleView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
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
