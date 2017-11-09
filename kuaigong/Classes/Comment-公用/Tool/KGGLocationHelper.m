//
//  KGGLocationHelper.m
//  kuaigong
//
//  Created by Ding on 2017/11/9.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLocationHelper.h"

@interface KGGLocationHelper ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
/** 定位 */
@property (nonatomic, strong) BMKLocationService *locationService;
/** 地理/逆地理编码 */
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
/** 检索 */
@property (nonatomic, strong) BMKPoiSearch *poiSearch;

@property (nonatomic, copy) locationCompletionHandler locationCompletion;

@property (nonatomic, copy) neaybyCompletionHandler nearbyCompletion;

@property (nonatomic, copy) searchCompletionHandler searchCompletion;

@property (nonatomic, assign) BOOL reverse;

@end

@implementation KGGLocationHelper

- (void)dealloc{
    KGGLogFunc
    [self clearLocationDelegate];
    [self clearPoiSearchDelegate];
    [self clearGeoCodeSearchDelegate];
}

#pragma mark - 懒加载
- (BMKLocationService *)locationService{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc]init];
        _locationService.delegate = self;
    }
    return _locationService;
}


- (BMKGeoCodeSearch *)geoCodeSearch{
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        _geoCodeSearch.delegate = self;
    }
    return _geoCodeSearch;
}

- (BMKPoiSearch *)poiSearch{
    if (!_poiSearch) {
        _poiSearch = [[BMKPoiSearch alloc]init];
        _poiSearch.delegate = self;
    }
    return _poiSearch;
}




#pragma mark - pulic
- (void)clearLocationDelegate{
    if (_locationService) {
        _locationService.delegate = nil;
        _locationService = nil;
    }
}

- (void)clearGeoCodeSearchDelegate{
    if (_geoCodeSearch) {
        _geoCodeSearch.delegate = nil;
        _geoCodeSearch = nil;
    }
}


- (void)clearPoiSearchDelegate{
    if (_poiSearch) {
        _poiSearch.delegate = nil;
        _poiSearch = nil;
    }
}



#pragma mark - 获取用户位置
/**
 获取用户位置
 
 @param completion 完成的回调，获取失败为nil
 */
- (void)getUserCurrentLocation:(locationCompletionHandler)completion{
    _locationCompletion = completion;
    _reverse = NO;
    [self.locationService startUserLocationService];
}

/**
 获取用户位置，带有逆地理编码
 
 @param completion 完成的回调，获取失败为nil
 */
- (void)getUserCurrentReverseLocation:(neaybyCompletionHandler)completion;{
    _nearbyCompletion = completion;
    _reverse = YES;
    [self.locationService startUserLocationService];
}

/**
 获取用户位置，带有逆地理编码
 
 @param completion 完成的回调，获取失败为nil
 */
- (void)getUserNearbyPois:(neaybyCompletionHandler)completion{
    [self getUserCurrentReverseLocation:completion];
}


/**
 获取用户位置，带有逆地理编码
 
 @param completion 完成的回调，获取失败为nil
 @param location 位置
 */
- (void)getUserNearbyPois:(neaybyCompletionHandler)completion location:(CLLocation *)location{
    [self reverseLocation:location completion:completion];
}


/**
 逆地理编码
 
 @param location 位置
 @param completion 完成的回调，获取失败为nil
 */
- (void)reverseLocation:(CLLocation *)location completion:(neaybyCompletionHandler)completion{
    
    if (!_nearbyCompletion) _nearbyCompletion = completion;
    
    CLLocationCoordinate2D pt = location.coordinate;
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    
    if (!flag){
        
        if (_nearbyCompletion) {
            _nearbyCompletion(nil);
        }
    }
}


/**
 周边检索
 
 @param completion completion 完成的回调，获取失败为nil
 @param coordinate 位置
 @param keyword 关键词
 @param page 页数
 */
//- (void)getNearbyPois:(searchCompletionHandler) completion coordinate:(CLLocationCoordinate2D)coordinate keyword:(NSString *)keyword pageIndex:(int)page
//{
//    self.searchCompletion = completion;
//    
//    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
//    option.pageIndex = page;
//    option.pageCapacity = 10;
//    option.location = coordinate;
//    option.keyword = keyword;
//    BOOL flag = [self.poiSearch poiSearchNearBy:option];
//    
//    if(!flag){
//        if (completion) {
//            completion(nil);
//        }
//    }
//}




#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    if (!userLocation.location) return;
    
    [self.locationService stopUserLocationService];
    
    if (self.locationCompletion) {
        self.locationCompletion(userLocation.location);
    }
    
    if (!_reverse) return;
    
    [self reverseLocation:userLocation.location completion:self.nearbyCompletion];
}

#pragma mark - BMKGeoCodeSearchDelegate
// 接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        //在此处理正常结果
        if (_nearbyCompletion) {
            _nearbyCompletion(result);
        }
        
    }else {
        
        if (_nearbyCompletion) {
            _nearbyCompletion(nil);
        }
    }
}

#pragma mark - BMKPoiSearchDelegate
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        if (_searchCompletion) {
            _searchCompletion(poiResultList.poiInfoList);
        }
    }else {
        if (_searchCompletion) {
            _searchCompletion(nil);
        }
    }
}


@end
