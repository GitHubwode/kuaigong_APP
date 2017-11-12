//
//  KGGCompanyView.m
//  kuaigong
//
//  Created by Ding on 2017/11/12.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGCompanyView.h"
#import "KGGCompanyChooseField.h"

@interface KGGCompanyView()<KGGCompanyChooseFieldDelegate>


@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeTitle;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *sendCodeButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *imagessString;

@end

@implementation KGGCompanyView

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title imageString:(NSString *)imageString PlaceText:(NSString *)placeText{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.placeTitle = placeText;
        self.textField.tintColor = KGGGoldenThemeColor;
        self.imagessString = imageString;
        self.imageView.image = [UIImage imageNamed:imageString];
        [self setupLoginTextFieldUI];
    }
    return self;
}

- (void)companyChooseFieldFieldEnsureButtonClickText:(NSString *)text
{
    if ([self.companyDelegate respondsToSelector:@selector(textFieldCompanyName:)]) {
        [self.companyDelegate textFieldCompanyName:text];
    }
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
    [self addSubview:self.textField];
    [self addSubview:self.lineView];
    [self addSubview:self.imageView];
    weakSelf(self);
    
    self.titleLabel.text = self.title;
    self.textField.placeholder = self.placeTitle;
    
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
    
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (KGGCompanyChooseField *)textField
{
    if (!_textField) {
        _textField = [[KGGCompanyChooseField alloc]init];
        _textField.companyDelegate = self;
    }
    return _textField;
}

@end
