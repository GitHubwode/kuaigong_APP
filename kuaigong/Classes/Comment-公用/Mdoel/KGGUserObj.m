//
//  KGGUserObj.m
//  kuaigong
//
//  Created by Ding on 2017/10/9.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGUserObj.h"

@implementation KGGUserObj
MJCodingImplementation

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"userId": @"id"};
}

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject{

    _sexName = [_sex isEqualToString:@"MAN"] ? @"男" :@"女";
    _isLocked = [_isLock isEqualToString:@"N"] ? NO : YES;
    _isDeleted = [_isDelete isEqualToString:@"N"] ? NO : YES;
    
}

@end


@implementation KGGUserInfo


@end
