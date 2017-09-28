//
//  KGGAMapBaseViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGAMapBaseViewController.h"
#import "KGGAMapSearchViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface KGGAMapBaseViewController ()<MAMapViewDelegate,AMapSearchDelegate,UISearchResultsUpdating,UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic,retain) AMapSearchAPI *search;

@end

@implementation KGGAMapBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
}

- (void)dealloc
{
    KGGLogFunc
}
#pragma mark - 地图的加载
- (MAMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        _mapView.showsCompass = YES;
        _mapView.showsUserLocation = YES;
    }
    return _mapView;
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

- (AMapSearchAPI *)search
{
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
