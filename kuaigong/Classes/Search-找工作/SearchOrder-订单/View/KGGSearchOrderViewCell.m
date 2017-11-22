//
//  KGGSearchOrderViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/9/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGSearchOrderViewCell.h"
#import "KGGOrderDetailsModel.h"
#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"


static NSString *KGGSearchOrderView = @"KGGSearchOrderViewCell";

@interface KGGSearchOrderViewCell ()<SDPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *ramarkLabel;
@property (weak, nonatomic) IBOutlet UIView *factoryView;
@property (weak, nonatomic) IBOutlet UIView *factoryView1;
@property (nonatomic, strong) UIImageView *imageView1;

@end

@implementation KGGSearchOrderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setOrderDetails:(KGGOrderDetailsModel *)orderDetails
{
    _orderDetails = orderDetails;
    self.timeTitleLabel.text = orderDetails.workStartTime;
    self.addressLabel.text = orderDetails.address;
    self.detailsLabel.text = orderDetails.searchOrderDetails;
    self.ramarkLabel.text = [NSString stringWithFormat:@"%@\n支付时间:%@",orderDetails.remark,orderDetails.payTime];
    
    if (!self.orderDetails.imageArray) {
        [self.factoryView1 removeFromSuperview];
        [self.factoryView removeFromSuperview];
        return;
    }
    CGFloat widthImage = (kMainScreenWidth-65)/orderDetails.imageArray.count;

    for (int i =0; i<orderDetails.imageArray.count; i++) {
        self.imageView1 = [self creatImageView];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(snh_qrButtonClick:)];
        [self.imageView1 addGestureRecognizer:recognizer];
        self.imageView1.tag = 100+i;
        self.imageView1.frame = CGRectMake(15+5*i+widthImage*i, 10, widthImage, 62);
        [self.factoryView addSubview:self.imageView1];
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:orderDetails.imageArray[i]]];
    }
}

- (UIImageView *)creatImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    return imageView;
}

- (void)snh_qrButtonClick:(UITapGestureRecognizer *)reg
{
    KGGLog(@"二维码");
    UIView *vi = reg.view;
//    self.view = vi;
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.tag = 1000;
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = vi.tag-100;
    photoBrowser.imageCount = self.orderDetails.imageArray.count;
    photoBrowser.sourceImagesContainerView = self.factoryView;
    [photoBrowser show];
}

#pragma mark -SDPhotoBrowserDeleggate
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView;
//    imageView.tag = self.view.tag-100;
    return imageView.image;
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imgUrl = self.orderDetails.imageArray[index];
    return [NSURL URLWithString:imgUrl];
}

- (void )photoBrowserDidDissmissed:(SDPhotoBrowser *)browser{
    KGGLogFunc;
}

+ (NSString *)searchOrderIdentifier
{
    return KGGSearchOrderView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
