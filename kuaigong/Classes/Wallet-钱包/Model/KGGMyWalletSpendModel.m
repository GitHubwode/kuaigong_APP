//
//  KGGMyWalletSpendModel.m
//  kuaigong
//
//  Created by Ding on 2017/12/15.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMyWalletSpendModel.h"

@implementation KGGMyWalletSpendModel

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject{

    _createDate = [NSString OrderDetailsTimeStamp:_createDate];
}

@end
