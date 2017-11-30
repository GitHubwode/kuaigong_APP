//
//  KGGStationCycleScrollView.m
//  kuaigong
//
//  Created by Ding on 2017/11/27.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGStationCycleScrollView.h"
#import "UIView+SDExtension.h"
#import "KGGLookWorkListCollectionCell.h"

static NSString *lookWorkListCollectionCell = @"stationCycleScrollView";
static NSString *SNHHomeUserCycleScrollViewIdfy = @"SNHHomeUserCycleScrollViewIdfy";

@interface KGGStationCycleScrollView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *mainView;
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 图片滚动方向，默认为水平滚动 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic, assign) CycleScrollViewType scrollViewType;

@end

@implementation KGGStationCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialization];
    [self setupMainView];
}

- (void)initialization
{
    _autoScroll = YES;
    _infiniteLoop = YES;
}


//设置轮播图显示的 collectionView
- (void)setupMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//垂直滚动
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    UICollectionView *mainVIew = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainVIew.backgroundColor = [UIColor clearColor];
    mainVIew.pagingEnabled = YES;
    mainVIew.showsVerticalScrollIndicator = NO;
    mainVIew.showsHorizontalScrollIndicator = NO;
    mainVIew.scrollEnabled = NO;
    if (HomeUserCycleScrollViewType == _scrollViewType) {
//        [mainVIew registerClass:[SNHHomeUserCycleCell class] forCellWithReuseIdentifier:[SNHHomeUserCycleCell identifier]];
    }else if (StationCycleScrollViewType == _scrollViewType){
        [mainVIew registerNib:[UINib nibWithNibName:@"KGGLookWorkListCollectionCell" bundle:nil] forCellWithReuseIdentifier:lookWorkListCollectionCell];
    }
    
    mainVIew.dataSource = self;
    mainVIew.delegate = self;
    [self addSubview:mainVIew];
    _mainView = mainVIew;
    
}

+ (instancetype)snh_cycleScrollViewWithFrame:(CGRect)frame delegate:(id<KGGStationCycleScrollViewDelegate>)delegate type:(CycleScrollViewType)type
{
    KGGStationCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.delegate = delegate;
    cycleScrollView.scrollViewType = type;
    [cycleScrollView setupMainView];
    return cycleScrollView;
}

#pragma mark - 初始化时间 和销毁时间
- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(automationScrollView) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)automationScrollView
{
    if (0 == _totalItemsCount) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (int)currentIndex
{
    if (_mainView.xc_width == 0 || _mainView.xc_height == 0) {
        return 0;
    }
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    }else{
        index = (_mainView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    return MAX(0, index);
}

- (void)scrollToIndex:(int)targetIndex
{
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - 数据源的处理
- (void)setMessageDatasource:(NSArray *)messageDatasource{
    
    _messageDatasource = messageDatasource;
    
    [self invalidateTimer];
    
    _totalItemsCount = self.messageDatasource.count;
    
    if (messageDatasource.count != 1) {
        //        self.mainView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    }else{
        //        self.mainView.scrollEnabled = NO;
    }
    [self.mainView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.frame.size;
    
    _mainView.frame = self.bounds;
    if (_mainView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 0;
        //        if (self.infiniteLoop) {
        //            targetIndex = _totalItemsCount * 0.5;
        //        }else{
        //            targetIndex = 0;
        //        }
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}
//父类 view 释放,当前定时器销毁
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

- (void)dealloc
{
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}

#pragma mark - 当时图将要出现的时候
- (void)adjustWhenControllerViewWillAppera
{
    long targetIndex = [self currentIndex];
    if (targetIndex < _totalItemsCount) {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark - setter方法

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    _flowLayout.scrollDirection = scrollDirection;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messageDatasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    
//    if (HomeUserCycleScrollViewType == _scrollViewType) {
//        SNHHomeUserCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SNHHomeUserCycleCell identifier] forIndexPath:indexPath];
//        cell.user = self.messageDatasource[itemIndex];
//        return cell;
//    }
    KGGPostedModel *model = self.messageDatasource[itemIndex];
    KGGLookWorkListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lookWorkListCollectionCell forIndexPath:indexPath];
    [cell setUp: model];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(snh_cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate snh_cycleScrollView:self didSelectItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.messageDatasource.count;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

@end
