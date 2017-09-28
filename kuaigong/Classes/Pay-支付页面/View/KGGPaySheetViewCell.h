//
//  KGGPaySheetViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/9/14.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGPayChooseModel;

@interface KGGPaySheetViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

- (void)kgg_paySheetCellMessage:(KGGPayChooseModel *)model;
+ (NSString *)paySheetIdentifier;

@end
