//
//  KGGPayOrderViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/23.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPayOrderViewController.h"
#import "SUNSlideSwitchView.h"

@interface KGGPayOrderViewController ()<SUNSlideSwitchViewDelegate>

@property (nonatomic, strong) SUNSlideSwitchView *slideSwitchView;
@property (nonatomic, strong) NSArray<NSString *> *titles;

@end

@implementation KGGPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.navigationItem.title = @"我的订单";
    [self setupNavi];

}
#pragma mark - 创建item
- (void)setupNavi
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_back" highImage:@"nav_back" target:self action:@selector(kgg_back)];
}

- (void)kgg_back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    KGGLogFunc
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
