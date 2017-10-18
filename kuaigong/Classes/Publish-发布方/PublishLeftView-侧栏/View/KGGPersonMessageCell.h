//
//  KGGPersonMessageCell.h
//  kuaigong
//
//  Created by Ding on 2017/8/31.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGPublishPersonModel;

@interface KGGPersonMessageCell : UITableViewCell
/** 模型 */
@property (nonatomic,strong)KGGPublishPersonModel *personModel;
@property (weak, nonatomic) IBOutlet UITextField *personTextField;


+ (NSString *)personIdentifier;

- (void)kggUserNickName:(NSString *)nickName;
- (void)kggUserAvatar:(NSString *)avatarUrl;

@end
