//
//  KGGConfirmPasswordViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGConfirmPasswordViewController.h"
#import "KGGLoginView.h"
#import "KGGLoginRequestManager.h"
#import "KGGLoginParam.h"
#import "KGGLoginViewController.h"
#import "KGGCompanyView.h"

@interface KGGConfirmPasswordViewController ()<KGGCompanyViewDelegate>
@property (nonatomic, strong) KGGLoginView *loginView1;
@property (nonatomic, strong) KGGLoginView *loginView2;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) KGGCompanyView *companyView;
@property (nonatomic, copy) NSString *companyCode;
@end

@implementation KGGConfirmPasswordViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(0xffffff);
    self.companyCode = @"杭州001";
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
    
    self.loginView1 = [[KGGLoginView alloc]initWithFrame:CGRectMake(0, KGGAdaptedHeight(220), kMainScreenWidth, 44) WithTitle:@"输入密码:"imageString:nil PlaceText:@" 请输入密码"];
    self.loginView1.isPassWord = YES;
    
    self.loginView2 = [[KGGLoginView alloc]initWithFrame:CGRectMake(0, KGGAdaptedHeight(220+44+32), kMainScreenWidth, 44) WithTitle:@"确认密码:" imageString:nil PlaceText:@" 请输入密码"];
    self.loginView2.isPassWord = YES;
    [self.view addSubview:self.loginView1];
    [self.view addSubview:self.loginView2];
    
    self.companyView = [[KGGCompanyView alloc]initWithFrame:CGRectMake(0, KGGAdaptedHeight(220+44+32+44+32), kMainScreenWidth, 44) WithTitle:@"隶属公司:" imageString:nil PlaceText:@"请选择隶属公司"];
    self.companyView.companyDelegate = self;
    [self.view addSubview:self.companyView];
    
    UIButton *loginButton = [[UIButton alloc]init];
    [loginButton addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"but_kean"] forState:UIControlStateNormal];
    [loginButton setTitle:@"完成" forState:UIControlStateNormal];
    [loginButton setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    loginButton.titleLabel.font = KGGLightFont(18);
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(weakself.companyView.mas_bottom).offset(15);
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
    //    agreenButton.backgroundColor = [UIColor yellowColor];
    [agreenButton setBackgroundImage:[UIImage imageNamed:@"pic_xieyi"] forState:UIControlStateNormal];
    [agreenButton addTarget:self action:@selector(kgg_userAgreenMessage) forControlEvents:UIControlEventTouchUpInside];
    [agreeView addSubview:agreenButton];
    [agreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(agreenLabel.mas_trailing).offset(0);
        make.centerY.equalTo(agreenLabel.mas_centerY);
        make.width.equalTo(@70);
        make.height.equalTo(@12);
    }];
}


#pragma mark - 模拟导航栏
- (void)creatNaviUI
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 44)];
    label.text = @"输入密码";
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


#pragma mark - 按钮的点击事件
- (void)kgg_dissmissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 公司选择
- (void)textFieldCompanyName:(NSString *)name
{
    KGGLog(@"%@",name);
//    NSArray *array = [name componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
    self.companyCode = name;
}


- (void)loginButton:(UIButton *)sender
{
    KGGLog(@"完成按钮");
    NSString *cellphone = self.loginView1.loginTextField.text;
    if (!cellphone.length){
        [MBProgressHUD showMessag:@"请填写密码"];
        return;
    };
    
    NSString *pwd = self.loginView2.loginTextField.text;
    if (!pwd.length){
        [MBProgressHUD showMessag:@"请填写密码"];
        return;
    }
    
    if (pwd.length < KGGPasswordMinLength && cellphone.length < KGGPasswordMaxLength){
        [MBProgressHUD showMessag:[NSString stringWithFormat:@"密码不能小于%zd位",KGGPasswordMinLength]];
        return;
    }
    
    // 1.对用户密码是否相等
    BOOL isMatch = [cellphone isEqualToString:pwd];
    if (!isMatch){ // 不相等
        [MBProgressHUD showMessag:@"请检查密码是否一样"];
        return;
    }
    
    weakSelf(self);
    
    KGGRegisterParam *param = [[KGGRegisterParam alloc]initWithPhone:self.cellPhone password:self.loginView1.loginTextField.text Type:[NSUserDefaults objectForKey:KGGUserType] Code:self.smsCode InvitationCode:self.companyCode];
    [KGGLoginRequestManager registerWithParam:param completion:^(KGGResponseObj *responseObj) {
        if (!responseObj) {
            [MBProgressHUD showSuYaError:KGGHttpNerworkErrorTip toView:weakself.view];
        }else if (responseObj.code != KGGSuccessCode){
            [MBProgressHUD showError:responseObj.message toView:weakself.view];
        }else{
            [MBProgressHUD showMessag:@"注册成功请登录"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            });
        }
        
    } aboveView:self.view inCaller:self];
}

- (void)kgg_userAgreenMessage
{
    KGGLog(@"用户协议");
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
