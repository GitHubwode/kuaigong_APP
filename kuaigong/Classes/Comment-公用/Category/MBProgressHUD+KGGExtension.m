//
//  MBProgressHUD+KGGExtension.m
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "MBProgressHUD+KGGExtension.h"

@implementation MBProgressHUD (KGGExtension)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated{
    MBProgressHUD *hud = [[self alloc] initWithView:view];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    hud.contentColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        hud.offset = CGPointMake(0, scrollView.mj_offsetY);
    }
    [view addSubview:hud];
    [hud showAnimated:animated];
    return hud;
}
#pragma clang diagnostic pop

#pragma mark 显示错误信息
/**
 快速显示一个错误信息
 
 @param error 错误信息
 @param view 要显示在的View，nil代表显示在最上层的Window上，不一定是KeyWindow
 */
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

/**
 快速显示一个错误信息
 
 @param success 错误信息
 @param view 要显示在的View，nil代表显示在最上层的Window上，不一定是KeyWindow
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}


#pragma mark 显示信息
/**
 快速显示一个信息
 
 @param text 错误信息
 @param icon 图片
 @param view 要显示在的View，nil代表显示在最上层的Window上，不一定是KeyWindow
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].windows.firstObject;
    
    [view showHint:text image:icon];
    
}

/**
 快速显示一个信息
 
 @param message 信息
 @param view 要显示在的View，nil代表显示在最上层的Window上，不一定是KeyWindow
 */
+ (void)showMessag:(NSString *)message toView:(UIView *)view{
    
    if (view == nil) view = [UIApplication sharedApplication].windows.firstObject;
    
    [view showHint:message];
    
    //    // 快速显示一个提示信息
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //    hud.mode = MBProgressHUDModeText;
    //    hud.label.text = message;
    //    hud.animationType = MBProgressHUDAnimationZoomIn | MBProgressHUDAnimationZoomOut;
    //    // 隐藏时候从父控件中移除
    //    hud.removeFromSuperViewOnHide = YES;
    //    // 1秒后隐藏
    //    [hud hideAnimated:YES afterDelay:1.0f];
}

/**
 快速显示一个信息在最上层的Window上
 
 @param message 信息
 */
+ (void)showMessag:(NSString *)message{
    [self showMessag:message toView:nil];
}


/**
 快速显示一个错误信息
 
 @param success 错误信息
 @param view 要显示在的View，nil代表显示在最上层的Window上，不一定是KeyWindow
 */
+ (void)showSuYaSuccess:(NSString *)success toView:(UIView *)view{
    [self show:success icon:@"icon_suya_smile" view:view];
}

/**
 快速显示一个错误信息
 
 @param error 错误信息
 @param view 要显示在的View，nil代表显示在最上层的Window上，不一定是KeyWindow
 */
+ (void)showSuYaError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"icon_suya_sad" view:view];
    
}


@end
