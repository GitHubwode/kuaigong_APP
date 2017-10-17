//
//  KGGSearchOrderViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/9/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGOrderDetailsModel;

@interface KGGSearchOrderViewCell : UITableViewCell
@property (nonatomic, strong)KGGOrderDetailsModel *orderDetails;
+(NSString *)searchOrderIdentifier;

@end
