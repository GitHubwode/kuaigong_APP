//
//  KGGPersonNameEditController.m
//  kuaigong
//
//  Created by Ding on 2017/10/19.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPersonNameEditController.h"
#import "KGGPublishPersonModel.h"
#import "UITextField+KGGExtension.h"
#import "KGGLoginRequestManager.h"


@interface KGGPersonNameEditController ()<UITextFieldDelegate>
@property (nonatomic, strong) KGGPublishPersonModel *item;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation KGGPersonNameEditController

- (instancetype)initWithInfoItem:(KGGPublishPersonModel *)item currentUser:(KGGUserObj *)user
{
    self = [super init];
    if (self) {
        _item = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KGGViewBackgroundColor;
    [self setUpNavi];
    [self setUpSubViws];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - setUp
- (void)setUpNavi{
    
    self.navigationItem.title = @"编辑昵称";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"取消" target:self action:@selector(cancelEdit)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButtonTitle:@"完成" target:self action:@selector(completeEdit)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)cancelEdit{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)completeEdit{
    
    [self.view endEditing:YES];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;

    NSString *text = self.textField.text;
    
    [KGGLoginRequestManager updataUserNameNickString:text Sex:nil completion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            [MBProgressHUD showSuYaSuccess:@"修改成功" toView:nil];
            
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.completionHandler) {
                    self.completionHandler();
                }
            }];
        }
 
    } aboveView:self.view inCaller:self];
}

- (void)setUpSubViws
{
    UIView *toplineView = [UIView new];
    toplineView.backgroundColor = KGGSeparatorColor;
    [self.view addSubview:toplineView];
    [toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(KGGSmallMargin);
        make.height.mas_equalTo(KGGOnePixelHeight);
    }];
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toplineView.mas_bottom);
        make.height.mas_equalTo(KGGItemHeight);
        make.left.right.equalTo(self.view);
    }];
    
    UIView *bottomlineView = [UIView new];
    bottomlineView.backgroundColor = KGGSeparatorColor;
    [self.view addSubview:bottomlineView];
    [bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(KGGOnePixelHeight);
        make.top.equalTo(contentView.mas_bottom);
    }];
    
    
    _textField = [[UITextField alloc]init];
    _textField.textColor = KGGContentTextColor;
    _textField.font = KGGFont(15);
    _textField.tintColor = KGGGoldenThemeColor;
    _textField.text = _item.subTitle;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    [contentView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).with.offset(KGGLeftPadding);
        make.right.equalTo(contentView).with.offset(-KGGRightPadding);
        make.top.bottom.equalTo(contentView);
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [KGGNotificationCenter addObserver:self selector:@selector(textFiledEditChanged)name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [KGGNotificationCenter removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (![self.item.title isEqualToString:@"昵称"]) return YES;
    
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
        
    }
    return YES;
}


-(void)textFiledEditChanged{
    
    UITextField *textField = self.textField;
    
    self.navigationItem.rightBarButtonItem.enabled = ![textField.text isEqualToString:_item.subTitle];
    if (textField.text.length==0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    
    NSInteger maxLength = 20;
    if (maxLength == 0) maxLength = NSIntegerMax;
    NSString *toBeString = textField.text;
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        if (position) return;
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (toBeString.length <= maxLength) return;
        
        textField.text = [toBeString substringToIndex:maxLength];
        
    }else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length <= maxLength) return;
        textField.text = [toBeString substringToIndex:maxLength];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



- (void)dealloc{
    KGGLogFunc
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
