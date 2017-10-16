//
//  KGGApplyVIPView.m
//  kuaigong
//
//  Created by Ding on 2017/10/12.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGApplyVIPView.h"

@interface KGGApplyVIPView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *nowReButton;//立即充值
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIImageView *peopleImageView;
@property (nonatomic, strong) UIButton *VIPButton;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, copy) NSString *moneyString;


@end

@implementation KGGApplyVIPView
{
    UIButton    *_button1;
    UIButton    *_button2;
    UIButton    *_button3;
    UIButton    *_button4;
    UIView      *_middleView;
}

+ (instancetype)kgg_alertPromptApplyForViewKGGApplyButtonClick:(kggApplyButton )apply_Button KGGUnderstandButtonClick:(kggKnowButton )know_Button
{
    KGGApplyVIPView *applyView = [[KGGApplyVIPView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    applyView.backgroundColor = [UIColor clearColor];
    applyView.apply_Button = apply_Button;
    applyView.know_Button = know_Button;
    return applyView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.moneyString = @"399";
        [self setUpUIView];
    }
    return self;
}

#pragma mark - 初始化UI界面
-  (void)setUpUIView
{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    self.bgView = [[UIApplication sharedApplication].delegate window];
    
    weakSelf(self);
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    self.view1 = view1;
    view1.backgroundColor = KGGColorA(0, 0, 0, 75);
    [self.bgView addSubview:view1];
    
    UIView *topView = [UIView new];
    [view1 addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.centerY.equalTo(weakself.mas_centerY);
        make.width.equalTo(@(kMainScreenWidth-KGGAdaptedWidth(60)));
        make.height.equalTo(@(kMainScreenHeight-KGGAdaptedHeight(254)));
    }];
    
    self.bottomView = [UIView new];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.layer.masksToBounds = NO;
    self.bottomView.layer.cornerRadius = 25.f;
    [view1 addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left);
        make.bottom.equalTo(topView.mas_bottom);
        make.top.equalTo(topView.mas_top).offset(KGGAdaptedHeight(80));
        make.width.equalTo(topView.mas_width);
    }];
    
    self.peopleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-man"]];
    [self.bottomView addSubview:self.peopleImageView];
    [self.peopleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(topView.mas_leading);
        make.top.equalTo(topView.mas_top);
    }];
    
    [topView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-8);
        make.bottom.equalTo(weakself.bottomView.mas_top).offset(-10);
    }];
    
    [self.bottomView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.peopleImageView.mas_bottom);
        make.centerX.equalTo(weakself.bottomView.mas_centerX).offset(20);
    }];
    
    [self.bottomView addSubview:self.VIPButton];
    [self.VIPButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.messageLabel.mas_centerX);
        make.top.equalTo(weakself.bottomView.mas_top).offset(23);
    }];
    
    [self.bottomView addSubview:self.nextButton];
//    self.nextButton.backgroundColor = [UIColor redColor];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.bottomView.mas_centerX);
        make.bottom.equalTo(weakself.bottomView.mas_bottom).offset(-10);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];
    
    [self.bottomView addSubview:self.nowReButton];
    [self.nowReButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.bottomView.mas_centerX);
        make.bottom.equalTo(weakself.nextButton.mas_top).offset(-10);
        make.width.equalTo(@200);
        make.height.equalTo(@45);
    }];
    
    _middleView = [UIView new];
    [self.bottomView addSubview:_middleView];
//    _middleView.backgroundColor = [UIColor yellowColor];
    [_middleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.bottomView.mas_left);
        make.top.equalTo(weakself.peopleImageView.mas_bottom);
        make.bottom.equalTo(weakself.nowReButton.mas_top);
        make.width.equalTo(weakself.bottomView.mas_width);
    }];
    
    [self rewardBackUI];

}

