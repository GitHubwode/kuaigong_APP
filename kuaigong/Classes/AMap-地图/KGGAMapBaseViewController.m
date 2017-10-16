//
//  KGGAMapBaseViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGAMapBaseViewController.h"
#import "KGGAMapSearchViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface KGGAMapBaseViewController ()<UISearchResultsUpdating,UISearchBarDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, strong) BMKMapView *mapView;//地图试图
@property (nonatomic, strong) BMKLocationService *service;//定位服务
@property (nonatomic, strong) BMKPoiSearch *poiSearch;//搜索服务
@property (nonatomic, strong) BMKGeoCodeSearch *geoCode;
@property (nonatomic, strong) NSString *addressDetails;//地址的详细信息
@property (nonatomic, assign) CGFloat longitudeAMap;
@property (nonatomic, assign) CGFloat latitudeAMap;

@end

@implementation KGGAMapBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.fd_interactivePopDisabled = YES;//禁止右滑
    [self addSearchTextField];
    [self.view addSubview:self.mapView];
    //开启定位
    [self.service startUserLocationService];
}

- (void)addSearchTextField
{
    self.navigationItem.titleView = self.searchController.searchBar;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"返回" target:self action:@selector(baseLeftAction)];
}
#pragma mark -------BMKLocationServiceDelegate

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //展示定位
    BMKGeoCodeSearch *codeSearch = [[BMKGeoCodeSearch alloc]init];
    codeSearch.delegate = self;
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
    //    BMKCoordinateRegion region;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: userLocation.location completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            if (placemark != nil) {
                NSString *city = placemark.locality;
                self.currentCity = city;
                KGGLog(@"当前城市名称------%@",city);
                //                BMKOfflineMap * _offlineMap = [[BMKOfflineMap alloc] init];
                //                NSArray* records = [_offlineMap searchCity:city];
                //                BMKOLSearchRecord* oneRecord = [records objectAtIndex:0];
                //                //城市编码如:北京为131
                //                NSInteger cityId = oneRecord.cityID;
                //                KGGLog(@"当前城市编号-------->%zd",cityId);
                //                找到了当前位置城市后就关闭服务
                //                [self.service stopUserLocationService];
            }
        }
    }];
    
    //发起反地理编码
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    option.reverseGeoPoint = pt;
    BOOL flag = [codeSearch reverseGeoCode:option];
    if (flag) {
        KGGLog(@"反geo检索发送成功");
    }else{
        KGGLog(@"反geo检索发送失败");
    }
    //更新位置数据
    [self.mapView updateLocationData:userLocation];
    //获取用户的坐标
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    self.mapView.zoomLevel = 18;
    if (userLocation.location.coordinate.latitude != 0) {
        [_service stopUserLocationService];
    }
}

#pragma mark - BMKMapViewDelegate
//点击气泡
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    KGGLog(@"点击大头针");
}
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    KGGLog(@"点击气泡");
    self.backBlock(self.addressDetails,self.longitudeAMap,self.latitudeAMap);
    [self.navigationController popViewControllerAnimated:YES];
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *pin = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotation"];
        pin.pinColor = BMKPinAnnotationColorRed;
        [pin setSelected:YES];
        return pin;
    }
    return nil;
}

#pragma mark - 搜索框
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    KGGLog(@"开始改变时 %@",searchText);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    KGGLog(@"点击搜索按钮跳转页面");
    KGGLog(@"%@",searchBar.text);
    KGGAMapSearchViewController *searchVC = [[KGGAMapSearchViewController alloc]init];
    searchVC.city = self.currentCity;
    searchVC.searchAddress = searchBar.text;
    searchVC.backLock = ^(BMKPoiInfo *poi) {
        KGGLog(@"点击的墨一行");
        [_mapView removeAnnotation:[_mapView.annotations firstObject]];
        [self updataSearch:poi];
    };
    [self.navigationController pushViewController:searchVC animated:YES];
}


//更新输入的地址
- (void)updataSearch:(BMKPoiInfo *)poi
{
    BMKGeoCodeSearch *codeSearch = [[BMKGeoCodeSearch alloc]init];
    codeSearch.delegate = self;
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = poi.pt;
    BOOL flag = [codeSearch reverseGeoCode:option];
    if (flag) {
        KGGLog(@"反geo检索发送成功");
    }else{
        KGGLog(@"反geo检索发送失败");
    }
}

#pragma mark - 饭地理编码代理
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = [NSString stringWithFormat:@"%@",result.address];
//        NSString* titleStr;
//        NSString* showmeg;
//        titleStr = @"反向地理编码";
//        showmeg = [NSString stringWithFormat:@"%@%@",item.title,result.sematicDescription];
        self.addressDetails = result.address;
        self.longitudeAMap = result.location.longitude;
        self.latitudeAMap = result.location.latitude;
        KGGLog(@"annotations:%@",item);
        [self.mapView addAnnotation:item];
        self.mapView.centerCoordinate = result.location;
        self.mapView.isSelectedAnnotationViewFront = YES;
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)dealloc
{
    KGGLogFunc
}
#pragma mark - 地图的加载

- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
        _mapView.delegate = self;
        _mapView.mapType = BMKMapTypeStandard;
        _mapView.zoomLevel = 18;
        _mapView.rotateEnabled =NO;
        _mapView.scrollEnabled = YES;
        _mapView.showMapScaleBar = YES;
    }
    return _mapView;
}

- (BMKLocationService *)service
{
    if (!_service) {
        _service = [[BMKLocationService alloc]init];
        _service.delegate = self;
    }
    return _service;
}

- (UISearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate  = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.frame = CGRectMake(kMainScreenWidth/2-100, 20, 200, 44);
    }
    return _searchController;
}

//返回按钮
- (void)baseLeftAction
{
    self.backBlock(self.addressDetails,self.longitudeAMap,self.latitudeAMap);
    [self.navigationController popViewControllerAnimated:YES ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
