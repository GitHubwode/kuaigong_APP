//
//  KGGAMapSearchViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGAMapSearchViewController.h"
#import "KGGLocationTextFieldSubClass.h"
#import "KGGAMapSearchViewCell.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>

@interface KGGAMapSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate,BMKPoiSearchDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) BOOL isSelected;//是否点击搜索,点击之前都只是匹配
@property (nonatomic, strong) BMKLocationService *service;//定位服务
@property (nonatomic, strong) BMKPoiSearch *poiSearch;//搜索服务
@property (nonatomic, strong) BMKCitySearchOption *option;//初始化一个检索对象
@property (nonatomic, assign) int pageNum;

@end

@implementation KGGAMapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pageNum = 0;
    [self addSearchTextField];
    [self setupSearchAddressList];
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer = [KGGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadAddMoreMessage)];
    
}

- (void)LoadAddMoreMessage
{
    self.pageNum ++;
    //检索当前页码
    self.option.pageIndex = self.pageNum;
    //检索条数
    self.option.pageCapacity = 10;
    self.option.city = self.city;
    self.option.keyword = self.searchAddress;
    BOOL flag = [self.poiSearch poiSearchInCity:self.option];
    if (flag) {
        KGGLog(@"城市内检索发送成功");
    }else{
        KGGLog(@"城市内检索发送成功");
    }
}

//初始化搜索
- (BMKPoiSearch *)poiSearch
{
    if (!_poiSearch) {
        _poiSearch = [[BMKPoiSearch alloc]init];
        _poiSearch.delegate = self;
    }
    return _poiSearch;
}

- (BMKCitySearchOption *)option
{
    if (!_option) {
        _option = [[BMKCitySearchOption alloc]init];
    }
    return _option;
}

- (void)setupSearchAddressList
{
    //检索当前页码
    self.option.pageIndex = self.pageNum;
    //检索条数
    self.option.pageCapacity = 10;
    self.option.city = self.city;
    self.option.keyword = self.searchAddress;
    BOOL flag = [self.poiSearch poiSearchInCity:self.option];
    if (flag) {
        KGGLog(@"城市内检索发送成功");
    }else{
        KGGLog(@"城市内检索发送成功");
    }
}

#pragma mark - BMKPoiSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    KGGLog(@"%@",poiResult.poiAddressInfoList);
    if (self.pageNum == 0) {
        [self.dataList removeAllObjects];
    }
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        for (int i =0; i<poiResult.poiInfoList.count; i++) {
            BMKPoiInfo *poi = [poiResult.poiInfoList objectAtIndex:i];
            
            [self.dataList addObject:poi];
            KGGLog(@"annotations:名称:%@ 地址:%@",poi.name,poi.address);
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        KGGLog(@"annotations:%@",self.dataList);
    }else if (errorCode == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        KGGLog(@"起始点有歧义");
    }else{
        KGGLog(@"%u",errorCode);
    }
}

- (void)addSearchTextField
{
    self.navigationItem.titleView = self.searchController.searchBar;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"返回" target:self action:@selector(leftAction)];
    self.searchController.searchBar.text = self.searchAddress;
}

#pragma mark - UITableVIewDelegate UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    设置区域的行数(重点),这个就是使用委托之后需要需要判断是一下是否是需要使用Search之后的视图:
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGAMapSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGAMapSearchViewCell aMapSearchViewIdentifier] forIndexPath:indexPath];
    BMKPoiInfo *poi = self.dataList[indexPath.row];
    cell.titleLabel.text = poi.name;
    cell.subTitleLabel.text = poi.address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchController.searchBar resignFirstResponder];
    BMKPoiInfo *poi = self.dataList[indexPath.row];
    self.backLock(poi);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搜索框
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    KGGLog(@"开始改变时 %@",searchText);
    _isSelected = YES;
    self.searchAddress = searchBar.text;
    [self setupSearchAddressList];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    KGGLog(@"点击搜索按钮跳转页面");
    KGGLog(@"%@",searchBar.text);
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
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

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGAMapSearchViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGAMapSearchViewCell aMapSearchViewIdentifier]];
        _tableView.separatorStyle = UITableViewCellStyleDefault;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UISearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate  = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.frame = CGRectMake(kMainScreenWidth/2-100, 20, 200, 44);
    }
    return _searchController;
}

//返回按钮
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
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