- (void)rewardBackUI
{
//    weakSelf(self);
    CGFloat buttonWidth = (kMainScreenWidth-KGGAdaptedWidth(60)-2*KGGAdaptedWidth(20)-3*KGGAdaptedWidth(15))/4;
    CGFloat buttonHeight = KGGAdaptedWidth(57.5);

    _button1 = [self snh_buttonTag:10000 Image:@"btn1_chosed"];
    [_middleView addSubview:_button1];
    
    _button2 = [self snh_buttonTag:10001 Image:@"btn2"];
    [_middleView addSubview:_button2];
    
    _button3 = [self snh_buttonTag:10002 Image:@"btn3"];
    [_middleView addSubview:_button3];
    
    _button4 = [self snh_buttonTag:10003 Image:@"btn4"];
    [_middleView addSubview:_button4];
    
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_middleView.mas_centerY);
        make.left.equalTo(_middleView.mas_left).offset(KGGAdaptedWidth(20));
        make.height.equalTo(@(buttonHeight));
        make.width.equalTo(@(buttonWidth));
    }];
    
        [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_button1.mas_centerY);
            make.left.equalTo(_button1.mas_right).offset(KGGAdaptedWidth(15));
            make.height.equalTo(@(buttonHeight));
            make.width.equalTo(@(buttonWidth));
        }];
    
        [_button3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_button2.mas_centerY);
            make.left.equalTo(_button2.mas_right).offset(KGGAdaptedWidth(15));
            make.height.equalTo(@(buttonHeight));
            make.width.equalTo(@(buttonWidth));
        }];
    
        [_button4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_button3.mas_centerY);
            make.left.equalTo(_button3.mas_right).offset(KGGAdaptedWidth(15));
            make.height.equalTo(@(buttonHeight));
            make.width.equalTo(@(buttonWidth));
        }];
    
}

- (UIButton *)snh_buttonTag:(NSInteger )tag Image:(NSString *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    KGGLog(@"创建按钮的Tag:%ld",(long)button.tag);
    [button addTarget:self action:@selector(rewardBUttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)rewardBUttonClick:(UIButton *)sender
{
    for (int i =0; i<4; i++) {
        if (i==sender.tag-10000) {
            NSString *string = [NSString stringWithFormat:@"btn%d_chosed",i+1];
            [sender setBackgroundImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
        }else{
            NSString *string = [NSString stringWithFormat:@"btn%d",i+1];
            UIButton *button = (UIButton *)[self.bottomView viewWithTag:10000+i];
            [button setBackgroundImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
        }
    }
    
    switch (sender.tag) {
        case 10000:
            KGGLog(@"399");
            self.moneyString = @"399";
            break;
        case 10001:
            KGGLog(@"699");
            self.moneyString = @"699";
            break;
        case 10002:
            KGGLog(@"999");
            self.moneyString = @"999";
            break;
        case 10003:
            KGGLog(@"2699");
            self.moneyString = @"2699";
            break;
        default:
            break;
    }

}


#pragma mark - ButtonClick
- (void)kgg_nowReButtonClick:(UIButton *)sender
{
    KGGLog(@"立即充值");
    
    [self dismissSheetView];
    if (self.apply_Button) {
        self.apply_Button(self.moneyString);
    }
}

- (void)kgg_nextButtonClick:(UIButton *)sender
{
    KGGLog(@"下次再说");
    [self dismissSheetView];
}

- (void)kgg_cancelButtonClick:(UIButton *)sender
{
    KGGLog(@"取消按钮");
    [self dismissSheetView];
}

//消失
- (void)dismissSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        
        
    } completion:^(BOOL finished) {
        [weakSelf.bottomView removeFromSuperview];
        [weakSelf.view1 removeFromSuperview];
        [weakSelf.cancelButton removeFromSuperview];
        [weakSelf.bgView removeFromSuperview];
        [weakSelf.nowReButton removeFromSuperview];
        [weakSelf.nextButton removeFromSuperview];
        [weakSelf.messageLabel removeFromSuperview];
        [weakSelf.peopleImageView removeFromSuperview];
        [weakSelf.VIPButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - 懒加载
- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.font = KGGFont(14);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = UIColorHex(0x333333);
        _messageLabel.text = @"随时发单,抢工期更容易";
    }
    return _messageLabel;
}

- (UIButton *)nowReButton
{
    if (!_nowReButton) {
        _nowReButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nowReButton setBackgroundImage:[UIImage imageNamed:@"icon_btn"] forState:UIControlStateNormal];
        [_nowReButton setTitle:@"立即充值" forState:UIControlStateNormal];
        [_nowReButton setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
        _nowReButton.titleLabel.font = KGGFont(18);
        [_nowReButton addTarget:self action:@selector(kgg_nowReButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nowReButton;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"下次再说" forState:UIControlStateNormal];
        [_nextButton setTitleColor:UIColorHex(0x999999) forState:UIControlStateNormal];
        _nextButton.titleLabel.font = KGGFont(12);
         [_nextButton addTarget:self action:@selector(kgg_nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _nextButton;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"icon-x"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(kgg_cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)VIPButton
{
    if (!_VIPButton) {
        _VIPButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_VIPButton setImage:[UIImage imageNamed:@"icon-vip"] forState:UIControlStateNormal];
//        _VIPButton.enabled = NO;
        [_VIPButton setTitle:@" 用户" forState:UIControlStateNormal];
        [_VIPButton setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
        _VIPButton.titleLabel.font = KGGFont(24);
        
    }
    return _VIPButton;
}


@end
