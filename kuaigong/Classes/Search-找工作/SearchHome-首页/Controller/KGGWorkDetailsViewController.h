//
//  KGGWorkDetailsViewController.h
//  kuaigong
//
//  Created by Ding on 2017/9/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGOrderDetailsModel;
@interface KGGWorkDetailsViewController : UIViewController

@property (nonatomic, strong)KGGOrderDetailsModel *searchOrderModel;
/** 收到的通知 */
@property (nonatomic, assign) BOOL isNotification;

@end
