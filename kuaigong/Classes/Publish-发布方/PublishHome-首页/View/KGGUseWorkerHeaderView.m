//
//  KGGUseWorkerHeaderView.m
//  kuaigong
//
//  Created by Ding on 2017/8/23.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGUseWorkerHeaderView.h"

@interface KGGUseWorkerHeaderView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, assign) NSInteger maxLenght;


@end

@implementation KGGUseWorkerHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupUI
{
    weakSelf(self);
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = UIColorHex(0xffffff);
    [self addSubview:headerView];
    self.orderDetailLabel = [self creatLabelTitle:@""];
    self.orderTotalLabel = [self creatLabelTitle:@""];
    
    [headerView addSubview:self.orderDetailLabel];
    [headerView addSubview:self.orderTotalLabel];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.top.equalTo(weakself.mas_top);
        make.height.equalTo(@65);
        make.width.equalTo(@(kMainScreenWidth));
    }];
    
    [self.orderDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(15);
        make.top.equalTo(headerView.mas_top).offset(3);
        make.right.equalTo(headerView.mas_right).offset(-15);
        make.height.equalTo(@55);
    }];
    
    [self.orderTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-10);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
    
    
    
    UIView *orderRemark = [self sectionViewWithTitle:@"订单备注"];
    [self addSubview:orderRemark];
    
    [self addSubview:self.headerTextView];
    [self.headerTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderRemark.mas_bottom);
        make.left.equalTo(weakself.mas_left).offset(15);
        make.width.equalTo(@(kMainScreenWidth-30));
        make.height.equalTo(@96);
    }];
    
    [self.headerTextView addSubview:self.placeLabel];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.headerTextView.mas_left).offset(0);
        make.top.equalTo(weakself.headerTextView.mas_top).offset(10);
        make.width.equalTo(@(kMainScreenWidth-30));
        make.height.equalTo(@40);
    }];

}

#pragma mark - UITextView

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.placeLabel removeFromSuperview];
    [KGGNotificationCenter addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    KGGLog(@"textView.text:%@",textView.text);
    self.headerTextView.text = textView.text;
    [KGGNotificationCenter removeObserver:self];
}

- (void)textViewEditChanged:(NSNotification *)noti
{
    UITextView *textView = (UITextView *)noti.object;
//    NSInteger maxLength = self.infoItem.maxTextLength;
    NSInteger maxLength = 0;
    if (maxLength == 0) maxLength = NSIntegerMax;
    NSString *toBeString = textView.text;
    
    NSString *lang = [[textView textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        if (position) return;
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (toBeString.length <= maxLength) return;
        
        textView.text = [toBeString substringToIndex:maxLength];
        
    }else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length <= maxLength) return;
        textView.text = [toBeString substringToIndex:maxLength];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.headerTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    if ([[textView textInputMode] primaryLanguage] == nil || [[[textView textInputMode]primaryLanguage]isEqualToString:@"emoji"]) {
        return NO;
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < self.maxLenght) {
            return YES;
        }else{
            KGGLog(@"字数");

            return YES;
        }
    }
    
    return YES;
}

#pragma mark - lazyView

- (UILabel *)creatLabelTitle:(NSString *)title
{
    UILabel *label = [UILabel new];
    label.text = title;
    label.numberOfLines = 0;
    label.textColor = UIColorHex(0x333333);
    label.font = KGGFont(14);
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (UIView *)sectionViewWithTitle:(NSString *)title
{
    UIView *view = [UIView new];
    view.backgroundColor = KGGViewBackgroundColor;
    view.frame = CGRectMake(0, 65, kMainScreenWidth, 33);
    UILabel *label = [UILabel new];
    label.text = title;
    label.textColor = UIColorHex(0x333333);
    label.font = KGGFont(14);
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(@15.f);
    }];

    return view;
}

- (UITextView *)headerTextView
{
    if (!_headerTextView) {
        _headerTextView = [[UITextView alloc]init];
        _headerTextView.font = KGGFont(14);
        _headerTextView.textColor = UIColorHex(0x333333);
        _headerTextView.textAlignment = NSTextAlignmentLeft;
        _headerTextView.returnKeyType = UIReturnKeyDone;
        _headerTextView.scrollEnabled = YES;
        _headerTextView.delegate = self;
    }
    return _headerTextView;
}

- (UILabel *)placeLabel
{
    if (!_placeLabel) {
        _placeLabel = [UILabel new];
        _placeLabel.text = @"简单介绍一些需求:如需要带什么工具,需要技术熟练,要不要女工......";
        _placeLabel.font = KGGFont(14);
        _placeLabel.numberOfLines = 0;
        _placeLabel.textAlignment = NSTextAlignmentLeft;
        _placeLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
    }
    return _placeLabel;
}


@end
