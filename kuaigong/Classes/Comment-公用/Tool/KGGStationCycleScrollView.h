//
//  KGGStationCycleScrollView.h
//  kuaigong
//
//  Created by Ding on 2017/11/27.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,CycleScrollViewType){
    StationCycleScrollViewType,
    HomeUserCycleScrollViewType,
};

@class KGGStationCycleScrollView;
@protocol KGGStationCycleScrollViewDelegate <NSObject>

@optional
- (void)snh_cycleScrollView:(KGGStationCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSUInteger )index;
@end

@interface KGGStationCycleScrollView : UIView

/** 初始化驿站顶部的轮播图 */
+ (instancetype)snh_cycleScrollViewWithFrame:(CGRect)frame delegate:(id<KGGStationCycleScrollViewDelegate>)delegate type:(CycleScrollViewType)type;

@property (nonatomic, weak) id<KGGStationCycleScrollViewDelegate>delegate;

/** 数据源 */
@property (nonatomic, strong) NSArray *messageDatasource;

@end
