//
//  KGGWithdrawalPasswordViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/8.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGWithdrawalPasswordViewController.h"
#import "KGGPasswordView.h"
#import "KGGWallectRequestManager.h"
#import "KGGWithdrawViewController.h"
#import "KGGMyWalletViewController.h"


@interface KGGWithdrawalPasswordViewController ()<UITextFieldDelegate>
/** 响应者 */
@property (nonatomic, weak) UITextField *responsder;
/**  */
@property (nonatomic,copy) NSString *pwd;
@property (nonatomic, weak) KGGPasswordView *pwdView;

@end

@implementation KGGWithdrawalPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置提现密码";
    self.view.backgroundColor = KGGViewBackgroundColor;
    [self setupPwdView];
    [self setupResponsder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    KGGLogFunc
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.responsder becomeFirstResponder];
}

//响应者
- (void)setupResponsder
{
    UITextField *responsder = [[UITextField alloc]init];
    responsder.delegate = self;
    responsder.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:responsder];
    self.responsder = responsder;
}

- (void)setupPwdView
{
    UIView *pView = [[UIView alloc]init];
    pView.xc_width = kMainScreenWidth;
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = KGGFont(15);
    textLabel.textColor = KGGTimeTextColor;
    textLabel.text = self.firstPassword.length ? @"再次填写以确认":@"请设置提现密码,用于提现验证";
    [textLabel sizeToFit];
    
    textLabel.xc_width = pView.xc_width;
    [pView addSubview:textLabel];
    
    KGGPasswordView *pwdView = [[KGGPasswordView alloc]init];
    pwdView.xc_width = KGGAdaptedWidth(300.f);
    pwdView.xc_height = pwdView.xc_width / 6;
    pwdView.xc_x = (pView.xc_width - pwdView.xc_width) *0.5;
    pwdView.xc_y = CGRectGetMaxY(textLabel.frame)+KGGAdaptedHeight(40.f);
    
    pView.xc_height = CGRectGetMaxY(pwdView.frame);
    pView.xc_centerY = (kMainScreenHeight - 216.0f - 64.f) *0.5;
    
    [pView addSubview:pwdView];
    [self.view addSubview:pView];
    self.pwdView = pwdView;
}

#pragma mark - 处理字符串 和 删除键
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!self.pwd) {
        self.pwd = string;
    }else{
        self.pwd = [NSString stringWithFormat:@"%@%@",self.pwd,string];
        if (self.pwd.length > 6) {
            NSString *lastStr = [self.pwd substringToIndex:[self.pwd length] - 1];
            self.pwd = lastStr;
            return YES;
        }
    }
    
    if ([string isEqualToString:@""]) {
        [self.pwdView deleteNum];
        
        if (self.pwd.length > 0) { //删除最后一个字符串
            NSString *lastStr = [_pwd substringToIndex:[self.pwd length] -1];
            self.pwd = lastStr;
        }
    }else{
        
        [self.pwdView pressNum:string];
        
        if (self.pwd.length == 6) {
            if (!self.firstPassword.length) {
                KGGWithdrawalPasswordViewController *alipayPwd = [[KGGWithdrawalPasswordViewController alloc]init];
                alipayPwd.firstPassword = self.pwd;
                alipayPwd.cellphone =self.cellphone;
                alipayPwd.codeNum = self.codeNum;
                alipayPwd.updataPwd = self.updataPwd;
                [self.navigationController pushViewController:alipayPwd animated:YES];
            }else{
                
                if (![self.firstPassword isEqualToString:self.pwd]) {
                    [MBProgressHUD showMessag:@"两次密码输入不一致"];
                    [self.pwdView deleteAllNum];
                    self.pwd = nil;
                }else{
                    [self setPayPwd];
                }
                
            }
        }
    }
    return YES;
}

- (void)setPayPwd
{
    [self.view endEditing:YES];
    KGGLog(@"是否更改密码:%@",self.updataPwd);
    if ([self.updataPwd isEqualToString:@"1"]) {
        [self updataDrawPwd];
    }else{
        [self setupDrawPwd];
    }
}

#pragma mark - 第一次设置密码
- (void)setupDrawPwd
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"password"] = self.pwd;
    param[@"bankPhone"] = self.cellphone;
    param[@"bankCardNo"] = [NSUserDefaults objectForKey:KGGBankNumKey];
    param[@"drawBalance"] = [NSUserDefaults objectForKey:KGGDrawBalanceMoneyKey];
    param[@"realName"] = [NSUserDefaults objectForKey:KGGCardholderKey];
    param[@"code"] = self.codeNum;
    NSString *blanceMoney = [NSUserDefaults objectForKey:KGGBalanceMoneyKey];
    if ([blanceMoney isEqualToString:@"您没有干活"]) {
        blanceMoney = @"0";
    }
    param[@"balance"] = blanceMoney;
    NSString *bankName = [NSUserDefaults objectForKey:KGGBankOfDepositKey];
    param[@"branchBankName"] = bankName;
    KGGLog(@"%@ - %@",[NSUserDefaults objectForKey:KGGCardholderKey],[NSUserDefaults objectForKey:KGGBankOfDepositKey]);
    KGGLog(@"参数:%@",param);
    
    [KGGWallectRequestManager myWalletAddBankCardWithParam:param completion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            [self.view showHint:@"设置成功"];
            
            for (UIViewController *temp in self.navigationController.childViewControllers) {
                if ([temp isKindOfClass:[KGGMyWalletViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }
        
    } aboveView:self.view idCaller:self];
}

#pragma mark - 修改密码
- (void)updataDrawPwd
{
    [KGGWallectRequestManager myWalletWithUpdataPwdCode:self.codeNum Phone:self.cellphone PassWord:self.pwd completion:^(KGGResponseObj *responseObj) {
        
        if (responseObj.code == KGGSuccessCode) {
            [self.view showHint:@"更新密码成功成功"];
            for (UIViewController *temp in self.navigationController.childViewControllers) {
                if ([temp isKindOfClass:[KGGWithdrawViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }
        
    } aboveView:self.view idCaller:self];
    
}


@end
