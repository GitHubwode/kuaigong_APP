//
//  KGGAMapBaseViewController.h
//  kuaigong
//
//  Created by Ding on 2017/9/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface KGGAMapBaseViewController : UIViewController

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAUserLocation *currentLocation;
@property (nonatomic, strong) AMapPOI *currentPOI;
@property (nonatomic, strong) MAPointAnnotation *destinationPoint;

@end
