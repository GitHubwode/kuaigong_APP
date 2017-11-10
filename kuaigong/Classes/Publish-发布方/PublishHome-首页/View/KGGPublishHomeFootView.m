//
//  KGGPublishHomeFootView.m
//  kuaigong
//
//  Created by Ding on 2017/8/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishHomeFootView.h"
#import "SDCycleScrollView.h"
#import "TXScrollLabelView.h"


@interface KGGPublishHomeFootView ()<SDCycleScrollViewDelegate,TXScrollLabelViewDelegate>
//@property (nonatomic, strong) SDCycleScrollView *cycleTitleView;
@property (strong, nonatomic) TXScrollLabelView *scrollLabelView;


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
    
//    [self addSubview:self.cycleTitleView];
//    [self.cycleTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakself.mas_left);
//        make.top.equalTo(weakself.carLabel.mas_bottom).offset(KGGAdaptedHeight(10));
//        make.width.equalTo(@(kMainScreenWidth));
//        make.height.equalTo(@(KGGAdaptedHeight(32)));
//    }];
    
//            self.scrollLabelView.frame = CGRectMake(16, snh_width, snh_titleWidth, 13);
            /** Step5: 开始滚动(Start scrolling!) */
    
    //    * Step2: 创建 ScrollLabelView
    self.scrollLabelView = [TXScrollLabelView scrollWithTitle:@"注:架子工每天用工8小时,其它工种每天用工9小时 每车7人,少于4人无需车费" type:TXScrollLabelViewTypeLeftRight velocity:1 options:UIViewAnimationOptionCurveEaseInOut];
    
    /** Step3: 设置代理进行回调 */
    self.scrollLabelView.scrollLabelViewDelegate = self;
    
    [self addSubview:self.scrollLabelView];
    
    //偏好(Optional), Preference,if you want.
    self.scrollLabelView.tx_centerX  = kMainScreenWidth * 0.5;
    self.scrollLabelView.scrollInset = UIEdgeInsetsMake(0, 10 , 0, 10);
    self.scrollLabelView.scrollSpace = 10;
    self.scrollLabelView.font = KGGFont(14);
    self.scrollLabelView.scrollTitleColor = UIColorHex(0x333333);
    self.scrollLabelView.textAlignment = NSTextAlignmentCenter;
    self.scrollLabelView.backgroundColor = [UIColor clearColor];
    
    /** Step4: 布局(Required) */
    self.scrollLabelView.frame = CGRectMake(16, self.carLabel.xc_y+32, kMainScreenWidth-32, KGGAdaptedHeight(32));
    /** Step5: 开始滚动(Start scrolling!) */
    [self.scrollLabelView beginScrolling];
    
    UIView *addView = [UIView new];
    addView.backgroundColor = KGGViewBackgroundColor;
    addView.layer.masksToBounds = YES;
    addView.layer.cornerRadius = 5;
    [self addSubview:addView];
    [addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.top.equalTo(weakself.scrollLabelView.mas_bottom).offset(1);
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

//- (TXScrollLabelView *)scrollLabelView
//{
//    if (!_scrollLabelView) {
//        _scrollLabelView = [TXScrollLabelView scrollWithTitle:@"注:每天用工9小时 每车7人,少于4人无需车费" type:TXScrollLabelViewTypeLeftRight velocity:1 options:UIViewAnimationOptionCurveEaseInOut];
//
//        /** Step3: 设置代理进行回调 */
//        _scrollLabelView.scrollLabelViewDelegate = self;
//        //偏好(Optional), Preference,if you want.
//        _scrollLabelView.tx_centerX  = kMainScreenWidth * 0.5;
//        _scrollLabelView.scrollInset = UIEdgeInsetsMake(0, 10 , 0, 10);
//        _scrollLabelView.scrollSpace = 10;
//        _scrollLabelView.font = KGGFont(14);
//        _scrollLabelView.scrollTitleColor = UIColorHex(0x999999);
//        _scrollLabelView.textAlignment = NSTextAlignmentCenter;
//        _scrollLabelView.backgroundColor = [UIColor clearColor];
//        _scrollLabelView.scrollTitle = @"注:每天用工9小时 每车7人,少于4人无需车费";
//        /** Step4: 布局(Required) */
////        _scrollLabelView.frame = CGRectMake(16, snh_width, snh_titleWidth, 13);
////        /** Step5: 开始滚动(Start scrolling!) */
////        [_scrollLabelView beginScrolling];
//
//    }
//    return _scrollLabelView;
//}

//- (SDCycleScrollView *)cycleTitleView
//{
//    if (!_cycleTitleView) {
//        _cycleTitleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, 28) delegate:self placeholderImage:nil];
//        _cycleTitleView.autoScrollTimeInterval = 4.f;
//        _cycleTitleView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        _cycleTitleView.onlyDisplayText = YES;
//        _cycleTitleView.titleLabelTextColor = UIColorHex(0x333333);
//        _cycleTitleView.titleLabelBackgroundColor = [UIColor whiteColor];
//        _cycleTitleView.titleLabelTextAlignment = NSTextAlignmentCenter;
//        NSMutableArray *titlesArray = [NSMutableArray new];
//        [titlesArray addObject:@"注:每天用工9小时 "];
//        [titlesArray addObject:@"每车7人,少于4人无需车费"];
//        _cycleTitleView.titlesGroup = [titlesArray copy];
//    }
//    return _cycleTitleView;
//}

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
