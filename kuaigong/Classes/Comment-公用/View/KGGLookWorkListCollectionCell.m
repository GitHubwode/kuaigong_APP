//
//  KGGLookWorkListCollectionCell.m
//  kuaigong
//
//  Created by Ding on 2017/11/27.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLookWorkListCollectionCell.h"
#import "KGGPostedModel.h"
#import "UIImageView+WebCache.h"
@interface KGGLookWorkListCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation KGGLookWorkListCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 15.f;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10.f;
}

- (void)setUp:(KGGPostedModel *)stageModel
{
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:stageModel.imageUrl] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    self.nameLabel.text = stageModel.name;
//    self.phoneLabel.text = stageModel.phone;
}


@end
