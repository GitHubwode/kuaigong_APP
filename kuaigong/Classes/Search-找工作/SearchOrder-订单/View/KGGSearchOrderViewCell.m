//
//  KGGSearchOrderViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/9/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGSearchOrderViewCell.h"
#import "KGGOrderDetailsModel.h"

static NSString *KGGSearchOrderView = @"KGGSearchOrderViewCell";

@interface KGGSearchOrderViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *ramarkLabel;

@end

@implementation KGGSearchOrderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setOrderDetails:(KGGOrderDetailsModel *)orderDetails
{
    _orderDetails = orderDetails;
    self.timeTitleLabel.text = orderDetails.workStartTime;
    self.addressLabel.text = orderDetails.address;
    self.detailsLabel.text = orderDetails.orderDetails;
    self.ramarkLabel.text = orderDetails.remark;
}


+ (NSString *)searchOrderIdentifier
{
    return KGGSearchOrderView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
