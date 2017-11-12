//
//  KGGPublishHomeHeaderView.m
//  kuaigong
//
//  Created by Ding on 2017/10/19.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishHomeHeaderView.h"
#import "SDCycleScrollView.h"
#import "KGGSlideMenu.h"

static CGFloat const itemHeight = 168.f;

@interface KGGPublishHomeHeaderView ()<SDCycleScrollViewDelegate,CKSlideMenuDelegate>
@property (nonatomic, strong) SDCycleScrollView  *headSDCycleView;
@property (nonatomic, strong) KGGSlideMenu *slideMenu;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSString *cityName;

@end

@implementation KGGPublishHomeHeaderView

- (void)creatPublishHeaderViewTitle:(NSString *)title
{
    if ([title isEqualToString:@"杭州市"]) {
        title = @"杭州总公司";
    }else{
        title = [title stringByReplacingOccurrencesOfString:@"市" withString:@"公司"];
    }
    
    
    weakSelf(self);
    UIButton *button = [self creatButtonSelectImage:@"icon_nine" ImageString:@"icon_nine" Tag:100];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.mas_right).offset(-15);
        make.bottom.equalTo(weakself.mas_bottom).offset(KGGAdaptedHeight(-47));
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    
    UILabel *label = [UILabel new];
    label.text = title;
    label.textColor = UIColorHex(0xffffff);
    label.font = KGGFont(15);
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.mas_top).offset(5);
        make.left.equalTo(weakself.mas_left).offset(14);
    }];

}

- (instancetype)initWithFrame:(CGRect)frame HeaderViewSlideTitle:(NSArray *)titleArray ImageArray:(NSArray *)imageArray City:(NSString *)city;
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleArray = titleArray;
        _imageArray = imageArray;
        _cityName = city;
        [self setupHomeView];
        [self creatPublishHeaderViewTitle:city];
    }
    return self;
}

#pragma mark - 设计页面
- (void)setupHomeView
{
    self.headSDCycleView.frame = CGRectMake(0, 0, kMainScreenWidth, KGGAdaptedHeight(itemHeight));
    [self addSubview:self.headSDCycleView];
    self.slideMenu.frame = CGRectMake(0, KGGAdaptedHeight(itemHeight), kMainScreenWidth, KGGAdaptedHeight(37));
    [self addSubview:self.slideMenu];
}

#pragma mark - KGGSlideMenuDelegate
- (void)pageTabViewDidEndChangeIndex:(NSInteger)index
{
    KGGLog(@"---TOP点击了第%ld张图片", (long)index);
    if ([self.headerDelegate respondsToSelector:@selector(KGG_SlideMenuDidSelectItemAtIndex:)]) {
        [self.headerDelegate KGG_SlideMenuDidSelectItemAtIndex:index];
    }
}

//#pragma mark - SDCycleScrollViewDelegate
//
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
//{
//    KGGLog(@"---点击了第%ld张图片", (long)index);
//    if ([self.headerDelegate respondsToSelector:@selector(kgg_scrollViewDidScrollIndex:)]) {
//        [self.headerDelegate KGG_SlideMenuDidSelectItemAtIndex:index];
//    }
//}
//
//
//// 滚动到第几张图回调
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
//{
////    KGGLog(@">>>>>> 滚动到第%ld张图", (long)index);
//}



#pragma mark - 懒加载
-(SDCycleScrollView *)headSDCycleView{
    if (!_headSDCycleView) {
        _headSDCycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"image_loading_25_16"]];
        _headSDCycleView.currentPageDotImage = [UIImage imageNamed:@"point_xuan"];
        _headSDCycleView.pageDotImage = [UIImage imageNamed:@"point"];
        _headSDCycleView.imageURLStringsGroup = _imageArray;
    }
    return _headSDCycleView;
}

- (KGGSlideMenu *)slideMenu
{
    if (!_slideMenu) {
        _slideMenu = [[KGGSlideMenu alloc]initWithFrame:CGRectZero titles:_titleArray];
        _slideMenu.indicatorOffsety = 2;
        _slideMenu.slideDelegate = self;
        _slideMenu.indicatorWidth = 40;
        _slideMenu.indicatorColor =KGGGoldenThemeColor;
        _slideMenu.titleStyle = SlideMenuTitleStyleGradient;
        _slideMenu.selectedColor = KGGGoldenThemeColor;
        _slideMenu.unselectedColor = KGGTimeTextColor;
    }
    return _slideMenu;
}

#pragma mark - 按钮的点击事件
- (void)buttonClick:(UIButton *)sender
{
    KGGLog(@"按钮的点击事件");
    if ([self.headerDelegate respondsToSelector:@selector(KGG_SDCycleTabViewDidSelectItemAtIndex:)]) {
        [self.headerDelegate KGG_SDCycleTabViewDidSelectItemAtIndex:sender.tag];
    }
}

- (UIButton *)creatButtonSelectImage:(NSString *)selectImage ImageString:(NSString *)imageString Tag:(NSInteger )tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
