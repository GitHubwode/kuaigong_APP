//
//  KGGWithdrawalPasswordViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/8.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGWithdrawalPasswordViewController.h"
#import "KGGPasswordView.h"

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
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"password"] = [self.pwd base64_encode];
//    param[@"userId"] = [SNHUserManager sharedUserManager].currentUser.userId;
    param[@"mobile"] = self.cellphone;
    param[@"bankId"] = [NSUserDefaults objectForKey:KGGBankNumKey];
    
    NSString *depositBankName = [NSUserDefaults objectForKey:KGGBankOfDepositKey];
    if (depositBankName.length) {
        param[@"depositBankName"] = depositBankName;
    }
    
    param[@"cardUserName"] = [NSUserDefaults objectForKey:KGGCardholderKey];
    
    KGGLog(@"%@ - %@",[NSUserDefaults objectForKey:KGGCardholderKey],[NSUserDefaults objectForKey:KGGBankOfDepositKey]);
    
    
//    [SNHWalletRequestManager setPayPasswordWithParam:param completion:^(SNHResponseObj *responseObj) {
    
//        if (responseObj) {
//            [MBProgressHUD showSuYaSuccess:@"设置成功" toView:nil];
//            
//            if([self.navigationController.childViewControllers.firstObject isKindOfClass:NSClassFromString(@"SNHWithdrawViewController")]){
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }else{
//                
//                NSInteger count = self.navigationController.childViewControllers.count;
//                for (NSInteger i = count - 1; i >= 0; i--) {
//                    
//                    UIViewController *  obj = self.navigationController.childViewControllers[i];
//                    
//                    if ([obj isKindOfClass:NSClassFromString(@"SNHDetailOrderViewController")]) {
//                        [self.navigationController popToViewController:obj animated:YES];
//                        return;
//                        
//                    }else if ([obj
//                               isKindOfClass:NSClassFromString(@"SNHMyOrderViewController")]){
//                        [self.navigationController popToViewController:obj animated:YES];
//                        return;
//                    }
//                }
//                
//            }
//            
//            [self.navigationController popToViewController:self.navigationController.childViewControllers[2] animated:YES];
//            
//        }
        
//    } aboveView:self.view inCaller:self];

}


@end
