//
//  KGGBillingDetailsViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/9/14.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGBillingDetailsViewCell.h"
#import "KGGMyWalletOrderDetailsModel.h"
#import "KGGMyWalletSpendModel.h"
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
    self.titleLabel.text = @"工资到账";
    self.timeLabel.text = detailsModel.workStartTime;
    self.moneyLabel.text = [NSString stringWithFormat:@"+  %@",detailsModel.differentPrice];
}

- (void)setSpendModel:(KGGMyWalletSpendModel *)spendModel
{
    self.moneyLabel.textColor = UIColorHex(0x333333);
    self.titleLabel.text = @"提现到银行卡";
    self.timeLabel.text = spendModel.createDate;
    self.moneyLabel.text = [NSString stringWithFormat:@"-  %.2f",spendModel.drawAmount];
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
