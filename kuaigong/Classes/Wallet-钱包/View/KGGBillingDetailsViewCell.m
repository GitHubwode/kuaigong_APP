//
//  KGGBillingDetailsViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/9/14.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGBillingDetailsViewCell.h"
#import "KGGMyWalletOrderDetailsModel.h"

static NSString *billingDetailsViewCell = @"KGGBillingDetailsViewCell";

@interface KGGBillingDetailsViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation KGGBillingDetailsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDetailsModel:(KGGMyWalletOrderDetailsModel *)detailsModel
{
    self.timeLabel.text = detailsModel.workStartTime;
    self.moneyLabel.text = [NSString stringWithFormat:@"+  %@",detailsModel.differentPrice];
}



+ (NSString *)billIdentifier
{
    return billingDetailsViewCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
