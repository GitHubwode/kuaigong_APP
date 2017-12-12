//
//  KGGMyWalletCardModel.m
//  kuaigong
//
//  Created by Ding on 2017/12/11.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMyWalletCardModel.h"

@implementation KGGMyWalletCardMessageModel


/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject
{
    if (_branchBankName.length > 0) {
        NSRange range = [_branchBankName rangeOfString:@"行"];//匹配得到的下标
        _bankName = [NSString stringWithFormat:@"%@行",[_branchBankName substringToIndex:range.location]];//截取掉下标2之前的字符串        
    }
    if (_bankCardNo.length > 0) {
        NSString *topString = [_bankCardNo substringToIndex:4];
        NSString *bottomString = [_bankCardNo substringFromIndex:16];
        KGGLog(@"%@--%@",topString,bottomString);
        _hideBankNum = [NSString stringWithFormat:@"%@************%@",topString,bottomString];
    }
    
}


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
