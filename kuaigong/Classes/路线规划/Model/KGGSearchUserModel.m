//
//  KGGSearchUserModel.m
//  kuaigong
//
//  Created by Ding on 2017/11/10.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGSearchUserModel.h"

@implementation KGGSearchUserModel
/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject{
    if (_avatarUrl.length >0) {
        _avatarUrl = [NSString stringWithFormat:@"https:%@",_avatarUrl];
    }
}
@end
