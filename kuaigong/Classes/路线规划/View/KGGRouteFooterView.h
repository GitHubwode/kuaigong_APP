//
//  KGGRouteFooterView.h
//  kuaigong
//
//  Created by Ding on 2017/11/6.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGRouteFooterViewDelegate <NSObject>

- (void)routeFooterViewButtonClickTag:(UIButton *)buttonTag;
- (void)routeFooterViewGoButtonClickTag:(UIButton *)buttonTag;

@end
@interface KGGRouteFooterView : UIView

@property (nonatomic, weak) id<KGGRouteFooterViewDelegate>footerDelegate;
- (instancetype)initWithFrame:(CGRect)frame IdentifyType:(NSUInteger)identifyType IsSart:(NSString *)isStart;

@end
