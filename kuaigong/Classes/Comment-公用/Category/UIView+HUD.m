//
//  UIView+HUD.m
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "UIView+HUD.h"
#import <objc/runtime.h>

static const void *KGGHttpRequestHUDKey = &KGGHttpRequestHUDKey;


@implementation UIView (HUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, KGGHttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, KGGHttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/**
 在当前view上显示一个HUD
 */
- (void)showHUD{
    
    if (!self) return;
    
    // 移除已有的HUD
    [self hideHUD];
    // 添加新的HUD
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
        // 隐藏时候从父控件中移除
        HUD.removeFromSuperViewOnHide = YES;
        
        
        [self setHUD:HUD];
        
    });
}


/**
 移除当前view上的HUD
 */
- (void)hideHUD{
    
    if (!self) return;
    
    // 没有HUD在显示
    if (![self HUD]) return;
    // 移除HUD
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[self HUD] hideAnimated:NO];
        
        objc_setAssociatedObject(self, KGGHttpRequestHUDKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    
}


/**
 在当前view上显示一个带有图片和文字的HUD
 图片名为空时，只显示文字
 
 @param hint 文字
 @param image 图片
 */
- (void)showHint:(NSString *)hint image:(NSString *)image{
    
    if (!self) return;
    
    // 移除已有的HUD
    [self hideHUD];
    // 添加新的HUD
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
        
        HUD.label.text = hint;
        if (image.length) {
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
            // 1秒之后再消失
            [HUD hideAnimated:YES afterDelay:1.5f];
        }else{
            HUD.mode = MBProgressHUDModeText;
            // 1秒之后再消失
            [HUD hideAnimated:YES afterDelay:1.0f];
        }
        
        [self setHUD:HUD];
    });
}


/**
 在当前view上显示一个带文字的HUD
 
 @param hint 文字
 */
- (void)showHint:(NSString *)hint{
    [self showHint:hint image:nil];
}


// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen
{
    if (self == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (self.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    return TRUE;
}



@end
