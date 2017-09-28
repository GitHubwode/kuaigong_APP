//
//  KGGPublishPersonModel.h
//  kuaigong
//
//  Created by Ding on 2017/8/31.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGPublishPersonModel : NSObject

/** 标题 */
@property (nonatomic,copy) NSString *title;
/** 输入的占位符 */
@property (nonatomic,copy) NSString *perPlace;
/** 是否隐藏 */
@property (nonatomic,assign) BOOL  ishides;
/** 是否必填 */
@property (nonatomic,assign) BOOL  isMust;
/** 输入的内容 */
@property (nonatomic,copy) NSString *subTitle;

@property (nonatomic,assign) BOOL  isHidesAvatar;

@end
