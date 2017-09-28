//
//  KGGPublishOrderViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/8/24.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGGPublishOrderViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailsLabel;

+ (NSString *)publishOrderIdentifier;

@end
