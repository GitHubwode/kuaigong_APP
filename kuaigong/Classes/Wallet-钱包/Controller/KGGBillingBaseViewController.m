//
//  KGGBillingBaseViewController.m
//  kuaigong
//
//  Created by Ding on 2017/12/15.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGBillingBaseViewController.h"
#import "KGGBillingDetailsViewController.h"
#import "KGGBillingSpendingViewController.h"
#import "SUNSlideSwitchView.h"

@interface KGGBillingBaseViewController ()<SUNSlideSwitchViewDelegate>

@property (nonatomic, strong) SUNSlideSwitchView *slideSwitchView;
@property (nonatomic, strong) NSArray<NSString *> *titles;

@end

@implementation KGGBillingBaseViewController

- (void)viewDidAppear:(BOOL)animated {
    [JANALYTICSService startLogPageView:@"KGGBillingBaseViewController"];
}
- (void)viewDidDisappear:(BOOL)animated {
    [JANALYTICSService stopLogPageView:@"KGGBillingBaseViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.navigationItem.title = @"收支明细";
    [self setupChildViewControllers];
    [self setUpSlideSwitchView];
}

- (void)setupChildViewControllers
{
    KGGBillingDetailsViewController *incomeVC = [[KGGBillingDetailsViewController alloc]init];
    [self addChildViewController:incomeVC];
    
    KGGBillingSpendingViewController *spendingVC = [[KGGBillingSpendingViewController alloc]init];
    [self addChildViewController:spendingVC];

    _titles = @[@"收入",@"支出"];
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


@end
