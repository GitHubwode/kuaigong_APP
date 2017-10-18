//
//  KGGNavigationController.m
//  kuaigong
//
//  Created by Ding on 2017/8/15.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGNavigationController.h"

@interface KGGNavigationController ()

@end

@implementation KGGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBarButtonItem];
    
    [self setUpNavigationBar];
}


/**
 设置导航栏标题字体和颜色
 */
- (void)setUpNavigationBar{
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName: KGGFont(18), NSForegroundColorAttributeName: KGGTitleTextColor}];
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_icon"] forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [UIImage new];

}

/**
 设置导航栏item字体和颜色
 */
- (void)setUpBarButtonItem{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{NSFontAttributeName: KGGLightFont(15), NSForegroundColorAttributeName: KGGTitleTextColor} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName: KGGLightFont(15), NSForegroundColorAttributeName: KGGContentTextColor} forState:UIControlStateHighlighted];
    [item setTitleTextAttributes:@{NSFontAttributeName: KGGLightFont(15), NSForegroundColorAttributeName: KGGItemSeletedColor} forState:UIControlStateDisabled];
}


/*  重写push方法的目的 : 拦截所有push进来的子控制器
 *
 *  @param viewController 刚刚push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果viewController不是最早push进来的子控制器
        // 左上角
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        // 这句代码放在sizeToFit后面
        //        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        // 隐藏底部的工具条
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 所有设置搞定后, 再push控制器
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)dealloc
{
    KGGLogFunc
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    
    return self.topViewController;
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
