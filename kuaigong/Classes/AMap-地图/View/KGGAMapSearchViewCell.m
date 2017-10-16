//
//  KGGAMapSearchViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/9/29.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGAMapSearchViewCell.h"

static NSString *AMapSearchViewCell = @"AMapSearchViewCell";

@implementation KGGAMapSearchViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (NSString *)aMapSearchViewIdentifier
{
    return AMapSearchViewCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
