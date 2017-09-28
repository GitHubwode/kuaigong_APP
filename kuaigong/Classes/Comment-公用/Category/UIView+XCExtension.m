//
//  UIView+XCExtension.m
//  sunvhui
//
//  Created by apple on 2016/11/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIView+XCExtension.h"

@implementation UIView (XCExtension)

- (CGSize)xc_size
{
    return self.frame.size;
}

- (void)setXc_size:(CGSize)xc_size
{
    CGRect frame = self.frame;
    frame.size = xc_size;
    self.frame = frame;
}

- (CGFloat)xc_width
{
    return self.frame.size.width;
}

- (CGFloat)xc_height
{
    return self.frame.size.height;
}

- (void)setXc_width:(CGFloat)xc_width
{
    CGRect frame = self.frame;
    frame.size.width = xc_width;
    self.frame = frame;
}

- (void)setXc_height:(CGFloat)xc_height
{
    CGRect frame = self.frame;
    frame.size.height = xc_height;
    self.frame = frame;
}

- (CGFloat)xc_x
{
    return self.frame.origin.x;
}

- (void)setXc_x:(CGFloat)xc_x
{
    CGRect frame = self.frame;
    frame.origin.x = xc_x;
    self.frame = frame;
}

- (CGFloat)xc_y
{
    return self.frame.origin.y;
}

- (void)setXc_y:(CGFloat)xc_y
{
    CGRect frame = self.frame;
    frame.origin.y = xc_y;
    self.frame = frame;
}

- (CGFloat)xc_centerX
{
    return self.center.x;
}

- (void)setXc_centerX:(CGFloat)xc_centerX
{
    CGPoint center = self.center;
    center.x = xc_centerX;
    self.center = center;
}

- (CGFloat)xc_centerY
{
    return self.center.y;
}

- (void)setXc_centerY:(CGFloat)xc_centerY
{
    CGPoint center = self.center;
    center.y = xc_centerY;
    self.center = center;
}

- (CGFloat)xc_right
{
    //    return self.xc_x + self.xc_width;
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)xc_bottom
{
    //    return self.xc_y + self.xc_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setXc_right:(CGFloat)xc_right
{
    self.xc_x = xc_right - self.xc_width;
}

- (void)setXc_left:(CGFloat)xc_left
{
    self.frame = CGRectMake(xc_left, self.xc_top, self.xc_width, self.xc_height);
}

- (CGFloat)xc_left
{
    return self.frame.origin.x;
}

- (void)setXc_top:(CGFloat)xc_top
{
    self.frame = CGRectMake(self.xc_left, xc_top, self.xc_width, self.xc_height);
}

- (CGFloat)xc_top
{
    return self.frame.origin.y;
}

- (void)setXc_bottom:(CGFloat)xc_bottom
{
    self.xc_y = xc_bottom - self.xc_height;
}

- (CGFloat)tx {
    return self.transform.tx;
}


- (void)setTx:(CGFloat)tx {
    CGAffineTransform transform = self.transform;
    transform.tx = tx;
    self.transform = transform;
}

- (CGFloat)ty {
    return self.transform.ty;
}

- (void)setTy:(CGFloat)ty {
    CGAffineTransform transform = self.transform;
    transform.ty = ty;
    self.transform = transform;
}


+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)removeAllSubViews
{
    for (UIView *subview in self.subviews){
        [subview removeFromSuperview];
    }
}

@end
