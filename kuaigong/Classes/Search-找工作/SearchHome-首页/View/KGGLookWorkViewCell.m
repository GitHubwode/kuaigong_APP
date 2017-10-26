//
//  KGGLookWorkViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLookWorkViewCell.h"
#import "KGGOrderDetailsModel.h"
#import "UIImageView+WebCache.h"

static NSString *const lookWorkViewCell = @"KGGLookWorkViewCell";

@interface KGGLookWorkViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;

@end

@implementation KGGLookWorkViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 18.f;
    self.lineViewHeight.constant = KGGOnePixelHeight;
}

- (void)setDetailsModel:(KGGOrderDetailsModel *)detailsModel
{
    _detailsModel = detailsModel;
    self.classNameLabel.text = detailsModel.workerType;
    self.peopleNumLabel.text = [NSString stringWithFormat:@"%lu人",(unsigned long)detailsModel.number];
    self.timeLabel.text = [NSString stringWithFormat:@"工作时间:%@",detailsModel.workStartTime];
    self.moneyLabel.text = [NSString stringWithFormat:@"总价:%.f元",detailsModel.differentPrice];
    self.nickNameLabel.text = detailsModel.contacts;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:detailsModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
}

+ (NSString *)lookWorkIdentifier
{
    return lookWorkViewCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
