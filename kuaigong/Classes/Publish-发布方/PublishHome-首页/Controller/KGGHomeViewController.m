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
#import "KGGSliderMenuTool.h"
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


static CGFloat const itemHeight = 168.f;
static CGFloat const topHeight = 37.f;

@interface KGGHomeViewController ()<KGGPublishHomeHeaderViewDelegate,KGGPublishHomeFootViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)SDCycleScrollView  *headSDCycleView;
@property (nonatomic, strong)KGGPublishHomeHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KGGHomeListViewCell *homeCell;
@property (nonatomic, strong) KGGPublishHomeFootView *footView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) CGFloat longitudeMap;
@property (nonatomic, assign) CGFloat latitudeMap;
@property (nonatomic, copy) NSString *workAddress;
//@property (nonatomic, assign) NSUInteger topIndex;
@property (nonatomic, strong) NSMutableArray *workDatasource;
@property (nonatomic, strong) KGGWorkTypeModel *priceModel;
@property (nonatomic, strong) KGGCarFeeModel *feeModel;

@end

@implementation KGGHomeViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupRequest];
    self.tabBarController.tabBar.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"快工";
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建tarBarItem
    [self setupNavi];
    //获取车费
    [self setupCarFee];
    self.tableView.tableFooterView = self.footView;
    [self.view addSubview:self.tableView];
    
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self kgg_addButton];
    
}

#pragma mark -获取数据
- (void)setupRequest
{
    [KGGPublishHomeRequestManager publishHomeWorkTypeCompletion:^(NSArray<KGGWorkTypeModel *> *response) {
        if (!response)  return ;
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
            self.footView.carLabel.text = [NSString stringWithFormat:@"每辆车车费:%d元",self.feeModel.itemValue];
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
    
    NSArray *imageNames = @[@"pic.png",
                            @"pic_gangjin.png",
                            @"pic_jiazi.png",
                            @"pic-jia.png",
                            @"pic.png",
                            @"pic_gangjin.png",
                            @"pic_jiazi.png",
                            @"pic-jia.png"// 本地图片请填写全名
                            ];
    self.headerView = [[KGGPublishHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, itemHeight+topHeight) HeaderViewSDCycleImage:imageNames SlideTitle:titleArray];
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
    
    UIButton *useButton = [self snh_creatButtonImage:@"bg_button" Title:@"现在用工"];
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
        int i=0;
        BOOL isJump = NO;
        CGFloat peopleNum = 0;
        int carNum = 0;
        for ( KGGHomePublishModel *publishModel in self.datasource) {
            i++;
            if (![publishModel.title isEqualToString:@"价格/天"]) {
                if (publishModel.subtitle.length==0 || publishModel.subtitle == nil || [publishModel.subtitle isEqualToString:@"0"]){
                    [self.view showHint:@"用工信息不能为空"];
                    isJump = NO;
                    return;
                }else {
                    isJump = YES;
                }
            }
            if ([publishModel.title isEqualToString:@"用工人数"]) {
                peopleNum =  [publishModel.subtitle intValue];
            }
        }
        
       
        
        if ((int)peopleNum<4) {
            carNum = 0;
        }else if([self isPureFloat:[NSString stringWithFormat:@"%f",peopleNum/7]]) {
            carNum =(int) (peopleNum/7+1);
        }
        
        KGGLog(@"车辆为%d",carNum);
        
        self.footView.carLabel.text = [NSString stringWithFormat:@"车费总计:%d元*%d",self.feeModel.itemValue,carNum];

        
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
            useVC.catTotal = self.feeModel.itemValue*carNum;
            useVC.workType = self.priceModel;
            useVC.peoplePrice = self.priceModel.guidePrice;;
            
            [self.navigationController pushViewController:useVC animated:YES];
        }
    }else{
        KGGLog(@"我的订单");
        KGGOrderRecordController *payVC = [[KGGOrderRecordController alloc]init];
        [self.navigationController pushViewController:payVC animated:YES];
    }
}
#pragma mark - 字符串判断为浮点数
-(BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark - UITableViewHeaderViewDelegate
/** 轮播图的点击 */
- (void)KGG_SDCycleTabViewDidSelectItemAtIndex:(NSInteger )index
{
    KGGLog(@"轮播图%ld",(long)index);
}
/** top */
- (void)KGG_SlideMenuDidSelectItemAtIndex:(NSInteger )index
{
    KGGLog(@"点击%ld",(long)index);
    self.priceModel = self.workDatasource[index];
    [self.tableView reloadData];
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
            [self.footView.locationButton setTitle:addressDetails forState:UIControlStateNormal];
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
    }else{
        [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLoginViewController alloc]init]] animated:YES completion:nil];
    }
}

- (void)kgg_homeMessage
{
    KGGLog(@"导航栏左边的按钮");
    [KGGSliderMenuTool showWithRootViewController:self contentViewController:[[KGGLeftTableController alloc] init]];
}


#pragma mark - UITableViewDelegate  UITableViewDatasource
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
        _footView = [[KGGPublishHomeFootView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, itemHeight)];
        _footView.delegate =self;
    }
    return _footView;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:@"KGGHomeListViewCell" bundle:nil] forCellReuseIdentifier:[KGGHomeListViewCell homeListIdentifier]];
        _tableView.rowHeight = 45.f;
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
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_xiaoxi" highImage:@"icon_xiaoxi2" target:self action:@selector(kgg_homeUserMessage)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
