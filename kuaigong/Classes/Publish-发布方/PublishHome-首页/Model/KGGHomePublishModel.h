//
//  KGGHomePublishModel.h
//  kuaigong
//
//  Created by Ding on 2017/8/28.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGHomePublishModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
/** 占位文字 */
@property (nonatomic, strong) NSString *placeholder;
/** 是否是必填项 */
@property (nonatomic, assign) BOOL required;

@end
