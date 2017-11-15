//
//  KGGPublishPostedHeaderView.m
//  kuaigong
//
//  Created by Ding on 2017/11/15.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishPostedHeaderView.h"
#import "KGGOrderDetailsModel.h"
#import "UIImageView+WebCache.h"
#import "SNHStartRateView.h"

@interface KGGPublishPostedHeaderView ()<snhStartRateViewDelegate>

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *gradeImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *orderLabel;
@property (nonatomic, strong) UILabel *reamrkLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *moneylabel;
@property (nonatomic, strong) SNHStartRateView *startRate;


@end

@implementation KGGPublishPostedHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KGGViewBackgroundColor;
        [self creatHeaderView];
    }
    return self;
}

- (void)setOrderModel:(KGGOrderDetailsModel *)orderModel
{
    _orderModel = orderModel;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:orderModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    self.nameLabel.text = orderModel.contacts;
    self.moneylabel.text = [NSString stringWithFormat:@"%.f¥",orderModel.totalAmount];
    self.timeLabel.text = orderModel.workStartTime;
    self.orderLabel.text = orderModel.orderDetails;
    self.reamrkLabel.text = orderModel.remark;
    self.addressLabel.text = orderModel.address;
}

-(void)starRateView:(SNHStartRateView *)starRateView currentScore:(CGFloat)currentScore
{
    
}

