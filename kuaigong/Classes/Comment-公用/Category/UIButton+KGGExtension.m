//
//  UIButton+KGGExtension.m
//  kuaigong
//
//  Created by Ding on 2017/8/22.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "UIButton+KGGExtension.h"

@implementation UIButton (KGGExtension)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    if (bounds.size.width<44) {
        CGFloat widthDelta = 44.0 - bounds.size.width;
        CGFloat heightDelta = 44.0 - bounds.size.height;
        
        bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5*heightDelta);
        return CGRectContainsPoint(bounds, point);
    }else{
        return CGRectContainsPoint(bounds, point);
    }
}

@end
