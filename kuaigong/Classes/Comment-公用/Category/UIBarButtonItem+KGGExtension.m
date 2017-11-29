//
//  UIBarButtonItem+KGGExtension.m
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "UIBarButtonItem+KGGExtension.h"

@implementation UIBarButtonItem (KGGExtension)

/**
 快速创建一个UIBarButtonItem模型对象
 @param image 普通状态的图片
 @param highImage 高亮状态的图片
 @param target 事件对象
 @param action 事件对象的方法
 @return UIBarButtonItem模型对象
 */
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return [[self alloc] initWithCustomView:button];
}


+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = KGGFont(15);
    [button setTitleColor:UIColorHex(0xffffff) forState:UIControlStateDisabled];
    [button setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)itemWithButtonTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = KGGLightFont(17);
    [button setTitleColor:UIColorHex(0xffffff) forState:UIControlStateDisabled];
    [button setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    return [[self alloc] initWithCustomView:button];
    
}



@end
