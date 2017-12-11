//
//  KGGMyWalletCardModel.m
//  kuaigong
//
//  Created by Ding on 2017/12/11.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMyWalletCardModel.h"

@implementation KGGMyWalletCardMessageModel

@end

@implementation KGGMyWalletCardModel

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject
{
    if ([_isHas isEqualToString:@"Y"]) {
        _isBink = YES;
    }else{
        _isBink = NO;
    }
}


@end
