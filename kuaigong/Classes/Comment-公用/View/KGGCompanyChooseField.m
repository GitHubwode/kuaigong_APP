//
//  KGGCompanyChooseField.m
//  kuaigong
//
//  Created by Ding on 2017/11/12.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGCompanyChooseField.h"

@interface KGGCompanyChooseField ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, weak)UIPickerView *pickView;
//是否初始化
/** <#name#> */
@property (nonatomic,assign) BOOL  isInitial;
/**  */
@property (nonatomic,strong)NSString *selectedText;

@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation KGGCompanyChooseField

- (void)initiaText
{
    if (_isInitial == NO) {
        [self pickerView:self.pickView didSelectRow:0 inComponent:0];
        _isInitial = YES;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

//初始化
- (void)setup
{
    self.borderStyle = UITextBorderStyleNone;
    //创建pickerView
    UIPickerView *pickerView = [[UIPickerView alloc]init];
    pickerView.backgroundColor = [UIColor whiteColor];
    _pickView = pickerView;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    //自定义文本输入框
    self.inputView = pickerView;
    
    UIView *toolbar = [UIView new];
    toolbar.backgroundColor = UIColorHex(0xf8f9f9);
    toolbar.xc_height = KGGItemHeight;
    self.inputAccessoryView = toolbar;
    
    UIView *toplineView = [UIView new];
    toplineView.backgroundColor = KGGSeparatorColor;
    [toolbar addSubview:toplineView];
    [toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(toolbar);
        make.height.mas_equalTo(KGGOnePixelHeight);
    }];
    
    UIView *bottomlineView = [UIView new];
    bottomlineView.backgroundColor = KGGSeparatorColor;
    [toolbar addSubview:bottomlineView];
    [bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(toolbar);
        make.height.mas_equalTo(KGGOnePixelHeight);
    }];
    
    UIButton *ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ensureButton.titleLabel.font = KGGRegularFont(16);
    [ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    [ensureButton addTarget:self action:@selector(ensureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [ensureButton setTitleColor:KGGGoldenThemeColor forState:UIControlStateNormal];
    [toolbar addSubview:ensureButton];
    [ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolbar);
        make.right.equalTo(toolbar).with.offset(-KGGRightPadding);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.font = KGGRegularFont(16);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:KGGTimeTextColor forState:UIControlStateNormal];
    [toolbar addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolbar);
        make.left.equalTo(toolbar).with.offset(KGGLeftPadding);
    }];
    
}

- (void)ensureButtonAction{
    self.text = self.selectedText;
    if ([self.companyDelegate respondsToSelector:@selector(companyChooseFieldFieldEnsureButtonClickText:)]) {
        [self.companyDelegate companyChooseFieldFieldEnsureButtonClickText:self.text];
    }
    [self cancelButtonAction];
}

- (void)cancelButtonAction{
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder{
    [self initiaText];
    return [super becomeFirstResponder];
}


- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.datasource.count;
}

// 返回每一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.datasource[row];
}


// 选中某一行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectedText = self.datasource[row];
}

#pragma mark - lazy

-(NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray arrayWithObjects:@"Hangzhou001",@"Jiaxing002",@"Wenzhou003",@"Jinhua004", nil];
    }
    return _datasource;
}


@end
