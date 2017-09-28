//
//  KGGAMapSearchViewController.h
//  kuaigong
//
//  Created by Ding on 2017/9/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>


typedef void(^moveBlock)(AMapPOI *poi);
@interface KGGAMapSearchViewController : UIViewController

@property (nonatomic, strong) MAUserLocation *currentLocation;//当前位置
@property (nonatomic, strong) NSString *currentCity;//当前参数
@property (nonatomic, strong) NSString *searchStr;//搜索的内容
@property (nonatomic, copy) moveBlock moveBlock;

@end
