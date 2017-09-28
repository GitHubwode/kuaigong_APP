//
//  KGGPersonalMessageController.m
//  kuaigong
//
//  Created by Ding on 2017/8/30.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPersonalMessageController.h"
#import "KGGPersonMessageCell.h"
#import "KGGPublishPersonModel.h"
#import "KGGSexChangeViewCell.h"

@interface KGGPersonalMessageController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *perTableView;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation KGGPersonalMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"个人信息";
    [self.view addSubview:self.perTableView];
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 90.f;
    }else{
        return 48.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGPublishPersonModel *model = self.datasource[indexPath.row];
    if (indexPath.row == 2) {
        KGGSexChangeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGSexChangeViewCell cellIdentifier]];
        cell.personModel = model;
        return cell;
    }else{
        KGGPersonMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGPersonMessageCell personIdentifier] forIndexPath:indexPath];
        cell.personModel = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGLog(@"%ld",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KGGPublishPersonModel *model = self.datasource[indexPath.row];
    if (model.isHidesAvatar) return;
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[cell personTextField] becomeFirstResponder];
}


- (UITableView *)perTableView
{
    if (!_perTableView) {
        _perTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -37, kMainScreenWidth, kMainScreenHeight) style:UITableViewStyleGrouped];
        [_perTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGPersonMessageCell class]) bundle:nil] forCellReuseIdentifier:[KGGPersonMessageCell personIdentifier]];
        [_perTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGSexChangeViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGSexChangeViewCell cellIdentifier]];
        _perTableView.separatorStyle = UITableViewCellStyleDefault;
        _perTableView.delegate = self;
        _perTableView.dataSource = self;
    }
    return _perTableView;
}


- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [KGGPublishPersonModel mj_objectArrayWithFilename:@"KGGPublishPrivate.plist"];
    }
    return _datasource;
}

- (void)dealloc
{
    KGGLogFunc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
