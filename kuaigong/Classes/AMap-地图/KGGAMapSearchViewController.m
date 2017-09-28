//
//  KGGAMapSearchViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGAMapSearchViewController.h"
#import "KGGLocationTextFieldSubClass.h"
#import <AMapSearchKit/AMapSearchKit.h>

static NSString *AMapSearchCell = @"AMapSearchCell";

@interface KGGAMapSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate,UISearchBarDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic,retain) AMapSearchAPI *search;
@property (nonatomic, assign) BOOL isSelected;//是否点击搜索,点击之前都只是匹配

@end

@implementation KGGAMapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - UITableVIewDelegate UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    设置区域的行数(重点),这个就是使用委托之后需要需要判断是一下是否是需要使用Search之后的视图:
    if (!_isSelected) {
        return [self.searchList count];
    }else{
        return [self.dataList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AMapSearchCell forIndexPath:indexPath];
    //如果搜索狂激活
    if (!_isSelected) {
        AMapAOI *poi = _searchList[indexPath.row];
        [cell.textLabel setText:poi.name];
    }else{
        AMapAOI *poi = _dataList[indexPath.row];
        [cell.textLabel setText:poi.name];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchController.searchBar resignFirstResponder];
    
    AMapPOI *poi = [[AMapPOI alloc]init];
    //如果搜索框激活
    if (!_isSelected) {
        poi = _searchList[indexPath.row];
    }
    else{
        poi = _dataList[indexPath.row];
    }

    KGGLog(@"%@,%f,%f",poi.name,poi.location.latitude,poi.location.longitude);
    
    self.moveBlock(poi);
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchController.searchBar becomeFirstResponder];
}

#pragma mark - lazy;
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)searchList
{
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:AMapSearchCell];
        _tableView.separatorStyle = UITableViewCellStyleDefault;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
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
