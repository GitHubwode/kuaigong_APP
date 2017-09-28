//
//  KGGOrderDetailsViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/8/23.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGOrderDetailsViewCell.h"
#import "KGGCustomInfoItem.h"

static NSString *orderDetailsCell = @"KGGOrderDetailsViewCell";

@interface KGGOrderDetailsViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation KGGOrderDetailsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfoItem:(KGGCustomInfoItem *)infoItem
{
    _infoItem = infoItem;
    self.titleLabel.text = infoItem.title;
}

+ (NSString *)oderDetailsIdentifier
{
    return orderDetailsCell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
