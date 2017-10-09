//
//  KGGForgetPasswordViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGForgetPasswordViewController.h"
#import "KGGLoginView.h"

@interface KGGForgetPasswordViewController ()<KGGLoginViewDelegate>

@property (nonatomic, strong) KGGLoginView *loginView1;
@property (nonatomic, strong) KGGLoginView *loginView2;
@property (nonatomic, strong) KGGLoginView *loginView3;
@property (nonatomic, strong) KGGLoginView *loginView4;
@property (nonatomic, strong) UIButton *completeButton;

@end

@implementation KGGForgetPasswordViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(0xffffff);
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 设置点击空白区域键盘收回
    [self setupForDismissKeyboard];
    [self creatNaviUI];
    [self creatUI];

}

#pragma mark - 键盘显示隐藏
- (void)keyboardWillShow:(NSNotification *)notification
{
    //取出键盘最后的 frame
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat height = keyboardFrame.origin.y;
    //计算控制器 view 需要移动的距离
    CGFloat textField_maxY = -30;
    if ([self.loginView3.loginTextField isFirstResponder] || [self.loginView4.loginTextField isFirstResponder]) {
        CGFloat space = textField_maxY+kMainScreenHeight;
        //得出键盘输入框的间距
        CGFloat transformY = height- space;
        if (transformY < 0) {
            CGRect frame = self.view.frame;
            frame.origin.y = transformY;
            self.view.frame = frame;
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    //恢复到默认y为0的状态，有时候要考虑导航栏要+64
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [KGGNotificationCenter removeObserver:self];
}

- (void)dealloc{
    [KGGNotificationCenter removeObserver:self];
    KGGLogFunc
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
    self.loginView2.containCodeButton = YES;
    self.loginView2.codeDelegate = self;
    self.loginView3 = [[KGGLoginView alloc]initWithFrame:CGRectMake(0, KGGAdaptedHeight(220+44+32+44+33), kMainScreenWidth, 44) WithTitle:nil imageString:@"icon_mima" PlaceText:@" 请输入新密码"];
    self.loginView3.isPassWord = YES;
    
    self.loginView4 = [[KGGLoginView alloc]initWithFrame:CGRectMake(0, KGGAdaptedHeight(220+44+32+44+32+44+32), kMainScreenWidth, 44) WithTitle:nil imageString:@"icon_mima" PlaceText:@" 请输入新密码"];
    self.loginView4.isPassWord = YES;
    
    [self.view addSubview:self.loginView1];
    [self.view addSubview:self.loginView2];
    [self.view addSubview:self.loginView3];
    [self.view addSubview:self.loginView4];
    
    
    UIButton *loginButton = [[UIButton alloc]init];
    [loginButton addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"but_kean"] forState:UIControlStateNormal];
    [loginButton setTitle:@"完成" forState:UIControlStateNormal];
    [loginButton setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    loginButton.titleLabel.font = KGGLightFont(18);
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(weakself.loginView4.mas_bottom).offset(15);
        make.width.equalTo(@(kMainScreenWidth-60));
        make.height.equalTo(@(KGGLoginButtonHeight));
    }];
}


#pragma mark - 模拟导航栏
- (void)creatNaviUI
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 44)];
    label.text = self.itemTitle;
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

#pragma mark - KGGLoginViewDelegate
- (NSString *)textFieldCanSendCode:(KGGLoginView *)textField
{
    return self.loginView1.loginTextField.text;
}

- (NSString *)codeType
{
    return @"EDIT_LOGIN_PWD";
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
    
    return YES;
}

- (UIView *)hudView{
    return self.loginView1;
}



#pragma mark - 按钮的点击事件
- (void)kgg_dissmissViewController
{
//    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginButton:(UIButton *)sender
{
    KGGLog(@"完成更改密码");
    
    NSString *cellphone = self.loginView1.loginTextField.text;
    if (!cellphone.length){
        [MBProgressHUD showMessag:@"请填写手机号码"];
        return;
    };
    
    NSString *containCode = self.loginView2.loginTextField.text;
    if (!containCode.length){
        [MBProgressHUD showMessag:@"请填写验证码"];
        return;
    }
    
    NSString *pwd1 = self.loginView3.loginTextField.text;
    if (!pwd1.length){
        [MBProgressHUD showMessag:@"请填写密码"];
        return;
    }
    
    NSString *pwd2 = self.loginView3.loginTextField.text;
    if (!pwd2.length){
        [MBProgressHUD showMessag:@"请填写确认密码"];
        return;
    }
    
    if (pwd1.length < KGGPasswordMinLength && pwd2.length < KGGPasswordMaxLength){
        [MBProgressHUD showMessag:[NSString stringWithFormat:@"密码不能小于%zd位",KGGPasswordMinLength]];
        return;
    }
    
    // 1.对用户密码是否相等
    BOOL isSame = [pwd1 isEqualToString:pwd2];
    if (!isSame){ // 不相等
        [MBProgressHUD showMessag:@"请检查密码是否一样"];
        return;
    }
    
    // 1.对用户输入的手机号进行正则匹配
    BOOL isMatch = [cellphone isPhoneNumer];
    // 2.对不同的匹配结果做处理
    if (!isMatch){ // 不是正规的手机号码
        [MBProgressHUD showMessag:@"请输入正确格式的手机号码"];
        return;
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
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
