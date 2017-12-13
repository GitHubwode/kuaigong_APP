//
//  KGGLookWorkViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLookWorkViewController.h"
#import "KGGLookWorkViewCell.h"
#import "KGGOrderDetailsModel.h"
#import "KGGSearchOrderController.h"
#import "KGGLocationHelper.h"
#import "KGGCancelOrderPayView.h"
#import "KGGLookWorkHeaderView.h"
#import "KGGLoginViewController.h"
#import "KGGStationCycleScrollView.h"
#import "KGGPostedModel.h"
#import "KGGJPushManager.h"
#import "KGGConversionListViewController.h"
#import "KGGLoginRequestManager.h"
#import "AppDelegate+KGGRongCloud.h"
#import "KGGWorkDetailsViewController.h"
#import "KGGPublishOrderRequestManager.h"

static CGFloat kCycleScrollViewH = 39.f;

@interface KGGLookWorkViewController ()<UITableViewDelegate,UITableViewDataSource,KGGStationCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) NSUInteger pageNum;
@property (nonatomic, strong) KGGLocationHelper *locationHelper;
@property (nonatomic, strong) KGGCancelOrderPayView *payView;
@property (nonatomic, strong) KGGLookWorkHeaderView *headerView;
@property (nonatomic, strong) KGGStationCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *messageDatasource;
@property (nonatomic, strong) UIButton *JPButton;
@property (nonatomic, strong) NSString *isJPush;


@end

@implementation KGGLookWorkViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self RefreshNewMessag];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.navigationItem.title = @"快工邦";
    //创建tarBarItem
    [self setupNavi];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.mj_header = [KGGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(RefreshNewMessag)];
    self.tableView.mj_footer = [KGGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadAddMoreMessage)];
    [self.tableView.mj_header beginRefreshing];
    [self.view addSubview:self.tableView];
    [self addDataMesssage];
    
    [self addNotificationMessage];
}

- (void)addNotificationMessage
{
    [KGGNotificationCenter addObserver:self selector:@selector(kggJumpController:) name:KGGRongYunReceiedNotifacation object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(accountOfflineNotification:) name:KGGConnectionStatusOffLine object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(showBadge:) name:KGGShowAlertNotifacation object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(hidenBadge:) name:KGGHidenAlertNotifacation object:nil];
}

#pragma mark - 导航栏按钮的点击事件
- (void)kgg_homeUserMessage
{
    KGGLog(@"导航栏右边的按钮");
    BOOL login = [KGGUserManager shareUserManager].logined;
    if (login) {
        KGGLog(@"已登录");
        self.navigationItem.rightBarButtonItem.badgeValue = @"0";
        KGGConversionListViewController *listVC = [[KGGConversionListViewController alloc]init];
        [self.navigationController pushViewController:listVC animated:YES];
    }else{
        [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLoginViewController alloc]init]] animated:YES completion:nil];
    }
}

- (void)kgg_homelocation
{
    KGGLog(@"导航栏左边的按钮");
    //    [KGGSliderMenuTool showWithRootViewController:self contentViewController:[[KGGLeftTableController alloc] init]];
}

#pragma mark - 增加导航按钮
- (void)showBadge:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationItem.rightBarButtonItem.badgeValue = @"1";
    });
}

- (void)hidenBadge:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationItem.rightBarButtonItem.badgeValue = @"0";
    });
}

- (void)accountOfflineNotification:(NSNotification *)noti
{
    [KGGLoginRequestManager logout];
    KGGLoginViewController *login = [[KGGLoginViewController alloc]init];
    login.offline = 1;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:login] animated:YES completion:nil];
    });
}

#pragma mark - 获取到通知的信息
- (void)kggJumpController:(NSNotification *)notification
{
    KGGLog(@"通知的内容%@",notification);
    KGGLog(@"%@",notification.userInfo);
    
    NSUInteger type = [[notification.userInfo objectForKey:@"type"] integerValue];
    if (type == 502) {
        [self RefreshNewMessag];
    }else if (type == 508){
        NSString *orderId = [notification.userInfo objectForKey:@"orderId"];
        [self setupOrderMessageRequestOrderId:[orderId integerValue]];
    }
}

#pragma mark - 推送获取订单详情
- (void)setupOrderMessageRequestOrderId:(NSUInteger )orderId
{
    [KGGPublishOrderRequestManager publishOrderDetailsMessageOrder:orderId completion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            KGGOrderDetailsModel *model = [KGGOrderDetailsModel mj_objectWithKeyValues:responseObj.data];
            KGGWorkDetailsViewController *workVC = [[KGGWorkDetailsViewController alloc]initWithNibName:NSStringFromClass([KGGWorkDetailsViewController class]) bundle:[NSBundle mainBundle]];
            workVC.isNotification = YES;
            workVC.searchOrderModel = model;
            [self.navigationController pushViewController:workVC animated:YES];
        }
    } aboveView:self.view inCaller:self];
}

