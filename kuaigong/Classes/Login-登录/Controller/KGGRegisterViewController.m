//
//  KGGRegisterViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGRegisterViewController.h"
#import "KGGLoginView.h"
#import "KGGConfirmPasswordViewController.h"

@interface KGGRegisterViewController ()<KGGLoginViewDelegate>

@property (nonatomic, strong) KGGLoginView *loginView1;
@property (nonatomic, strong) KGGLoginView *loginView2;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation KGGRegisterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(0xffffff);
    // 设置点击空白区域键盘收回
    [self setupForDismissKeyboard];
    [self creatNaviUI];
    [self creatUI];
}

#pragma mark - 设计页面
- (void)creatUI
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
    
    self.loginView2 = [[KGGLoginView alloc]initWithFrame:CGRectMake(0, KGGAdaptedHeight(220+44+32), kMainScreenWidth, 44) WithTitle:nil imageString:@"icon_yanzheng" PlaceText:@" 请输入验证码"];
    self.loginView2.codeDelegate = self;
    self.loginView2.containCodeButton = YES;
    [self.view addSubview:self.loginView1];
    [self.view addSubview:self.loginView2];
    

    UIButton *loginButton = [[UIButton alloc]init];
    loginButton.enabled = NO;
    [loginButton addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"but_kean"] forState:UIControlStateNormal];
    [loginButton setTitle:@"下一步" forState:UIControlStateNormal];
    [loginButton setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    loginButton.titleLabel.font = KGGLightFont(18);
    [self.view addSubview:loginButton];
    self.loginButton = loginButton;
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(weakself.loginView2.mas_bottom).offset(15);
        make.width.equalTo(@(kMainScreenWidth-60));
        make.height.equalTo(@(KGGLoginButtonHeight));
    }];
 
}


#pragma mark - KGGLoginViewDelegate
- (NSString *)textFieldCanSendCode:(KGGLoginView *)textField
{
    return self.loginView1.loginTextField.text;
}

- (NSString *)codeType
{
    return @"REGISTER";
}

- (BOOL)textFieldShouldSendCode:(KGGLoginView *)textField
{
    NSString *cellPhone = self.loginView1.loginTextField.text;
    if (!cellPhone.length){
        [MBProgressHUD showMessag:@"请填写手机号码"];
        return NO;
    };
    
    // 1.对用户输入的手机号进行正则匹配
    BOOL isMatch = [cellPhone isPhoneNumer];
    // 2.对不同的匹配结果做处理
    if (!isMatch){ // 不是正规的手机号码
        [MBProgressHUD showMessag:@"请输入正确格式的手机号码"];
        return NO;
    }
    self.loginButton.enabled = YES;
    return YES;
}

- (UIView *)hudView{
    return self.loginView1;
}

#pragma mark - 模拟导航栏
- (void)creatNaviUI
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 44)];
    label.text = @"注册";
    label.font = KGGLightFont(18);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *jumpButton = [[UIButton alloc]init];
    jumpButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [jumpButton setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
    [jumpButton addTarget:self action:@selector(kgg_dissmissViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpButton];
    [jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.left.equalTo(label.mas_left).offset(14);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, KGGOnePixelHeight)];
    lineView.backgroundColor = UIColorHex(0xb2b2b2);
    [self.view addSubview:lineView];
}

#pragma mark - 按钮点击事件
- (void)loginButton:(UIButton *)sender
{
    KGGLog(@"下一步");
    
    if (self.loginView2.loginTextField.text.length==0) {
        [self.view showHint:@"请输入验证码"];
        return;
    }
    
    KGGConfirmPasswordViewController *confirmVC = [[KGGConfirmPasswordViewController alloc]init];
    confirmVC.cellPhone = self.loginView1.loginTextField.text;
    confirmVC.smsCode = self.loginView2.loginTextField.text;
    [self presentViewController:confirmVC animated:YES completion:nil];
}

#pragma mark - 按钮的点击事件
- (void)kgg_dissmissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    KGGLogFunc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
