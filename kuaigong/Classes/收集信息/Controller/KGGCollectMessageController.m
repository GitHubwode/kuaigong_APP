//
//  KGGCollectMessageController.m
//  kuaigong
//
//  Created by Ding on 2017/11/3.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGCollectMessageController.h"
#import "KGGCustomInfoItem.h"
#import "KGGCollectViewCell.h"
#import "KGGCollectFooterView.h"
#import "KGGPublishHomeRequestManager.h"

@interface KGGCollectMessageController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) KGGCollectFooterView *footerView;
@end

@implementation KGGCollectMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationItem.title = self.itemName;
//    [self creatNaviUI];
    [self creatBottomImageView];
    [self kgg_addButton];
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)creatNaviUI
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 44)];
    label.text = self.itemName;
    label.textColor = UIColorHex(0xffffff);
    label.backgroundColor = KGGGoldenThemeColor;
    label.font = KGGLightFont(18);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *jumpButton = [[UIButton alloc]init];
    [jumpButton setTitle:@"跳过" forState:UIControlStateNormal];
    [jumpButton addTarget:self action:@selector(kgg_dissmissViewController) forControlEvents:UIControlEventTouchUpInside];
    [jumpButton setTitleColor:UIColorHex(0x737373) forState:UIControlStateNormal];
    jumpButton.titleLabel.font = KGGLightFont(18);
    [self.view addSubview:jumpButton];
    [jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.right.equalTo(label.mas_right).offset(-14);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, KGGOnePixelHeight)];
    lineView.backgroundColor = UIColorHex(0xb2b2b2);
    [self.view addSubview:lineView];
}

#pragma mark - 按钮的点击事件
- (void)kgg_dissmissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 底层图片
- (void)creatBottomImageView
{
//    weakSelf(self);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    imageView.image = [UIImage imageNamed:@"bossBg"];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    [imageView addSubview:self.tableView];
    self.tableView.tableFooterView = self.footerView;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
    view.backgroundColor =KGGGoldenThemeColor;
    [imageView addSubview:view];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 44)];
    label.text = self.itemName;
    label.textColor = UIColorHex(0xffffff);
    label.backgroundColor = KGGGoldenThemeColor;
    label.font = KGGLightFont(18);
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIButton *jumpButton = [[UIButton alloc]init];
    [jumpButton setTitle:@"取消" forState:UIControlStateNormal];
    [jumpButton addTarget:self action:@selector(kgg_dissmissViewController) forControlEvents:UIControlEventTouchUpInside];
    [jumpButton setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    jumpButton.titleLabel.font = KGGLightFont(18);
    [view addSubview:jumpButton];
    [jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.right.equalTo(label.mas_right).offset(-14);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, KGGOnePixelHeight)];
//    lineView.backgroundColor = UIColorHex(0xb2b2b2);
//    [view addSubview:lineView];
    
}

#pragma mark - UITableViewDelegate UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGCustomInfoItem *item = self.datasource[indexPath.row];
    KGGCollectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGCollectViewCell collectIdentifier]];
    cell.infoItem = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KGGCustomInfoItem *item = self.datasource[indexPath.row];
    KGGLog(@"%@",item);
    if (!item.enabled) return;
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    [[cell collectTextField] becomeFirstResponder];
}