- (void)addDataMesssage
{
    KGGPostedModel *model = [[KGGPostedModel alloc]init];
    model.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/1as14jc2z4c8ktw009hyuh3ph5gv94f0.jpg";
    model.name = @"李**";
    model.phone = @"133****1243";
    [self.messageDatasource addObject:model];
    
    
    KGGPostedModel *model1 = [[KGGPostedModel alloc]init];
    model1.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/1klngysvgo1doib5putajd5hpvwdeijo.jpg";
    model1.name = @"张**";
    model1.phone = @"136****3453";
    [self.messageDatasource addObject:model1];
    
    KGGPostedModel *model2 = [[KGGPostedModel alloc]init];
    model2.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/1kjvwbzcbh3n4irz1qx5igm73ozg0zi4.jpg";
    model2.name = @"李**";
    model2.phone = @"151****4094";
    [self.messageDatasource addObject:model2];
    
    KGGPostedModel *model3 = [[KGGPostedModel alloc]init];
    model3.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/1klngysvgo1doib5putajd5hpvwdeijo.jpg";
    model3.name = @"王**";
    model3.phone = @"152****1986";
    [self.messageDatasource addObject:model3];
    
    KGGPostedModel *model4 = [[KGGPostedModel alloc]init];
    model4.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/2s4zax3t0p1hehmhujc7wtv4e5xic7fa.jpg";
    model4.name = @"刘**";
    model4.phone = @"189****7620";
    [self.messageDatasource addObject:model4];
    
    KGGPostedModel *model5 = [[KGGPostedModel alloc]init];
    model5.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/369a3iq1j6r4v6716cgtkr1r0hnvhk1v.jpg";
    model5.name = @"郑**";
    model5.phone = @"131****0954";
    [self.messageDatasource addObject:model5];
    
    KGGPostedModel *model6 = [[KGGPostedModel alloc]init];
    model6.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/41i81srszo1rkburqhf3aw2y17syzaz1.jpg";
    model6.name = @"王**";
    model6.phone = @"150****1975";
    [self.messageDatasource addObject:model6];
    
    KGGPostedModel *model7 = [[KGGPostedModel alloc]init];
    model7.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/45x0g6skk5bnfbediomc9y1ldm3bp5pu.jpg";
    model7.name = @"苗**";
    model7.phone = @"139****0983";
    [self.messageDatasource addObject:model7];
    
    KGGPostedModel *model8 = [[KGGPostedModel alloc]init];
    model8.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/4ci25wrlwtcdxdlt4szf0ntj8ccllxgk.jpg";
    model8.name = @"秦**";
    model8.phone = @"133****9740";
    [self.messageDatasource addObject:model8];
    
    [self.headerView addSubview:self.cycleScrollView];
    self.cycleScrollView.messageDatasource = self.messageDatasource;
    [self.headerView addSubview:self.JPButton];
    self.isJPush = [NSUserDefaults objectForKey:KGGJPushType];
    if ([self.isJPush isEqualToString:@"YES"]) {
        self.JPButton.selected = NO;
    }else{
        self.JPButton.selected = YES;
    }
    KGGLog(@"角色:%@",[NSUserDefaults objectForKey:KGGJPushType]);
    weakSelf(self);
    [self.JPButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.cycleScrollView.mas_bottom);
        make.height.equalTo(@(kCycleScrollViewH-5));
        make.left.equalTo(weakself.cycleScrollView.mas_right).offset(5);
        make.right.equalTo(weakself.headerView.mas_right).offset(-5);
    }];
}

#pragma mark - 请求数据
- (void)RefreshNewMessag
{
    self.pageNum = 1;
    [self kgg_hostLiveLocation:YES];
}

- (void)LoadAddMoreMessage
{
    [self kgg_hostLiveLocation:NO];
}

- (void)kgg_hostLiveLocation:(BOOL)refresh
{
    __block CGFloat longitude;
    __block CGFloat latitude;
    weakSelf(self);
    [self.locationHelper getUserCurrentLocation:^(CLLocation *location) {
        
        [weakself.locationHelper clearLocationDelegate];
        weakself.locationHelper = nil;
        
        CLLocationCoordinate2D coordinate = location.coordinate;
        longitude = coordinate.longitude;
        latitude = coordinate.latitude;        
        [weakself setupUserLongitude:longitude Latitude:latitude Refresh:refresh];
        
        [self.locationHelper getUserNearbyPois:^(BMKReverseGeoCodeResult *result) {
            
            KGGLog(@"城市信息:%@ 地址设计:%@",result.addressDetail.city,result.address);
            
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:result.addressDetail.city target:self action:@selector(kgg_homelocation)];

        } location:location];
    }];
}

