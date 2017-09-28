//
//  KGGOrderDetailsViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/8/23.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGCustomInfoItem;

@interface KGGOrderDetailsViewCell : UITableViewCell

@property (nonatomic, strong) KGGCustomInfoItem *infoItem;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;


+ (NSString *)oderDetailsIdentifier;

@end