#pragma mark - 提交按钮
- (void)snh_beginButtonClick:(UIButton *)sender
{
    NSString *name;
    NSString *phone;
    NSString *age;
    NSString *id_Card_Num;
    NSString *industry;
    NSString *nativePlace;
    NSString *address;
    
    for ( KGGCustomInfoItem *infoItem in self.datasource) {
        if ([infoItem.title isEqualToString:@"姓名:"] && infoItem.subtitle.length == 0) {
            [self.view showHint:@"姓名不能为空"];
            return;
        }else{
            name = infoItem.subtitle;
        }
        if ([infoItem.title isEqualToString:@"手机:"]) {
            if (infoItem.subtitle.length == 0) {
                [self.view showHint:@"手机不能为空"];
                return;
            }else{
                if (![infoItem.subtitle isPhoneNumer]) {
                    [self.view showHint:@"请输入正确的手机格式"];
                    return;
                }
            }
            
        }else{
            phone = infoItem.subtitle;
        }
        if ([infoItem.title isEqualToString:@"年龄:"]) {
            age = infoItem.subtitle;
        }
        if ([infoItem.title isEqualToString:@"身份证号码:"]) {
            id_Card_Num = infoItem.subtitle;
        }
        if ([infoItem.title isEqualToString:@"行业:"]) {
            industry = infoItem.subtitle;
        }
        if ([infoItem.title isEqualToString:@"年龄籍贯:"]) {
            nativePlace = infoItem.subtitle;
        }
        if ([infoItem.title isEqualToString:@"现住址:"]) {
            address = infoItem.subtitle;
        }
    }
   
    [self publishHomeMessageRequestName:name Phone:phone Age:age IdCard:id_Card_Num Industry:industry NativePlace:nativePlace Address:address];
    KGGLog(@"提交按钮");
}

#pragma mark - 提交信息
- (void)publishHomeMessageRequestName:(NSString *)name Phone:(NSString *)phone Age:(NSString *)age IdCard:(NSString *)idCard Industry:(NSString *)industry NativePlace:(NSString *)nativePlace Address:(NSString *)address
{
    NSString *type;
    if ([self.itemName isEqualToString:@"共享老板"]) {
        type = @"BOSS";
    }else{
        type = @"WORKER";
    }
    
    [KGGPublishHomeRequestManager publishHomeHeaderViewType:type Name:name Phome:phone Age:age Id_Card_Num:idCard Industry:industry NativePlace:nativePlace Address:address completion:^(KGGResponseObj *responseObj) {
        KGGLog(@"%@",responseObj);
        if (responseObj.code == KGGSuccessCode) {
            [self.view showHint:@"上传成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } aboveView:self.view inCaller:self];
}

#pragma mark - 键盘显示隐藏
- (void)keyboardWillShow:(NSNotification *)notification{
    
    if ([self.footerView.textView isFirstResponder]) {
        CGFloat heightA = kMainScreenHeight/568;
        [self.tableView setContentOffset:CGPointMake(0, 230/heightA) animated:NO];

    }else{
        CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat offset = 74 + 58.f * (self.datasource.count-1) - keyboardBounds.size.height;
        KGGLog(@"offset:%f",offset);
        KGGLog(@"%lu",(unsigned long)self.datasource.count);
        [self.tableView setContentOffset:CGPointMake(0, offset) animated:NO];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [self.tableView setContentOffset:CGPointZero animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64-KGGLoginButtonHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellStyleDefault;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGCollectViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGCollectViewCell collectIdentifier]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 58.f;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    }
    return _tableView;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [KGGCustomInfoItem mj_objectArrayWithFilename:@"KGCreatUserMessage.plist"];
    }
    return _datasource;
}

- (void)kgg_addButton
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
    
    UIButton *useButton = [self snh_creatButtonImage:@"bg_button" Title:@"提交"];
    [bgView addSubview:useButton];
    [useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView.mas_centerY);
        make.leading.equalTo(bgView.mas_leading);
        make.height.equalTo(bgView.mas_height);
        make.width.equalTo(@(kMainScreenWidth));
    }];
}

#pragma mark - lazyButton
- (UIButton *)snh_creatButtonImage:(NSString *)image Title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = KGGFont(17);
    [button setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(snh_beginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (KGGCollectFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[KGGCollectFooterView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 140)];
//        _footerView.backgroundColor = [UIColor redColor];
    }
    return _footerView;
}

- (void)dealloc
{
    [KGGNotificationCenter removeObserver:self];
    KGGLogFunc;
}

@end
