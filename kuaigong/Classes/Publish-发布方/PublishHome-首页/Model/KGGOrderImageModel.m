//
//  KGGOrderImageModel.m
//  kuaigong
//
//  Created by Ding on 2017/10/30.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGOrderImageModel.h"

@implementation KGGOrderImageModel

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject{
    
    if (_host) {
        _host = [NSString stringWithFormat:@"https:%@",_host];
    }
}

@end
