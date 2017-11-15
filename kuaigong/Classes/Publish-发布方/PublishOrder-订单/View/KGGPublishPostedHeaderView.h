//
//  KGGPublishPostedHeaderView.h
//  kuaigong
//
//  Created by Ding on 2017/11/15.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGPublishPostedHeaderViewDelegate <NSObject>

- (void)KGGPublishPostedHeaderViewCancelOrderButtonClick;

@end

@class KGGOrderDetailsModel;

@interface KGGPublishPostedHeaderView : UIView

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, weak)id<KGGPublishPostedHeaderViewDelegate>postedDelegate;
@property (nonatomic, strong) KGGOrderDetailsModel *orderModel;

@end
