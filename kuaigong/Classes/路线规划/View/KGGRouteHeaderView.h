//
//  KGGRouteHeaderView.h
//  kuaigong
//
//  Created by Ding on 2017/11/6.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGRouteHeaderViewDelegate <NSObject>

- (void)routeHeaderViewButtonClickTag:(UIButton *)buttonTag;
- (void)routeHeaderViewArrowButtonClick:(UIButton *)sender;

@end

@interface KGGRouteHeaderView : UIView

@property (nonatomic, weak) id<KGGRouteHeaderViewDelegate>headerDelegate;

- (void)routeHeaderViewAvatar:(NSString *)avatar Name:(NSString *)name Phone:(NSString *)phone Address:(NSString *)address TotalMoney:(NSString *)totalMoney;

@end
