//
//  KGGPayTimeChooseViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/9/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPayTimeChooseViewCell.h"
#import "KGGCustomInfoItem.h"

static NSString *payTimeChooseViewCell = @"PayTimeChooseViewCell";

@interface KGGPayTimeChooseViewCell ()<KGGPayTimeChooseFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end


@implementation KGGPayTimeChooseViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.timeTextField.timeDelegate = self;
    self.lineHeight.constant = KGGOnePixelHeight;
}

- (void)setInfoItem:(KGGCustomInfoItem *)infoItem
{
    _infoItem = infoItem;
    self.titleLabel.text = infoItem.title;
    self.timeTextField.placeholder = infoItem.placeholder;
    self.timeTextField.text = infoItem.subtitle;
    self.timeTextField.keyboardType = infoItem.keyboardType;
}


+ (NSString *)payTimeIdentifier
{
    return payTimeChooseViewCell;
}

#pragma mark - KGGPayTimeChooseFieldDelegate
- (void)payTimeChooseFieldEnsureButtonClick
{
    if (self.infoItem.editabled) {
        self.infoItem.subtitle = self.timeTextField.text;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
