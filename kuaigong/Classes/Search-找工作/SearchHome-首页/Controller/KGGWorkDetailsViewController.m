//
//  KGGWorkDetailsViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/21.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGWorkDetailsViewController.h"
#import "KGGOrderDetailsModel.h"
#import "UIImageView+WebCache.h"
#import "KGGPublishOrderRequestManager.h"

@interface KGGWorkDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payImageView;

/** 电话号码 */
@property (nonatomic,copy) NSString *phoneCall;

@end

@implementation KGGWorkDetailsViewController

- (void)viewDidAppear:(BOOL)animated {
    [JANALYTICSService startLogPageView:@"KGGWorkDetailsViewController"];
}
- (void)viewDidDisappear:(BOOL)animated {
    [JANALYTICSService stopLogPageView:@"KGGWorkDetailsViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 18.f;
    self.view.backgroundColor = KGGViewBackgroundColor;
    [self setUpOrderDetailsModel:self.searchOrderModel];
    
    if (self.isNotification) {
        [self notificationSetUp];
        [self.payImageView removeFromSuperview];
    }
    if (self.requestType == KGGSearchOrderRequestCompleteType) {
        
    }else{
        [self.payImageView removeFromSuperview];
    }
}

#pragma mark - 接到通知
- (void)notificationSetUp
{
    NSString *orderId = [NSString stringWithFormat:@"%lu",(unsigned long)self.searchOrderModel.orderId];
    NSString *message = [NSString stringWithFormat:@"老板正在修改订单天数为%@,人数为%@,是否同意修改",self.dayNum,self.peopleNum];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self sureChangeOrderMessageOrderId:orderId Type:@"N"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        KGGLog(@"同意修改");
        [self sureChangeOrderMessageOrderId:orderId Type:@"Y"];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma makr - 确定是否修改
- (void)sureChangeOrderMessageOrderId:(NSString *)orderId Type:(NSString *)type
{
    [KGGSearchOrderRequestManager workerChangeOrderMessageOrder:orderId IsSbumit:type Day:self.dayNum PeopleNum:self.peopleNum completion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            if ([type isEqualToString:@"Y"]) {
                [self changeOrderMessage];
            }
        }
    } aboveView:self.view inCaller:self];
}

#pragma mark - 更新订单详情的接口
- (void)changeOrderMessage
{
    [KGGPublishOrderRequestManager publishOrderDetailsMessageOrder:self.searchOrderModel.orderId completion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            KGGOrderDetailsModel *model = [KGGOrderDetailsModel mj_objectWithKeyValues:responseObj.data];
            [self setUpOrderDetailsModel:model];
        }
    } aboveView:self.view inCaller:self];
}


- (UIImageView *)creatImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    return imageView;
}

#pragma mark - 赋值
- (void)setUpOrderDetailsModel:(KGGOrderDetailsModel *)model
{
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    self.nameLabel.text = model.contacts;
    self.phoneLabel.text = model.hidePhone;
    self.addressLabel.text = model.address;
    self.orderDetailsLabel.text = model.searchOrderDetails;
    self.remarkLabel.text = [NSString stringWithFormat:@"备注: %@",model.remark];
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单编号: %@",model.orderNo];
    self.timeLabel.text = [NSString stringWithFormat:@"接单时间: %@",model.accpetTime];
    self.phoneCall = [NSString stringWithFormat:@"tel:%@",model.contactsPhone];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@ ¥",model.differentPrice];
    self.payLabel.text = [NSString stringWithFormat:@"支付时间:%@",model.payTime];
}

- (IBAction)callPhoneButtonClick:(UIButton *)sender {
    KGGLog(@"打电话");
    UIWebView *callWebView = [[UIWebView alloc]init];
    NSURL *telUrl = [NSURL URLWithString:self.phoneCall];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telUrl]];
    [self.view addSubview:callWebView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    KGGLogFunc
}

@end
