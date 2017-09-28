//
//  KGGRefreshFooter.m
//  kuaigong
//
//  Created by Ding on 2017/8/28.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGRefreshFooter.h"

@implementation KGGRefreshFooter

- (void)prepare
{
    [super prepare];
    
}

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action{
    KGGRefreshFooter *footer = [super footerWithRefreshingTarget:target refreshingAction:action];
    // 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新
    footer.triggerAutomaticallyRefreshPercent = 0.5;
    // 隐藏刷新状态的文字
    footer.refreshingTitleHidden = NO;
    // 自动根据有无数据来显示和隐藏（有数据就显示，没有数据隐藏。默认是NO）
    footer.automaticallyHidden = YES;
    
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    
    return footer;
}


@end
