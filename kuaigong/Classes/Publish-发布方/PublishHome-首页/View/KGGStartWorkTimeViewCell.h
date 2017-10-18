//
//  KGGStartWorkTimeViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/10/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGCustomInfoItem;

@protocol KGGStartWorkTimeViewCellDelegate <NSObject>

@optional
- (void)workStartChooseSureButtonClick;

@end

@interface KGGStartWorkTimeViewCell : UITableViewCell

@property (nonatomic, strong) KGGCustomInfoItem *infoItem;
@property (nonatomic, weak) id<KGGStartWorkTimeViewCellDelegate>cellDelegate;

+ (NSString *)workStartIdentifier;


@end
