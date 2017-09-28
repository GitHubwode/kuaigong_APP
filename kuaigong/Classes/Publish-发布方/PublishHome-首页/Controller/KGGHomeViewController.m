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
#import "KGGHomeListViewController.h"
#import "KGGUseWorkerViewController.h"
#import "KGGOrderRecordController.h"
#import "CKSlideMenu.h"

//测试登录
#import "KGGLoginViewController.h"
#import "KGGAMapBaseViewController.h"

static CGFloat const itemHeight = 168.f;

@interface KGGHomeViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong)SDCycleScrollView      *headSDCycleView;

@end

@implementation KGGHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.navigationItem.title = @"快工";
    self.fd_interactivePopDisabled = YES;//禁止右滑
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建tarBarItem
    [self setupNavi];
    
    [self setupChildViewControllers];
    [self kgg_addSDCycleImage];
    
    [self kgg_addButton];
    
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [KGGNotificationCenter addObserver:self selector:@selector(buttonClickLocation) name:@"aaaaaaaaa" object:nil];

}

- (void)buttonClickLocation
{
    KGGLog(@"点击点击");
    KGGAMapBaseViewController *amapVC = [[KGGAMapBaseViewController alloc]init];
    [self.navigationController pushViewController:amapVC animated:YES];
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
    self.view.frame = frame;}


- (void)kgg_addButton
{
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, kMainScreenHeight-KGGLoginButtonHeight-64, kMainScreenWidth, KGGLoginButtonHeight);
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    UIButton *useButton = [self snh_creatButtonImage:@"btn_left" Title:nil];
    useButton.tag = 1000;
    UIButton *orderButton = [self snh_creatButtonImage:@"btn_right" Title:nil];
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


#pragma mark - 底部按钮
- (void)snh_beginButtonClick:(UIButton *)sender
{
    if (sender.tag == 1000) {
        KGGLog(@"我要用工");
        KGGUseWorkerViewController *useVC = [[KGGUseWorkerViewController alloc]init];
        [self.navigationController pushViewController:useVC animated:YES];
       
    }else{
        KGGLog(@"支付订单");
        KGGOrderRecordController *payVC = [[KGGOrderRecordController alloc]init];
        [self.navigationController pushViewController:payVC animated:YES];
    }
}

- (void)kgg_addSDCycleImage
{
    NSArray *imageNames = @[@"pic.png",
                            @"pic_gangjin.png",
                            @"pic_jiazi.png",
                            @"pic-jia.png",
                            @"pic.png",
                            @"pic_gangjin.png",
                            @"pic_jiazi.png",
                            @"pic-jia.png"// 本地图片请填写全名
                            ];
    
    self.headSDCycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, itemHeight) delegate:self placeholderImage:[UIImage imageNamed:@""]];
    self.headSDCycleView.currentPageDotImage = [UIImage imageNamed:@"point_xuan"];
    self.headSDCycleView.pageDotImage = [UIImage imageNamed:@"point"];
    self.headSDCycleView.imageURLStringsGroup = imageNames;
    self.headSDCycleView.autoScroll = NO;
    
    [self.view addSubview:self.headSDCycleView];
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    KGGLog(@"---点击了第%ld张图片", (long)index);
    
}

 
 // 滚动到第几张图回调
 - (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
 {
     KGGLog(@">>>>>> 滚动到第%ld张图", (long)index);
 }


- (void)setupChildViewControllers
{
    NSArray *titles = @[@"木工",@"钢筋工",@"内架子工",@"外架子工",@"泥工",@"水电工",@"电焊工",@"小工"];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i <titles.count ; i++) {
        [arr addObject:[KGGHomeListViewController new]];
    }
    CKSlideMenu *slideMenu = [[CKSlideMenu alloc]initWithFrame:CGRectMake(0, itemHeight, kMainScreenWidth, 37) titles:titles controllers:arr];
    slideMenu.bodyFrame = CGRectMake(0,  itemHeight + 37, kMainScreenWidth, kMainScreenHeight- itemHeight-KGGLoginButtonHeight-101);
    slideMenu.bodySuperView = self.view;
    slideMenu.indicatorOffsety = 2;
    slideMenu.indicatorWidth = 40;
    slideMenu.indicatorColor =KGGGoldenThemeColor;
    slideMenu.titleStyle = SlideMenuTitleStyleGradient;
    slideMenu.selectedColor = KGGGoldenThemeColor;
    slideMenu.unselectedColor = KGGTimeTextColor;
    [self.view addSubview:slideMenu];
}

#pragma mark - 创建item
- (void)setupNavi
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_xiaoxi" highImage:@"icon_xiaoxi2" target:self action:@selector(kgg_homeUserMessage)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_wode" highImage:@"icon_wode2" target:self action:@selector(kgg_homeMessage)];
}


#pragma mark - 导航栏按钮的点击事件
- (void)kgg_homeUserMessage
{
    KGGLog(@"导航栏右边的按钮");
    [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLoginViewController alloc]init]] animated:YES completion:nil];
}

- (void)kgg_homeMessage
{
    KGGLog(@"导航栏左边的按钮");
    [KGGSliderMenuTool showWithRootViewController:self contentViewController:[[KGGLeftTableController alloc] init]];
}

#pragma mark - lazyButton
- (UIButton *)snh_creatButtonImage:(NSString *)image Title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(snh_beginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)dealloc
{
    KGGLogFunc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
