//
//  KGGPublishPayViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/7.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishPayViewController.h"
#import "KGGActionSheetController.h"

@interface KGGPublishPayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;

@end

@implementation KGGPublishPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)publishSurePayButtonClick:(UIButton *)sender {
    
    KGGActionSheetController *sheetVC = [[KGGActionSheetController alloc]init];
//    sheetVC.moneyString = [NSString stringWithFormat:@"%.2f",_headerView.model.fee];
    sheetVC.receiverId = @"";
    sheetVC.tradeType = 1;
    sheetVC.payFrom = 22;
    sheetVC.isPublish = NO;
    sheetVC.itemId = 11;
//    __weak typeof(self) weakSelf = self;
    sheetVC.callPaySuccessBlock = ^(NSString *code){
        if ([code isEqualToString:@"200"]) {
            KGGLog(@"付费成功");
        }
    };
    sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:sheetVC animated:YES completion:nil];
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
