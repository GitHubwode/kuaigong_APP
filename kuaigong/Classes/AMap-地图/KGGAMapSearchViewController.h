//
//  KGGAMapSearchViewController.h
//  kuaigong
//
//  Created by Ding on 2017/9/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>


typedef void(^ClickBackLock)(BMKPoiInfo *poi);

@interface KGGAMapSearchViewController : UIViewController

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *searchAddress;
@property (nonatomic, copy) ClickBackLock backLock;


@end
