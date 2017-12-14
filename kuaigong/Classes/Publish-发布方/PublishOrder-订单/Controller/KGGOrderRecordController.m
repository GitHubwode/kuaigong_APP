//
//  KGGOrderRecordController.m
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGOrderRecordController.h"
#import "SUNSlideSwitchView.h"
#import "KGGUndoneOrderController.h"
#import "KGGDoneOrderController.h"

@interface KGGOrderRecordController ()<SUNSlideSwitchViewDelegate>

@property (nonatomic, strong) SUNSlideSwitchView *slideSwitchView;
@property (nonatomic, strong) NSArray<NSString *> *titles;

@end

@implementation KGGOrderRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.navigationItem.title = @"订单记录";
    [self setupChildViewControllers];
    [self setUpSlideSwitchView];
    
}

- (void)setupChildViewControllers
{
    KGGUndoneOrderController *undoingVC = [[KGGUndoneOrderController alloc]init];
    undoingVC.requestType = KGGOrderRequestMyDoingType;
    [self addChildViewController:undoingVC];
    
    KGGUndoneOrderController *undoneVC = [[KGGUndoneOrderController alloc]init];
    undoneVC.requestType = KGGOrderRequestNotCompleteType;
    [self addChildViewController:undoneVC];
    
    KGGDoneOrderController *doneOrderVC = [[KGGDoneOrderController alloc]init];
    doneOrderVC.requestType = KGGOrderRequestDoPayType;
    [self addChildViewController:doneOrderVC];
    
    KGGDoneOrderController *donePayVC = [[KGGDoneOrderController alloc]init];
    donePayVC.requestType = KGGOrderRequestCompleteType;
    [self addChildViewController:donePayVC];
    
    _titles = @[@"已接单",@"派单中",@"未支付",@"已支付"];
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
