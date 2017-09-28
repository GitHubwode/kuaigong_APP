//
//  KGGMyWorkViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/20.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMyWorkViewController.h"
#import "KGGMyWorkViewCell.h"
#import "KGGWorkDetailsViewController.h"

@interface KGGMyWorkViewController ()

@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation KGGMyWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的工作";
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.tableView.separatorColor = KGGSeparatorColor;
    self.tableView.rowHeight = 59.f;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGMyWorkViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGMyWorkViewCell myWorkIdentifier]];
}

- (void)dealloc
{
    KGGLogFunc
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGLog(@"点击我的工作进入工作详情");
    KGGWorkDetailsViewController *workVC = [[KGGWorkDetailsViewController alloc]initWithNibName:NSStringFromClass([KGGWorkDetailsViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:workVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KGGMyWorkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGMyWorkViewCell myWorkIdentifier] forIndexPath:indexPath];
    
    
    return cell;
}


#pragma mark - lazy
- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}




@end
