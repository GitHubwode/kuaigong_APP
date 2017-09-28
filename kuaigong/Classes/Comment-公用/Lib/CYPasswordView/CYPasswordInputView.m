//
//  CYPasswordInputView.m
//  CYPasswordViewDemo
//
//  Created by cheny on 15/10/8.
//  Copyright © 2015年 zhssit. All rights reserved.
//

#import "CYPasswordInputView.h"
#import "CYConst.h"
#import "UIView+Extension.h"

#define kNumCount 6

@interface CYPasswordInputView ()

/** 保存用户输入的数字集合 */
@property (nonatomic, strong) NSMutableArray *inputNumArray;
/** 关闭按钮 */
@property (nonatomic, weak) UIButton *btnClose;
/** 忘记密码 */
@property (nonatomic, weak) UIButton *btnForgetPWD;

@end

@implementation CYPasswordInputView

#pragma mark  - 生命周期方法
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        /** 注册通知 */
        [self setupNotification];
        /** 添加子控件 */
        [self setupSubViews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置关闭按钮的坐标
    self.btnClose.width = CYPasswordViewCloseButtonWH;
    self.btnClose.height = CYPasswordViewCloseButtonWH;
    self.btnClose.x = CYPasswordViewCloseButtonMarginLeft;
    self.btnClose.centerY = CYPasswordViewTitleHeight * 0.5;

    // 设置忘记密码按钮的坐标
    self.btnForgetPWD.xc_x = CYScreenWith - (CYScreenWith - KGGAdaptedWidth(CYPasswordViewTextFieldWidth)) * 0.5 - self.btnForgetPWD.xc_width;
    self.btnForgetPWD.y = CYPasswordViewTitleHeight + CYPasswordViewTextFieldMarginTop + 15.f + CYPasswordViewTextFieldMarginTop + KGGAdaptedHeight(CYPasswordViewTextFieldHeight) + CYPasswordViewForgetPWDButtonMarginTop;
    if (!self.subtitle.length) {
        self.btnForgetPWD.y -= 15.f;
    }
    
}

