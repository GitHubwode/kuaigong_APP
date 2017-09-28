//
//  KGGNewFeatureViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGNewFeatureViewController.h"
#import "KGGTabBarController.h"
#import "KGGTabBarWorkController.h"

#import "KGGNavigationController.h"
#import "KGGLoginViewController.h"

@interface KGGNewFeatureViewController ()


@end

@implementation KGGNewFeatureViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)kgg_useTheWorkerClick:(UIButton *)sender {
    KGGLog(@"用工");
    KGGTabBarController *rootVc = [[KGGTabBarController alloc] init];
    self.view.window.rootViewController = rootVc;
}
- (IBAction)kgg_lookTheWorkClick:(UIButton *)sender {
     KGGLog(@"找活");
    KGGTabBarWorkController *rootVc = [[KGGTabBarWorkController alloc] init];
    self.view.window.rootViewController = rootVc;
}

- (void)dealloc
{
    KGGLogFunc;
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
