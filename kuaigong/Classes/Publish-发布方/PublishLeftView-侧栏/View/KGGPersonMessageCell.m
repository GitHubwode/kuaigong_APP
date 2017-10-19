//
//  KGGPersonMessageCell.m
//  kuaigong
//
//  Created by Ding on 2017/8/31.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPersonMessageCell.h"
#import "KGGPublishPersonModel.h"
#import "UIImageView+WebCache.h"


static NSString *personMessageCell = @"personMessageCell";

@interface KGGPersonMessageCell ()
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
    self.personLabel.text = personModel.subTitle;
    self.arrwImageView.hidden = personModel.ishides;
    self.avatarImageView.hidden = personModel.isHidesAvatar;
    if (personModel.isHidesAvatar == NO) {
        [self.personLabel removeFromSuperview];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:personModel.subTitle] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    }
}

- (void)kggUserNickName:(NSString *)nickName
{
    self.personLabel.text = nickName;
    self.personModel.subTitle = nickName;
    
}
- (void)kggUserAvatar:(NSString *)avatarUrl
{
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    self.personModel.subTitle = avatarUrl;
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
