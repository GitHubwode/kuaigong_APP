//
//  KGGPublishOrderViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/8/24.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishOrderViewCell.h"


static NSString *kggPublishOrderIdentify = @"KGGPublishOrderViewCell";

@interface KGGPublishOrderViewCell ()


@end

@implementation KGGPublishOrderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)publishOrderIdentifier
{
    return kggPublishOrderIdentify;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
