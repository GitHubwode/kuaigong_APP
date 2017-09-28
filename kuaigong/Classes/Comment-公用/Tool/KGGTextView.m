//
//  KGGTextView.m
//  kuaigong
//
//  Created by Ding on 2017/8/23.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGTextView.h"

@interface KGGTextView ()

@property (nonatomic, weak) UILabel *placeholderLabel;


@end

@implementation KGGTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    [self setUp];
    return self;
}

- (void)setUp {
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_placeholderLabel = placeholderLabel];
    
    self.kgg_placeholderColor = [UIColor lightGrayColor];
    self.kgg_placeholderFont = [UIFont systemFontOfSize:16.0f];
    self.font = [UIFont systemFontOfSize:16.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark - UITextViewTextDidChangeNotification

- (void)textDidChange {
    self.placeholderLabel.hidden = self.hasText;
}


- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

- (void)setKgg_placeholderFont:(UIFont *)kgg_placeholderFont
{
    _kgg_placeholderFont = kgg_placeholderFont;
    self.placeholderLabel.font = kgg_placeholderFont;
    [self setNeedsLayout];
}

- (void)setKgg_placeholder:(NSString *)kgg_placeholder
{
    _kgg_placeholder = [kgg_placeholder copy];
    self.placeholderLabel.text = kgg_placeholder;
    [self setNeedsLayout];
}

- (void)setKgg_placeholderColor:(UIColor *)kgg_placeholderColor
{
    _kgg_placeholderColor = kgg_placeholderColor;
    self.placeholderLabel.textColor = kgg_placeholderColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.placeholderLabel.frame;
    frame.origin.y = self.textContainerInset.top;
    frame.origin.x = self.textContainerInset.left+6.0f;
    frame.size.width = self.frame.size.width - self.textContainerInset.left*2.0;
    
    CGSize maxSize = CGSizeMake(frame.size.width, MAXFLOAT);
    frame.size.height = [self.kgg_placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size.height;
    self.placeholderLabel.frame = frame;
}

- (void)dealloc
{
    [KGGNotificationCenter removeObserver:UITextViewTextDidChangeNotification];
}



@end
