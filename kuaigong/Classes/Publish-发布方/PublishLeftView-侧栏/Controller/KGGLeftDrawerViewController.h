//
//  KGGLeftDrawerViewController.h
//  kuaigong
//
//  Created by Ding on 2017/8/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGGLeftDrawerViewController : UIViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController contentViewController:(UIViewController *)leftVc;
@property (nonatomic, assign) BOOL hideStatusBar;//隐藏状态栏

@end
