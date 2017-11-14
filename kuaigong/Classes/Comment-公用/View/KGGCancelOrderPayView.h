//
//  KGGCancelOrderPayView.h
//  kuaigong
//
//  Created by Ding on 2017/11/14.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

//立即支付
typedef void(^PayOrderButton)();
//取消
typedef void(^CancelButton)();

@interface KGGCancelOrderPayView : UIView

/** 确定 */
@property (nonatomic,copy) PayOrderButton sureButton;
/** 取消 */
@property (nonatomic,copy) CancelButton cancelButton;

+ (instancetype)kgg_alertPromptApplyForViewKGGApplyButtonClick:(PayOrderButton )apply_Button KGGUnderstandButtonClick:(CancelButton )know_Button;

@end
