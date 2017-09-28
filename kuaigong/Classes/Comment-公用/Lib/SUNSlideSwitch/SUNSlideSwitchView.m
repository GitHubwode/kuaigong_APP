//
//  SUNSlideSwitchView.m
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-9-4.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import "SUNSlideSwitchView.h"




@implementation SUNSlideSwitchView

#pragma mark - 初始化参数



- (instancetype)initWithFrame:(CGRect)frame selectedChannelID:(NSInteger)selectedChannelID{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithSelectedChannelID:selectedChannelID];
    }
    return self;
}


- (void)setupWithSelectedChannelID:(NSInteger)selectedChannelID{
    
    if (!_kHeightOfTopScrollView) _kHeightOfTopScrollView = 36.f;
    
    //创建顶部可滑动的tab
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, _kHeightOfTopScrollView)];
    _topScrollView.delegate = self;
    _topScrollView.backgroundColor = [UIColor whiteColor];
    _topScrollView.pagingEnabled = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.scrollEnabled = NO;
    _topScrollView.scrollsToTop = NO;
    _topScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _bottomLineView = [[UIView alloc]init];
    _bottomLineView.backgroundColor = KGGItemSeletedColor;
    _bottomLineView.xc_height = KGGOnePixelHeight;
    _bottomLineView.xc_width = _topScrollView.xc_width;
    _bottomLineView.xc_y = _kHeightOfTopScrollView - _bottomLineView.xc_height;
    [_topScrollView addSubview:_bottomLineView];

    
    [self addSubview:_topScrollView];
    _userSelectedChannelID = selectedChannelID + 100;
    
    //创建主滚动视图
    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _kHeightOfTopScrollView, self.bounds.size.width, self.bounds.size.height - _kHeightOfTopScrollView)];
    _rootScrollView.scrollsToTop = NO;
    _rootScrollView.delegate = self;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.userInteractionEnabled = YES;
    _rootScrollView.bounces = NO;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_rootScrollView];
    
    _viewArray = [[NSMutableArray alloc] init];
    
    _widthOfButtonMargin = 15.f;
    _kFontSizeOfTabButton = 15.f;
}




- (void)initValues
{
    [self setupWithSelectedChannelID:0];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupWithSelectedChannelID:0];
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithSelectedChannelID:0];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame heightOfTopScrollView:(CGFloat)heightOfTopScrollView{
    _kHeightOfTopScrollView = heightOfTopScrollView;
    return [self initWithFrame:frame];
}

#pragma mark - 创建控件



/*!
 * @method 创建子视图UI
 */
- (void)buildUI
{
    NSUInteger number = [self.slideSwitchViewDelegate numberOfTab:self];
    _rootScrollView.contentSize = CGSizeMake(self.bounds.size.width * number, 0);
    
    for (int i=0; i<number; i++) {
        UIViewController *vc = [self.slideSwitchViewDelegate slideSwitchView:self viewOfTab:i];
        [_viewArray addObject:vc];
    }
    

    [self addChildVcView];
    
    [self createNameButtons];
    
    //选中第一个view
    if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
        
        [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100];
    }
}

/*!
 * @method 初始化顶部tab的各个按钮
 */
- (void)createNameButtons
{
    
    _shadowImageView = [[UIImageView alloc] init];
    [_shadowImageView setImage:_shadowImage];
    [_topScrollView addSubview:_shadowImageView];
    
    
    for (int i = 0; i < [_viewArray count]; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width / _viewArray.count;
        //设置按钮尺寸
        [button setFrame:CGRectMake(buttonWidth * i,0,buttonWidth, _kHeightOfTopScrollView)];
        
        [button setTag:i+100];
        
        if (i == _userSelectedChannelID - 100) {
            _shadowImageView.frame = CGRectMake(_widthOfButtonMargin, 0, buttonWidth - _widthOfButtonMargin * 2, _kHeightOfTopScrollView);
            button.selected = YES;
        }
        [button setTitle:[self.slideSwitchViewDelegate slideSwitchView:self titleOfTab:i] forState:UIControlStateNormal];
        button.titleLabel.font = KGGLightFont(_kFontSizeOfTabButton);
        [button setTitleColor:self.tabItemNormalColor forState:UIControlStateNormal];
        [button setTitleColor:self.tabItemSelectedColor forState:UIControlStateSelected];
        [button setBackgroundImage:self.tabItemNormalBackgroundImage forState:UIControlStateNormal];
        [button setBackgroundImage:self.tabItemSelectedBackgroundImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:button];
    }
    
}

- (void)addChildVcView{
    
    NSUInteger index = _userSelectedChannelID - 100;
    // 取出子控制器
    UIViewController *childVc = self.viewArray[index];
    if ([childVc isViewLoaded]) return;
    childVc.view.frame = CGRectMake(_rootScrollView.bounds.size.width*index, 0,_rootScrollView.bounds.size.width, _rootScrollView.bounds.size.height);
    [_rootScrollView addSubview:childVc.view];
}




#pragma mark - 顶部滚动视图逻辑方法

/*!
 * @method 选中tab时间
 * @sender 按钮
 */
- (void)selectNameButton:(UIButton *)sender
{
    
    //如果更换按钮
    if (sender.tag != _userSelectedChannelID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        lastButton.selected = NO;
        //赋值按钮ID
        _userSelectedChannelID = sender.tag;
    }
    
    //按钮选中状态
    if (sender.selected)  return;
    
    sender.selected = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [_shadowImageView setFrame:CGRectMake(sender.frame.origin.x + _widthOfButtonMargin, 0, sender.frame.size.width - _widthOfButtonMargin * 2, _kHeightOfTopScrollView)];
        
    } completion:^(BOOL finished) {
        if (finished) {
            //设置新页出现
            BOOL anim = self.viewArray.count <= 2;
            
            [_rootScrollView setContentOffset:CGPointMake((sender.tag - 100)*self.bounds.size.width, 0) animated:anim];
            
            [self addChildVcView];
            
            if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
                [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100];
            }
        }
    }];
    
    if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didscrollToTab:)]) {
        [self.slideSwitchViewDelegate slideSwitchView:self didscrollToTab:_userSelectedChannelID - 100];
    }
    
}
#pragma mark 主视图逻辑方法
//滚动视图释放滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        //调整顶部滑条按钮状态
        int tag = (int)scrollView.contentOffset.x/self.bounds.size.width +100;
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:tag];
        [self selectNameButton:button];
    }
}



- (void)setUserSelectedChannelID:(NSInteger)userSelectedChannelID{

    UIButton *button = (UIButton *)[_topScrollView viewWithTag:userSelectedChannelID];
    [self selectNameButton:button];
}



@end
