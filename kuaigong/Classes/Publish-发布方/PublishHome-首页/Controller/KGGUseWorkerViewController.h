//
//  KGGUseWorkerViewController.h
//  kuaigong
//
//  Created by Ding on 2017/8/23.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGGUseWorkerViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *publishDatasource;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CGFloat longitudeMap;
@property (nonatomic, assign) CGFloat latitudeMap;
/** 用工类型 */
@property (nonatomic,assign) NSUInteger workerType;
@end
