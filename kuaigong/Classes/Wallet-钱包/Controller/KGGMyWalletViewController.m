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
#import "KGGMyWalletCardModel.h"

//测试
#import "KGGWithdrawViewController.h"

@interface KGGMyWalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic, strong) KGGMyWalletCardModel *cardModel;
@property (weak, nonatomic) IBOutlet UIButton *walletButton;
@property (nonatomic, strong) NSMutableArray *datasource;

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
    
    [self setupCardMessage];
}

#pragma mark - 获取本用户银行卡信息
- (void)setupCardMessage
{
    [KGGWallectRequestManager myWalletLookUpBandingCardCompletion:^(KGGMyWalletCardModel *cardModel) {
        KGGLog(@"%@",cardModel);
        self.cardModel = cardModel;
        KGGLog(@"%@",self.cardModel);
    } aboveView:nil idCaller:self];
}


#pragma mark - 获取数据信息
- (void)requestMessageUserType:(NSString *)userType
{
    [KGGWallectRequestManager myWalletOrderDetailsUserType:userType Page:1 completion:^(NSArray< KGGMyWalletOrderDetailsModel *>*response,NSString *totalMoeny, NSString *drawAcount) {
        if (!response) {
            
        }else{
            totalMoeny = [totalMoeny isEqualToString:@"(null)"] ? @"您没有干活":totalMoeny;
            [self.datasource addObjectsFromArray:response];
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
    
    if (self.cardModel.isBink) {
        KGGWithdrawViewController *drawVC = [[KGGWithdrawViewController alloc]initWithNibName:NSStringFromClass([KGGWithdrawViewController class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:drawVC animated:YES];
    }else{
        KGGAddBankCarController *addVC = [[KGGAddBankCarController alloc]initWithNibName:NSStringFromClass([KGGAddBankCarController class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:addVC animated:YES];
    }
}
- (IBAction)billListDetailsClick:(UIButton *)sender {
    KGGLog(@"账单明细");
    KGGBillingDetailsViewController *billVC = [[KGGBillingDetailsViewController alloc]init];
    billVC.datasource = self.datasource;
    [self.navigationController pushViewController:billVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)dealloc
{
    KGGLogFunc
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
