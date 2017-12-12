//
//  KGGAddBankCardFirstController.m
//  kuaigong
//
//  Created by Ding on 2017/9/8.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGAddBankCardFirstController.h"
#import "KGGCustomInfoItem.h"
#import "KGGCustomInfoCell.h"
#import "KGGFillBankInfoViewController.h"
#import "KGGWallectRequestManager.h"

static NSString *KGGAddBankCardHeaderIdfy = @"KGGAddBankCardHeaderIdfy";

@interface KGGAddBankCardFirstController ()

@property (nonatomic, strong) NSMutableArray <KGGCustomInfoItem *>*dataArray;

@end

@implementation KGGAddBankCardFirstController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加银行卡";
    
    self.view.backgroundColor = KGGViewBackgroundColor;
    
    self.tableView.separatorColor = KGGSeparatorColor;
    self.tableView.rowHeight = 58.f;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGCustomInfoCell class]) bundle:nil] forCellReuseIdentifier:[KGGCustomInfoCell cellIdentifier]];
    
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
    [NSUserDefaults removeObjectForKey:KGGBankNumKey];
    [NSUserDefaults removeObjectForKey:KGGCardholderKey];
    [NSUserDefaults removeObjectForKey:KGGBankOfDepositKey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [NSUserDefaults removeObjectForKey:KGGBankNumKey];
    [NSUserDefaults removeObjectForKey:KGGCardholderKey];
    [NSUserDefaults removeObjectForKey:KGGBankOfDepositKey];
    KGGLogFunc
}


- (NSMutableArray<KGGCustomInfoItem *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        KGGCustomInfoItem *cardholderItem = [KGGCustomInfoItem new];
        cardholderItem.title = @"持卡人";
        cardholderItem.placeholder = @"请输入持卡人姓名";
        cardholderItem.required = YES;
        cardholderItem.enabled = YES;
        cardholderItem.editabled = YES;
        cardholderItem.hidenIndicator = YES;
        [_dataArray addObject:cardholderItem];
        
        KGGCustomInfoItem *cardItem = [KGGCustomInfoItem new];
        cardItem.title = @"银行卡";
        cardItem.placeholder = @"请输入持卡人卡号";
        cardItem.keyboardType = UIKeyboardTypeNumberPad;
        cardItem.required = YES;
        cardItem.enabled = YES;
        cardItem.editabled = YES;
        cardItem.hidenIndicator = YES;
        [_dataArray addObject:cardItem];
        
        KGGCustomInfoItem *bankOfDepositItem = [KGGCustomInfoItem new];
        bankOfDepositItem.title = @"开户行";
        bankOfDepositItem.placeholder = @"请输入开户行 例如:**银行**支行";
        bankOfDepositItem.required = NO;
        bankOfDepositItem.enabled = YES;
        bankOfDepositItem.editabled = YES;
        bankOfDepositItem.hidenIndicator = YES;
        [_dataArray addObject:bankOfDepositItem];
        
        
    }
    return _dataArray;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KGGCustomInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGCustomInfoCell cellIdentifier]];
    cell.infoItem = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[cell textField] becomeFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:KGGAddBankCardHeaderIdfy];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:KGGAddBankCardHeaderIdfy];
        header.contentView.backgroundColor = KGGViewBackgroundColor;
        UILabel *textLabel = [UILabel new];
        textLabel.textColor = KGGTimeTextColor;
        textLabel.font = KGGFont(13);
        textLabel.text = @"请绑定持卡人本人银行卡";
        [header.contentView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(header);
            make.left.equalTo(header).with.offset(KGGLeftPadding);
        }];
    }
    return header;
}

- (void)nextButtonAction:(UIButton *)sender{
    
//    [self.view endEditing:YES];
    
    KGGCustomInfoItem *cardholderItem= self.dataArray.firstObject;
    if (!cardholderItem.subtitle.length) {
        [MBProgressHUD showMessag:cardholderItem.placeholder];
        return;
    }
    
    KGGCustomInfoItem *cardItem = self.dataArray[1];
    NSString *bankNum = [self bankNumToNormalNum:cardItem.subtitle];
    if (!bankNum || !bankNum.length) {
        [MBProgressHUD showMessag:cardItem.placeholder];
        return;
    }
    
    KGGLog(@"bankNum = %@",bankNum);
    
    if (![self checkCardNo:bankNum]) {
        [MBProgressHUD showMessag:@"格式不正确"];
        return;
    }
    
    [KGGWallectRequestManager myWalletInquireBankCarNameCarNum:bankNum completion:^(KGGResponseObj *responseObj) {
        
        NSString *bankName = responseObj.data;
//        NSString *bankNums = @"15026418284";
        
        if (bankName.length) {
            
            KGGFillBankInfoViewController *bankInfo = [[KGGFillBankInfoViewController alloc]init];
            bankInfo.bankInfo = bankName;
            [self.navigationController pushViewController:bankInfo animated:YES];
            [NSUserDefaults setObject:bankNum forKey:KGGBankNumKey];
            [NSUserDefaults setObject:cardholderItem.subtitle forKey:KGGCardholderKey];
            [NSUserDefaults setObject:bankName forKey:KGGBankOfDepositKey];
            
            KGGCustomInfoItem *bankOfDepositItem = self.dataArray.lastObject;
//            if (bankOfDepositItem.subtitle.length) {
//                [NSUserDefaults setObject:bankOfDepositItem.subtitle forKey:KGGBankOfDepositKey];
//            }
        }
    } aboveView:self.view idCaller:self];
}


- (BOOL)checkCardNo:(NSString*)cardNo{
    
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}


// 银行卡号转正常号 － 去除4位间的空格
-(NSString *)bankNumToNormalNum:(NSString *)text
{
    return [text stringByReplacingOccurrencesOfString:@" " withString:@""];
}


@end
