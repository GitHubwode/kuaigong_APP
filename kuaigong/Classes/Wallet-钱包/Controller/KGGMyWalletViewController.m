//
//  KGGMyWalletViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/8.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMyWalletViewController.h"
#import "KGGAddBankCarController.h"
#import "KGGBillingDetailsViewController.h"
#import "KGGWallectRequestManager.h"

//测试
#import "KGGWithdrawViewController.h"

@interface KGGMyWalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation KGGMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的钱包";
    NSString *requestType;
    if ([[KGGUserManager shareUserManager].currentUser.type isEqualToString:@"BOSS"]) {
        requestType = @"postContent";
    }else{
        requestType = @"acceptContent";
    }
    [self requestMessageUserType:requestType];
}

#pragma mark - 获取数据信息
- (void)requestMessageUserType:(NSString *)userType
{
    [KGGWallectRequestManager myWalletOrderDetailsUserType:userType Page:1 completion:^(NSArray< KGGMyWalletOrderDetailsModel *>*response,NSString *totalMoeny) {
        if (!response) {
            
        }else{
            self.moneyLabel.text = [NSString stringWithFormat:@"%@",totalMoeny];
        }
    } aboveView:self.view inCaller:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [JANALYTICSService startLogPageView:@"KGGMyWalletViewController"];
}
- (void)viewDidDisappear:(BOOL)animated {
    [JANALYTICSService stopLogPageView:@"KGGMyWalletViewController"];
}

- (IBAction)tiXianToBankCardClick:(UIButton *)sender {
    KGGLog(@"提现到银行卡");
//    KGGAddBankCarController *addVC = [[KGGAddBankCarController alloc]initWithNibName:NSStringFromClass([KGGAddBankCarController class]) bundle:[NSBundle mainBundle]];
//    [self.navigationController pushViewController:addVC animated:YES];

    KGGWithdrawViewController *addVC = [[KGGWithdrawViewController alloc]initWithNibName:NSStringFromClass([KGGWithdrawViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:addVC animated:YES];
}
- (IBAction)billListDetailsClick:(UIButton *)sender {
    KGGLog(@"账单明细");
    KGGBillingDetailsViewController *billVC = [[KGGBillingDetailsViewController alloc]init];
    [self.navigationController pushViewController:billVC animated:YES];
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
