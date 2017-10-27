//
//  KGGLoginViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/16.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLoginViewController.h"
#import "KGGLoginView.h"
#import "KGGRegisterViewController.h"
#import "KGGForgetPasswordViewController.h"
#import "KGGUMSocialHelper.h"
#import "KGGLoginParam.h"
#import "KGGLoginRequestManager.h"
#import "KGGLookforPWDViewController.h"

@interface KGGLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) KGGLoginView *loginView1;
@property (nonatomic, strong) KGGLoginView *loginView2;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation KGGLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = UIColorHex(0xffffff);
    [self creatNaviUI];
    [self setupUI];
    // 设置点击空白区域键盘收回
    [self setupForDismissKeyboard];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self loginButton:self.loginButton];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

#pragma mark - 模拟导航栏
- (void)creatNaviUI
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 44)];
    label.text = @"登录";
    label.font = KGGLightFont(18);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *jumpButton = [[UIButton alloc]init];
    [jumpButton setTitle:@"跳过" forState:UIControlStateNormal];
    [jumpButton addTarget:self action:@selector(kgg_dissmissViewController) forControlEvents:UIControlEventTouchUpInside];
    [jumpButton setTitleColor:UIColorHex(0x737373) forState:UIControlStateNormal];
    jumpButton.titleLabel.font = KGGLightFont(18);
    [self.view addSubview:jumpButton];
    [jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.right.equalTo(label.mas_right).offset(-14);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, KGGOnePixelHeight)];
    lineView.backgroundColor = UIColorHex(0xb2b2b2);
    [self.view addSubview:lineView];
}

