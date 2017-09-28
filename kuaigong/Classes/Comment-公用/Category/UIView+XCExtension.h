//
//  UIView+XCExtension.h
//  sunvhui
//
//  Created by apple on 2016/11/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XCExtension)

/** 控件的尺寸 */
@property (nonatomic, assign) CGSize xc_size;

/** 控件宽度 */
@property (nonatomic, assign) CGFloat xc_width;

/** 控件高度 */
@property (nonatomic, assign) CGFloat xc_height;

/** 控件的X值 */
@property (nonatomic, assign) CGFloat xc_x;

/** 控件的Y值 */
@property (nonatomic, assign) CGFloat xc_y;

/** 控件中心点的X值 */
@property (nonatomic, assign) CGFloat xc_centerX;

/** 控件中心点的Y值 */
@property (nonatomic, assign) CGFloat xc_centerY;

/** 控件距离父控件的右侧距离 */
@property (nonatomic, assign) CGFloat xc_right;

/** 控件距离父控件的左侧距离 */
@property (nonatomic, assign) CGFloat xc_left;

/** 控件距离父控件的底部距离 */
@property (nonatomic, assign) CGFloat xc_bottom;

/** 控件距离父控件的顶部距离 */
@property (nonatomic, assign) CGFloat xc_top;

@property (nonatomic, assign) CGFloat tx;

@property (nonatomic, assign) CGFloat ty;



/**
 从xib加载一个控件

 @return 这个类的一个控件对象
 */
+ (instancetype)viewFromXib;

- (void)removeAllSubViews;


@end
