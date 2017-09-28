//
//  KGGPaySheetViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/9/14.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPaySheetViewCell.h"
#import "KGGPayChooseModel.h"

static NSString *paySheetViewCell = @"KGGPaySheetViewCell";

@interface KGGPaySheetViewCell ()


@end

@implementation KGGPaySheetViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)kgg_paySheetCellMessage:(KGGPayChooseModel *)model
{
    self.iconImageView.image = [UIImage imageNamed:model.iconImage];
    self.titleLabel.text = model.title;
    self.statusImageView.image = [UIImage imageNamed:model.chooseImage];
}


+ (NSString *)paySheetIdentifier
{
    return paySheetViewCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
