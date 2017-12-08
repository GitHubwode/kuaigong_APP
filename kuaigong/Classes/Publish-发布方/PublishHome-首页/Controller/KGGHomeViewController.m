//
//  KGGHomeViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/16.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHomeViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "KGGLeftTableController.h"
#import "SDCycleScrollView.h"
#import "KGGUseWorkerViewController.h"
#import "KGGOrderRecordController.h"
#import "KGGSlideMenu.h"
#import "KGGHomePublishModel.h"
#import "KGGPublishHomeHeaderView.h"
#import "KGGHomeListViewCell.h"
#import "KGGPublishHomeFootView.h"
#import "KGGAMapBaseViewController.h"
#import "KGGLoginViewController.h"
#import "KGGPublishHomeRequestManager.h"
#import "KGGWorkTypeModel.h"
#import "KGGCarFeeModel.h"
#import "MenuView.h"
#import "KGGPersonalMessageController.h"
#import "KGGCollectTotalController.h"
#import "KGGCollectMessageController.h"
#import "KGGShareMessageViewController.h"
#import "KGGLocationHelper.h"
#import "KGGLoginRequestManager.h"
#import "AppDelegate+KGGRongCloud.h"
#import "KGGWorkPackagesController.h"
//聊天列表和单聊
#import "KGGConversionListViewController.h"
#import "KGGPrivateMessageViewController.h"

static CGFloat const itemHeight = 120.f;
static CGFloat const topHeight = 37.f;
static CGFloat const middleHeight = 70.f;

@interface KGGHomeViewController ()<KGGPublishHomeHeaderViewDelegate,KGGPublishHomeFootViewDelegate,UITableViewDataSource,UITableViewDelegate,HomeMenuViewDelegate>

@property (nonatomic,strong)SDCycleScrollView  *headSDCycleView;
@property (nonatomic, strong)KGGPublishHomeHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KGGHomeListViewCell *homeCell;
@property (nonatomic, strong) KGGPublishHomeFootView *footView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) CGFloat longitudeMap;
@property (nonatomic, assign) CGFloat latitudeMap;
@property (nonatomic, copy) NSString *workAddress;
@property (nonatomic, strong) NSMutableArray *workDatasource;
@property (nonatomic, strong) KGGWorkTypeModel *priceModel;
@property (nonatomic, strong) KGGCarFeeModel *feeModel;
@property (nonatomic ,strong) MenuView   * menu;
@property (nonatomic, strong) KGGLeftTableController *leftView;
@property (nonatomic, strong) KGGLocationHelper *locationHelper;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSString *cityName;
/** 车辆数 */
@property (nonatomic,assign) int  carNum;

@end

@implementation KGGHomeViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app updateBadgeValueForTabBarItem];
}

- (void)viewDidAppear:(BOOL)animated {
    [JANALYTICSService startLogPageView:@"KGGHomeViewController"];
}
- (void)viewDidDisappear:(BOOL)animated {
    [JANALYTICSService stopLogPageView:@"KGGHomeViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"快工邦";
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupUserAddress];
    //创建tarBarItem
    [self setupNavi];
    //获取车费
    [self setupCarFee];
    self.tableView.tableFooterView = self.footView;
    [self.view addSubview:self.tableView];
    
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(kggPeopleNumChange:) name:KGGInputCarNumNotifacation object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(accountOfflineNotification:) name:KGGConnectionStatusOffLine object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(showBadge:) name:KGGShowAlertNotifacation object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(hidenBadge:) name:KGGHidenAlertNotifacation object:nil];
    
    [self kgg_addButton];
    
    KGGLeftTableController *leftView = [[KGGLeftTableController alloc]initWithFrame:CGRectMake(0, 0, KGGAdaptedWidth(kMainScreenWidth*0.62), kMainScreenHeight)];
    self.leftView = leftView;
    leftView.customDelegate = self;
    self.menu = [[MenuView alloc]initWithDependencyView:self.view MenuView:leftView isShowCoverView:YES];
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

