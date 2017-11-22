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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 18.f;
    self.view.backgroundColor = KGGViewBackgroundColor;
    [self setUpOrderDetails];
    
    if (!self.searchOrderModel.imageArray) {
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
    CGFloat widthImage = (kMainScreenWidth-65)/self.searchOrderModel.imageArray.count;
    for (int i =0; i<self.searchOrderModel.imageArray.count; i++) {
        self.imageView = [self creatImageView];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(snh_qrButtonClick:)];
        [self.imageView addGestureRecognizer:recognizer];
        self.imageView.tag = 100+i;
        self.imageView.frame = CGRectMake(15+5*i+widthImage*i, 10, widthImage, 62);
        [self.factoryView addSubview:self.imageView];
        
        if (![self.searchOrderModel.imageArray[i] containsString:@"http"]) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https:%@",self.searchOrderModel.imageArray[i]]]];
        }else{
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.searchOrderModel.imageArray[i]]];
        }
    }
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
- (void)setUpOrderDetails
{
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.searchOrderModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    self.nameLabel.text = self.searchOrderModel.contacts;
    self.phoneLabel.text = self.searchOrderModel.hidePhone;
    self.addressLabel.text = self.searchOrderModel.address;
    self.orderDetailsLabel.text = self.searchOrderModel.searchOrderDetails;
    self.remarkLabel.text = [NSString stringWithFormat:@"备注: %@",self.searchOrderModel.remark];
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单编号: %@",self.searchOrderModel.orderNo];
    self.timeLabel.text = [NSString stringWithFormat:@"接单时间: %@",self.searchOrderModel.accpetTime];
    self.phoneCall = [NSString stringWithFormat:@"tel:%@",self.searchOrderModel.contactsPhone];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@ ¥",self.searchOrderModel.differentPrice];
    self.payLabel.text = [NSString stringWithFormat:@"支付时间:%@",self.searchOrderModel.payTime];
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
