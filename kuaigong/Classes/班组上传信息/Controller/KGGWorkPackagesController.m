//
//  KGGWorkPackagesController.m
//  kuaigong
//
//  Created by Ding on 2017/12/1.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGWorkPackagesController.h"
#import "KGGWorkPackagesViewCell.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface KGGWorkPackagesController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *mainView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *workDatasource;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation KGGWorkPackagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"班组信息";
    self.fd_interactivePopDisabled = YES;//禁止右滑
    self.view.backgroundColor = KGGViewBackgroundColor;
//    [self.view addSubview:self.mainView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.mainView];
    //创建tarBarItem
    [self setupNavi];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    KGGLog(@"划定的大小%f",scrollView.contentOffset.y);
    if (scrollView == self.mainView) {
        KGGLog(@"uicollectionView");
    } else if (scrollView == self.scrollView) {
//            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y);
    }
}

#pragma mark - 创建item
- (void)setupNavi
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"木工" target:self action:@selector(rightBarButtonClick)];
}

- (void)rightBarButtonClick
{
    
}

#pragma mark - UICollectionViewDelegate  UICollectionDatasource

//header的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    KGGPublishHomeCycleModel *model = self.workDatasource[indexPath.row];
    KGGWorkPackagesViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[KGGWorkPackagesViewCell workPackagesIdentifier] forIndexPath:indexPath];
//    cell.cycleModel = model;
    return cell;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//#pragma mark - 懒加载UIControllerView
- (UICollectionView *)mainView
{
    if (!_mainView) {
        _mainView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.xc_height) collectionViewLayout:self.flowLayout];
        [_mainView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGWorkPackagesViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[KGGWorkPackagesViewCell workPackagesIdentifier]];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.showsVerticalScrollIndicator = NO;
        _mainView.pagingEnabled = YES;
        _mainView.dataSource = self;
        _mainView.delegate = self;
    }
    return _mainView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(kMainScreenWidth, self.view.xc_height);
    }
    return _flowLayout;
}

- (NSMutableArray *)workDatasource
{
    if (!_workDatasource) {
        _workDatasource = [NSMutableArray array];
    }
    return _workDatasource;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.contentSize = CGSizeMake(kMainScreenWidth, 700);
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}


- (void)dealloc
{
    KGGLogFunc
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end














