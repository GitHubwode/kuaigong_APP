//
//  KGGMeWorkHeaderView.h
//  kuaigong
//
//  Created by Ding on 2017/8/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@protocol KGGMeWorkHeaderViewDelegate <NSObject> ;

- (void)kggMeWorkHeaderViewButtonClick;
/** 中间的 */
- (void)KGG_CycleCollectionViewMeWorkDidSelectItemAtIndex:(NSInteger)index;

@end

@interface KGGMeWorkHeaderView : UIView

@property (nonatomic, weak) id <KGGMeWorkHeaderViewDelegate>delegate;

- (void)updataUserMessageLogin:(BOOL)login;

@end
