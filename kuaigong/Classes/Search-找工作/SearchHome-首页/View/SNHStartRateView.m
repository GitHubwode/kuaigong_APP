//
//  SNHStartRateView.m
//  sunvhui
//
//  Created by apple on 2017/5/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SNHStartRateView.h"


typedef void(^completeBlock)(CGFloat currentScore);


@interface SNHStartRateView ()
@property (nonatomic, strong) UIView *foregroundStartView;
@property (nonatomic, strong) UIView *backgroundStartView;
@property (nonatomic, assign) NSInteger numberOfStart;
@property (nonatomic,strong)completeBlock complete;

@end

@implementation SNHStartRateView

#pragma mark - 代理方式
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStart = 5;
        _rateStyle = WholeStart;
        [self creatStartView];
    }
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame NumberOfStart:(NSInteger)numberOfStart RateStyle:(RateStyle)rateStyle IsAnimation:(BOOL)isAnimation delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStart = numberOfStart;
        _rateStyle = rateStyle;
        _isAnimation = isAnimation;
        _delegate = delegate;
         [self creatStartView];
    }
    return self;
    
}

#pragma mark - block方式
- (instancetype)initWithFrame:(CGRect)frame FinishBlock:(finishBlock)finishBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStart = 5;
        _rateStyle = WholeStart;
        _complete = ^(CGFloat currentScore){
            finishBlock(currentScore);
        };
        [self creatStartView];
    }
    return self;
    
}
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStart = numberOfStars;
        _rateStyle = rateStyle;
        _isAnimation = isAnimation;
        _complete = ^(CGFloat currentScore){
            finish(currentScore);
        };
        [self creatStartView];
    }
    return self;
}

- (void)creatStartView
{
    self.foregroundStartView = [self createStartViewImage:@"icon_xing"];
    self.backgroundStartView = [self createStartViewImage:@"icon_kong"];
    self.foregroundStartView.frame = CGRectMake(0, 0, self.bounds.size.width * _currentScore/self.numberOfStart, self.bounds.size.height);
    [self addSubview:self.backgroundStartView];
    [self addSubview:self.foregroundStartView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(snh_userTapRateView:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
}

- (UIView *)createStartViewImage:(NSString *)imageName
{
    UIView *view = [[UIView alloc]initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < self.numberOfStart; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i*self.bounds.size.width/self.numberOfStart, 0 , self.bounds.size.width / self.numberOfStart, self.bounds.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)snh_userTapRateView:(UITapGestureRecognizer *)gesture
{
//    if (_isDisplay)  return;
    
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStart);
    switch (_rateStyle) {
        case WholeStart:
        {
            self.currentScore = ceilf(realStarScore);
            break;
        }
        case HalfStart:
            self.currentScore = roundf(realStarScore)>realStarScore ? ceilf(realStarScore):(ceilf(realStarScore)-0.5);
            break;
        case IncompleteStart:
            self.currentScore = realStarScore;
            break;
        default:
            break;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    weakSelf(self);
    CGFloat animationTimeInterval = self.isAnimation ? 0.2 : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        weakself.foregroundStartView.frame = CGRectMake(0, 0, weakself.bounds.size.width * weakself.currentScore/weakself.numberOfStart, weakself.bounds.size.height);
    }];
}

- (void)setCurrentScore:(CGFloat)currentScore
{
    if (_currentScore == currentScore) {
        return;
    }
    if (currentScore < 0) {
        _currentScore = 0;
    }else if (currentScore > _numberOfStart){
        _currentScore = _numberOfStart;
    }else{
        _currentScore = currentScore;
    }
    if ([self.delegate respondsToSelector:@selector(starRateView:currentScore:)]) {
        [self.delegate starRateView:self currentScore:_currentScore];
    }
    if (self.complete) {
        _complete(_currentScore);
    }
    [self setNeedsLayout];
}


@end
