//
//  KGGPublishHomeFootView.h
//  kuaigong
//
//  Created by Ding on 2017/8/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGPublishHomeFootViewDelegate <NSObject>

- (void)kgg_publishHomeFootViewLocationButtonClick;

@end

@interface KGGPublishHomeFootView : UIView

@property (nonatomic, weak) id<KGGPublishHomeFootViewDelegate> delegate;


@end
