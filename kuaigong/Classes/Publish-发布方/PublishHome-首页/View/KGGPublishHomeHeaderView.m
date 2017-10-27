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

@end

@implementation KGGPublishHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame HeaderViewSDCycleImage:(NSArray *)imageArray SlideTitle:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleArray = titleArray;
        _imageArray = imageArray;
         [self setupHomeView];
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

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    KGGLog(@"---点击了第%ld张图片", (long)index);
    if ([self.headerDelegate respondsToSelector:@selector(kgg_scrollViewDidScrollIndex:)]) {
        [self.headerDelegate KGG_SlideMenuDidSelectItemAtIndex:index];
    }
}


// 滚动到第几张图回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
//    KGGLog(@">>>>>> 滚动到第%ld张图", (long)index);
}



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
//        NSArray *titles = @[@"木工",@"钢筋工",@"内架子工",@"外架子工",@"泥工",@"水电工",@"电焊工",@"小工"];
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

@end
