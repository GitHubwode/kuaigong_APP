//
//  KGGFillBankInfoViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/8.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGFillBankInfoViewController.h"
#import "KGGCustomInfoCell.h"
#import "KGGCustomInfoItem.h"
#import "SNHSecurityCodeViewController.h"

@interface KGGFillBankInfoViewController ()

@property (nonatomic, strong) NSMutableArray <KGGCustomInfoItem *> *dataArray;

@end

@implementation KGGFillBankInfoViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"填写银行卡信息";
    
    self.view.backgroundColor = KGGViewBackgroundColor;
    
    self.tableView.separatorColor = KGGSeparatorColor;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGCustomInfoCell class]) bundle:nil] forCellReuseIdentifier:[KGGCustomInfoCell cellIdentifier]];
    self.tableView.rowHeight = 48.f;
    UIView *footer = [UIView new];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"btn_bot"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"btn_bot"] forState:UIControlStateHighlighted];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
    nextButton.xc_width = KGGAdaptedWidth(240);
    nextButton.xc_height = KGGAdaptedHeight(49.f);
    nextButton.xc_x = (kMainScreenWidth - nextButton.xc_width) * 0.5;
    nextButton.xc_y = 27.f;
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    footer.xc_height = CGRectGetMaxY(nextButton.frame);
    [footer addSubview:nextButton];
    self.tableView.tableFooterView = footer;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    KGGLogFunc
}

- (NSMutableArray<KGGCustomInfoItem *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        KGGCustomInfoItem *cardItem = [KGGCustomInfoItem new];
        cardItem.title = @"卡类型";
        cardItem.subtitle = _bankInfo;
        cardItem.required = YES;
        cardItem.enabled = NO;
        cardItem.editabled = NO;
        cardItem.hidenIndicator = YES;
        [_dataArray addObject:cardItem];
        
        KGGCustomInfoItem *cellphoneItem = [KGGCustomInfoItem new];
        cellphoneItem.title = @"手机号";
        cellphoneItem.placeholder = @"请输入银行预留手机号码";
        cellphoneItem.keyboardType = UIKeyboardTypeNumberPad;
        cellphoneItem.required = YES;
        cellphoneItem.enabled = YES;
        cellphoneItem.editabled = YES;
        cellphoneItem.hidenIndicator = YES;
        cellphoneItem.maxTextLength = 11;
        [_dataArray addObject:cellphoneItem];
    }
    return _dataArray;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KGGCustomInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGCustomInfoCell cellIdentifier]];
    cell.infoItem = self.dataArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.dataArray[indexPath.row].enabled) return;
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[cell textField] becomeFirstResponder];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return KGGSmallMargin;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)nextButtonAction:(UIButton *)sender{
    
    [self.view endEditing:YES];
    
    KGGCustomInfoItem *cellphoneItem = self.dataArray.lastObject;
    NSString *cellphone = cellphoneItem.subtitle;
    if (!cellphone.length){
        [MBProgressHUD showMessag:cellphoneItem.placeholder];
        return;
    };
    
    // 1.对用户输入的手机号进行正则匹配
    BOOL isMatch = [cellphone isPhoneNumer];
    // 2.对不同的匹配结果做处理
    if (!isMatch){ // 不是正规的手机号码
        [MBProgressHUD showMessag:@"请输入正确格式的手机号码"];
        return;
    }
    
    SNHSecurityCodeViewController *code = [[SNHSecurityCodeViewController alloc]init];
    code.cellphone = cellphone;
    [self.navigationController pushViewController:code animated:YES];
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
