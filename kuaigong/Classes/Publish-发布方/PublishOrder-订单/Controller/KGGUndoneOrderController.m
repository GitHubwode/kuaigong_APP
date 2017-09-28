//
//  KGGUndoneOrderController.m
//  kuaigong
//
//  Created by Ding on 2017/8/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGUndoneOrderController.h"
#import "KGGPublishOrderViewCell.h"
#import "KGGPublishPayViewController.h"

@interface KGGUndoneOrderController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation KGGUndoneOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    [self.view addSubview:self.orderTableView];
}

#pragma mark - UITableViewDelegate  UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGPublishOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGPublishOrderViewCell publishOrderIdentifier] forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGLog(@"直接支付");
    
    KGGPublishPayViewController *payVC = [[KGGPublishPayViewController alloc]initWithNibName:NSStringFromClass([KGGPublishPayViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:payVC animated:YES];
    

    
}

- (UITableView *)orderTableView
{
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-47-64) style:UITableViewStylePlain];
        _orderTableView.backgroundColor = [UIColor whiteColor];
        [_orderTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGPublishOrderViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGPublishOrderViewCell publishOrderIdentifier]];
        _orderTableView.rowHeight = 95.f;
        _orderTableView.separatorStyle = UITableViewCellStyleDefault;
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
    }
    return _orderTableView;
}

- (void)dealloc
{
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
