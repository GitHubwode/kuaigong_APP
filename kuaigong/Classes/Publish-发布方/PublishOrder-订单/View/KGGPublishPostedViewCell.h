//
//  KGGPublishPostedViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/11/15.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGGPublishPostedViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
+ (NSString *)publishPostedIdentifier;

@end
