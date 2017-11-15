//
//  KGGPublishPostedMessageViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/11/15.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishPostedMessageViewCell.h"

static NSString *publishPostedMessageViewCell = @"PublishPostedMessageViewCell";

@implementation KGGPublishPostedMessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)publishPostedMessageIdentifier
{
    return publishPostedMessageViewCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
