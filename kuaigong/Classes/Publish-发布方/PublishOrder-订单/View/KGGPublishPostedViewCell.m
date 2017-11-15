//
//  KGGPublishPostedViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/11/15.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishPostedViewCell.h"
#import "SNHStartRateView.h"

static NSString *publishPostedView = @"PublishPostedViewCell";

@interface KGGPublishPostedViewCell ()<snhStartRateViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *startView;

@property (nonatomic, strong) SNHStartRateView *startRate;


@end

@implementation KGGPublishPostedViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 19;
    
    [self creatStartView];
}

- (void)creatStartView
{
    weakSelf(self);
    
    self.startRate = [[SNHStartRateView alloc]initWithFrame:CGRectMake(0, 0, 80, 11) NumberOfStart:5 RateStyle:IncompleteStart IsAnimation:YES delegate:self];
    self.startRate.delegate = self;
    self.startRate.currentScore = 5;
    self.startRate.isDisplay = YES;
    [self.startView addSubview:self.startRate];
    [self.startRate mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.startView.mas_centerY);
        make.left.equalTo(weakself.startView.mas_left).offset(5);
        make.width.equalTo(weakself.startView.mas_width);
        make.height.equalTo(weakself.startView.mas_height);
    }];
}


+ (NSString *)publishPostedIdentifier
{
    return publishPostedView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