#pragma mark - 获取用户的地址
- (void)setupUserAddress
{
    weakSelf(self);
    self.cityName = @"杭州总";
    [self.locationHelper getUserNearbyPois:^(BMKReverseGeoCodeResult *result) {
        [weakself.locationHelper clearLocationDelegate];
        [weakself.locationHelper clearGeoCodeSearchDelegate];
        self.cityName = result.addressDetail.city;
        KGGLog(@" 城市%@",result.addressDetail.city);
        [weakself setupRequest];
    }];
}

#pragma mark - 侧栏的代理
-(void)LeftMenuViewClick:(NSInteger)tag Drawer:(NSString *)model{
    [self.menu hidenWithAnimation];
    
    if (tag == 1000) {
        
        if ([KGGUserManager shareUserManager].logined) {
            KGGPersonalMessageController *personalVC = [[KGGPersonalMessageController alloc]init];
            personalVC.editInfoSuccessBlock = ^{
                [self.leftView changeUserAvatarIamge];
            };
            [self.navigationController pushViewController:personalVC animated:YES];
        }else{
            [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLoginViewController alloc]init]] animated:YES completion:nil];
        }
        
    }else{
        Class class = NSClassFromString(model);
        [self.navigationController pushViewController:[class new] animated:YES];
    }
}


#pragma mark -获取数据
- (void)setupRequest
{
    [KGGPublishHomeRequestManager publishHomeWorkTypeCompletion:^(NSArray<KGGWorkTypeModel *> *response) {
        if (!response)  return ;
        if (response.count == 0) return;
        [self.workDatasource removeAllObjects];
        [self.workDatasource addObjectsFromArray:response];
        [self creatTableViewHeaderView];
        self.priceModel = [self.workDatasource firstObject];
        [self.tableView reloadData];
    } aboveView:self.view inCaller:self];
}

- (void)setupCarFee
{
    [KGGPublishHomeRequestManager publishHomeWorkFeecompletion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            self.feeModel = [KGGCarFeeModel mj_objectWithKeyValues:responseObj.data];
            self.footView.carLabel.text = [NSString stringWithFormat:@"%d元",self.feeModel.itemValue];
              }
    } aboveView:nil inCaller:self];
}

#pragma makr - 获取数据创建headerView
- (void)creatTableViewHeaderView
{
    NSMutableArray *titleArray = [NSMutableArray array];
    for (KGGWorkTypeModel *model in self.workDatasource) {
        [titleArray addObject:model.name];
    }
    self.headerView = [[KGGPublishHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, KGGAdaptedHeight(itemHeight+topHeight)+middleHeight) HeaderViewSlideTitle:titleArray ImageArray:self.imageArray City:self.cityName];
    self.headerView.headerDelegate = self;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)kgg_addButton
{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(kMainScreenWidth));
        make.height.equalTo(@(KGGLoginButtonHeight));
    }];
    
    UIButton *useButton = [self snh_creatButtonImage:@"bg_button" Title:@"发布用工"];
    useButton.tag = 1000;
    UIButton *orderButton = [self snh_creatButtonImage:@"bg_button" Title:@"我的订单"];
    orderButton.tag = 1001;
    [bgView addSubview:useButton];
    [bgView addSubview:orderButton];
    [useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView.mas_centerY);
        make.leading.equalTo(bgView.mas_leading);
        make.height.equalTo(bgView.mas_height);
        make.width.equalTo(@(kMainScreenWidth/2-0.5));
    }];
    
    [orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(bgView.mas_trailing);
        make.centerY.equalTo(bgView.mas_centerY);
        make.height.equalTo(bgView.mas_height);
        make.width.equalTo(@(kMainScreenWidth/2-0.5));
    }];
}

