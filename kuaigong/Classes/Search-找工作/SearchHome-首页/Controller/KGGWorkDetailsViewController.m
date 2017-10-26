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

@interface KGGWorkDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

/** 电话号码 */
@property (nonatomic,copy) NSString *phoneCall;

@end

@implementation KGGWorkDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 18.f;
    self.view.backgroundColor = KGGViewBackgroundColor;
    [self setUpOrderDetails];
}
#pragma mark - 赋值
- (void)setUpOrderDetails
{
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.searchOrderModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    self.nameLabel.text = self.searchOrderModel.contacts;
    self.phoneLabel.text = self.searchOrderModel.hidePhone;
    self.addressLabel.text = self.searchOrderModel.address;
    self.orderDetailsLabel.text = self.searchOrderModel.orderDetails;
    self.remarkLabel.text = [NSString stringWithFormat:@"备注: %@",self.searchOrderModel.remark];
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单编号: %@",self.searchOrderModel.orderNo];
    self.timeLabel.text = [NSString stringWithFormat:@"接单时间: %@",self.searchOrderModel.accpetTime];
    self.phoneCall = [NSString stringWithFormat:@"tel:%@",self.searchOrderModel.contactsPhone];
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
