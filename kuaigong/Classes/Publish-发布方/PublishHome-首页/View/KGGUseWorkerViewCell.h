//
//  KGGUseWorkerViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/8/23.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGCustomInfoItem;

@interface KGGUseWorkerViewCell : UITableViewCell

@property (nonatomic, strong) KGGCustomInfoItem *infoItem;
@property (weak, nonatomic) IBOutlet UITextField *textField;


- (void)kgg_UserName:(NSString *)name;
- (void)kgg_UserTel:(NSString *)tel;
- (void)kgg_userAddress:(NSString *)address;
+ (NSString *)cellIdentifier;


@end
