//
//  SDBrowserImageView.h
//  SDPhotoBrowser
//
//  Created by aier on 15-2-6.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWaitingView.h"


@interface SDBrowserImageView : UIImageView <UIGestureRecognizerDelegate>

@property (nonatomic, strong, readonly) UIImageView *zoomingImageView;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, readonly) BOOL isScaled;
@property (nonatomic, assign) BOOL hasLoadedImage;


- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)doubleTapToZommWithTouchPoint:(CGPoint)touchPoint;

- (void)clear;

@end
