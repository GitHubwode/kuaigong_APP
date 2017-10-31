//
//  KGGCenterViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/10/31.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGCenterViewCell.h"

static NSString * centerViewCell = @"centerViewCell";
@interface KGGCenterViewCell()


@end

@implementation KGGCenterViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)identifierCenterCell
{
    return centerViewCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
