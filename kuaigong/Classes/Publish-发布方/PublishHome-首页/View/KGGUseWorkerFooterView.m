//
//  KGGUseWorkerFooterView.m
//  kuaigong
//
//  Created by Ding on 2017/12/1.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGUseWorkerFooterView.h"
#import "UIImageView+WebCache.h"
#import "SDPhotoBrowser.h"

@interface KGGUseWorkerFooterView ()<SDPhotoBrowserDelegate>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation KGGUseWorkerFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    weakSelf(self);
    UIView *photoView = [self sectionViewWithTitle:@"工地照片"];
    [self addSubview:photoView];
    [photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.mas_top).offset(0);
        make.left.equalTo(weakself.mas_left);
        make.width.equalTo(@(kMainScreenWidth));
        make.height.equalTo(@(32));
    }];

    self.bottomView = [UIView new];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoView.mas_bottom);
        make.left.equalTo(weakself.mas_left);
        make.right.equalTo(weakself.mas_right);
        make.bottom.equalTo(weakself.mas_bottom);
    }];
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton = addButton;
    [addButton setBackgroundImage:[UIImage imageNamed:@"icon_jia"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.bottomView.mas_centerX);
        make.centerY.equalTo(weakself.bottomView.mas_centerY);
        make.width.height.mas_equalTo(62);
    }];
}

- (void)addButtonClick:(UIButton *)sender
{
    KGGLog(@"添加照片");
    if ([self.footerDelegate respondsToSelector:@selector(kgg_userworkFooterPhoneButtonClick)]) {
        [self.footerDelegate kgg_userworkFooterPhoneButtonClick];
    }
}

#pragma mark - 给工地照片赋值
- (void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray;
    if (imageArray.count!= 0) {
        [self.addButton removeFromSuperview];
        CGFloat widthImage = (kMainScreenWidth-65)/imageArray.count;
        for (int i =0; i<imageArray.count; i++) {
            self.imageView = [self creatImageView];
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(snh_qrButtonClick:)];
            [self.imageView addGestureRecognizer:recognizer];
            self.imageView.tag = 100+i;
            self.imageView.frame = CGRectMake(15+5*i+widthImage*i, 0, widthImage, 62);
            [self.bottomView addSubview:self.imageView];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]]];
        }
    }
}

- (void)snh_qrButtonClick:(UITapGestureRecognizer *)reg
{
    KGGLog(@"二维码");
    UIView *vi = reg.view;
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.tag = 1000;
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = vi.tag-100;
    photoBrowser.imageCount = self.imageArray.count;
    photoBrowser.sourceImagesContainerView = self.bottomView;
    [photoBrowser show];
}

#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:@""];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    NSString *imgUrl = self.imageArray[index];
    return [NSURL URLWithString:imgUrl];
}

- (void )photoBrowserDidDissmissed:(SDPhotoBrowser *)browser{
    KGGLogFunc;
    
}

- (UIImageView *)creatImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    return imageView;
}

- (UIView *)sectionViewWithTitle:(NSString *)title
{
    UIView *view = [UIView new];
    view.backgroundColor = KGGViewBackgroundColor;
    view.frame = CGRectMake(0, 65, kMainScreenWidth, 33);
    UILabel *label = [UILabel new];
    label.text = title;
    label.textColor = UIColorHex(0x333333);
    label.font = KGGFont(14);
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(@15.f);
    }];
    
    return view;
}

@end













