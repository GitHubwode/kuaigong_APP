//
//  KGGPublishPostedViewController.m
//  kuaigong
//
//  Created by Ding on 2017/11/15.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishPostedViewController.h"
#import "KGGPublishPostedHeaderView.h"
#import "KGGPublishPostedViewCell.h"
#import "KGGPublishPostedMessageViewCell.h"
#import "KGGOrderDetailsModel.h"
#import "KGGPublishOrderParam.h"
#import "KGGPostedModel.h"
#import "UIImageView+WebCache.h"
#import "KGGPublishOrderRequestManager.h"
#import "KGGRoutePlanningController.h"

@interface KGGPublishPostedViewController ()<KGGPublishPostedHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) KGGPublishPostedHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSMutableArray *messageDatasource;
@property (nonatomic, strong) NSMutableArray * result;


@end

@implementation KGGPublishPostedViewController

- (void)viewDidAppear:(BOOL)animated {
    [JANALYTICSService startLogPageView:@"KGGPublishPostedViewController"];
}
- (void)viewDidDisappear:(BOOL)animated {
    [JANALYTICSService stopLogPageView:@"KGGPublishPostedViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"派单中";
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.tableView.tableHeaderView = self.headerView;
    if (self.type == 1) {
        self.headerView.cancelButton.hidden = YES;
    }else{
        self.headerView.imageView.hidden = YES;
        [self.headerView.imageView removeFromSuperview];
    }
    self.headerView.orderModel = self.detailsModel;
    [self.view addSubview:self.tableView];
    [self addDataMesssage];
    [self PromptMessage];
    
    [KGGNotificationCenter addObserver:self selector:@selector(kggJumpController:) name:KGGRongYunReceiedNotifacation object:nil];
}

#pragma mark - 获取到通知的信息
- (void)kggJumpController:(NSNotification *)notification
{
    KGGLog(@"通知的内容%@",notification);
    KGGLog(@"%@",notification.userInfo);
    
    NSUInteger type = [[notification.userInfo objectForKey:@"type"] integerValue];
    if (type == 503) {
        [self setupOrderDetails];
    }
}

#pragma mark - 获取当前订单的详情
- (void)setupOrderDetails
{
    [KGGPublishOrderRequestManager publishOrderDetailsMessageOrder:self.detailsModel.orderId completion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            KGGOrderDetailsModel*Model = [KGGOrderDetailsModel mj_objectWithKeyValues:responseObj.data];
            KGGRoutePlanningController *routeVC = [[KGGRoutePlanningController alloc]init];
            routeVC.orderDetails = Model;
            routeVC.planType = KGGRoutePlanningBOSSType;
            routeVC.presentId = 1;
            routeVC.backBlock = ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
            [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:routeVC] animated:YES completion:nil];
        }
    } aboveView:self.view inCaller:self];
}



#pragma mark - 提示信息
- (void)PromptMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提醒" message:@"浙江省发单百分之百接单,其他省份等待开放" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];}

