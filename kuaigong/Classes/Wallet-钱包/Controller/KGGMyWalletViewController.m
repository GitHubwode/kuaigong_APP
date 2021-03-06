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
#import "KGGWithdrawViewController.h"
#import "KGGBillingBaseViewController.h"
#import "KGGLoginViewController.h"

@interface KGGMyWalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic, strong) KGGMyWalletCardModel *cardModel;
@property (weak, nonatomic) IBOutlet UIButton *walletButton;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSString *isBankCard;
@property (nonatomic, strong) NSString *totalMoney;
@property (nonatomic, strong) NSString *drawMoney;

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
    [KGGNotificationCenter addObserver:self selector:@selector(addBankCard) name:KGGAddBankCardSuccessNotifacation object:nil];
}

- (void)addBankCard
{
    [self setupCardMessage];
}

#pragma mark - 获取本用户银行卡信息
- (void)setupCardMessage
{
    [KGGWallectRequestManager myWalletLookUpBandingCardCompletion:^(KGGMyWalletCardModel *cardModel,NSString *isHas) {
        KGGLog(@"%@",cardModel);
        self.cardModel = cardModel;
        KGGLog(@"%@",self.cardModel);
        [self withdrawalState:cardModel.bankAccountDO.status];
    } aboveView:nil idCaller:self];
}

#pragma mark - 正在提现中请稍等
- (void)withdrawalState:(NSUInteger )status
{
    /** 提现状态 0可提现 1 为提现中 2为提现成功 */
    if (status == 1) {
        self.walletButton.enabled = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提现中" message:@"提现申请已提交,等待公司打款审核" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 获取数据信息
- (void)requestMessageUserType:(NSString *)userType
{
    [KGGWallectRequestManager myWalletOrderDetailsUserType:userType Page:1 completion:^(NSArray< KGGMyWalletOrderDetailsModel *>*response,NSString *totalMoeny, NSString *drawAcount) {
        if (!response) {
            
        }else{
            totalMoeny = [totalMoeny isEqualToString:@"(null)"] ? @"没有工钱":totalMoeny;
            self.moneyLabel.text = [NSString stringWithFormat:@"¥ %@",totalMoeny];
            
            self.totalMoney = totalMoeny;
            self.drawMoney = drawAcount;
            [NSUserDefaults setObject:totalMoeny forKey:KGGBalanceMoneyKey];
            [NSUserDefaults setObject:drawAcount forKey:KGGDrawBalanceMoneyKey];
            KGGLog(@"%@-%@",[NSUserDefaults objectForKey:KGGBalanceMoneyKey],[NSUserDefaults objectForKey:KGGDrawBalanceMoneyKey])
            [self.datasource addObjectsFromArray:response];
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
    
    BOOL login = [KGGUserManager shareUserManager].logined;
    if (!login) {
        KGGLog(@"未登录");
        [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLoginViewController alloc]init]] animated:YES completion:nil];
        return;
    }
    KGGLog(@"%.2f",self.cardModel.bankAccountDO.drawBalance);
    if (self.cardModel.isBink) {
        KGGWithdrawViewController *drawVC = [[KGGWithdrawViewController alloc]initWithNibName:NSStringFromClass([KGGWithdrawViewController class]) bundle:[NSBundle mainBundle]];
        drawVC.cardModel = self.cardModel;
        drawVC.removeBlock = ^{
            [self setupCardMessage];
        };
        [self.navigationController pushViewController:drawVC animated:YES];
    }else{
        KGGAddBankCarController *addVC = [[KGGAddBankCarController alloc]initWithNibName:NSStringFromClass([KGGAddBankCarController class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

- (IBAction)billListDetailsClick:(UIButton *)sender {
    KGGLog(@"账单明细");
    BOOL login = [KGGUserManager shareUserManager].logined;
    if (!login) {
        KGGLog(@"未登录");
        [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLoginViewController alloc]init]] animated:YES completion:nil];
        return;
    }
    
    KGGBillingBaseViewController *billVC = [[KGGBillingBaseViewController alloc]init];
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
    [KGGNotificationCenter removeObserver:self];
    [NSUserDefaults removeObjectForKey:KGGBalanceMoneyKey];
    [NSUserDefaults removeObjectForKey:KGGDrawBalanceMoneyKey];
}

@end
