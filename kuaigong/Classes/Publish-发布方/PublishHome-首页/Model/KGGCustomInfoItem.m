//
//  KGGCustomInfoItem.m
//  kuaigong
//
//  Created by Ding on 2017/8/23.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGCustomInfoItem.h"

@implementation KGGCustomInfoItem

- (CGFloat)cellHeight{
    // 如果cell的高度已经计算过, 就直接返回
    if (_cellHeight) return _cellHeight;
    
    if ([self.title isEqualToString:@"头像"]) {
        _cellHeight = KGGItemHeight * 2;
    }else if ([self.title isEqualToString:@"生活照"]){
        _cellHeight = 142.f;
    }else if (![self.title isEqualToString:@"个人简介"] && ![self.title isEqualToString:@"格言"]){
        _cellHeight = KGGItemHeight;
    }else{
        if (!self.subtitle || !self.subtitle.length) {
            _cellHeight = KGGItemHeight;
        }else{
            CGFloat textMaxW = kMainScreenWidth - KGGLongTextEdgeInsets.left - KGGLongTextEdgeInsets.right;
            CGFloat h = ceilf([self.subtitle sizeWithFont:KGGCustomInfoCellSubtitle maxW:textMaxW].height) + KGGLongTextEdgeInsets.top + KGGLongTextEdgeInsets.bottom;
            _cellHeight = MAX(KGGItemHeight, h);
        }
    }
    
    return _cellHeight;
    
}



@end
