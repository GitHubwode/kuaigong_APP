//
//  SNHSecurityCodeViewController.m
//  sunvhui
//
//  Created by apple on 2017/1/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SNHSecurityCodeViewController.h"
#import "UITextField+KGGExtension.h"
#import "UIButton+Countdown.h"
#import "KGGWithdrawalPasswordViewController.h"
#import "KGGLoginParam.h"
#import "KGGLoginRequestManager.h"

@interface SNHSecurityCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *alertTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation SNHSecurityCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"填写验证码";
    self.codeTextField.placeholderColor = UIColorHex(bbbbbb);
    NSString *mobile = [NSString stringWithFormat:@"%@****%@",[_cellphone substringToIndex:3],[_cellphone substringWithRange:NSMakeRange(_cellphone.length - 4, 4)]];
    _alertTextLabel.text = [NSString stringWithFormat:@"请输入手机号%@收到的短信验证码",mobile];
    
    [self sencodeButtonAction:self.sendCodeButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    KGGLogFunc
}


- (IBAction)sencodeButtonAction:(UIButton *)sender{
    
    
    [self.view showHUD];
    
    long time1 = [[NSString publishSetUpNowTime] longLongValue];
    NSString *codeType = @"DRAW_BANK_PWD";
    NSString *sig = [NSString stringWithFormat:@"%@%@%ld%@",self.cellphone,codeType,time1,KGGAesKey];
    NSString *sig1 = [sig md5String];
    
    KGGSMSCodeParam *param = [[KGGSMSCodeParam alloc]initWithPhone:self.cellphone Type:codeType Timestamp:time1 Signature:sig1];
    
    weakSelf(self);
    
    [KGGLoginRequestManager sendVerificationCodeToCellParam:param completion:^(KGGResponseObj *responseObj) {
        [self.view hideHUD];
        
        if (!responseObj) {
            [self.view showHint:KGGHttpNerworkErrorTip];
        }else if (responseObj.code != KGGSuccessCode){
            [self.view showHint:responseObj.message];
        }else{
            [weakself startCountDown];
        }
        
    } inCaller:self];
}

- (void)startCountDown{
    //倒计时时间
    __block NSInteger timeOut = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    weakSelf(self);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.sendCodeButton.backgroundColor = KGGGoldenThemeColor;
                [weakself.sendCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                [weakself.sendCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                weakself.sendCodeButton.userInteractionEnabled = YES;
            });
        } else {
            int allTime = 61;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.sendCodeButton.backgroundColor = KGGItemSeletedColor;
                [weakself.sendCodeButton setTitle:[NSString stringWithFormat:@"验证码%@秒",timeStr] forState:UIControlStateNormal];
                [weakself.sendCodeButton setTitleColor:KGGTimeTextColor forState:UIControlStateNormal];
                weakself.sendCodeButton.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);

}

- (IBAction)nextBuutonAction:(UIButton *)sender{
    
    [self.view endEditing:YES];
    
    if (!self.codeTextField.text.length) {
        [MBProgressHUD showMessag:@"请填写验证码"];
        return;
    }
    
    KGGWithdrawalPasswordViewController *pwd = [[KGGWithdrawalPasswordViewController alloc] init];
    pwd.cellphone = _cellphone;
    pwd.codeNum = self.codeTextField.text;
    [self.navigationController pushViewController:pwd animated:YES];
    
//    [SNHWalletRequestManager checkVerificationCodeWithCellphone:_cellphone code:self.codeTextField.text completion:^(SNHResponseObj *responseObj) {
//        
//        if (responseObj) {
//            SNHWithdrawalPasswordViewController *pwd = [[SNHWithdrawalPasswordViewController alloc] init];
//            pwd.cellphone = _cellphone;
//            [self.navigationController pushViewController:pwd animated:YES];
//        }
//        
//    } aboveView:self.view inCaller:self];
    
   

}



@end
