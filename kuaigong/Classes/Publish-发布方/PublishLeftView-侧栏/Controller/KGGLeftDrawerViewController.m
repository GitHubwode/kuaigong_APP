//
//  KGGLeftDrawerViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLeftDrawerViewController.h"
#import "KGGSliderMenuTool.h"

@interface KGGLeftDrawerViewController ()

@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, assign) BOOL hasShow;

@property (nonatomic, strong) UIViewController *leftVc;
@property (nonatomic, weak) UIView *bgView;

@end

static NSTimeInterval animationTime = 0.4;


@implementation KGGLeftDrawerViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController contentViewController:(UIViewController *)leftVc {
    self = [super init];
    if (self) {
        _rootViewController = rootViewController;
        _leftVc = leftVc;
    }
    return self;
}

//// 控制状态栏
//- (BOOL)prefersStatusBarHidden {
//    return self.hideStatusBar;
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}
//
//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
//    return UIStatusBarAnimationSlide;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    // 半透明的view
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.frame = [UIScreen mainScreen].bounds;
    bgView.alpha = 0;
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    // 添加两个手势
    UITapGestureRecognizer *tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideBar)];
    [bgView addGestureRecognizer:tapGestureRec];
    
    UIPanGestureRecognizer *panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [self.view addGestureRecognizer:panGestureRec];
    
    self.leftVc.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width;
    width = kMainScreenWidth *0.68;

    self.leftVc.view.frame = CGRectMake(-width, 0, width, [UIScreen mainScreen].bounds.size.height);
    self.leftVc.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.leftVc.view];
    [self addChildViewController:self.leftVc];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.hasShow) {
        self.hasShow = YES;
//        self.hideStatusBar = YES;
        [UIView animateWithDuration:animationTime animations:^{
//            [self setNeedsStatusBarAppearanceUpdate];
            self.rootViewController.navigationController.navigationBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        }];
    }
    //    self.hideStatusBar = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self showAnimation];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //    self.hideStatusBar = NO;
    //    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


/**
 显示控制器
 */
- (void)showAnimation {
    self.view.userInteractionEnabled = NO;
    //根据当前x，计算显示时间
    CGFloat time = fabs(self.leftVc.view.frame.origin.x / self.leftVc.view.frame.size.width) * animationTime;
    [UIView animateWithDuration:time animations:^{
        self.leftVc.view.frame = CGRectMake(0, 0, self.leftVc.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        self.bgView.alpha = 0.3;
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)closeAnimation {
    self.view.userInteractionEnabled = NO;
    CGFloat time = (1-fabs(self.leftVc.view.frame.origin.x / self.leftVc.view.frame.size.width))*animationTime;
    [UIView animateWithDuration:time animations:^{
        CGRect frame = self.leftVc.view.frame;
        frame.origin.x = -frame.size.width;
        self.leftVc.view.frame = frame;
    } completion:^(BOOL finished) {
        //状态栏出现
        self.hideStatusBar = NO;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            [UIView animateWithDuration:animationTime animations:^{
                [self setNeedsStatusBarAppearanceUpdate];
            }];
        }
        [KGGSliderMenuTool kgg_Sliderdismiss];
    }];
}

/**
 * 点击手势
 */
- (void)closeSideBar {
    [self closeAnimation];
}

/**
 * 拖拽手势
 */
- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes {
    // 下面是计算
    // 开始位置
    static CGFloat startX;
    // 结束位置
    static CGFloat lastX;
    // 改变多少
    static CGFloat durationX;
    CGPoint touchPoint = [panGes locationInView:[[UIApplication sharedApplication] keyWindow]];
    // 手势开始
    if (panGes.state == UIGestureRecognizerStateBegan) {
        startX = touchPoint.x;
        lastX = touchPoint.x;
    }
    // 手势改变
    if (panGes.state == UIGestureRecognizerStateChanged) {
        CGFloat currentX = touchPoint.x;
        durationX = currentX - lastX;
        lastX = currentX;
        CGFloat leftVcX = durationX + self.leftVc.view.frame.origin.x;
        // 如果控制器的x小于宽度直接返回
        if (leftVcX <= -self.leftVc.view.frame.size.width) {
            leftVcX = -self.leftVc.view.frame.size.width;
        }
        // 如果控制器的x大于0直接返回
        if (leftVcX >= 0) {
            leftVcX = 0;
        }
        // 计算bgView的透明度
        self.bgView.alpha = (1 + leftVcX / self.leftVc.view.frame.size.width) * 0.5;
        // 设置左边控制器的frame
        [self.leftVc.view setFrame:CGRectMake(leftVcX, 0, self.leftVc.view.frame.size.width, self.leftVc.view.frame.size.height)];
        //        NSLog(@"%f", self.leftVc.view.frame.origin.x);
    }
    // 手势结束
    if (panGes.state == UIGestureRecognizerStateEnded) {
        // 结束为止超时屏幕一半
        if (self.leftVc.view.frame.origin.x > - self.leftVc.view.frame.size.width + [UIScreen mainScreen].bounds.size.width / 2) {
            [self showAnimation];
        } else {
            [self closeAnimation];
        }
    }
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