#pragma mark - 获取经纬度
- (void)setupUserLongitude:(CGFloat )longitude Latitude:(CGFloat)latitude Refresh:(BOOL)refresh
{
    [KGGPublishOrderRequestManager publishOrderListType:self.requestType Page:self.pageNum UserId:[[KGGUserManager shareUserManager].currentUser.userId integerValue] Order:0 Latitude:latitude Longitude:longitude completion:^(NSArray<KGGOrderDetailsModel *> *response) {
        if (!response) {
            if (refresh) {
                [self.tableView.mj_header endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{ //有数据
            self.pageNum ++;
            if (refresh) {
                [self.tableView.mj_header endRefreshing];
                [self.datasource removeAllObjects];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            [self.datasource addObjectsFromArray:response];
        }
        [self.tableView reloadData];
        if (self.datasource.count == 0) {
            [self.tableView showBusinessErrorViewWithError:@"这里还没有内容" yOffset:100.f];
        }
        
    } aboveView:self.view inCaller:self];
    
}


#pragma mark - UITableViewDelegate  UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGOrderDetailsModel *model = self.datasource[indexPath.row];
    KGGLookWorkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGLookWorkViewCell lookWorkIdentifier] forIndexPath:indexPath];
    cell.detailsModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![KGGUserManager shareUserManager].logined) {
        [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLoginViewController alloc]init]] animated:YES completion:nil];
        return;
    }
    KGGOrderDetailsModel *model = self.datasource[indexPath.row];
    if (![KGGUserManager shareUserManager].currentUser.isRegister) {
        [self.view showHint:@"非签约用户,请联系快工公司"];
        return;
    }else if (model.status == 0){
        KGGLog(@"订单详情");
        KGGSearchOrderController *orderVC = [[KGGSearchOrderController alloc]init];
        orderVC.orderDetails = model;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else{
        [self.view showHint:@"来晚了,此订单已接"];
    }
}

#pragma mark - 取消推送的点击按钮
- (void)beginJPushButtonClick:(UIButton *)sender
{
    if (sender.selected) {
        KGGLog(@"打开推送和");
        self.isJPush = @"YES";
        [[KGGJPushManager shareJPushManager]cmd_beginJPush];
    }else{
        KGGLog(@"取消推送和");
        self.isJPush = @"NO";
        [[KGGJPushManager shareJPushManager]cmd_stopJPush];
    }
    sender.selected = !sender.selected;
    [self saveUserJPush];
}

#pragma mark - 存储用户是否接受通知的信息
- (void)saveUserJPush
{
    [NSUserDefaults removeObjectForKey:KGGJPushType];
    //首次存取角色
    [NSUserDefaults setObject:self.isJPush forKey:KGGJPushType];
    KGGLog(@"角色:%@",[NSUserDefaults objectForKey:KGGJPushType]);
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"KGGLookWorkViewCell" bundle:nil] forCellReuseIdentifier:[KGGLookWorkViewCell lookWorkIdentifier]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (KGGLocationHelper *)locationHelper{
    if (!_locationHelper) {
        _locationHelper = [[KGGLocationHelper alloc] init];
    }
    return _locationHelper;
}

- (KGGLookWorkHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KGGLookWorkHeaderView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 174)];
    }
    return _headerView;
}

- (KGGStationCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [KGGStationCycleScrollView snh_cycleScrollViewWithFrame:CGRectMake(0, 135, kMainScreenWidth-100, kCycleScrollViewH) delegate:self type:StationCycleScrollViewType];
    }
    return _cycleScrollView;
}

- (UIButton *)JPButton
{
    if (!_JPButton) {
        _JPButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _JPButton.layer.masksToBounds = YES;
        _JPButton.layer.cornerRadius = 10.f;
        _JPButton.titleLabel.font = KGGFont(12);
        [_JPButton setTitle:@"停止接单" forState:UIControlStateNormal];
        [_JPButton setTitle:@"开始接单" forState:UIControlStateSelected];
        [_JPButton setTitleColor:KGGGoldenThemeColor forState:UIControlStateNormal];
        [_JPButton setTitleColor:UIColorHex(0xffffff) forState:UIControlStateSelected];
        [_JPButton setBackgroundImage:[UIImage imageNamed:@"bg_00"] forState:UIControlStateNormal];
        [_JPButton setBackgroundImage:[UIImage imageNamed:@"but_kean"] forState:UIControlStateSelected];
        [_JPButton addTarget:self action:@selector(beginJPushButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _JPButton;
}

- (NSMutableArray *)messageDatasource
{
    if (!_messageDatasource) {
        _messageDatasource = [NSMutableArray array];
    }
    return _messageDatasource;
}

#pragma mark - 创建item
- (void)setupNavi
{
    int count = [[RCIMClient sharedRCIMClient]
                 getTotalUnreadCount];
    count = count > 0 ? count : 0;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_xiaoxi" highImage:@"icon_xiaoxi2" target:self action:@selector(kgg_homeUserMessage)];
    self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%d",count];
    self.navigationItem.rightBarButtonItem.badgeFont = KGGFont(0);
    self.navigationItem.rightBarButtonItem.badgeMinSize = 2.f;
    self.navigationItem.rightBarButtonItem.badgeOriginX = 27.f;
    self.navigationItem.rightBarButtonItem.badgeOriginY = 3.f;
    self.navigationItem.rightBarButtonItem.shouldHideBadgeAtZero = YES;
    self.navigationItem.rightBarButtonItem.badgeBGColor = UIColorHex(0xffd200);
}

- (void)dealloc
{
    [KGGNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
