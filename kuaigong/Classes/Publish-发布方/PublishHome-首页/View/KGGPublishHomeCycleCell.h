//
//  KGGPublishHomeCycleCell.h
//  kuaigong
//
//  Created by Ding on 2017/11/29.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGPublishHomeCycleModel;
@interface KGGPublishHomeCycleCell : UICollectionViewCell
@property (nonatomic, strong) KGGPublishHomeCycleModel *cycleModel;

+ (NSString *)publishHomeIdentifier;
@end
