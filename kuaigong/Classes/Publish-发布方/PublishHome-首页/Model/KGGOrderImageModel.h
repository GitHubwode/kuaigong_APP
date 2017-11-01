//
//  KGGOrderImageModel.h
//  kuaigong
//
//  Created by Ding on 2017/10/30.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGOrderImageModel : NSObject
/** id */
@property (nonatomic,copy) NSString *accessid;
/** di'r */
@property (nonatomic,copy) NSString *dir;
/** expire */
@property (nonatomic,copy) NSString *expire;
/** host */
@property (nonatomic,copy) NSString *host;
/** policy */
@property (nonatomic,copy) NSString *policy;
/** 签名 */
@property (nonatomic,copy) NSString *signature;

//增加参数
/** endPoint*/
@property (nonatomic,copy) NSString *endPoint;

@end
