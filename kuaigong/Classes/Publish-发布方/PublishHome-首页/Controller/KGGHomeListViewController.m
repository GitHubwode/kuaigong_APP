//
//  KGGHomeListViewController.m
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHomeListViewController.h"
#import "KGGHomeListViewCell.h"
#import "KGGPublishHomeFootView.h"
#import "KGGHomePublishModel.h"
#import "KGGAMapBaseViewController.h"

@interface KGGHomeListViewController ()<UITableViewDelegate,UITableViewDataSource,KGGPublishHomeFootViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KGGHomeListViewCell *homeCell;
@property (nonatomic, strong) KGGPublishHomeFootView *footView;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation KGGHomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    [self setupForDismissKeyboard];
    self.tableView.tableFooterView = self.footView;
    [self.view addSubview:self.tableView];
}

#pragma mark -KGGPublishHomeFootViewDelegate
- (void)kgg_publishHomeFootViewLocationButtonClick
{
    [KGGNotificationCenter postNotificationName:@"aaaaaaaaa" object:nil];
}

#pragma mark - 键盘显示隐藏
- (void)keyboardWillShow:(NSNotification *)notification{
    
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (self.homeCell) {
        
    }
    
    CGFloat offset = 168+37 + 44.f * 4 - keyboardBounds.size.height;
    
    [self.tableView setContentOffset:CGPointMake(0, offset) animated:NO];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [self.tableView setContentOffset:CGPointZero animated:NO];
}

#pragma mark - UITableViewDelegate  UITableViewDatasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGHomePublishModel *publishModel = self.datasource[indexPath.row];
    KGGHomeListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGHomeListViewCell homeListIdentifier] forIndexPath:indexPath];
    self.homeCell = cell;
    cell.publishModel = publishModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[cell homeTextField] becomeFirstResponder];
}


- (KGGPublishHomeFootView *)footView
{
    if (!_footView) {
        _footView = [[KGGPublishHomeFootView alloc]initWithFrame:CGRectMake(0, 0, self.view.xc_width, 170)];
        _footView.delegate =self;
    }
    return _footView;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-KGGLoginButtonHeight-168-37-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
         [_tableView registerNib:[UINib nibWithNibName:@"KGGHomeListViewCell" bundle:nil] forCellReuseIdentifier:[KGGHomeListViewCell homeListIdentifier]];
        _tableView.rowHeight = 45.f;
        _tableView.separatorStyle = UITableViewCellStyleDefault;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [KGGHomePublishModel mj_objectArrayWithFilename:@"KGGPublishMessage.plist"];
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

@end
