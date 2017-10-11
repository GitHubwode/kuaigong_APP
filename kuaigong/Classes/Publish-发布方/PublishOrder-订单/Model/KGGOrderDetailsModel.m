
//
//  KGGOrderDetailsModel.m
//  kuaigong
//
//  Created by Ding on 2017/10/11.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGOrderDetailsModel.h"

@implementation KGGOrderDetailsModel
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"orderId": @"id"};
}

@end