#pragma mark - UI界面
- (void)setupUI
{
    weakSelf(self);
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"login_icon"];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(weakself.view.mas_top).offset(KGGAdaptedHeight(110));
        make.width.equalTo(@111);
        make.height.equalTo(@79);
    }];
   
    self.loginView1 = [[KGGLoginView alloc]initWithFrame:CGRectMake(0, KGGAdaptedHeight(220), kMainScreenWidth, 44) WithTitle:nil imageString:@"icon_zhanghao" PlaceText:@" 请输入手机号"];
    self.loginView1.isPhoneNum = YES;
    self.loginView1.maxTextLength = KGGCellphoneMaxLength;

    
    self.loginView2 = [[KGGLoginView alloc]initWithFrame:CGRectMake(0, KGGAdaptedHeight(220+44+32), kMainScreenWidth, 44) WithTitle:nil imageString:@"icon_mima" PlaceText:@" 请输入密码"];
    self.loginView2.isPassWord = YES;
    self.loginView2.maxTextLength = KGGCellphoneMaxLength;

    [self.view addSubview:self.loginView1];
    [self.view addSubview:self.loginView2];
   
    UIButton *loginButton = [[UIButton alloc]init];
    [loginButton addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"but_kean"] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    loginButton.titleLabel.font = KGGLightFont(18);
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(weakself.loginView2.mas_bottom).offset(15);
        make.width.equalTo(@(kMainScreenWidth-60));
        make.height.equalTo(@(KGGLoginButtonHeight));
    }];
    
    UIView *agreeView = [UIView new];
    [self.view addSubview:agreeView];
    
    [agreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(loginButton.mas_bottom).offset(10);
        make.width.equalTo(@160);
        make.height.equalTo(@24);
    }];
    
    UILabel *agreenLabel = [UILabel new];
    agreenLabel.text = @"登录即表示同意";
    agreenLabel.textColor = UIColorHex(0x737373);
    agreenLabel.font = KGGLightFont(12);
    agreenLabel.textAlignment = NSTextAlignmentLeft;
    [agreeView addSubview:agreenLabel];
    
    [agreenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(agreeView.mas_leading).offset(0);
        make.centerY.equalTo(agreeView.mas_centerY);
        make.width.equalTo(@90);
    }];
    
    UIButton *agreenButton = [[UIButton alloc]init];
    [agreenButton setBackgroundImage:[UIImage imageNamed:@"pic_xieyi"] forState:UIControlStateNormal];
    [agreenButton addTarget:self action:@selector(kgg_userAgreenMessage) forControlEvents:UIControlEventTouchUpInside];
    [agreeView addSubview:agreenButton];
    [agreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(agreenLabel.mas_trailing).offset(0);
        make.centerY.equalTo(agreenLabel.mas_centerY);
        make.width.equalTo(@70);
        make.height.equalTo(@12);
    }];
    
    UIButton *regisButton = [[UIButton alloc]init];
    [regisButton setTitle:@"点击注册" forState:UIControlStateNormal];
    regisButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    regisButton.titleLabel.font = KGGLightFont(16);
    [regisButton setTitleColor:UIColorHex(0x4c4c4c) forState:UIControlStateNormal];
    [self.view addSubview:regisButton];
    [regisButton addTarget:self action:@selector(kgg_userRegistrationButton) forControlEvents:UIControlEventTouchUpInside];
    [regisButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(loginButton.mas_leading).offset(0);
        make.top.equalTo(loginButton.mas_bottom).offset(90);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    
    UIButton *forgetButton = [[UIButton alloc]init];
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetButton.titleLabel.font = KGGLightFont(16);
    forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    [forgetButton setTitleColor:UIColorHex(0x4c4c4c) forState:UIControlStateNormal];
    [self.view addSubview:forgetButton];
    [forgetButton addTarget:self action:@selector(kgg_userForgetPasswordButton) forControlEvents:UIControlEventTouchUpInside];
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(loginButton.mas_trailing);
        make.centerY.equalTo(regisButton.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    
    UIButton *weachatButton = [[UIButton alloc]init];
    [weachatButton setBackgroundImage:[UIImage imageNamed:@"icon-WX"] forState:UIControlStateNormal];
    [weachatButton addTarget:self action:@selector(kgg_weChatButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weachatButton];
    [weachatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(loginButton.mas_bottom).offset(56);
        make.width.equalTo(@84.5);
        make.height.equalTo(@16);
    }];
}

#pragma mark - 按钮的点击事件
- (void)kgg_dissmissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginButton:(UIButton *)sender
{
    KGGLog(@"登录按钮");
    
    NSString *cellphone = self.loginView1.loginTextField.text;
    if (!cellphone.length){
        [MBProgressHUD showMessag:@"请填写手机号码"];
        return;
    };
    
    NSString *pwd = self.loginView2.loginTextField.text;
    if (!pwd.length){
        [MBProgressHUD showMessag:@"请填写密码"];
        return;
    }
    
    if (pwd.length < KGGPasswordMinLength){
        [MBProgressHUD showMessag:[NSString stringWithFormat:@"密码不能小于%zd位",KGGPasswordMinLength]];
        return;
    }
    
    // 1.对用户输入的手机号进行正则匹配
    BOOL isMatch = [cellphone isPhoneNumer];
    // 2.对不同的匹配结果做处理
    if (!isMatch){ // 不是正规的手机号码
        [MBProgressHUD showMessag:@"请输入正确格式的手机号码"];
        return;
    }
    
    KGGLoginParam *param = [[KGGLoginParam alloc]initWithPhone:cellphone password:pwd SmsCode:nil Mode:@"PWD"];
    
    [KGGLoginRequestManager loginWithParam:param completion:^(KGGUserInfo *user) {
        KGGLog(@"%@",user);
        [KGGNotificationCenter postNotificationName:KGGUserLoginNotifacation object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    } aboveView:self.view inCaller:self];

}

- (void)kgg_userAgreenMessage
{
    KGGLog(@"用户协议");
}

- (void)kgg_userRegistrationButton
{
    KGGLog(@"注册按钮");
    [self presentViewController:[[KGGNavigationController alloc] initWithRootViewController:[[KGGRegisterViewController alloc]init] ] animated:YES completion:nil];
}

- (void)kgg_userForgetPasswordButton
{
    KGGLog(@"忘记密码");
    KGGLookforPWDViewController *forgrtVC = [[KGGLookforPWDViewController alloc]init];
    [self presentViewController:[[KGGNavigationController alloc] initWithRootViewController:forgrtVC] animated:YES completion:nil];
}

- (void)kgg_loginOut
{
    [KGGLoginRequestManager loginOutWithcompletion:^(KGGResponseObj *responseObj) {
        
        [[KGGUserManager shareUserManager] logout];
        [KGGNotificationCenter postNotificationName:KGGUserLogoutNotifacation object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } aboveView:self.view inCaller:self];
}

- (void)kgg_weChatButton
{
    KGGLog(@"微信登录");
    weakSelf(self);
    //拉去第三方平台用户信息
    [KGGUMSocialHelper getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(UMSocialUserInfoResponse *userinfo) {
        if (!userinfo) {
            [weakself.view showHint:@"授权失败"];
        }else{
            KGGLog(@"userinfo %@",userinfo);
             // 设置性别，微信中 m 代表男，f 代表女
            NSString *gender = userinfo.gender;
            if ([gender isEqualToString:@"m"]) {
                gender = @"MAN";
            }else if ([gender isEqualToString:@"f"]){
                gender = @"WOMAN";
            }else{
                gender = @"OTHER";
            }

            userinfo.iconurl = [userinfo.iconurl stringByReplacingOccurrencesOfString:@"https:" withString:@""];
            [KGGLoginRequestManager WXRegisterWithOpenId:userinfo.openid Platform:nil UserType:[NSUserDefaults objectForKey:KGGUserType] Sex:gender vatarUrl:userinfo.iconurl Nickname:userinfo.name completion:^(KGGResponseObj *responseObj) {
                KGGLog(@"%@",responseObj);
                if (responseObj.code == KGGSuccessCode) {
                    [weakself WXLoginOpenId:userinfo.openid];
                }
            } aboveView:self.view inCaller:self];
        }
    }];
}

#pragma mark - 微信登录成功
- (void)WXLoginOpenId:(NSString *)openId
{
    [KGGLoginRequestManager WXloginWithOpenId:openId completion:^(KGGUserInfo *user) {
        KGGLog(@"微信登录成功");
        KGGLog(@"%@",user);
        [KGGNotificationCenter postNotificationName:KGGUserLoginNotifacation object:nil];
        [self bindingPhoneNum];
    } aboveView:self.view inCaller:self];
}

#pragma mark - 绑定手机号和输入密码
- (void)bindingPhoneNum
{
    KGGForgetPasswordViewController *forgrtVC = [[KGGForgetPasswordViewController alloc]init];
    forgrtVC.changetype = KGGUserChangeBindPhoneType;
    [self presentViewController:[[KGGNavigationController alloc] initWithRootViewController:forgrtVC] animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
