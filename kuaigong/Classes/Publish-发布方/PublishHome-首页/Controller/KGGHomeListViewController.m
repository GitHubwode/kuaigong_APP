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
#import "KGGUseWorkerViewController.h"
#import "KGGOrderRecordController.h"
#import "KGGLoginViewController.h"

@interface KGGHomeListViewController ()<UITableViewDelegate,UITableViewDataSource,KGGPublishHomeFootViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KGGHomeListViewCell *homeCell;
@property (nonatomic, strong) KGGPublishHomeFootView *footView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) CGFloat longitudeMap;
@property (nonatomic, assign) CGFloat latitudeMap;
@property (nonatomic, copy) NSString *workAddress;

@end

@implementation KGGHomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    [self setupForDismissKeyboard];
    self.tableView.tableFooterView = self.footView;
    [self.view addSubview:self.tableView];
    [self kgg_addButton];
    [KGGNotificationCenter addObserver:self selector:@selector(UpdateUserLocationNotifacation:) name:KGGUpdateUserLocationNotifacation object:nil];
}

- (void)UpdateUserLocationNotifacation:(NSNotification *)noti
{
    self.workAddress = [noti.userInfo objectForKey:@"locationText"];
    [self.footView.locationButton setTitle:self.workAddress forState:UIControlStateNormal];
    self.longitudeMap = [[noti.userInfo objectForKey:@"longitude"] floatValue];
    self.latitudeMap = [[noti.userInfo objectForKey:@"latitude"] floatValue];
}

- (void)kgg_addButton
{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(kMainScreenWidth));
        make.height.equalTo(@(KGGLoginButtonHeight));
    }];
    
    UIButton *useButton = [self snh_creatButtonImage:@"btn_left" Title:nil];
    useButton.tag = 1000;
    UIButton *orderButton = [self snh_creatButtonImage:@"btn_right" Title:nil];
    orderButton.tag = 1001;
    [bgView addSubview:useButton];
    [bgView addSubview:orderButton];
    
    [useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView.mas_centerY);
        make.leading.equalTo(bgView.mas_leading);
        make.height.equalTo(bgView.mas_height);
        make.width.equalTo(@(kMainScreenWidth/2-0.5));
    }];
    
    [orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(bgView.mas_trailing);
        make.centerY.equalTo(bgView.mas_centerY);
        make.height.equalTo(bgView.mas_height);
        make.width.equalTo(@(kMainScreenWidth/2-0.5));
    }];
}

#pragma mark - lazyButton
- (UIButton *)snh_creatButtonImage:(NSString *)image Title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(snh_beginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - 底部按钮
- (void)snh_beginButtonClick:(UIButton *)sender
{
    if (![KGGUserManager shareUserManager].logined){
        [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:[[KGGLoginViewController alloc]init]] animated:YES completion:^{
            self.tableView.frame = CGRectMake(0, 168+37+64, kMainScreenWidth, kMainScreenHeight-64-168-37);
        }];
    }else{
        KGGLog(@"登录就可以进入");
        [self jumpIWantToUse:sender];
    }
}

- (void)jumpIWantToUse:(UIButton *)sender
{

    if (sender.tag == 1000) {
        int i=0;
        BOOL isJump = NO;
        for ( KGGHomePublishModel *publishModel in self.datasource) {
            i++;
            if (![publishModel.title isEqualToString:@"车辆/每人"]) {
                if (publishModel.subtitle.length==0 || publishModel.subtitle == nil || [publishModel.subtitle isEqualToString:@"0"]){
                    [self.view showHint:@"用工信息不能为空"];
                    isJump = NO;
                    return;
                }else {
                    isJump = YES;
                }
            }
        }
        
        if (isJump == YES) {
            KGGLog(@"我要用工");
            KGGUseWorkerViewController *useVC = [[KGGUseWorkerViewController alloc]init];
            useVC.publishDatasource = self.datasource;
            useVC.address = self.workAddress;
            useVC.longitudeMap = self.longitudeMap;
            useVC.latitudeMap = self.latitudeMap;
            [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:useVC] animated:YES completion:^{
                self.tableView.frame = CGRectMake(0, 168+37+64, kMainScreenWidth, kMainScreenHeight-64-168-37);
            }];
        } 
    }else{
        KGGLog(@"我的订单");
        KGGOrderRecordController *payVC = [[KGGOrderRecordController alloc]init];
        [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:payVC] animated:YES completion:^{
            self.tableView.frame = CGRectMake(0, 168+37+64, kMainScreenWidth, kMainScreenHeight-64-168-37);
        }];
    }
}


#pragma mark -KGGPublishHomeFootViewDelegate
- (void)kgg_publishHomeFootViewLocationButtonClick
{
    [KGGNotificationCenter postNotificationName:KGGPublishLocationNotification object:nil];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-168-37) style:UITableViewStyleGrouped];
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

- (void)dealloc
{
    [KGGNotificationCenter removeObserver:self];
    KGGLogFunc
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
