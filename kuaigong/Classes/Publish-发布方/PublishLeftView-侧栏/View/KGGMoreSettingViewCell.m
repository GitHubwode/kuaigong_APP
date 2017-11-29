//
//  KGGMoreSettingViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/9/5.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMoreSettingViewCell.h"
#import "KGGMoreSetModel.h"

static NSString *moreSettingViewCell = @"MoreSettingViewCell";

@interface KGGMoreSettingViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *pushSeitch;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;


@end

@implementation KGGMoreSettingViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)pushSwitchClick:(UISwitch *)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        KGGLog(@"开");
        
    }else {
        KGGLog(@"关");
    }
}

- (void)setSetModel:(KGGMoreSetModel *)setModel
{
    _setModel = setModel;
    self.titleLabel.text = setModel.title;
    self.pushSeitch.hidden = setModel.enabled;
    self.arrowImageView.hidden = setModel.arrowImageHiden;
}

+ (NSString *)moreSettingIdentifier
{
    return moreSettingViewCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
