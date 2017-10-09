//
//  KGGLoginView.h
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGLoginView;

@protocol KGGLoginViewDelegate <NSObject>

- (BOOL)textFieldShouldSendCode:(KGGLoginView *)textField;
- (NSString *)textFieldCanSendCode:(KGGLoginView *)textField;
- (UIView *)hudView;
- (NSString *)codeType;

@end

@interface KGGLoginView : UIView

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title imageString:(NSString *)imageString PlaceText:(NSString *)placeText;

@property (nonatomic, weak) id<KGGLoginViewDelegate> codeDelegate;


/** 输入框最长文字输入个数 */
@property (nonatomic, assign) NSUInteger maxTextLength;
/** 是否包含发送验证码按钮 */
@property (nonatomic, assign) BOOL containCodeButton;
@property (nonatomic, strong) UITextField *loginTextField;
@property (nonatomic, assign) BOOL isPhoneNum;
@property (nonatomic, assign) BOOL isPassWord;

@end
