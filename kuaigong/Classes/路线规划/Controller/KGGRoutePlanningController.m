//
//  KGGRoutePlanningController.m
//  kuaigong
//
//  Created by Ding on 2017/11/6.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGRoutePlanningController.h"
#import "KGGOrderDetailsModel.h"

@interface KGGRoutePlanningController ()

@end

@implementation KGGRoutePlanningController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    KGGLog(@"orderDetails:%@",self.orderDetails);
}

#pragma mark -懒加载

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    KGGLogFunc
}
@end
