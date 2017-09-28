//
//  KGGMoreSetModel.m
//  kuaigong
//
//  Created by Ding on 2017/9/5.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMoreSetModel.h"

@implementation KGGMoreSetModel

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject{
    if (!_enabled ) {
        _arrowImageHiden = YES;
    }else{
        _arrowImageHiden = NO;
    }
}

@end
