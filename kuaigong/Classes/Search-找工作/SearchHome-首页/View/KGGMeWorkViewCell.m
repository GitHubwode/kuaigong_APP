//
//  KGGMeWorkViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/8/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMeWorkViewCell.h"

static NSString *meWorkViewCell = @"KGGMeWorkViewCell";

@interface KGGMeWorkViewCell ()


@end

@implementation KGGMeWorkViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)meWorkViewIdentifier
{
    return meWorkViewCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
