//
//  KGGPublishPostedViewController.h
//  kuaigong
//
//  Created by Ding on 2017/11/15.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGOrderDetailsModel;
@class KGGPublishCreatParam;
typedef void(^CancelOrderBlock)();

@interface KGGPublishPostedViewController : UIViewController

@property (nonatomic, copy) CancelOrderBlock backBlock;
@property (nonatomic, strong) KGGOrderDetailsModel *detailsModel;
@property (nonatomic, strong) KGGPublishCreatParam *param;

@property (nonatomic, assign) NSInteger type;

@end
