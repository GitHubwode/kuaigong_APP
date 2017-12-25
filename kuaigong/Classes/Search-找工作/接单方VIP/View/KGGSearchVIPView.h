//
//  KGGSearchVIPView.h
//  kuaigong
//
//  Created by Ding on 2017/12/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

//立即支付
typedef void(^kggApplyButton)(NSString *money);
//我知道了取消页面
typedef void(^kggKnowButton)();

@interface KGGSearchVIPView : UIView

@property (nonatomic, copy) kggApplyButton apply_Button;
@property (nonatomic, copy) kggKnowButton know_Button;

+ (instancetype)kgg_alertPromptSearchForViewKGGApplyButtonClick:(kggApplyButton )apply_Button KGGUnderstandButtonClick:(kggKnowButton )know_Button;

@end
