//
//  KGGOrderCorrectViewController.h
//  kuaigong
//
//  Created by Ding on 2017/10/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGOrderDetailsModel;

typedef void(^backViewBlock)(NSUInteger code);

@interface KGGOrderCorrectViewController : UIViewController
//订单id
@property (nonatomic, strong) KGGOrderDetailsModel *detailsModel;


/** 回调 */
@property (nonatomic,copy) backViewBlock  backBlock;

@end
