//
//  KGGPictureMetadata.m
//  kuaigong
//
//  Created by Ding on 2017/10/29.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPictureMetadata.h"

@implementation KGGPictureMetadata
MJCodingImplementation
/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSArray *)mj_ignoredPropertyNames{
    return @[@"data"];
}

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject{
    _data = UIImageJPEGRepresentation(_image, 0.5);
}



@end
