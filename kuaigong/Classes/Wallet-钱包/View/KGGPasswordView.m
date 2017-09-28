//
//  KGGPasswordView.m
//  kuaigong
//
//  Created by Ding on 2017/9/8.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPasswordView.h"

@interface KGGPasswordView ()
/** 保存用户输入的数字合集 */
@property (nonatomic, strong) NSMutableArray *inputNumArray;

@end

@implementation KGGPasswordView

#pragma mark  - 懒加载
- (NSMutableArray *)inputNumArray {
    if (_inputNumArray == nil) {
        _inputNumArray = [NSMutableArray array];
    }
    return _inputNumArray;
}

#pragma mark  - 私有方法

// 响应用户按下删除键事件
- (void)deleteNum
{
    [self.inputNumArray removeLastObject];
    [self setNeedsDisplay];
}

- (void)deleteAllNum
{
    [self.inputNumArray removeAllObjects];
    [self setNeedsDisplay];
}
// 响应用户按下数字键事件
- (void)pressNum:(NSString *)num
{
    if (num.length > 6) return;
    [self.inputNumArray addObject:num];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor redColor];
    
    //画圆
    UIImage *imgTextfield = [UIImage imageNamed:@"grid(1)"];
    
    CGFloat textfieldY = 0;
    CGFloat textfieldW = self.xc_width;
    CGFloat textfieldX = 0;
    CGFloat textfieldH = self.xc_height;
    [imgTextfield drawInRect:CGRectMake(textfieldX, textfieldY, textfieldW, textfieldH)];

    //画点
    UIImage *pointImage = [UIImage imageNamed:@"password_point"];
    CGFloat pointW = 10;
    CGFloat pointH = 10;
    CGFloat pointY = textfieldY + (textfieldH - pointH) *0.5;
    
    __block CGFloat pointX;
    
    //一个格子的宽度
    CGFloat cellW = textfieldW / 6;
    CGFloat padding = (cellW - pointW) *0.5;
    [self.inputNumArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        pointX = textfieldX + (2 * idx+1)*padding + idx *pointW;
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }];
}

@end




















