//
//  SNHPublishToolBar.m
//  sunvhui
//
//  Created by apple on 2016/11/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SNHPublishToolBar.h"

@interface SNHPublishToolBar ()

@end

@implementation SNHPublishToolBar

+ (instancetype)publishToolBar{
    SNHPublishToolBar *instance = [self viewFromXib];
//    instance.xc_height = 60.f;
    return instance;
}

- (void)dealloc{
    KGGLogFunc
}


@end
