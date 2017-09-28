//
//  SUNSlideSwitchView.h
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-9-4.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SUNSlideSwitchViewDelegate;
@interface SUNSlideSwitchView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_rootScrollView;                  //主视图
    UIScrollView *_topScrollView;                   //顶部页签视图
    
    
    NSInteger _userSelectedChannelID;               //点击按钮选择名字ID
    
    UIImageView *_shadowImageView;
    UIImage *_shadowImage;
    
    UIColor *_tabItemNormalColor;                   //正常时tab文字颜色
    UIColor *_tabItemSelectedColor;                 //选中时tab文字颜色
    UIImage *_tabItemNormalBackgroundImage;         //正常时tab的背景
    UIImage *_tabItemSelectedBackgroundImage;       //选中时tab的背景
    NSMutableArray<UIViewController *> *_viewArray;                     //主视图的子视图数组
    
    
    __weak id<SUNSlideSwitchViewDelegate> _slideSwitchViewDelegate;
}

@property (nonatomic, strong) IBOutlet UIScrollView *rootScrollView;
@property (nonatomic, strong) IBOutlet UIScrollView *topScrollView;
@property (nonatomic, assign) NSInteger userSelectedChannelID;

@property (nonatomic, weak) IBOutlet id<SUNSlideSwitchViewDelegate> slideSwitchViewDelegate;
@property (nonatomic, strong) UIColor *tabItemNormalColor;
@property (nonatomic, strong) UIColor *tabItemSelectedColor;
@property (nonatomic, strong) UIImage *tabItemNormalBackgroundImage;
@property (nonatomic, strong) UIImage *tabItemSelectedBackgroundImage;
@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, strong) NSMutableArray<UIViewController *> *viewArray;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, assign) CGFloat widthOfButtonMargin;
@property (nonatomic, assign) CGFloat kFontSizeOfTabButton;
@property (nonatomic, assign) CGFloat kHeightOfTopScrollView;
/*!
 * @method 通过selectedChannelID初始化（自己加上去的）0，1，2...
 */
- (instancetype)initWithFrame:(CGRect)frame selectedChannelID:(NSInteger)selectedChannelID;
- (instancetype)initWithFrame:(CGRect)frame heightOfTopScrollView:(CGFloat)heightOfTopScrollView;
/*!
 * @method 创建子视图UI
 */
- (void)buildUI;

@end

@protocol SUNSlideSwitchViewDelegate <NSObject>

@required

/*!
 * @method 顶部tab个数
 * @result tab个数
 */
- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view;


/**
 控制器

 @param view <#view description#>
 @param number <#number description#>
 @return <#return value description#>
 */
- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number;

/**
 顶部Tab标题

 @param view <#view description#>
 @param number <#number description#>
 @return <#return value description#>
 */
- (NSString *)slideSwitchView:(SUNSlideSwitchView *)view titleOfTab:(NSUInteger)number;

@optional


/*!
 * @method 点击tab
 */
- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number;
- (void)slideSwitchView:(SUNSlideSwitchView *)view didscrollToTab:(NSUInteger)number;
@end
