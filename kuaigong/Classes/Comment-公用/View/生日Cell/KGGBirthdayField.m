//
//  KGGBirthdayField.m
//  kuaigong
//
//  Created by Ding on 2017/12/7.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGBirthdayField.h"

@interface KGGBirthdayField ()
@property (nonatomic, weak) UIDatePicker *dateP;
@property (nonatomic, strong) NSString *selectedText;
@property (nonatomic, assign) BOOL isInitial;

@end

@implementation KGGBirthdayField

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

//初始化文字的方法
- (void)initialText{
    if (_isInitial == NO) {
        [self dateChange:self.dateP];
        _isInitial = YES;
    }
}

//初始化
- (void)setup
{
    self.borderStyle = UITextBorderStyleNone;
    //创建日期选择器
    UIDatePicker *dateP = [[UIDatePicker alloc]init];
    dateP.backgroundColor = [UIColor whiteColor];
    //设置日期模式,年月日
    dateP.datePickerMode = UIDatePickerModeDate;
    //设置地区 zh:中国标识
    dateP.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    dateP.maximumDate = [NSDate date];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    dateP.minimumDate = [fmt dateFromString:@"1900-01-01"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里设置成为自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式 2010-10-27 10:22:22
    dateP.minimumDate = [fmt dateFromString:currentDateStr];
    
    [dateP addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    self.dateP = dateP;
    //自定义文本框键盘
    self.inputView = dateP;
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

//只要UIDatePicker选中的时候调用
- (void)dateChange:(UIDatePicker *)picker
{
    //2015-09-06 yyyy-MM-dd
    //创建一个日期格式的字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"MM-dd HH:mm";
    self.selectedText = [fmt stringFromDate:picker.date];
}

- (void)ensureButtonAction
{
    self.text = self.selectedText;
    if ([self.birthdayDelegate respondsToSelector:@selector(ensureButtonClick)]) {
        [self.birthdayDelegate ensureButtonClick];
    }
    [self cancelButtonAction];
}

- (void)cancelButtonAction
{
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    [self initialText];
    return [super becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}


@end
