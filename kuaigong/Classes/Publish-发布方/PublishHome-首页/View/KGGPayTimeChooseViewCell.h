//
//  KGGPayTimeChooseViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/9/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGGPayTimeChooseField.h"

@class KGGCustomInfoItem;
@interface KGGPayTimeChooseViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet KGGPayTimeChooseField *timeTextField;
@property (nonatomic, strong) KGGCustomInfoItem *infoItem;
+ (NSString *)payTimeIdentifier;


@end
