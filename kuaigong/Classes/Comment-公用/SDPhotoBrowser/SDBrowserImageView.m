//
//  SDBrowserImageView.m
//  SDPhotoBrowser
//
//  Created by aier on 15-2-6.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDBrowserImageView.h"
#import "UIImageView+WebCache.h"
#import "SDPhotoBrowserConfig.h"

@interface SDBrowserImageView ()<UIScrollViewDelegate>

@end
@implementation SDBrowserImageView
{
    __weak SDWaitingView *_waitingView;

    UIScrollView *_zoomingScroolView;
//    UIImageView *_zoomingImageView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        
        [self setUpZoomingScrollView];
    }
    return self;
}

- (BOOL)isScaled
{
    if (_zoomingScroolView) {
        return 1.0 != _zoomingScroolView.zoomScale;
    }
    return  NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutZoomingScrollView];
    
    _waitingView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    if (_waitingView) {
        [self bringSubviewToFront:_waitingView];
    }
    
}

- (void)setUpZoomingScrollView{
    if (!_zoomingScroolView) {
        _zoomingScroolView = [[UIScrollView alloc] init];
        _zoomingScroolView.backgroundColor = SDPhotoBrowserBackgrounColor;
        _zoomingScroolView.showsVerticalScrollIndicator = NO;
        _zoomingScroolView.showsHorizontalScrollIndicator = NO;
        _zoomingScroolView.minimumZoomScale = 1.0f;
        _zoomingScroolView.maximumZoomScale = 2.5f;
        _zoomingScroolView.delegate = self;
        
        _zoomingImageView = [[UIImageView alloc] init];
        [_zoomingScroolView addSubview:_zoomingImageView];
        [self addSubview:_zoomingScroolView];
    }
}

- (void)layoutZoomingScrollView{
    
    UIImage *image = self.image;
    
    if (!image) return;
    
    _zoomingScroolView.frame = self.bounds;
    
    CGFloat imageScale = image.size.width / image.size.height;
    
    if (imageScale * _zoomingScroolView.xc_height > _zoomingScroolView.xc_width) {
        
        _zoomingImageView.xc_width = _zoomingScroolView.xc_width;
        _zoomingImageView.xc_height = _zoomingScroolView.xc_width / imageScale;
        
        CGFloat scale = _zoomingScroolView.xc_height / _zoomingImageView.xc_height;
        
        scale = scale > _zoomingScroolView.maximumZoomScale ? scale : _zoomingScroolView.maximumZoomScale;
        
        _zoomingScroolView.maximumZoomScale = scale;
        
        
    }else{
        
        _zoomingImageView.xc_height = _zoomingScroolView.xc_height;
        _zoomingImageView.xc_width = _zoomingScroolView.xc_height * imageScale;
        
        CGFloat scale = _zoomingScroolView.xc_width / _zoomingImageView.xc_width;
        
        scale = scale > _zoomingScroolView.maximumZoomScale ? scale : _zoomingScroolView.maximumZoomScale;
        
        
        _zoomingScroolView.maximumZoomScale = scale;
        
    }
    
    _zoomingImageView.center = CGPointMake(_zoomingScroolView.xc_width * 0.5, _zoomingScroolView.xc_height * 0.5);
    
    _zoomingImageView.image = image;
}


- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _waitingView.progress = progress;

}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    
    
    SDWaitingView *waiting = [[SDWaitingView alloc] init];
    waiting.bounds = CGRectMake(0, 0, 100, 100);
    waiting.mode = SDWaitingViewProgressMode;
    _waitingView = waiting;
    [self addSubview:waiting];
    
    
    __weak SDBrowserImageView *imageViewWeak = self;

    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        imageViewWeak.progress = (CGFloat)receivedSize / expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [imageViewWeak removeWaitingView];
        
        
        if (error) {
            UILabel *label = [[UILabel alloc] init];
            label.bounds = CGRectMake(0, 0, 160, 30);
            label.center = CGPointMake(imageViewWeak.bounds.size.width * 0.5, imageViewWeak.bounds.size.height * 0.5);
            label.text = @"图片加载失败";
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            label.layer.cornerRadius = 5;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [imageViewWeak addSubview:label];
        }
   
    }];
}





- (void)doubleTapToZommWithTouchPoint:(CGPoint)touchPoint{
    if (_zoomingScroolView.zoomScale > 1.0) {
        [_zoomingScroolView setZoomScale:1.0 animated:YES];
    } else {
        CGFloat newZoomScale = _zoomingScroolView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_zoomingScroolView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}




- (void)clear{
    [_zoomingScroolView removeFromSuperview];
    _zoomingScroolView = nil;
    _zoomingImageView = nil;

}

- (void)removeWaitingView{
    [_waitingView removeFromSuperview];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _zoomingImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.xc_width > scrollView.contentSize.width) ? (scrollView.xc_width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.xc_height > scrollView.contentSize.height) ? (scrollView.xc_height - scrollView.contentSize.height) * 0.5 : 0.0;
    _zoomingImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

@end
