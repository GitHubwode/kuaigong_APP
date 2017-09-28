//
//  KGGLeftDrawerCell.h
//  kuaigong
//
//  Created by Ding on 2017/8/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGGLeftDrawerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;


+ (NSString *)leftIdentifierClass;

@end
