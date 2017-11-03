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

@interface KGGCollectMessageController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) KGGCollectFooterView *footerView;
@end

@implementation KGGCollectMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.itemName;
    [self creatBottomImageView];
    [self kgg_addButton];
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [KGGNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 底层图片
- (void)creatBottomImageView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    imageView.image = [UIImage imageNamed:@"bossBg"];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    [imageView addSubview:self.tableView];
    self.tableView.tableFooterView = self.footerView;
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
    for ( KGGCustomInfoItem *infoItem in self.datasource) {
        if ([infoItem.title isEqualToString:@"姓名:"] && infoItem.subtitle.length == 0) {
            [self.view showHint:@"姓名不能为空"];
            return;
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
            
        }
    }
    
    KGGLog(@"提交按钮");
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-KGGLoginButtonHeight) style:UITableViewStyleGrouped];
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
        _footerView = [[KGGCollectFooterView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 130)];
    }
    return _footerView;
}

- (void)dealloc
{
    [KGGNotificationCenter removeObserver:self];
    KGGLogFunc;
}

@end
