//
//  KGGCollectViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/11/3.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGCollectViewCell.h"
#import "KGGCustomInfoItem.h"
#import "UITextField+KGGExtension.h"

static NSString *collectViewCell = @"collectViewCell";
@interface KGGCollectViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation KGGCollectViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.collectTextField.delegate = self;
}

- (void)setInfoItem:(KGGCustomInfoItem *)infoItem
{
    _infoItem = infoItem;
    self.titleLabel.text = infoItem.title;
    self.collectTextField.placeholder = infoItem.placeholder;
    self.collectTextField.text = infoItem.subtitle;
    self.collectTextField.keyboardType = infoItem.keyboardType;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!self.infoItem.editabled) return;
    [KGGNotificationCenter addObserver:self selector:@selector(textFiledEditChanged:)name:UITextFieldTextDidChangeNotification object:textField];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (!self.infoItem.editabled) return;
    self.infoItem.subtitle = textField.text;
    [KGGNotificationCenter removeObserver:self];
    
}
-(void)textFiledEditChanged:(NSNotification *)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    
    NSInteger maxLength = self.infoItem.maxTextLength;
    
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([self.infoItem.title isEqualToString:@"姓名"]) {
        if (textField.text.length > 10) {
            return YES;
        }
    }
    if (![self.infoItem.title isEqualToString:@"微信号"]) return YES;
    
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}


+ (NSString *)collectIdentifier
{
    return collectViewCell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
