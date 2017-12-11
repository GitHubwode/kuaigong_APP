//
//  KGGTabBarWorkController.m
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGTabBarWorkController.h"
#import "KGGNavigationController.h"
#import "KGGLookWorkViewController.h"
#import "KGGMyWorkBaseViewController.h"
#import "KGGSmallVideoViewController.h"
#import "KGGMeWorkViewController.h"

@interface KGGTabBarWorkController ()

@end

@implementation KGGTabBarWorkController

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
    
    [self setupOneChildViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLookWorkViewController alloc]init]] title:@"我要找活" image:@"icon_zhaohuo" selectedImage:@"icon_zhaohuo_press"];
    
    [self setupOneChildViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGMyWorkBaseViewController alloc]init]] title:@"我的工作" image:@"icon_work_default" selectedImage:@"icon_work_press"];
    
    [self setupOneChildViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGSmallVideoViewController alloc]init]] title:@"小视频" image:@"icon_shipin" selectedImage:@"icon_shipin_press"];
    
    [self setupOneChildViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGMeWorkViewController alloc]init]] title:@"我的" image:@"icon_wode_default" selectedImage:@"icon_wode_press"];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
