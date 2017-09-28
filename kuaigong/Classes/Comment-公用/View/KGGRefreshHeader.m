//
//  KGGRefreshHeader.m
//  kuaigong
//
//  Created by Ding on 2017/8/28.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGRefreshHeader.h"

@implementation KGGRefreshHeader

- (void)prepare
{
    [super prepare];
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    KGGRefreshHeader *header = [super headerWithRefreshingTarget:target refreshingAction:action];
    header.lastUpdatedTimeLabel.hidden = NO;
    header.stateLabel.hidden = NO;
    return header;
}

@end
