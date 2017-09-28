//
//  KGGMoreSetModel.h
//  kuaigong
//
//  Created by Ding on 2017/9/5.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGMoreSetModel : NSObject

/** 标题 */
@property (nonatomic,copy) NSString *title;
/** 文本 */
@property (nonatomic,copy) NSString *subTitle;
/** 是否显示 */
@property (nonatomic,assign) BOOL  enabled;

//增加的属性
/** 隐藏箭头 */
@property (nonatomic,assign) BOOL  arrowImageHiden;

@end
