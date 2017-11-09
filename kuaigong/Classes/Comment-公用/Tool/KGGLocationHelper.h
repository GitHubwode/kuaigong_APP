//
//  KGGLocationHelper.h
//  kuaigong
//
//  Created by Ding on 2017/11/9.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
@class BMKReverseGeoCodeResult;

typedef void(^locationCompletionHandler)(CLLocation *location);
typedef void(^neaybyCompletionHandler)(BMKReverseGeoCodeResult *result);
typedef void(^searchCompletionHandler)(NSArray *pois);

@interface KGGLocationHelper : NSObject

/**
 获取用户位置
 
 @param completion 完成的回调，获取失败为nil
 */
- (void)getUserCurrentLocation:(locationCompletionHandler) completion;
/**
 获取用户位置，带有逆地理编码
 
 @param completion 完成的回调，获取失败为nil
 */
- (void)getUserCurrentReverseLocation:(neaybyCompletionHandler)completion;


/**
 逆地理编码
 
 @param location 位置
 @param completion 完成的回调，获取失败为nil
 */
- (void)reverseLocation:(CLLocation *)location completion:(neaybyCompletionHandler)completion;


/**
 获取用户位置，带有逆地理编码
 
 @param completion 完成的回调，获取失败为nil
 */
- (void)getUserNearbyPois:(neaybyCompletionHandler) completion;


/**
 获取用户位置，带有逆地理编码
 
 @param completion 完成的回调，获取失败为nil
 @param location 位置
 */
- (void)getUserNearbyPois:(neaybyCompletionHandler)completion location:(CLLocation *)location;


/**
 周边检索
 
 @param completion completion 完成的回调，获取失败为nil
 @param coordinate 位置
 @param keyword 关键词
 @param page 页数
 */
//- (void)getNearbyPois:(searchCompletionHandler) completion coordinate:(CLLocationCoordinate2D )coordinate keyword:(NSString *)keyword pageIndex:(int)page;


- (void)clearLocationDelegate;
- (void)clearGeoCodeSearchDelegate;
- (void)clearPoiSearchDelegate;


@end
