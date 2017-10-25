//
//  KGGStartWorkTimeViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/10/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGStartWorkTimeViewCell.h"
#import "KGGCustomInfoItem.h"
#import "HcdDateTimePickerView.h"


static NSString *startWorkTimeViewCell = @"KGGStartWorkTimeViewIdentifier";

@interface KGGStartWorkTimeViewCell()<KGGWorkTimeChooseFieldDelegate>

@property (nonatomic, strong) HcdDateTimePickerView * dateTimePickerView;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end

@implementation KGGStartWorkTimeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.workTextField.workDelegate = self;
    self.lineHeight.constant = KGGOnePixelHeight;
}

- (void)setInfoItem:(KGGCustomInfoItem *)infoItem
{
    _infoItem = infoItem;
    self.titleLabel.text = infoItem.title;
    self.workTextField.placeholder = infoItem.placeholder;
    self.workTextField.text = infoItem.subtitle;
    self.workTextField.keyboardType = infoItem.keyboardType;
}

#pragma mark - KGGWorkTimeChooseFieldDelegate

- (void)workTimeChooseFieldEnsureButtonClick
{
    if (self.infoItem.editabled) {
        self.infoItem.subtitle = self.workTextField.text;
    }
}

+ (NSString *)workStartIdentifier
{
    return startWorkTimeViewCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
