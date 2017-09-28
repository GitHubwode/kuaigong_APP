//
//  KGGMoreSettingViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/9/5.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGMoreSetModel;

@interface KGGMoreSettingViewCell : UITableViewCell

/** 模型 */
@property (nonatomic,strong)KGGMoreSetModel *setModel;

+ (NSString *)moreSettingIdentifier;

@end
