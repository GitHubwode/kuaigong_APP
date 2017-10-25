//
//  KGGStartWorkTimeViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/10/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGGWorkTimeChooseField.h"

@class KGGCustomInfoItem;

@interface KGGStartWorkTimeViewCell : UITableViewCell

@property (nonatomic, strong) KGGCustomInfoItem *infoItem;
@property (weak, nonatomic) IBOutlet KGGWorkTimeChooseField *workTextField;


+ (NSString *)workStartIdentifier;


@end
