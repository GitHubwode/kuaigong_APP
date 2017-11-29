//
//  KGGPublishHomeCycleView.m
//  kuaigong
//
//  Created by Ding on 2017/11/29.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishHomeCycleView.h"
#import "KGGPublishHomeCycleCell.h"
#import "KGGPublishHomeCycleModel.h"

@interface KGGPublishHomeCycleView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *mainView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation KGGPublishHomeCycleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addMessage];
    }
    return self;
}

#pragma mark - 数据源
- (void)addMessage
{
    KGGPublishHomeCycleModel *model = [[KGGPublishHomeCycleModel alloc]init];
    model.imageString = @"icon_btn_boss";
    model.nameString = @"快臣老板";
    [self.datasource addObject:model];
    
    KGGPublishHomeCycleModel *model1 = [[KGGPublishHomeCycleModel alloc]init];
    model1.imageString = @"icon_btn_team";
    model1.nameString = @"快排班组";
    [self.datasource addObject:model1];
    
    KGGPublishHomeCycleModel *model2 = [[KGGPublishHomeCycleModel alloc]init];
    model2.imageString = @"icon_btn_daiban";
    model2.nameString = @"快排带班长";
    [self.datasource addObject:model2];
    
    KGGPublishHomeCycleModel *model3 = [[KGGPublishHomeCycleModel alloc]init];
    model3.imageString = @"icon_btn_diangong";
    model3.nameString = @"快排点工长";
    [self.datasource addObject:model3];
    
    KGGPublishHomeCycleModel *model4 = [[KGGPublishHomeCycleModel alloc]init];
    model4.imageString = @"icon_btn_money";
    model4.nameString = @"代发生活费";
    [self.datasource addObject:model4];
    
    KGGPublishHomeCycleModel *model5 = [[KGGPublishHomeCycleModel alloc]init];
    model5.imageString = @"icon_btn_aixin";
    model5.nameString = @"快工助学";
    [self.datasource addObject:model5];
    
    KGGPublishHomeCycleModel *model6 = [[KGGPublishHomeCycleModel alloc]init];
    model6.imageString = @"icon_btn_baoxian";
    model6.nameString = @"保险";
    [self.datasource addObject:model6];
    
    KGGPublishHomeCycleModel *model7 = [[KGGPublishHomeCycleModel alloc]init];
    model7.imageString = @"icon_btn_jiuyuan";
    model7.nameString = @"快工救援";
    [self.datasource addObject:model7];
    
    KGGPublishHomeCycleModel *model8 = [[KGGPublishHomeCycleModel alloc]init];
    model8.imageString = @"icon_btn_falv";
    model8.nameString = @"法律援助";
    [self.datasource addObject:model8];
    
    [self addSubview:self.mainView];
}

#pragma mark - UICollectionViewDelegate  UICollectionDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KGGPublishHomeCycleModel *model = self.datasource[indexPath.row];
    KGGPublishHomeCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[KGGPublishHomeCycleCell publishHomeIdentifier] forIndexPath:indexPath];
    cell.cycleModel = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cycleDelegate respondsToSelector:@selector(KGG_PublishHomeCycleViewDidSelectItemAtIndex:)]) {
        [self.cycleDelegate KGG_PublishHomeCycleViewDidSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark - 懒加载UICollectionView
- (UICollectionView *)mainView
{
    if (!_mainView) {
        _mainView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.xc_height) collectionViewLayout:self.layout];
        _mainView.backgroundColor = [UIColor whiteColor];
        [_mainView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGPublishHomeCycleCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[KGGPublishHomeCycleCell publishHomeIdentifier]];
        _mainView.showsHorizontalScrollIndicator = NO;
        _mainView.dataSource = self;
        _mainView.delegate = self;
    }
    return _mainView;
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.itemSize = CGSizeMake(69, 70);
    }
    return _layout;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

@end
