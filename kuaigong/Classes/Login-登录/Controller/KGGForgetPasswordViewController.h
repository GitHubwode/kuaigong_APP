//
//  KGGForgetPasswordViewController.h
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KGGUserChangeType) {
    KGGUserChangePWDType, // 修改密码
    KGGUserChangeLookForPWDType, // 找回密码
    KGGUserChangeBindPhoneType // 绑定手机号
};
typedef void(^ForgetPwdBackBlock)();

@interface KGGForgetPasswordViewController : UIViewController
@property (nonatomic, copy) ForgetPwdBackBlock forgetSuccessBlock;
@property (nonatomic, assign) KGGUserChangeType changetype;


@end
