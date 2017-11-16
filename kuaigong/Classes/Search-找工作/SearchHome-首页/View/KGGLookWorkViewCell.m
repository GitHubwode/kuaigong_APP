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
#import "SNHStartRateView.h"

static NSString *const lookWorkViewCell = @"KGGLookWorkViewCell";

@interface KGGLookWorkViewCell ()<snhStartRateViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIView *startView;
@property (nonatomic, strong) SNHStartRateView *startRate;

@end

@implementation KGGLookWorkViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 22.f;
    [self creatTableCell];
}

- (void)creatTableCell
{
    weakSelf(self);
    
    self.startRate = [[SNHStartRateView alloc]initWithFrame:CGRectMake(0, 0, 80, 11) NumberOfStart:5 RateStyle:IncompleteStart IsAnimation:YES delegate:self];
    self.startRate.delegate = self;
    self.startRate.currentScore = 3.3;
    self.startRate.isDisplay = YES;
    [self.startView addSubview:self.startRate];
    [self.startRate mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.startView.mas_centerY);
        make.centerX.equalTo(weakself.startView.mas_centerX);
        make.width.equalTo(weakself.startView.mas_width);
        make.height.equalTo(weakself.startView.mas_height);
    }];
}

-(void)starRateView:(SNHStartRateView *)starRateView currentScore:(CGFloat)currentScore{
    
//    KGGLog(@"星星%f",currentScore);
}

- (void)setDetailsModel:(KGGOrderDetailsModel *)detailsModel
{
    _detailsModel = detailsModel;
    self.classNameLabel.text = detailsModel.workerType;
    self.peopleNumLabel.text = [NSString stringWithFormat:@"%lu人",(unsigned long)detailsModel.number];
    self.timeLabel.text = [NSString stringWithFormat:@"工作时间:%@",detailsModel.workStartTime];
    self.moneyLabel.text = [NSString stringWithFormat:@"总价:%@元",detailsModel.differentPrice];
    KGGLog(@"接单方显示价格%@",self.moneyLabel.text);
    self.nickNameLabel.text = detailsModel.contacts;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:detailsModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    self.distanceLabel.text = detailsModel.instance;
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
