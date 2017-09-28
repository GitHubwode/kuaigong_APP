//
//  KGGPersonMessageCell.m
//  kuaigong
//
//  Created by Ding on 2017/8/31.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPersonMessageCell.h"
#import "KGGPublishPersonModel.h"


static NSString *personMessageCell = @"personMessageCell";

@interface KGGPersonMessageCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;
@property (weak, nonatomic) IBOutlet UIImageView *arrwImageView;

@end

@implementation KGGPersonMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineHeight.constant = KGGOnePixelHeight;
}


- (void)setPersonModel:(KGGPublishPersonModel *)personModel
{
    _personModel = personModel;
    self.titleLabel.text = personModel.title;
    self.personTextField.text = personModel.subTitle;
    self.personTextField.placeholder = personModel.perPlace;
    self.arrwImageView.hidden = personModel.ishides;
    self.avatarImageView.hidden = personModel.isHidesAvatar;
    if (personModel.isHidesAvatar == NO) {
        [self.personTextField removeFromSuperview];
    }
}

+ (NSString *)personIdentifier
{
    return personMessageCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