- (void)dealloc
{
    CYLog(@"cy =========== %@：我走了", [self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 添加子控件 */
- (void)setupSubViews
{
    /** 关闭按钮 */
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnCancel];
    [btnCancel setImage:[UIImage imageNamed:@"icon_canclepay"] forState:UIControlStateNormal];
    
    
    [btnCancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.btnClose = btnCancel;
    [self.btnClose addTarget:self action:@selector(btnClose_Click:) forControlEvents:UIControlEventTouchUpInside];

    /** 忘记密码按钮 */
    UIButton *btnForgetPWD = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnForgetPWD];
    [btnForgetPWD setTitle:@"忘记密码" forState:UIControlStateNormal];
    [btnForgetPWD setTitleColor:KGGGoldenThemeColor forState:UIControlStateNormal];
    btnForgetPWD.titleLabel.font = CYFont(13);
    [btnForgetPWD sizeToFit];
    self.btnForgetPWD = btnForgetPWD;
    [self.btnForgetPWD addTarget:self action:@selector(btnForgetPWD_Click:) forControlEvents:UIControlEventTouchUpInside];
}

/** 注册通知 */
- (void)setupNotification {
    // 用户按下删除键通知
    [CYNotificationCenter addObserver:self selector:@selector(delete) name:CYPasswordViewDeleteButtonClickNotification object:nil];
    // 用户按下数字键通知
    [CYNotificationCenter addObserver:self selector:@selector(number:) name:CYPasswordViewNumberButtonClickNotification object:nil];
    [CYNotificationCenter addObserver:self selector:@selector(disEnalbeCloseButton:) name:CYPasswordViewDisEnabledUserInteractionNotification object:nil];
    [CYNotificationCenter addObserver:self selector:@selector(disEnalbeCloseButton:) name:CYPasswordViewEnabledUserInteractionNotification object:nil];
}

// 按钮点击
- (void)btnClose_Click:(UIButton *)sender {
    [CYNotificationCenter postNotificationName:CYPasswordViewCancleButtonClickNotification object:self];
    [self.inputNumArray removeAllObjects];
}

- (void)btnForgetPWD_Click:(UIButton *)sender {
    [CYNotificationCenter postNotificationName:CYPasswordViewForgetPWDButtonClickNotification object:self];
}

- (void) disEnalbeCloseButton:(NSNotification *)notification{
    BOOL flag = [[notification.object valueForKeyPath:@"enable"] boolValue];
    self.btnClose.userInteractionEnabled = flag;
    self.btnForgetPWD.userInteractionEnabled = flag;
}

- (void)drawRect:(CGRect)rect {
    // 画图
    // 背景
    UIImage *imgBackground = [UIImage imageNamed:@"icon_button_default"];
    [imgBackground drawInRect:rect];
    // 标题背景
    UIImage *imgTitleBackground = [UIImage imageNamed:@"icon_navigation"];
    [imgTitleBackground drawInRect:CGRectMake(0, 0, CYScreenWith, CYPasswordViewTitleHeight)];
    // 画标题
    NSString *title = self.title ? self.title : @"输入交易密码";
    
    NSDictionary *arrts = @{NSFontAttributeName:CYFont(16)};
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:arrts context:nil].size;
    CGFloat titleW = size.width;
    CGFloat titleH = size.height;
    CGFloat titleX = (self.width - titleW) * 0.5;
    CGFloat titleY = (CYPasswordViewTitleHeight - titleH) * 0.5;
    CGRect titleRect = CGRectMake(titleX, titleY, titleW, titleH);
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = CYFont(16);
    attr[NSForegroundColorAttributeName] = KGGContentTextColor;
    [title drawInRect:titleRect withAttributes:attr];
    // 副标题
    arrts = @{NSFontAttributeName:CYFont(14)};
    size = [self.subtitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:arrts context:nil].size;
    CGFloat subtitleW = size.width;
    CGFloat subtitleH = size.height;
    CGFloat subtitleX = (self.width - subtitleW) * 0.5;
    CGFloat subtitleY = CYPasswordViewTitleHeight + CYPasswordViewTextFieldMarginTop;
    CGRect subtitleRect = CGRectMake(subtitleX, subtitleY, subtitleW, subtitleH);
    attr[NSFontAttributeName] = CYFont(14);
    attr[NSForegroundColorAttributeName] = KGGTimeTextColor;
    [_subtitle drawInRect:subtitleRect withAttributes:attr];
    
    
    UIImage *imgTextfield = [UIImage imageNamed:@"input_white"];
    CGFloat textfieldY = CGRectGetMaxY(subtitleRect) + CYPasswordViewTextFieldMarginTop;
    CGFloat textfieldW = KGGAdaptedWidth(CYPasswordViewTextFieldWidth);
    CGFloat textfieldX = (CYScreenWith - textfieldW) * 0.5;
    CGFloat textfieldH = KGGAdaptedHeight(CYPasswordViewTextFieldHeight);
    [imgTextfield drawInRect:CGRectMake(textfieldX, textfieldY, textfieldW, textfieldH)];


    // 画点
    UIImage *pointImage = [UIImage imageNamed:CYPasswordViewSrcName(@"password_point")];
    CGFloat pointW = CYPasswordViewPointnWH;
    CGFloat pointH = CYPasswordViewPointnWH;
    CGFloat pointY =  textfieldY + (textfieldH - pointH) * 0.5;
    __block CGFloat pointX;

    // 一个格子的宽度
    CGFloat cellW = textfieldW / kNumCount;
    CGFloat padding = (cellW - pointW) * 0.5;
    [self.inputNumArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        pointX = textfieldX + (2 * idx + 1) * padding + idx * pointW;
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }];
}

#pragma mark  - 懒加载
- (NSMutableArray *)inputNumArray {
    if (_inputNumArray == nil) {
        _inputNumArray = [NSMutableArray array];
    }
    return _inputNumArray;
}

#pragma mark  - 私有方法
// 响应用户按下删除键事件
- (void)delete {
    [self.inputNumArray removeLastObject];
    [self setNeedsDisplay];
}

// 响应用户按下数字键事件
- (void)number:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSString *numObj = userInfo[CYPasswordViewKeyboardNumberKey];
    if (numObj.length >= kNumCount) return;
    [self.inputNumArray addObject:numObj];
    [self setNeedsDisplay];
}

@end
