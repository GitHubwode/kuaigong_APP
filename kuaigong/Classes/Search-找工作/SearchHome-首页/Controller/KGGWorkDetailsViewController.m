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
#import "SDPhotoBrowser.h"
#import "KGGSearchOrderRequestManager.h"
#import "KGGPublishOrderRequestManager.h"

@interface KGGWorkDetailsViewController ()<SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIView *factoryView;
@property (nonatomic, strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

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
    }
}

#pragma mark - 接到通知
- (void)notificationSetUp
{
    
    NSString *orderId = [NSString stringWithFormat:@"%lu",(unsigned long)self.searchOrderModel.orderId];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"老板正在修改订单,是否同意修改" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self sureChangeOrderMessageOrderId:orderId Type:@"N"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        KGGLog(@"决绝修改");
        [self sureChangeOrderMessageOrderId:orderId Type:@"Y"];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma makr - 确定是否修改
- (void)sureChangeOrderMessageOrderId:(NSString *)orderId Type:(NSString *)type
{
    [KGGSearchOrderRequestManager workerChangeOrderMessageOrder:orderId IsSbumit:type completion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
//            [self.view showHint:@"哈哈哈哈"];
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

- (void)snh_qrButtonClick:(UITapGestureRecognizer *)reg
{
    KGGLog(@"二维码");
    UIView *vi = reg.view;
    self.view = vi;
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.tag = 1000;
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = vi.tag-100;
    photoBrowser.imageCount = self.searchOrderModel.imageArray.count;
    photoBrowser.sourceImagesContainerView = self.factoryView;
    [photoBrowser show];
}

- (UIImageView *)creatImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    return imageView;
}

#pragma mark -SDPhotoBrowserDeleggate
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView;
    imageView.tag = self.view.tag-100;
    return imageView.image;
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imgUrl = self.searchOrderModel.imageArray[index];
    return [NSURL URLWithString:imgUrl];
}

- (void )photoBrowserDidDissmissed:(SDPhotoBrowser *)browser{
    KGGLogFunc;
}

#pragma mark - 赋值
- (void)setUpOrderDetailsModel:(KGGOrderDetailsModel *)model
{
    if (!model.imageArray) {
        //        self.bgView.frame = CGRectMake(0, 0, kMainScreenWidth, 400);
        [self.factoryView removeFromSuperview];
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.top.equalTo(self.view.mas_top);
            make.width.equalTo(@(kMainScreenWidth));
            make.height.equalTo(@(400));
        }];
        
        return;
    };
    CGFloat widthImage = (kMainScreenWidth-65)/model.imageArray.count;
    for (int i =0; i<model.imageArray.count; i++) {
        self.imageView = [self creatImageView];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(snh_qrButtonClick:)];
        [self.imageView addGestureRecognizer:recognizer];
        self.imageView.tag = 100+i;
        self.imageView.frame = CGRectMake(15+5*i+widthImage*i, 10, widthImage, 62);
        [self.factoryView addSubview:self.imageView];
        
        if (![model.imageArray[i] containsString:@"http"]) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https:%@",model.imageArray[i]]]];
        }else{
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageArray[i]]];
        }
    }
    
    
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
