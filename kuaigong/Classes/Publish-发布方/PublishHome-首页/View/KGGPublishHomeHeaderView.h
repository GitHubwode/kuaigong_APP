//
//  KGGPublishHomeHeaderView.h
//  kuaigong
//
//  Created by Ding on 2017/10/19.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGPublishHomeHeaderViewDelegate <NSObject>

/** 轮播图的点击 */
- (void)KGG_SDCycleTabViewDidSelectItemAtIndex:(NSInteger )index;;
/** top */
- (void)KGG_SlideMenuDidSelectItemAtIndex:(NSInteger )index;

@end

@interface KGGPublishHomeHeaderView : UIView

@property (nonatomic, weak) id<KGGPublishHomeHeaderViewDelegate >headerDelegate;

- (instancetype)initWithFrame:(CGRect)frame HeaderViewSlideTitle:(NSArray *)titleArray;

@end
