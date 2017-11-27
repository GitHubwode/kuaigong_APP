//
//  KGGTabBarController.m
//  kuaigong
//
//  Created by Ding on 2017/8/16.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGTabBarController.h"
#import "KGGNavigationController.h"
#import "KGGHomeViewController.h"

@interface KGGTabBarController ()

@end

@implementation KGGTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupItemTitleTextAttributes];
    
    /**** 添加子控制器 ****/
    [self setupChildViewControllers];
}

/**
 *  设置所有UITabBarItem的文字属性
 */
- (void)setupItemTitleTextAttributes{
    
    UITabBarItem *item = [UITabBarItem appearance];
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    normalAttrs[NSForegroundColorAttributeName] = UIColorHex(666666);
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = KGGGoldenThemeColor;
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

/**
 *  添加子控制器
 */
- (void)setupChildViewControllers{
    
    [self setupOneChildViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGHomeViewController alloc]init]] title:@"首页" image:@"icon_home_default" selectedImage:@"icon_home"];
    
}

/**
 *  初始化一个子控制器
 *
 *  @param vc            子控制器
 *  @param title         标题
 *  @param image         图标
 *  @param selectedImage 选中的图标
 */
- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    if (image.length) { // 图片名有具体值
        vc.tabBarItem.image = [UIImage imageNamed:image];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    [self addChildViewController:vc];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
