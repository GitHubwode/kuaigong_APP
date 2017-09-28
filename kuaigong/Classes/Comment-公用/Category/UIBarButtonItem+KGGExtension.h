//
//  UIBarButtonItem+KGGExtension.h
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (KGGExtension)

/**
 快速创建一个UIBarButtonItem模型对象
 
 @param image 普通状态的图片
 @param highImage 高亮状态的图片
 @param target 事件对象
 @param action 事件对象的方法
 @return UIBarButtonItem模型对象
 */
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;


+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)itemWithButtonTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
