//
//  KGGSexChangeViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/9/1.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGSexChangeViewCell.h"
#import "KGGSexField.h"
#import "UITextField+KGGExtension.h"
#import "KGGPublishPersonModel.h"

static NSString *sexChangeViewCell = @"SexChangeViewCell";
@interface KGGSexChangeViewCell ()<KGGSexFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageView;

@end

@implementation KGGSexChangeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineViewHeight.constant = KGGOnePixelHeight;
    self.personTextField.borderStyle = UITextBorderStyleNone;
    self.personTextField.sexDelegate = self;
}

- (void)setPersonModel:(KGGPublishPersonModel *)personModel
{
    _personModel = personModel;
    self.titleLabel.text = personModel.title;
    self.personTextField.placeholder = personModel.perPlace;
    self.personTextField.text = personModel.subTitle;
    self.indicatorImageView.hidden = personModel.ishides;
    
}

+ (NSString *)cellIdentifier
{
    return sexChangeViewCell;
}

#pragma mark - SNHSexFieldDelegate
- (void)ensureButtonClick{
    
    self.personModel.subTitle = self.personTextField.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
