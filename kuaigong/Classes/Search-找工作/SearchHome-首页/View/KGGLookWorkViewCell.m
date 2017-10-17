//
//  KGGLookWorkViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLookWorkViewCell.h"
#import "KGGOrderDetailsModel.h"

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
    // Initialization code
    self.lineViewHeight.constant = KGGOnePixelHeight;
}

- (void)setDetailsModel:(KGGOrderDetailsModel *)detailsModel
{
    _detailsModel = detailsModel;
    self.classNameLabel.text = detailsModel.workerType;
    self.peopleNumLabel.text = [NSString stringWithFormat:@"%lu人",(unsigned long)detailsModel.number];
    self.timeLabel.text = detailsModel.whenLong;
    self.moneyLabel.text = [NSString stringWithFormat:@"总价:%.f元",detailsModel.differentPrice];
    self.nickNameLabel.text = detailsModel.contacts;
    
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
