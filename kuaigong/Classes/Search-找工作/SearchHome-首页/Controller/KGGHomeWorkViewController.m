//
//  KGGHomeWorkViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHomeWorkViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "SUNSlideSwitchView.h"
#import "KGGLookWorkViewController.h"
#import "KGGMeWorkViewController.h"
#import <CoreLocation/CoreLocation.h>

//测试接单
#import "KGGSearchOrderController.h"

@interface KGGHomeWorkViewController ()<SUNSlideSwitchViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) SUNSlideSwitchView *slideSwitchView;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, copy)NSString *cityName;



@end

@implementation KGGHomeWorkViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.navigationItem.title = @"快工";
    self.fd_interactivePopDisabled = YES;//禁止右滑
    //创建tarBarItem
    [self setupNavi];
    [self kgg_hostLiveLocation];
    [self setupChildViewControllers];
    [self setUpSlideSwitchView];

}

#pragma mark - 定位
- (void)kgg_hostLiveLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 1000;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager requestAlwaysAuthorization];
        //开始定位
        [self.locationManager startUpdatingLocation];
    }else{
        [self.view showHint:@"您尚未开启定位,请开启定位功能"];
    }
}

#pragma mark - CoreLocationdelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    //获取当前所在城市的名字
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //根据经纬度反向编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            //获取城市
            self.cityName = placemark.locality;
            if (!self.cityName) {
                self.cityName = placemark.administrativeArea;
            }
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:self.cityName target:self action:@selector(kgg_homelocation)];            [manager stopUpdatingLocation];
            
        }else if (error == nil && [placemarks count] == 0){
            [self.view showHint:@"定位不成功"];
        }else{
            [self.view showHint:@"定位失败"];
        }
    }];
}



- (void)setupChildViewControllers
{
    KGGLookWorkViewController *woodVC = [[KGGLookWorkViewController alloc]init];
    //    hostVC.requestType = SNHNewListRequestAudienceType;
    [self addChildViewController:woodVC];
    
    KGGMeWorkViewController *steelVC = [[KGGMeWorkViewController alloc]init];
    //    appointVC.requestType = SNHNewListRequestHostType;
    [self addChildViewController:steelVC];
    
    
    _titles = @[@"发现工作",@"我"];
}

- (void)setUpSlideSwitchView
{
    _slideSwitchView = [[SUNSlideSwitchView alloc]initWithFrame:self.view.bounds heightOfTopScrollView:50.f];
    _slideSwitchView.xc_height -= 64.f;
    _slideSwitchView.widthOfButtonMargin = 40.f;
    _slideSwitchView.bottomLineView.hidden = NO;
    _slideSwitchView.slideSwitchViewDelegate = self;
    _slideSwitchView.kFontSizeOfTabButton = 18.f;
    _slideSwitchView.topScrollView.backgroundColor = [UIColor whiteColor];
    _slideSwitchView.tabItemNormalColor = KGGTimeTextColor;
    _slideSwitchView.tabItemSelectedColor = KGGGoldenThemeColor;
    _slideSwitchView.shadowImage = [UIImage imageNamed:@"chosebar"];
    [_slideSwitchView buildUI];
    [self.view addSubview:_slideSwitchView];
}


#pragma mark - 创建item
- (void)setupNavi
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_xiaoxi" highImage:@"icon_xiaoxi2" target:self action:@selector(kgg_homeUserMessage)];
}

#pragma mark - SUNSlideSwitchViewDelegate
- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view{
    return self.childViewControllers.count;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number{
    return self.childViewControllers[number];
}

- (NSString *)slideSwitchView:(SUNSlideSwitchView *)view titleOfTab:(NSUInteger)number{
    return _titles[number];
}

#pragma mark - 导航栏按钮的点击事件
- (void)kgg_homeUserMessage
{
    KGGLog(@"导航栏右边的按钮");
    KGGSearchOrderController *orderVC = [[KGGSearchOrderController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
//    [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLoginViewController alloc]init]] animated:YES completion:nil];
}

- (void)kgg_homelocation
{
    KGGLog(@"导航栏左边的按钮");
//    [KGGSliderMenuTool showWithRootViewController:self contentViewController:[[KGGLeftTableController alloc] init]];
}

- (void)dealloc
{
    KGGLogFunc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
