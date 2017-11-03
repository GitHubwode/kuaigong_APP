//
//  KGGCollectFooterView.m
//  kuaigong
//
//  Created by Ding on 2017/11/3.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGCollectFooterView.h"

@interface KGGCollectFooterView ()<UITextViewDelegate>


@end

@implementation KGGCollectFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatFooterView];
    }
    return self;
}

- (void)creatFooterView
{
    weakSelf(self);
    UILabel *label = [UILabel new];
    label.text = @"现住址:";
    label.font = KGGFont(18);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor =UIColorHex(0xffffff);
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left).offset(15);
        make.top.equalTo(weakself.mas_top);
    }];
    
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.mas_top);
        make.left.equalTo(label.mas_right).offset(15);
        make.right.equalTo(weakself.mas_right).offset(-15);
        make.height.equalTo(@110);
    }];
    
}

#pragma mark - UITextView

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [KGGNotificationCenter addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    KGGLog(@"textView.text:%@",textView.text);
    self.textView.text = textView.text;
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
        [self.textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    if ([[textView textInputMode] primaryLanguage] == nil || [[[textView textInputMode]primaryLanguage]isEqualToString:@"emoji"]) {
        return NO;
    }
    
//    UITextRange *selectedRange = [textView markedTextRange];
//    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
//    if (selectedRange && pos) {
//        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
//        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
////        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
////        if (offsetRange.location < self.maxLenght) {
////            return YES;
////        }else{
//            KGGLog(@"字数");
////
//            return YES;
////        }
//    }
    
    return YES;
}

#pragma mark -  UITextView懒加载
- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = KGGFont(14);
        [_textView setTintColor:KGGGoldenThemeColor];
        _textView.textColor = UIColorHex(0xffffff);
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.scrollEnabled = YES;
        _textView.delegate = self;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 5.f;
        _textView.backgroundColor = UIColorHex(0x9d9d9d);
    }
    return _textView;
}


@end
