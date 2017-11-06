//
//  KGGWorkTypeModel.m
//  kuaigong
//
//  Created by Ding on 2017/10/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGWorkTypeModel.h"

@implementation KGGWorkTypeModel

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject{
//    _name isEqualToString:@""
    if ([_name isEqualToString:@"内架子工"] || [_name isEqualToString:@"外架子工"]) {
        _whenLong = @"8";
    }else{
        _whenLong = @"9";
    }
}

@end
