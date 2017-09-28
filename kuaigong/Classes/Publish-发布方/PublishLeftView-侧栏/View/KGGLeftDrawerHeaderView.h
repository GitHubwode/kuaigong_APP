//
//  KGGLeftDrawerHeaderView.h
//  kuaigong
//
//  Created by Ding on 2017/8/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGLeftDrawerHeaderViewDelegate <NSObject>

- (void)kgg_avatarImageButtonClick;

@end

@interface KGGLeftDrawerHeaderView : UIView

@property (nonatomic, weak) id<KGGLeftDrawerHeaderViewDelegate> delegate;


@end
