//
//  KGGCollectViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/11/3.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGCustomInfoItem;

@interface KGGCollectViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *collectTextField;
@property (nonatomic, strong) KGGCustomInfoItem *infoItem;

+ (NSString *)collectIdentifier;

@end
