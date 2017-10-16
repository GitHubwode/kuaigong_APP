//
//  KGGAMapSearchViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/9/29.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGGAMapSearchViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

+ (NSString *)aMapSearchViewIdentifier;

@end
