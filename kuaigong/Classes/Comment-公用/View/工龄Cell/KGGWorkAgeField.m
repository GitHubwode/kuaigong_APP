//
//  KGGWorkAgeField.m
//  kuaigong
//
//  Created by Ding on 2017/12/8.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGWorkAgeField.h"

@interface KGGWorkAgeField ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, weak) UIPickerView *pickView;
@property (nonatomic, strong) NSString *selectedText;
@property (nonatomic, assign) BOOL isInitial;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation KGGWorkAgeField

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

- (void)setup
{
    self.borderStyle = UITextBorderStyleNone;
    //创建pickView
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

- (void)ensureButtonAction
{
    
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35", nil];
    }
    return _datasource;
}


@end
