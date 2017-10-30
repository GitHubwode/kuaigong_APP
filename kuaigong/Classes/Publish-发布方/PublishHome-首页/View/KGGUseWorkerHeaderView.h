//
//  KGGUseWorkerHeaderView.h
//  kuaigong
//
//  Created by Ding on 2017/8/23.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGUseWorkerHeaderViewDelegate <NSObject>

- (void)kgg_userworkHeaderOrderRemarkMessage:(NSString *)message;
- (void)kgg_userworkHeaderPhoneButtonClick;

@end

@interface KGGUseWorkerHeaderView : UIView

@property (nonatomic, strong) UITextView *headerTextView;
@property (nonatomic, strong) UILabel *orderDetailLabel;
@property (nonatomic, strong) UILabel *orderTotalLabel;
@property (nonatomic, weak) id<KGGUseWorkerHeaderViewDelegate>headerDelegate;

@end
