//
//  KGGWithdrawViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/8.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGWithdrawViewController.h"
#import "LCActionSheet.h"
#import "CYPasswordView.h"
#import "SNHSecurityCodeViewController.h"


@interface KGGWithdrawViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *tiXianButton;
@property (nonatomic, strong) CYPasswordView *passwordView;


@end

@implementation KGGWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    self.messageLabel.text = [NSString stringWithFormat:@"7天之内收取1％手续费,当前可提现金额为4800"];
    [self addNativationItemRightButton];
    self.tiXianButton.enabled = NO;
    
    [KGGNotificationCenter addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(forgetPWD) name:CYPasswordViewForgetPWDButtonClickNotification object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(cancelInputPWD) name:CYPasswordViewCancleButtonClickNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.moneyTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [KGGNotificationCenter removeObserver:self];
    KGGLogFunc
}

#pragma mark - 支付密码
- (CYPasswordView *)passwordView
{
    if (!_passwordView) {
        _passwordView = [[CYPasswordView alloc]init];
        _passwordView.title = @"请输入提现密码";
    }
    return _passwordView;
}

#pragma mark - Notification
- (void)forgetPWD {
    CYLog(@"忘记密码");
    
    [self.passwordView hide];
    [self cancelInputPWD];
    
    
    SNHSecurityCodeViewController *code = [[SNHSecurityCodeViewController alloc]init];
//    code.cellphone = self.wallet.mobile;
    [self.navigationController pushViewController:code animated:YES];

}

- (void)textFieldTextDidChange
{
    CGFloat balance = 100000;
    self.tiXianButton.enabled = self.moneyTextField.text.length;
    CGFloat money = [self.moneyTextField.text doubleValue];
    if (money  > balance) {
        self.messageLabel.text = @"金额超过可用余额";
        self.messageLabel.textColor = UIColorHex(e24444);
        self.tiXianButton.enabled = NO;
    }else if (money < 200.f && money > 0.f){
        
        self.messageLabel.text = @"提现金额不能低于200";
        self.messageLabel.textColor = UIColorHex(e24444);
        self.tiXianButton.enabled = NO;
        
    }else{
        self.messageLabel.textColor = KGGTimeTextColor;
        
        if (money > 0.f) {
            
            CGFloat m = money * balance;
            if (m < 2) {
                m = 2.f;
            }
            self.messageLabel.text = [NSString stringWithFormat:@"佣金%.2f元",m];
        }else{
            self.messageLabel.text = [NSString stringWithFormat:@"可用余额¥%.2f",balance];
            self.tiXianButton.enabled = NO;
        }
    }
}


- (void)cancelInputPWD{
    [self.passwordView removeFromSuperview];
    self.passwordView = nil;
}


#pragma mark - 按钮的点击事件
- (IBAction)withdrawButtonClick:(UIButton *)sender {
    KGGLog(@"提现按钮");
    
    [self.moneyTextField resignFirstResponder];
    
    CGFloat money = [self.moneyTextField.text doubleValue];
    
    if (money < 200.f) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"提现金额不能低于200" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    CGFloat m = money * 100;
    if (m < 2) {
        m = 2.f;
    }
    
    self.passwordView.subtitle = [NSString stringWithFormat:@"到账资金%.2f,本次佣金%.2f",money - m,m];
    [self.passwordView showInView:self.view.window];
    weakSelf(self);
    self.passwordView.finish = ^(NSString *password) {
        
        [weakself.passwordView hide];
        [weakself cancelInputPWD];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"userId"] = @"123";
        param[@"password"] = [password base64_encode];
        param[@"amount"] = [NSString stringWithFormat:@"%.2f",money];
        
        [weakself.view.window showHUD];
        
//        [SNHWalletRequestManager applyWithdrawWithParam:param completion:^(SNHResponseObj *responseObj) {
//            
//            [weakself.view.window hideHUD];
//            if (!responseObj) {
//                [weakself.view showHint:SNHHttpNerworkErrorTip];
//            }else if (SNHSuccessCode != responseObj.code){
//                
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseObj.message preferredStyle:UIAlertControllerStyleAlert];
//                [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
//                [weakself presentViewController:alert animated:YES completion:nil];
//                
//            }else{
//                
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseObj.message preferredStyle:UIAlertControllerStyleAlert];
//                [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [weakself dismiss];
//                }]];
//                
//                [weakself presentViewController:alert animated:YES completion:nil];
//                
//                [SNHNotificationCenter postNotificationName:SNHApplyWithdrawSuccessNotifacation object:nil];
//                
//            }
//            
//        } aboveView:nil inCaller:weakself];
    };

}

- (void)adminiorButtonClick
{
    KGGLog(@"管理按钮");
    
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            
            if (buttonIndex) {
//                [SNHWalletRequestManager removeBankCardWithUserId:[SNHUserManager sharedUserManager].currentUser.userId completion:^(SNHResponseObj *responseObj) {
//                    
//                    
//                    if (responseObj) {
//                        
//                        
//                        _bankInfo = nil;
//                        self.tableView.rowHeight = SNHItemHeight;
//                        self.manageButton.hidden = !_bankInfo;
//                        [self.tableView reloadData];
//                        
//                        if (self.removeCompletionHandler) {
//                            self.removeCompletionHandler();
//                        }
//                    }
//                    
//                } aboveView:self.view inCaller:self];
            }
            
        } otherButtonTitles:@"删除银行卡", nil];
        [sheet show];


}

- (void)addNativationItemRightButton
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"管理" target:self action:@selector(adminiorButtonClick)];
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
