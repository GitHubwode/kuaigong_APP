//
//  KGGBillingDetailsViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/9/14.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGMyWalletOrderDetailsModel;

@interface KGGBillingDetailsViewCell : UITableViewCell
@property (nonatomic, strong) KGGMyWalletOrderDetailsModel *detailsModel;
+ (NSString *)billIdentifier;

@end
