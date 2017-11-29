//
//  KGGPublishHomeCycleView.h
//  kuaigong
//
//  Created by Ding on 2017/11/29.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGPublishHomeCycleViewDelegate <NSObject>

/** 分类入口 */
- (void)KGG_PublishHomeCycleViewDidSelectItemAtIndex:(NSInteger )index;;

@end

@interface KGGPublishHomeCycleView : UIView

@property (nonatomic, weak)id<KGGPublishHomeCycleViewDelegate>cycleDelegate;

@end
