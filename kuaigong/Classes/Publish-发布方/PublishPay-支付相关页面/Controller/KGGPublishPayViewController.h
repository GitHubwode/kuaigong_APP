//
//  KGGPublishPayViewController.h
//  kuaigong
//
//  Created by Ding on 2017/9/7.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGGPublishOrderRequestManager.h"

typedef void(^CancelOrderBlock)();

@class KGGOrderDetailsModel;
@interface KGGPublishPayViewController : UIViewController
@property (nonatomic, copy) CancelOrderBlock backBlock;
@property (nonatomic, assign) KGGOrderRequestType requestType;
@property (nonatomic, strong) KGGOrderDetailsModel *detailsModel;


@end