- (void)creatHeaderView
{
    CGFloat viewWidth = self.xc_width;//view的宽度
    CGFloat viewPadding = 0; //距离边的距离
    weakSelf(self);
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(viewPadding, 10, viewWidth, 52)];
    view1.backgroundColor = [UIColor whiteColor];
    [self addSubview:view1];
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_shalou"]];
    [view1 addSubview:imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view1.mas_centerY);
        make.left.equalTo(view1.mas_left).offset(20);
    }];
    UILabel *proLabel = [self creatHeaderViewTitleFont:KGGFont(14) Textcolor:UIColorHex(0x333333)];
    proLabel.text = @"请耐心等待20-60分钟";
    [view1 addSubview:proLabel];
    [proLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView1.mas_centerY);
        make.left.equalTo(imageView1.mas_right).offset(20);
    }];
    
    //订单信息View
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(viewPadding, 72, viewWidth, 62)];
    view2.backgroundColor = [UIColor whiteColor];
    [self addSubview:view2];
    [view2 addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view2.mas_centerY);
        make.left.equalTo(view2.mas_left).offset(23);
        make.width.and.height.mas_equalTo(@(38));
    }];
    self.nameLabel = [self creatHeaderViewTitleFont:KGGFont(14) Textcolor:UIColorHex(0x333333)];
    self.nameLabel.text = @"李老板";
    [view2 addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.avatarImageView.mas_top);
        make.left.equalTo(weakself.avatarImageView.mas_right).offset(23);
    }];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_xinyong"]];
    [view2 addSubview:imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakself.nameLabel.mas_leading);
        make.top.equalTo(weakself.nameLabel.mas_bottom).offset(9);
    }];
    //星星
    
    self.startRate = [[SNHStartRateView alloc]initWithFrame:CGRectMake(0, 0, 60, 15) NumberOfStart:5 RateStyle:IncompleteStart IsAnimation:YES delegate:self];
    self.startRate.delegate = self;
    self.startRate.currentScore = 5;
    self.startRate.isDisplay = YES;
    [view2 addSubview:self.startRate];
    [self.startRate mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView2.mas_centerY);
        make.left.equalTo(imageView2.mas_right).offset(10);
        make.width.equalTo(@(60));
        make.height.equalTo(@(15));
    }];
    
    self.moneylabel = [self creatHeaderViewTitleFont:KGGFont(14) Textcolor:UIColorHex(f8693d)];
    self.moneylabel.text = @"";
    self.moneylabel.textAlignment = NSTextAlignmentRight;
    [view2 addSubview:self.moneylabel];
    [self.moneylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.nameLabel.mas_centerY);
        make.right.equalTo(view2.mas_right).offset(-23);
    }];
    
    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = UIColorHex(0xf1f1f1);
    [view2 addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view2.mas_left);
        make.bottom.equalTo(view2.mas_bottom);
        make.right.equalTo(view2.mas_right);
        make.height.equalTo(@(KGGOnePixelHeight));
    }];
    
    //时间
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(viewPadding, 134, viewWidth, 35)];
    view3.backgroundColor = [UIColor whiteColor];
    [self addSubview:view3];
    UIImageView *badgeView1 = [self creatBageViewImage:@"icon_yuan1"];
    [view3 addSubview:badgeView1];
    [badgeView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view3.mas_centerY);
        make.left.equalTo(view3.mas_left).offset(23);
    }];
    self.timeLabel = [self creatHeaderViewTitleFont:KGGFont(14) Textcolor:UIColorHex(0x666666)];
    self.timeLabel.text = @"";
    [view3 addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view3.mas_centerY);
        make.left.equalTo(badgeView1.mas_right).equalTo(@(24));
    }];

    //地址
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(viewPadding, 134+35, viewWidth, 35)];
    view4.backgroundColor = [UIColor whiteColor];
    [self addSubview:view4];
    UIImageView *badgeView2 = [self creatBageViewImage:@"icon_yuan2"];
    [view4 addSubview:badgeView2];
    [badgeView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view4.mas_centerY);
        make.left.equalTo(view4.mas_left).offset(23);
    }];
    self.addressLabel = [self creatHeaderViewTitleFont:KGGFont(14) Textcolor:UIColorHex(0x666666)];
    self.addressLabel.text = @"";
    [view4 addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view4.mas_centerY);
        make.left.equalTo(badgeView2.mas_right).equalTo(@(24));
    }];
    //用工信息
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(viewPadding, 134+35+35, viewWidth, 58)];
    view5.backgroundColor = [UIColor whiteColor];
    [self addSubview:view5];
    
    UIImageView *badgeView3 = [self creatBageViewImage:@"icon_yuan3"];
    [view5 addSubview:badgeView3];
    [badgeView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view5.mas_centerY);
        make.left.equalTo(view5.mas_left).offset(23);
        make.width.and.height.mas_equalTo(@(10));
    }];
    self.orderLabel = [self creatHeaderViewTitleFont:KGGFont(14) Textcolor:UIColorHex(0x666666)];
    self.orderLabel.text = @"";
    [UILabel changeLineSpaceForLabel:self.orderLabel WithSpace:5.0];
    [view5 addSubview:self.orderLabel];
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view5.mas_centerY);
        make.left.equalTo(badgeView3.mas_right).equalTo(@(24));
        make.right.equalTo(view5.mas_right).offset(-24);
    }];
    
    
    //备注信息
    UIView *view6 = [[UIView alloc]initWithFrame:CGRectMake(viewPadding, 134+35+35+58, viewWidth, 58)];
    view6.backgroundColor = [UIColor whiteColor];
    [self addSubview:view6];

    UIImageView *badgeView4 = [self creatBageViewImage:@"icon_yuan4"];
    [view6 addSubview:badgeView4];
    [badgeView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view6.mas_centerY);
        make.left.equalTo(view6.mas_left).offset(23);
        make.width.and.height.mas_equalTo(@(10));
    }];
    self.reamrkLabel = [self creatHeaderViewTitleFont:KGGFont(14) Textcolor:UIColorHex(0x666666)];
    self.reamrkLabel.text = @"";
    [UILabel changeLineSpaceForLabel:self.reamrkLabel WithSpace:5.0];
    [view6 addSubview:self.reamrkLabel];
    [self.reamrkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view6.mas_centerY);
        make.left.equalTo(badgeView4.mas_right).equalTo(@(24));
        make.right.equalTo(view6.mas_right).offset(-24);
    }];
    
    
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = UIColorHex(0xf1f1f1);
    [view6 addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view6.mas_left);
        make.bottom.equalTo(view6.mas_bottom);
        make.right.equalTo(view6.mas_right);
        make.height.equalTo(@(KGGOnePixelHeight));
    }];

    //最后按钮
    UIView *view7 = [[UIView alloc]initWithFrame:CGRectMake(viewPadding, 134+35+35+58+58, viewWidth, 53)];
    view7.backgroundColor = [UIColor whiteColor];
    [self addSubview:view7];
    
    UILabel *messageLabel = [self creatHeaderViewTitleFont:KGGFont(10) Textcolor:UIColorHex(0xf5b617)];
    messageLabel.text = @"正在等待班主接单请耐心等待";
    [view7 addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view7.mas_centerY);
        make.left.equalTo(view7.mas_left).equalTo(@(23));
    }];
    
    [view7 addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view7.mas_centerY);
        make.right.equalTo(view7.mas_right).equalTo(@(-23));
        make.width.equalTo(@(72));
        make.height.equalTo(@(29));
    }];
}

#pragma 代理
- (void)cancelButtonClick:(UIButton *)sender
{
    if ([self.postedDelegate respondsToSelector:@selector(KGGPublishPostedHeaderViewCancelOrderButtonClick)]) {
        [self.postedDelegate KGGPublishPostedHeaderViewCancelOrderButtonClick];
    }
}

#pragma mark - 懒加载

- (UILabel *)creatHeaderViewTitleFont:(UIFont *)font Textcolor:(UIColor *)textColor
{
    UILabel *label = [UILabel new];
    label.textColor = textColor;
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 18;
        _avatarImageView.image = [UIImage imageNamed:@"icon_touxiang"];
    }
    return _avatarImageView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"bg_button"] forState:UIControlStateNormal];
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.cornerRadius = 5.f;
        _cancelButton.titleLabel.font = KGGFont(12);
        [_cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIImageView *)creatBageViewImage:(NSString *)image
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    return imageView;
}

@end
