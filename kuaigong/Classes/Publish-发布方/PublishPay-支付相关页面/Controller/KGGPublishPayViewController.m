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
#import "SDPhotoBrowser.h"


@interface KGGPublishPayViewController ()<SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UILabel *orderDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *factoryView;
@property (nonatomic, strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *factoryView1;

@end

@implementation KGGPublishPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;

    if (self.requestType ==KGGOrderRequestMyDoingType){
        KGGLog(@"正在进行时");
        self.title = @"进行中的订单";
        [self addButton];
    }else if (self.requestType ==KGGOrderRequestCompleteType){
        KGGLog(@"我已完成的订单");
        self.title = @"完成订单";
        [self.sureButton removeFromSuperview];
        [self.messageLabel removeFromSuperview];
    }else if (self.requestType ==KGGOrderRequestNotCompleteType){
        KGGLog(@"未接单");
        self.title = @"未接订单";
        [self.sureButton setTitle:@"取消订单" forState:UIControlStateNormal];
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
    
    if (!self.detailsModel.imageArray) {
        [self.factoryView removeFromSuperview];
        [self.factoryView1 removeFromSuperview];
        return;
    }
    
    CGFloat widthImage = (kMainScreenWidth-65)/self.detailsModel.imageArray.count;
    for (int i =0; i<self.detailsModel.imageArray.count; i++) {
        self.imageView = [self creatImageView];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(snh_qrButtonClick:)];
        [self.imageView addGestureRecognizer:recognizer];
        self.imageView.tag = 100+i;
        self.imageView.frame = CGRectMake(15+5*i+widthImage*i, 10, widthImage, 62);
        [self.factoryView addSubview:self.imageView];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.detailsModel.imageArray[i]]];
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
    photoBrowser.imageCount = self.detailsModel.imageArray.count;
    photoBrowser.sourceImagesContainerView = self.factoryView;
    [photoBrowser show];
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
    NSString *imgUrl = self.detailsModel.imageArray[index];
    return [NSURL URLWithString:imgUrl];
}

- (void )photoBrowserDidDissmissed:(SDPhotoBrowser *)browser{
    KGGLogFunc;
}

- (void)addButton
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
    
    UIButton *useButton = [self snh_creatButtonImage:@"bg_button" Title:@"修改订单"];
    useButton.tag = 1000;
    UIButton *orderButton = [self snh_creatButtonImage:@"bg_button" Title:@"支付订单"];
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

- (UIImageView *)creatImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    return imageView;
}

#pragma mark - lazyButton
- (UIButton *)snh_creatButtonImage:(NSString *)image Title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = KGGFont(18);
    [button setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(snh_beginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - 底部按钮
- (void)snh_beginButtonClick:(UIButton *)sender
{
    weakSelf(self);
    if (sender.tag == 1000){
        KGGLog(@"修改订单");
        KGGOrderCorrectViewController *orderVC = [[KGGOrderCorrectViewController alloc]init];
        orderVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        orderVC.detailsModel = self.detailsModel;
        orderVC.backBlock = ^(NSUInteger code) {
            KGGLog(@"%lu刷新页面",(unsigned long)code);
            [weakself refreshView];
        };
        
        [self presentViewController:orderVC animated:YES completion:nil];
    }else{
        KGGLog(@"登录就可以进入");
        [self kgg_orderDetailsMessage];
    }
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
- (IBAction)publishSurePayButtonClick:(UIButton *)sender {
    
    [self kgg_cancelOrder];
}

- (void)kgg_cancelOrder
{
    [KGGPublishOrderRequestManager publishCancelOrderId:self.detailsModel.orderId completion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            
            if (self.backBlock) {
                self.backBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } aboveView:self.view inCaller:self];
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
