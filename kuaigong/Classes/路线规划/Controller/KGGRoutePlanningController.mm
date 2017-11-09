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
#import "UIImage+Rotate.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


#define  routeHeight  334
#define  routeWidth  kMainScreenWidth-30
#define  routeTableViewCellHeight 125


#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

/**
 *  路线的标注
 */
@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; //0:起点 1:终点 2:公交 3:地铁 4:驾车 5:途经点
    int _degree;
}
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;

@end


@interface KGGRoutePlanningController ()<KGGRouteTableViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) KGGRouteTableView *routeTableView;
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKRouteSearch *routesearch;
@property (nonatomic, assign) CLLocationCoordinate2D userPt;

@end

@implementation KGGRoutePlanningController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    _routesearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    _routesearch.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.fd_interactivePopDisabled = YES;//禁止右滑
    [self loadMapView];
    [self getUserLocation];
    [self searchRoute];
}

#pragma mark -- 加载地图
- (void)loadMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    self.view = _mapView;
    [self.mapView addSubview:self.routeTableView];
}

#pragma mark -- 定位功能
- (void)getUserLocation
{
    [self setMapProperty];
    _locService = [[BMKLocationService alloc]init];
    _locService.distanceFilter = 5.0;//设置定位的最小距离
    //启动LocationService
    [_locService startUserLocationService];
}



/** 设置地图属性 */
- (void)setMapProperty
{
    self.mapView.showsUserLocation = NO;//蓝圈
    // 设置定位模式
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;//定位跟随模式
    // 允许旋转地图
    self.mapView.rotateEnabled = YES;
    [_mapView setZoomLevel:16.1];//设置地图方法等级
    // 显示比例尺 和比例尺位置
    self.mapView.showMapScaleBar = YES;
    self.mapView.mapScaleBarPosition = CGPointMake(0, self.view.xc_height - 90);
    // 定位图层自定义样式参数
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = YES;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = NO;//精度圈是否显示
    [self.mapView updateLocationViewWithParam:displayParam];
}
#pragma mark - 获取用户经纬度

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    KGGLog(@"heading is %@",userLocation.location);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];//设置定位到的位置为屏幕中心
    BMKPointAnnotation *poiAn = [self creatPointWithLocaiton:userLocation.location title:@"这是您的位置"];
    BMKAnnotationView *an = [_mapView viewForAnnotation:poiAn];
    an.tag = 10000;
    [_locService stopUserLocationService];//需要停止定位，否则创建大头针的时候会不断的添加
}

#pragma mark -- annotation添加标注
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
    
    //这里没做任何的判断，开发者可以根据自己的要求，判断不同点给不同的图
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    newAnnotationView.image = [UIImage imageNamed:@"icon_gongren"];
    newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
    return newAnnotationView;
}

/** 封装添加大头针方法 */
- (BMKPointAnnotation *)creatPointWithLocaiton:(CLLocation *)location title:(NSString *)title;
{
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = title;
    [self.mapView addAnnotation:point];
    return point;
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    //这里是点击大头针上面气泡触发的方法，可以写点击触发事件。如果需要区分是哪个大头针被点中，我用的是给她加tag值
    KGGLog(@"%ld",(long)view.tag);
}

#pragma mark -- 添加搜索功能
- (void)searchRoute{
    _routesearch = [[BMKRouteSearch alloc]init];
    [self driveBtnClick];
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark -- 事件

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
//                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.image = [UIImage imageNamed:@"icon_gongren"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.image = [UIImage imageNamed:@"icon_zhong"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}


#pragma mark - 设置驾车的路线
- (void)driveBtnClick
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    NSString *latt1 = @"30.28339767456055";
    NSString *longt1 = @"120.0134963989258";
        CLLocationCoordinate2D startPt = CLLocationCoordinate2DMake([latt1 doubleValue], [longt1 doubleValue]);
    start.pt = startPt;
//    start.pt = self.userPt;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D endPt = CLLocationCoordinate2DMake([self.orderDetails.latitude doubleValue], [self.orderDetails.longitude doubleValue]);
    end.pt = endPt;
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    if(flag){
        NSLog(@"car检索发送成功");
    }
    else{
        NSLog(@"car检索发送失败");
    }
}


#pragma mark - 私有

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}



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

