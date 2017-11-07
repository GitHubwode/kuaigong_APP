//
//  KGGRouteViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/11/6.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGRouteViewCell.h"

static NSString *routeViewCell = @"routeViewCell";

@interface KGGRouteViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineheight;

@end

@implementation KGGRouteViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineheight.constant = KGGOnePixelHeight;
}

+ (NSString *)identifierRouteView
{
    return routeViewCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
