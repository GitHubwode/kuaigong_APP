//
//  KGGPublishHomeCycleCell.m
//  kuaigong
//
//  Created by Ding on 2017/11/29.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishHomeCycleCell.h"
#import "KGGPublishHomeCycleModel.h"

static NSString *publishHomeCycleCell = @"publishHomeCycleCell";
@interface KGGPublishHomeCycleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end

@implementation KGGPublishHomeCycleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineHeight.constant = KGGOnePixelHeight;
}

- (void)setCycleModel:(KGGPublishHomeCycleModel *)cycleModel
{
    _cycleModel = cycleModel;
    self.imageView.image = [UIImage imageNamed:cycleModel.imageString];
    self.nameLabel.text = cycleModel.nameString;
}

+ (NSString *)publishHomeIdentifier
{
    return publishHomeCycleCell;
}

@end
