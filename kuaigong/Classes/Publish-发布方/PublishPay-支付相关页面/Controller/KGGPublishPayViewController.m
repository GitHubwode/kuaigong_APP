//
//  KGGPublishPayViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/7.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishPayViewController.h"
#import "KGGActionSheetController.h"
#import "KGGOrderDetailsModel.h"
#import "KGGOrderCorrectViewController.h"
#import "KGGPublishOrderRequestManager.h"
#import "UIImageView+WebCache.h"
//#import "SDPhotoBrowser.h"


@interface KGGPublishPayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *payImageView;

@end

@implementation KGGPublishPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    if (self.requestType ==KGGOrderRequestCompleteType){
        KGGLog(@"我已完成的订单");
        self.title = @"完成订单";
        [self.sureButton removeFromSuperview];
        [self.messageLabel removeFromSuperview];
    }else if (self.requestType == KGGOrderRequestDoPayType){
        self.title = @"未支付订单";
        [self.payImageView removeFromSuperview];
        [self.sureButton setTitle:@"确认支付" forState:UIControlStateNormal];
    }
    [self setupModel];
}

#pragma mark - 赋值
- (void)setupModel
{
    self.orderDetailsLabel.text = self.detailsModel.orderDetails;
    self.moneyLabel.text = [NSString stringWithFormat:@"总价:%.f元",self.detailsModel.totalAmount];
    self.remarkLabel.text = self.detailsModel.remark;
    self.orderNumLabel.text = self.detailsModel.orderNo;
    self.orderTimeLabel.text = [NSString TimeStamp:self.detailsModel.createTime];
}

- (UIImageView *)creatImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    return imageView;
}

- (IBAction)surePayButtonClick:(UIButton *)sender {
    
    [self kgg_orderDetailsMessage];
}

#pragma mark - 刷新当前页面
- (void)refreshView
{
    [KGGPublishOrderRequestManager publishOrderDetailsMessageOrder:self.detailsModel.orderId completion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            self.detailsModel = [KGGOrderDetailsModel mj_objectWithKeyValues:responseObj.data];
        }
        [self setupModel];
        
    } aboveView:self.view inCaller:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)kgg_orderDetailsMessage
{
    KGGActionSheetController *sheetVC = [[KGGActionSheetController alloc]init];
    sheetVC.moneyString = [NSString stringWithFormat:@"工资: ¥%.2f",self.detailsModel.totalAmount];
    sheetVC.itemId = self.detailsModel.orderNo;
    sheetVC.tradeType = @"ORDER";
    //    __weak typeof(self) weakSelf = self;
    sheetVC.callPaySuccessBlock = ^(NSString *code){
        if ([code isEqualToString:@"200"]) {
            KGGLog(@"付费成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:sheetVC animated:YES completion:nil];
}

-(void)dealloc
{
    KGGLogFunc;
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
