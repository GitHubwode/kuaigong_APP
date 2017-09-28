//
//  KGGLeftDrawerCell.m
//  kuaigong
//
//  Created by Ding on 2017/8/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLeftDrawerCell.h"

static NSString *const identifierClass = @"KGGLeftDrawerCell";

@implementation KGGLeftDrawerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)leftIdentifierClass
{
    return identifierClass;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
