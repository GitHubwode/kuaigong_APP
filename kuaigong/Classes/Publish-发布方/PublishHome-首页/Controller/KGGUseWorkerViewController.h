//
//  KGGUseWorkerViewController.h
//  kuaigong
//
//  Created by Ding on 2017/8/23.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGWorkTypeModel;
@interface KGGUseWorkerViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *publishDatasource;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CGFloat longitudeMap;
@property (nonatomic, assign) CGFloat latitudeMap;
/** 用工模型 */
@property (nonatomic, strong) KGGWorkTypeModel *workType;
/** 人一天多钱 */
@property (nonatomic,copy) NSString *peoplePrice;

/** 车辆总价 */
@property (nonatomic,assign) int  catTotal;
@end
