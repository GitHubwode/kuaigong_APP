//
//  KGGAddBankCarController.m
//  kuaigong
//
//  Created by Ding on 2017/9/8.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGAddBankCarController.h"
#import "KGGAddBankCardFirstController.h"

@interface KGGAddBankCarController ()

@end

@implementation KGGAddBankCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加银行卡";
}
- (IBAction)addBankCardButtonClick:(UIButton *)sender {
    KGGLog(@"添加银行卡");
    KGGAddBankCardFirstController *bankVC = [[KGGAddBankCardFirstController alloc]init];
    [self.navigationController pushViewController:bankVC animated:YES];
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
