//
//  KGGCustomInfoCell.h
//  kuaigong
//
//  Created by Ding on 2017/9/8.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGCustomInfoItem;

@interface KGGCustomInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) KGGCustomInfoItem *infoItem;

+ (NSString *)cellIdentifier;

@end
