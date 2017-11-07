//
//  KGGRoutePlanningController.m
//  kuaigong
//
//  Created by Ding on 2017/11/6.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGRoutePlanningController.h"
#import "KGGOrderDetailsModel.h"
#import "KGGRouteTableView.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#define  routeHeight  334
#define  routeWidth  kMainScreenWidth-30
#define  routeTableViewCellHeight 125

@interface KGGRoutePlanningController ()<KGGRouteTableViewDelegate,BMKMapViewDelegate,BMKRouteSearchDelegate>

@property (nonatomic, strong) KGGRouteTableView *routeTableView;
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKRouteSearch *routesearch;

@end

@implementation KGGRoutePlanningController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    KGGLog(@"orderDetails:%@",self.orderDetails);
    [self.view addSubview:self.routeTableView];
}

#pragma mark - 设置路线























#pragma mark -KGGRouteTableViewDelegate
- (void)routeRouteTableViewArrowButtonClick:(UIButton *)sender
{
    if (!sender.selected) {
        self.routeTableView.frame = CGRectMake(15, self.view.xc_height-routeHeight-10+routeTableViewCellHeight, routeWidth, routeHeight-routeTableViewCellHeight);
    }else{
        self.routeTableView.frame = CGRectMake(15, self.view.xc_height-routeHeight-10, routeWidth, routeHeight);
    }
    sender.selected = !sender.selected;
}

- (void)routeRouteTableViewButtonClickTag:(UIButton *)buttonTag
{
    KGGLog(@"%ld",(long)buttonTag.tag);
    if (buttonTag.tag==1000) {
        KGGLog(@"打电话")
    }else if (buttonTag.tag == 1002){
        KGGLog(@"聊天");
    }else if (buttonTag.tag == 10000){
        KGGLog(@"联系我们");
    }else if (buttonTag.tag == 10001){
        KGGLog(@"取消订单");
    }else if (buttonTag.tag == 10002){
        KGGLog(@"更多");
    }else if (buttonTag.tag == 10003){
        KGGLog(@"确认出工");
    }
}

#pragma mark - 地图的加载

- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.xc_height)];
        _mapView.delegate = self;
        _mapView.mapType = BMKMapTypeStandard;
        _mapView.zoomLevel = 18;
        _mapView.rotateEnabled =NO;
        _mapView.scrollEnabled = YES;
        _mapView.showMapScaleBar = YES;
    }
    return _mapView;
}

#pragma mark -懒加载

- (KGGRouteTableView *)routeTableView
{
    if (!_routeTableView) {
        _routeTableView = [[KGGRouteTableView alloc]initWithFrame:CGRectMake(15, self.view.xc_height-routeHeight-64-10, routeWidth, routeHeight) OrderModel:self.orderDetails];
        _routeTableView.routeDelegate = self;
    }
    return _routeTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    KGGLogFunc
}
@end
