//
//  UIView+ErrorView.m
//  泡吧
//
//  Created by jiang on 16/8/15.
//  Copyright © 2016年 paoba. All rights reserved.
//

#import "UIView+ErrorView.h"
#import <objc/runtime.h>


static const void *SNHErrorViewKey = &SNHErrorViewKey;
static const void *SNHErrorRetryKey = &SNHErrorRetryKey;

@interface UIView ()
@property (nonatomic, weak) UIView *errorView;
@end


@implementation UIView (ErrorView)

- (UIView *)errorView{
    return objc_getAssociatedObject(self, SNHErrorViewKey);
}

- (void)setErrorView:(UIView *)errorView{
    objc_setAssociatedObject(self, SNHErrorViewKey, errorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


///*!
// 网络错误
// */
//- (void)showNetworkErrorViewWithyOffset:(CGFloat)yOffset retryBlock:(void (^)(void))retryBlock{
//    [self removeErrorView];
//    
//    weakSelf(self);
//    
//    UIView *networkErrorView = [[UIView alloc]init];
//    [self addSubview:networkErrorView];
//    [networkErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.width.equalTo(weakself);
//    }];
//    self.errorView = networkErrorView;
//    [self sendSubviewToBack:self.errorView];
//    
//    UIImageView *errorImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"error_icon"]];
//    [networkErrorView addSubview:errorImgView];
//    [errorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(networkErrorView).with.offset(15.f);
//        make.top.equalTo(networkErrorView);
//    }];
//    
//    
//    
//    UILabel *label = [[UILabel alloc]init];
//    label.font = PBFont(15);
//    label.text = @"哎呀!  糟糕!";
//    [networkErrorView addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(networkErrorView);
//        make.top.equalTo(errorImgView.mas_bottom).with.offset(20.f);
//    }];
//    
//    
//    UILabel *errorLabel = [[UILabel alloc]init];
//    errorLabel.font = PBFont(12);
//    errorLabel.text = @"加载失败了,请检查网络连接是否正常!";
//    [errorLabel sizeToFit];
//    errorLabel.textColor = kBlackColor;
//    [networkErrorView addSubview:errorLabel];
//    [errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(networkErrorView);
//        make.top.equalTo(label.mas_bottom).with.offset(15.f);
//    }];
//    
//    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    retryButton.layer.cornerRadius = 40.f * HEIGHTZOOMSCALE * 0.5;
//    retryButton.clipsToBounds = YES;
//    retryButton.backgroundColor = kRedColor;
//    [retryButton setTitle:@"点击重试" forState:UIControlStateNormal];
//    [retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [retryButton addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
//    objc_setAssociatedObject(self, PBErrorRetryKey, retryBlock, OBJC_ASSOCIATION_COPY);
//    retryButton.titleLabel.font = PBFont(15);
//    [networkErrorView addSubview:retryButton];
//    [retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(225.f * HEIGHTZOOMSCALE, 40.f * HEIGHTZOOMSCALE));
//        make.centerX.equalTo(networkErrorView);
//        make.top.equalTo(errorLabel.mas_bottom).with.offset(25.f);
//    }];
//    
//    
//    [networkErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(retryButton);
//        make.centerY.equalTo(weakself).with.offset(yOffset);
//    }];
//    
//}




///*!
// 网络错误
// */
//- (void)showNetworkErrorViewWithRetryBlock:(void (^)(void))retryBlock {
//    
//    
//    [self showNetworkErrorViewWithyOffset:0.f retryBlock:retryBlock];
//    
//}





/*!
 业务错误
 */
- (void)showBusinessErrorViewWithError:(NSString *)error{
    
    [self showBusinessErrorViewWithError:error yOffset:0.f];
}


/*!
 业务错误
 */
- (void)showBusinessErrorViewWithError:(NSString *)error yOffset:(CGFloat)yOffset{
    
    [self removeErrorView];
    
    
    UIView *businessErrorView = [[UIView alloc]init];
    businessErrorView.xc_size = self.xc_size;
    [self addSubview:businessErrorView];
    self.errorView = businessErrorView;
    [self sendSubviewToBack:self.errorView];
    
    
    UILabel *label = [[UILabel alloc]init];
    label.font = KGGFont(13);
    label.textColor = KGGAlertTextColor;
    label.text = error;
    label.textAlignment = NSTextAlignmentCenter;
    [businessErrorView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(businessErrorView);
        make.top.equalTo(businessErrorView).with.offset(yOffset);
    }];
}







- (void)removeErrorView{
    
    [self.errorView removeFromSuperview];
    objc_setAssociatedObject(self, SNHErrorViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (void)retry{
    
    void(^action)(void) = objc_getAssociatedObject(self, SNHErrorRetryKey);
    
    if (action)
    {
        action();
    }
}


@end
