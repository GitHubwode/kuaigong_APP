//
//  KGGLookWorkHeaderView.m
//  kuaigong
//
//  Created by Ding on 2017/11/16.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLookWorkHeaderView.h"

@implementation KGGLookWorkHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banner9.jpg"]];
        imageView.frame = self.frame;
        [self addSubview:imageView];
    }
    return self;
}

@end
