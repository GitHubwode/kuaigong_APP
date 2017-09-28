//
//  KGGMyWorkViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/9/20.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMyWorkViewCell.h"

static NSString *myWorkViewCell = @"KGGMyWorkViewCell";

@interface KGGMyWorkViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation KGGMyWorkViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)myWorkIdentifier
{
    return myWorkViewCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
