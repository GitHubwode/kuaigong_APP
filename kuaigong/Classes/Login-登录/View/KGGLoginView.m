//
//  KGGLoginView.m
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLoginView.h"
#import "KGGLoginRequestManager.h"
#import "KGGLoginParam.h"

@interface KGGLoginView ()<UITextFieldDelegate>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeTitle;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *sendCodeButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *imagessString;

@end

@implementation KGGLoginView

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title imageString:(NSString *)imageString PlaceText:(NSString *)placeText{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.placeTitle = placeText;
        self.loginTextField.tintColor = KGGGoldenThemeColor;
        self.imagessString = imageString;
        self.imageView.image = [UIImage imageNamed:imageString];
        [self setupLoginTextFieldUI];
        [KGGNotificationCenter addObserver:self selector:@selector(textFieldTextChanged:)name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark - UITextFieldTextDidChangeNotification
-(void)textFieldTextChanged:(NSNotification *)noti{
    
    if (!_maxTextLength) _maxTextLength = NSUIntegerMax;
    
    NSString *toBeString = self.loginTextField.text;
    
    NSString *lang = [[self textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self.loginTextField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self.loginTextField positionFromPosition:selectedRange.start offset:0];
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        if (position) return;
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (toBeString.length <= _maxTextLength) return;
        
        self.loginTextField.text = [toBeString substringToIndex:_maxTextLength];
        
    }else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length <= _maxTextLength) return;
        self.loginTextField.text = [toBeString substringToIndex:_maxTextLength];
    }
}

/**
 *  调用时刻 : 成为第一响应者(开始编辑\弹出键盘\获得焦点)
 */

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.loginTextField resignFirstResponder];
    return NO;
}

- (BOOL)becomeFirstResponder
{
    self.lineView.backgroundColor = KGGGoldenThemeColor;
    
    
    BOOL isResponder = [super becomeFirstResponder];
    
    if (self.containCodeButton) [self bringSubviewToFront:self.sendCodeButton];
    
    return isResponder;
}

/**
 *  调用时刻 : 不做第一响应者(结束编辑\退出键盘\失去焦点)
 */
- (BOOL)resignFirstResponder
{
    self.lineView.backgroundColor = UIColorHex(aaaaaa);
    return [super resignFirstResponder];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (self.containCodeButton) {
        self.sendCodeButton.xc_width = KGGAdaptedWidth(75);
        self.sendCodeButton.xc_height = KGGAdaptedWidth(25);
        self.sendCodeButton.xc_centerY = self.xc_height * 0.5;
        self.sendCodeButton.xc_right = self.xc_width - KGGAdaptedWidth(30);
    }
    if (self.isPhoneNum) {
        self.loginTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    if (self.isPassWord) {
        self.loginTextField.secureTextEntry = YES;
    }
}

#pragma mark - private
- (void)sendCodeButtonAction:(UIButton *)sender{
    
    if ([self.codeDelegate respondsToSelector:@selector(textFieldShouldSendCode:)] && ![self.codeDelegate textFieldShouldSendCode:self]) return;
    
    NSString *cellphone = [self.codeDelegate textFieldCanSendCode:self];
    NSString *codeType = [self.codeDelegate codeType];

    long time1 = [[NSString publishSetUpNowTime] longLongValue];
    
    NSString *sig = [NSString stringWithFormat:@"%@%@%ld%@",cellphone,codeType,time1,KGGAesKey];
    NSString *sig1 = [sig md5String];
    
    KGGSMSCodeParam *param = [[KGGSMSCodeParam alloc]initWithPhone:cellphone Type:codeType Timestamp:time1 Signature:sig1];
    
    UIView *view = [self.codeDelegate hudView];
    weakSelf(view);
    [view showHUD];
    
    [KGGLoginRequestManager sendVerificationCodeToCellParam:param completion:^(KGGResponseObj *responseObj) {
        [weakview hideHUD];

        if (!responseObj) {
            [MBProgressHUD showMessag:KGGHttpNerworkErrorTip toView:weakview];
        }else if (responseObj.code != KGGSuccessCode){
            [MBProgressHUD showMessag:responseObj.message toView:weakview];
        }else{
            [sender startWithTime:60 title:@"获取验证码" subTitle:@"秒后重发" normalBackgroundColor:KGGGoldenThemeColor coundownBackgroundColor:UIColorHex(c3c3c3) completion:nil];
        }

    } inCaller:self];

}


- (void)setupLoginTextFieldUI
{
    if (self.title == nil) {
        self.titleLabel.hidden = YES;
    }
    if (self.imagessString == nil) {
        self.imageView.hidden = YES;
    }
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.loginTextField];
    [self addSubview:self.lineView];
    [self addSubview:self.imageView];
    weakSelf(self);
    
    self.titleLabel.text = self.title;
    self.loginTextField.placeholder = self.placeTitle;

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left).offset(30);
        make.centerY.equalTo(weakself.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@(KGGAdaptedHeight(44)));
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left).offset(30);
        make.centerY.equalTo(weakself.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@18);
    }];
    
    
    [self.loginTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLabel.mas_right);
        make.right.equalTo(weakself.mas_right).offset(-30);
        make.height.equalTo(@(KGGAdaptedHeight(44)));
        make.centerY.equalTo(weakself.titleLabel.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.mas_bottom).offset(-1);
        make.left.equalTo(weakself.mas_left).offset(30);
        make.right.equalTo(weakself.mas_right).offset(-30);
        make.height.equalTo(@(KGGOnePixelHeight));
    }];
}

#pragma mark - lazy
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = UIColorHex(0x000000);
        _titleLabel.font = KGGLightFont(18);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _imageView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorHex(0xb2b2b2);
    }
    return _lineView;
}

- (UITextField *)loginTextField
{
    if (!_loginTextField) {
        _loginTextField = [[UITextField alloc]init];
        _loginTextField.delegate = self;
        _loginTextField.font = KGGLightFont(18);
        _loginTextField.tintColor = KGGGoldenThemeColor;
        _loginTextField.returnKeyType = UIReturnKeyDone;
        _loginTextField.borderStyle = UITextBorderStyleNone;
    }
    return _loginTextField;
}

- (UIButton *)sendCodeButton{
    if (!_sendCodeButton) {
        UIButton *sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendCodeButton.titleLabel.font = KGGLightFont(12);
        sendCodeButton.backgroundColor = KGGGoldenThemeColor;
        sendCodeButton.layer.cornerRadius = 5.f;
        sendCodeButton.clipsToBounds = YES;
        [sendCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [sendCodeButton addTarget:self action:@selector(sendCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:sendCodeButton];
        self.sendCodeButton = sendCodeButton;
    }
    return _sendCodeButton;
}
@end


