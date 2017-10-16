//
//  KGGLookWorkViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGOrderDetailsModel;

@interface KGGLookWorkViewCell : UITableViewCell
@property (nonatomic, strong) KGGOrderDetailsModel *detailsModel;

+ (NSString *)lookWorkIdentifier;

@end
