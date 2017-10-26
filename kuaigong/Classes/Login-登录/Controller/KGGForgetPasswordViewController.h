//
//  KGGForgetPasswordViewController.h
//  kuaigong
//
//  Created by Ding on 2017/8/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ForgetPwdBackBlock)();


@interface KGGForgetPasswordViewController : UIViewController
@property (nonatomic, copy) ForgetPwdBackBlock forgetSuccessBlock;

/** 导航栏标题 */
@property (nonatomic, strong) NSString *itemTitle;

@end
