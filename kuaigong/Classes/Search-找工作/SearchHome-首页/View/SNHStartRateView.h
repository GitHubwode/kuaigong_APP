//
//  SNHStartRateView.h
//  sunvhui
//
//  Created by apple on 2017/5/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNHStartRateView;

typedef void(^finishBlock)(CGFloat currentScore);

typedef NS_ENUM(NSInteger ,RateStyle)
{
    WholeStart = 0, //整星评论
    HalfStart = 1,  //半星评论
    IncompleteStart = 2 //允许不完整星评论
};

@protocol snhStartRateViewDelegate <NSObject>

-(void)starRateView:(SNHStartRateView *)starRateView currentScore:(CGFloat)currentScore;

@end



@interface SNHStartRateView : UIView

@property (nonatomic, assign) BOOL isAnimation; //是否动画
@property (nonatomic, assign) RateStyle rateStyle;
@property (nonatomic, weak) id<snhStartRateViewDelegate>delegate;
@property (nonatomic, assign) CGFloat currentScore; //当前评分 0-5 默认为0
@property (nonatomic, assign) BOOL isDisplay;


- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame NumberOfStart:(NSInteger)numberOfStart RateStyle:(RateStyle)rateStyle IsAnimation:(BOOL)isAnimation delegate:(id)delegate;
- (instancetype)initWithFrame:(CGRect)frame FinishBlock:(finishBlock)finishBlock;
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish;

@end
