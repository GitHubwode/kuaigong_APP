//
//  KGGNewFeatureViewController.m
//  kuaigong
//
//  Created by Ding on 2017/11/27.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGNewFeatureViewController.h"
#import "KGGNewFeatureCell.h"
#import "KGGTabBarController.h"
#import "KGGTabBarWorkController.h"

@interface KGGNewFeatureViewController ()
@property (nonatomic, strong) UIButton *bossButton;
@property (nonatomic, strong) UIButton *workerButton;
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation KGGNewFeatureViewController

static NSString * const reuseIdentifier = @"NewFeatureCell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (instancetype)init
{
    // 创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置cell尺寸
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    
    // 设置最小行间距 0
    layout.minimumLineSpacing = 0;
    // 设置每个cell之间间距
    layout.minimumInteritemSpacing = 0;
    // 设置每一组的间距
    //    layout.sectionInset = UIEdgeInsetsMake(100, 0, 0, 0);
    // 设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return  [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCollectionView];
    self.bossButton = [self creatButtonImage:@"btn_yong" HightString:@"bnt_pre_r" TagButton:10000];
    self.workerButton = [self creatButtonImage:@"btn_zhao" HightString:@"bnt_pre_b" TagButton:10001];
    [self.view addSubview:self.bossButton];
    [self.view addSubview:self.workerButton];
    
    weakSelf(self);
    [self.workerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.width.equalTo(@(246));
        make.height.equalTo(@(59));
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-36);
    }];
    
    [self.bossButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.width.equalTo(@(246));
        make.height.equalTo(@(59));
        make.bottom.equalTo(weakself.workerButton.mas_top).offset(-36);
    }];
    
    if (self.identifierType == 1) {
        [self.datasource removeAllObjects];
        [self.datasource addObject:@"guide5.jpg"];
        self.workerButton.hidden = NO;
        self.bossButton.hidden = NO;
    }

}

// 设置CollectionView
- (void)setUpCollectionView
{
    // 注册cell
    [self.collectionView registerClass:[KGGNewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // self.view != self.collectionView
    // self.collectionView 添加到 self.view
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    // 开启分页
    self.collectionView.pagingEnabled = YES;
    
    // 隐藏滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.collectionView.bounces = NO;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *imageName = self.datasource[indexPath.row];
    KGGNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // 设置cell ImageView
    cell.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:nil]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.xc_width;
    // 四舍五入计算出页码
    KGGLog(@"page:%.f",page);
    if (page >= 4.f) {
        if ([[KGGUserManager shareUserManager].currentUser.type isEqualToString:@"BOSS"]) {
            self.bossButton.hidden = NO;
        }else if([[KGGUserManager shareUserManager].currentUser.type isEqualToString:@"WORKER"]){
            self.workerButton.hidden = NO;
        }else{
            self.workerButton.hidden = NO;
            self.bossButton.hidden = NO;
        }

    }else{
        self.workerButton.hidden = YES;
        self.bossButton.hidden = YES;
    }
}

- (void)dealloc
{
    KGGLogFunc
}

#pragma mark -按钮的点击事件
- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 10000) {
        KGGLog(@"用工");
        [self jumpLoginViewIdentity:@"BOSS"];
    }else{
        KGGLog(@"找活");
        [self jumpLoginViewIdentity:@"WORKER"];
    }
}

- (void)jumpLoginViewIdentity:(NSString *)IdString
{
    [NSUserDefaults removeObjectForKey:KGGUserType];
    //首次存取角色
    [NSUserDefaults setObject:IdString forKey:KGGUserType];
    KGGLog(@"角色:%@",[NSUserDefaults objectForKey:KGGUserType]);
    
    if ([IdString isEqualToString:@"BOSS"]) {
        KGGTabBarController *rootVc = [[KGGTabBarController alloc] init];
        self.view.window.rootViewController = rootVc;
    }else{
        KGGTabBarWorkController *rootVc = [[KGGTabBarWorkController alloc] init];
        self.view.window.rootViewController = rootVc;
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (UIButton *)creatButtonImage:(NSString *)imageString HightString:(NSString *)hightString TagButton:(NSInteger )tagButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tagButton;
    button.hidden = YES;
    [button setBackgroundImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hightString] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray arrayWithObjects:@"guide1.jpg",@"guide2.jpg",@"guide3.jpg",@"guide4.jpg",@"guide5.jpg", nil];
    }
    return _datasource;
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

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
