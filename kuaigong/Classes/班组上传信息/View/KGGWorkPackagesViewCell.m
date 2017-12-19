//
//  KGGWorkPackagesViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/12/1.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGWorkPackagesViewCell.h"

static NSString * workPackagesViewCell = @"kggWorkPackagesViewCell";

@interface KGGWorkPackagesViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *cativeLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation KGGWorkPackagesViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topImageView.layer.masksToBounds = YES;
    self.topImageView.layer.cornerRadius = 10.f;
    self.middleView.layer.masksToBounds = YES;
    self.middleView.layer.cornerRadius = 10.f;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handTap:)];
    [self.bottomView addGestureRecognizer:tap];
}

#pragma mark - 增加轻拍手势
- (void)handTap:(UITapGestureRecognizer *)gesture
{
    KGGLog(@"点击图片");
}

+ (NSString *)workPackagesIdentifier
{
    return workPackagesViewCell;
}
- (IBAction)callPhoneButtonClick:(UIButton *)sender
{
    KGGLog(@"打电话");
}

- (IBAction)chatButtonClick:(UIButton *)sender
{
    KGGLog(@"聊天");
}

@end