#pragma mark - lazyButton
- (UIButton *)snh_creatButtonImage:(NSString *)image Title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = KGGFont(17);
    [button setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(snh_beginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)kggPeopleNumChange:(NSNotification *)notification
{
    CGFloat peopleNum;
    peopleNum = [[notification.userInfo objectForKey:@"peopleNum"] floatValue];
    KGGLog(@"人数:%f",peopleNum);
    if ((int)peopleNum < 5) {
        self.carNum = 0;
    }else {
        self.carNum =ceil(peopleNum/7);
    }
    KGGLog(@"车辆为%d",self.carNum);
    self.footView.carLabel.text = [NSString stringWithFormat:@"%d元*%d辆",self.feeModel.itemValue,self.carNum];
}

#pragma mark - 底部按钮
- (void)snh_beginButtonClick:(UIButton *)sender
{
    if (![KGGUserManager shareUserManager].logined){
        [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLoginViewController alloc]init]] animated:YES completion:nil];
    }else{
        KGGLog(@"登录就可以进入");
        [self jumpIWantToUse:sender];
    }
}
- (void)jumpIWantToUse:(UIButton *)sender
{
    if (sender.tag == 1000) {
        BOOL isJump = NO;
        for ( KGGHomePublishModel *publishModel in self.datasource) {
            if (![publishModel.title isEqualToString:@"底价/天"]) {
                if (publishModel.subtitle.length==0 || publishModel.subtitle == nil || [publishModel.subtitle isEqualToString:@"0"]){
                    [self.view showHint:@"用工信息不能为空"];
                    isJump = NO;
                    return;
                }else {
                    isJump = YES;
                }
            }
        }
        
        if (self.longitudeMap==0) {
            [self.view showHint:@"工作地点不能为空"];
            return;
        }
        
        if (isJump == YES) {
            KGGLog(@"我要用工");
            KGGUseWorkerViewController *useVC = [[KGGUseWorkerViewController alloc]init];
            useVC.publishDatasource = self.datasource;
            useVC.address = self.workAddress;
            useVC.longitudeMap = self.longitudeMap;
            useVC.latitudeMap = self.latitudeMap;
            useVC.catTotal = self.feeModel.itemValue*self.carNum;
            useVC.workType = self.priceModel;
            useVC.peoplePrice = self.priceModel.guidePrice;
            
            [self.navigationController pushViewController:useVC animated:YES];
        }
    }else{
        KGGLog(@"我的订单");
        KGGOrderRecordController *payVC = [[KGGOrderRecordController alloc]init];
        [self.navigationController pushViewController:payVC animated:YES];
    }
}
#pragma mark - UITableViewHeaderViewDelegate
/** 轮播图的点击 */
- (void)KGG_SDCycleTabViewDidSelectItemAtIndex:(NSInteger )index
{
    KGGShareMessageViewController *shareVC = [[KGGShareMessageViewController alloc]initWithNibName:NSStringFromClass([KGGShareMessageViewController class]) bundle:nil];
    shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:shareVC animated:YES completion:nil];

}
/** top */
- (void)KGG_SlideMenuDidSelectItemAtIndex:(NSInteger )index
{
    KGGLog(@"点击%ld",(long)index);
    self.priceModel = self.workDatasource[index];
    [self.tableView reloadData];
}

/** 中间 */
- (void)KGG_CycleCollectionViewDidSelectItemAtIndex:(NSInteger)index
{
    KGGLog(@"中间:%ld",index);
    if (index == 0) {
//        KGGCollectMessageController *collVC = [[KGGCollectMessageController alloc]init];
//        collVC.itemName = @"共享老板";
//        [self presentViewController:collVC animated:YES completion:nil];
    }else if (index == 1){
        KGGLog(@"共享班组")
        KGGCollectMessageController *collVC = [[KGGCollectMessageController alloc]init];
        collVC.itemName = @"共享班组";
        [self presentViewController:collVC animated:YES completion:nil];
    }else if (index == 2){
//        KGGWorkPackagesController *packVC = [[KGGWorkPackagesController alloc]init];
//        [self.navigationController pushViewController:packVC animated:YES];
    }else if (index == 3){
        
    }else if (index == 4){
        
    }else if (index == 5){
        KGGLog(@"快工公益")
        KGGCollectTotalController *totalVC = [[KGGCollectTotalController alloc]initWithNibName:NSStringFromClass([KGGCollectTotalController class]) bundle:nil];
        totalVC.imageName = @"快工公益";
        [self presentViewController:totalVC animated:YES completion:nil];
    }else if (index == 6){
        
    }else if (index == 7){
        KGGCollectTotalController *totalVC = [[KGGCollectTotalController alloc]initWithNibName:NSStringFromClass([KGGCollectTotalController class]) bundle:nil];
        totalVC.imageName = @"快工救援";
        [self presentViewController:totalVC animated:YES completion:nil];
    }else if (index == 8){
        
    }

}

