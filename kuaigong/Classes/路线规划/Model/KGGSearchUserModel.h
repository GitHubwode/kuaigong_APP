//
//  KGGSearchUserModel.h
//  kuaigong
//
//  Created by Ding on 2017/11/10.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGSearchUserModel : NSObject

/** 头像 */
@property (nonatomic,copy) NSString *avatarUrl;
/** 昵称 */
@property (nonatomic,copy) NSString *nickname;
/** 电话号码 */
@property (nonatomic,copy) NSString *phone;

@end