- (void)addDataMesssage
{
    KGGPostedModel *model = [[KGGPostedModel alloc]init];
    model.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/1as14jc2z4c8ktw009hyuh3ph5gv94f0.jpg";
    model.name = @"附近班组";
    [self.messageDatasource addObject:model];
    
    
    KGGPostedModel *model1 = [[KGGPostedModel alloc]init];
    model1.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/1as14jc2z4c8ktw009hyuh3ph5gv94f0.jpg";
    model1.name = @"张带班";
    [self.datasource addObject:model1];
    
    KGGPostedModel *model2 = [[KGGPostedModel alloc]init];
    model2.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/1kjvwbzcbh3n4irz1qx5igm73ozg0zi4.jpg";
    model2.name = @"李代班";
    [self.datasource addObject:model2];
    
    KGGPostedModel *model3 = [[KGGPostedModel alloc]init];
    model3.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/1klngysvgo1doib5putajd5hpvwdeijo.jpg";
    model3.name = @"王代班";
    [self.datasource addObject:model3];
    
    KGGPostedModel *model4 = [[KGGPostedModel alloc]init];
    model4.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/2s4zax3t0p1hehmhujc7wtv4e5xic7fa.jpg";
    model4.name = @"刘带班";
    [self.datasource addObject:model4];
    
    KGGPostedModel *model5 = [[KGGPostedModel alloc]init];
    model5.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/369a3iq1j6r4v6716cgtkr1r0hnvhk1v.jpg";
    model5.name = @"郑代班";
    [self.datasource addObject:model5];
    
    KGGPostedModel *model6 = [[KGGPostedModel alloc]init];
    model6.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/41i81srszo1rkburqhf3aw2y17syzaz1.jpg";
    model6.name = @"王代班";
    [self.datasource addObject:model6];
    
    KGGPostedModel *model7 = [[KGGPostedModel alloc]init];
    model7.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/45x0g6skk5bnfbediomc9y1ldm3bp5pu.jpg";
    model7.name = @"苗带班";
    [self.datasource addObject:model7];
    
    KGGPostedModel *model8 = [[KGGPostedModel alloc]init];
    model8.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/4ci25wrlwtcdxdlt4szf0ntj8ccllxgk.jpg";
    model8.name = @"秦带班";
    [self.datasource addObject:model8];
    
    KGGPostedModel *model9 = [[KGGPostedModel alloc]init];
    model9.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/5oucyyj38a5qiw0yoklur8c934y72q92.jpg";
    model9.name = @"胡带班";
    [self.datasource addObject:model9];
    
    KGGPostedModel *model10 = [[KGGPostedModel alloc]init];
    model10.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/5r6jxzyb2lgnshzo759si0p31hzd4a3v.jpg";
    model10.name = @"赵带班";
    [self.datasource addObject:model10];
    
    KGGPostedModel *model11 = [[KGGPostedModel alloc]init];
    model11.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/65y0mdvmbwtkb4gvmp9qen03i1p27s70.jpg";
    model11.name = @"王代班";
    [self.datasource addObject:model11];
    
    KGGPostedModel *model12 = [[KGGPostedModel alloc]init];
    model12.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/6llpntv4drb82wbutk9u3c4tld5r8thg.jpg";
    model12.name = @"万代班";
    [self.datasource addObject:model12];
    
    KGGPostedModel *model13 = [[KGGPostedModel alloc]init];
    model13.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/6nbvgzzwoc6y74gs1lrya1ypfxxjki05.jpg";
    model13.name = @"徐带班";
    [self.datasource addObject:model13];
    
    KGGPostedModel *model14 = [[KGGPostedModel alloc]init];
    model14.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/6rwyv6ncm46zdbw8duuxr3y41s92cw83.jpg";
    model14.name = @"张带班";
    [self.datasource addObject:model14];
    
    KGGPostedModel *model15 = [[KGGPostedModel alloc]init];
    model15.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/8v1dcwxwswsikz9lc85u03xlxq57e0nr.jpg";
    model15.name = @"段代班";
    [self.datasource addObject:model15];
    
    KGGPostedModel *model16 = [[KGGPostedModel alloc]init];
    model16.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/9o309y06qcospcir9w67ta2wbegzwvpm.jpg";
    model16.name = @"陈带班";
    [self.datasource addObject:model16];
    
    KGGPostedModel *model17 = [[KGGPostedModel alloc]init];
    model17.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/cle36gjdngnekgzd777g05oovdwipmi6.jpg";
    model17.name = @"洪代班";
    [self.datasource addObject:model17];
    
    KGGPostedModel *model18 = [[KGGPostedModel alloc]init];
    model18.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/default.png";
    model18.name = @"周带班";
    [self.datasource addObject:model18];
    
    KGGPostedModel *model19 = [[KGGPostedModel alloc]init];
    model19.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/default.png";
    model19.name = @"段代班";
    [self.datasource addObject:model19];
    
    KGGPostedModel *model20 = [[KGGPostedModel alloc]init];
    model20.imageUrl = @"https://kuaigong0001.oss-cn-hangzhou.aliyuncs.com/kuaigong_help/avatar/default.png";
    model20.name = @"刘带班";
    [self.datasource addObject:model20];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:self.datasource];
    self.result = [NSMutableArray array];
    int i;
    int count = (int)self.datasource.count;
    for (i = 0; i<count; i++) {
        int index = arc4random() % (count - i);
        [self.result addObject:[tempArray objectAtIndex:index]];
        [tempArray removeObjectAtIndex:index];
    }
    [self.tableView reloadData];
}

#pragma mark - KGGPublishPostedHeaderViewDelegate
- (void)KGGPublishPostedHeaderViewCancelOrderButtonClick
{
    KGGLog(@"取消订单");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认删除订单吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        KGGLog(@"删除订单");
        
        [KGGPublishOrderRequestManager publishCancelOrderId:self.detailsModel.orderId completion:^(KGGResponseObj *responseObj) {
            if (responseObj.code == KGGSuccessCode) {
                
                if (self.backBlock) {
                    self.backBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        } aboveView:self.view inCaller:self];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate  UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGPostedModel *model = self.result[indexPath.row];
    if (indexPath.row == 0) {
        KGGPublishPostedMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGPublishPostedMessageViewCell publishPostedMessageIdentifier] forIndexPath:indexPath];
        cell.titleLabel.text = @"优秀班组";
        return cell;
    }else{
        KGGPublishPostedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGPublishPostedViewCell publishPostedIdentifier] forIndexPath:indexPath];
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
        cell.nameLabel.text = model.name;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(14, 0, kMainScreenWidth-28, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = KGGViewBackgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGPublishPostedViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGPublishPostedViewCell publishPostedIdentifier]];
         [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGPublishPostedMessageViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGPublishPostedMessageViewCell publishPostedMessageIdentifier]];
        _tableView.rowHeight = 46.f;
        _tableView.separatorStyle = UITableViewCellStyleDefault;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (KGGPublishPostedHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KGGPublishPostedHeaderView alloc]initWithFrame:CGRectMake(14, 0, kMainScreenWidth-28, 383)];
        _headerView.postedDelegate = self;
    }
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    KGGLogFunc
    [KGGNotificationCenter removeObserver:self];
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (NSMutableArray *)messageDatasource
{
    if (!_messageDatasource) {
        _messageDatasource = [NSMutableArray array];
    }
    return _messageDatasource;
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