#pragma mark - UITableViewFooterViewDelegate
- (void)kgg_publishHomeFootViewLocationButtonClick
{
    KGGLog(@"地图定位");
    KGGAMapBaseViewController *amapVC = [[KGGAMapBaseViewController alloc]init];
    amapVC.backBlock = ^(NSString *addressDetails, CGFloat longitude, CGFloat latitude) {
        KGGLog(@"详细的位置:%@",addressDetails);
        self.addressString = addressDetails;
        if (addressDetails.length ==0) {
            [self.view showHint:@"获取位置失败"];
        }else{
            self.longitudeMap = longitude;
            self.latitudeMap = latitude;
            self.workAddress = addressDetails;
            self.footView.locationLabel.text = addressDetails;
        }
    };
    [self.navigationController pushViewController:amapVC animated:YES];
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

- (void)kgg_homeMessage
{
    KGGLog(@"导航栏左边的按钮");
    [self.menu show];
}


#pragma mark - UITableViewDelegate  UITableViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KGGAdaptedHeight(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGHomePublishModel *publishModel = self.datasource[indexPath.row];
    KGGHomeListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGHomeListViewCell homeListIdentifier] forIndexPath:indexPath];
    self.homeCell = cell;
    cell.publishModel = publishModel;
    if (indexPath.row == 0) {
        cell.homeTextField.text = self.priceModel.guidePrice;
        cell.price = self.priceModel.guidePrice;
        cell.homeTextField.enabled = NO;
        publishModel.subtitle = self.priceModel.guidePrice;
        cell.loseButton.enabled = NO;
        cell.addButton.enabled = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[cell homeTextField] becomeFirstResponder];
}


- (KGGPublishHomeFootView *)footView
{
    if (!_footView) {
        _footView = [[KGGPublishHomeFootView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, KGGAdaptedHeight(itemHeight))];
        _footView.delegate =self;
    }
    return _footView;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.xc_height-49) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:@"KGGHomeListViewCell" bundle:nil] forCellReuseIdentifier:[KGGHomeListViewCell homeListIdentifier]];
        _tableView.rowHeight = KGGAdaptedHeight(51);
        _tableView.separatorStyle = UITableViewCellStyleDefault;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [KGGHomePublishModel mj_objectArrayWithFilename:@"KGGPublishMessage.plist"];
    }
    return _datasource;
}

#pragma mark - 键盘显示隐藏
- (void)keyboardWillShow:(NSNotification *)notification{
    
    //取出键盘最后的 frame
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat height = keyboardFrame.origin.y;
    //计算控制器 view 需要移动的距离
    CGFloat textField_maxY = -120;
        CGFloat space = textField_maxY+kMainScreenHeight;
        //得出键盘输入框的间距
        CGFloat transformY = height- space;
        if (transformY < 0) {
            CGRect frame = self.view.frame;
            frame.origin.y = transformY;
            self.view.frame = frame;
        }
}

- (void)keyboardWillHide:(NSNotification *)notification{
    //恢复到默认y为0的状态，有时候要考虑导航栏要+64
    CGRect frame = self.view.frame;
    frame.origin.y = 0+64;
    self.view.frame = frame;
    
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
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_wode" highImage:@"icon_wode2" target:self action:@selector(kgg_homeMessage)];
}

- (void)dealloc
{
    [KGGNotificationCenter removeObserver:self];
    KGGLogFunc;
}

- (NSMutableArray *)workDatasource
{
    if (!_workDatasource) {
        _workDatasource = [NSMutableArray array];
    }
    return _workDatasource;
}

- (KGGLocationHelper *)locationHelper
{
    if (!_locationHelper) {
        _locationHelper = [[KGGLocationHelper alloc]init];
    }
    return _locationHelper;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithObjects:@"pic_banner1",@"pic_banner2",@"pic_banner3",@"pic_banner4",@"pic_banner5",@"pic_banner6",@"pic_banner7", nil];
    }
    return _imageArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
