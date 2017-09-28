//
//  KGGCustomInfoItem.h
//  kuaigong
//
//  Created by Ding on 2017/8/23.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KGGCustomInfoCellSubtitle KGGLightFont(14)
static UIEdgeInsets KGGLongTextEdgeInsets = {14.f, 100.f, 14.f, 31.f};

@interface KGGCustomInfoItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
/** 能输入的文字的最多个数 */
@property (nonatomic, assign) NSUInteger maxTextLength;
/** 键盘类型 */
@property (nonatomic, assign) UIKeyboardType keyboardType;
/** 占位文字 */
@property (nonatomic, strong) NSString *placeholder;
/** 是否是必填项 */
@property (nonatomic, assign) BOOL required;
/** 对应的属性值 */
@property (nonatomic, copy) NSString *propertyKey;
/** 是否cell能够响应点击事件 */
@property (nonatomic, assign) BOOL enabled;
/** 是否在当前页面能够编辑 */
@property (nonatomic, assign) BOOL editabled;
/** 是否隐藏右边的指示器 */
@property (nonatomic, assign) BOOL hidenIndicator;

@property (nonatomic, assign) CGFloat cellHeight;

@end
