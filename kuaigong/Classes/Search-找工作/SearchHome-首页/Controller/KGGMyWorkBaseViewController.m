//
//  KGGMyWorkBaseViewController.m
//  kuaigong
//
//  Created by Ding on 2017/10/26.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMyWorkBaseViewController.h"
#import "KGGMyWorkViewController.h"
#import "SUNSlideSwitchView.h"

@interface KGGMyWorkBaseViewController ()<SUNSlideSwitchViewDelegate>
@property (nonatomic, strong) SUNSlideSwitchView *slideSwitchView;
@property (nonatomic, strong) NSArray<NSString *> *titles;

@end

@implementation KGGMyWorkBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.navigationItem.title = @"我的订单";
    [self setupChildViewControllers];
    [self setUpSlideSwitchView];
}

- (void)setupChildViewControllers
{
    KGGMyWorkViewController *workingVC = [[KGGMyWorkViewController alloc]init];
    workingVC.requestType = KGGSearchOrderRequestMyDoingType;
    [self addChildViewController:workingVC];
    
    KGGMyWorkViewController *workedVC = [[KGGMyWorkViewController alloc]init];
    workedVC.requestType = KGGSearchOrderRequestCompleteType;
    [self addChildViewController:workedVC];
    
    _titles = @[@"进行中",@"已完成"];
}

- (void)setUpSlideSwitchView
{
    _slideSwitchView = [[SUNSlideSwitchView alloc]initWithFrame:self.view.bounds heightOfTopScrollView:47.f];
    _slideSwitchView.xc_height -= 64.f;
    _slideSwitchView.bottomLineView.hidden = YES;
    _slideSwitchView.slideSwitchViewDelegate = self;
    _slideSwitchView.kFontSizeOfTabButton = 16.f;
    _slideSwitchView.topScrollView.backgroundColor = [UIColor whiteColor];
    _slideSwitchView.tabItemNormalColor = KGGTimeTextColor;
    _slideSwitchView.tabItemSelectedColor = KGGGoldenThemeColor;
    _slideSwitchView.shadowImage = [UIImage imageNamed:@"chosebar"];
    [_slideSwitchView buildUI];
    [self.view addSubview:_slideSwitchView];
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

- (void)dealloc{
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
