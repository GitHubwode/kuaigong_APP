//
//  KGGShareMessageViewController.m
//  kuaigong
//
//  Created by Ding on 2017/11/10.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGShareMessageViewController.h"
#import "KGGCollectMessageController.h"
#import "KGGCollectTotalController.h"

@interface KGGShareMessageViewController ()

@end

@implementation KGGShareMessageViewController

- (void)viewDidAppear:(BOOL)animated {
    [JANALYTICSService startLogPageView:@"KGGShareMessageViewController"];
}
- (void)viewDidDisappear:(BOOL)animated {
    [JANALYTICSService stopLogPageView:@"KGGShareMessageViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:204 green:204 blue:204 alpha:10];
}

#pragma mark - 按钮

- (IBAction)kuaigongBossButtonClick:(id)sender {
    
    KGGCollectMessageController *collVC = [[KGGCollectMessageController alloc]init];
    collVC.itemName = @"共享老板";
//    [self.navigationController pushViewController:collVC animated:YES];
    [self presentViewController:collVC animated:YES completion:nil];
}
- (IBAction)kuiagongTeamButtonClick:(id)sender {
    KGGLog(@"共享班组")
    KGGCollectMessageController *collVC = [[KGGCollectMessageController alloc]init];
    collVC.itemName = @"共享班组";
    [self presentViewController:collVC animated:YES completion:nil];
}

- (IBAction)kuiagongInsButtonClick:(id)sender {
    KGGLog(@"快工保险");
}
- (IBAction)kuiagongHelpButtonClick:(id)sender {
    KGGCollectTotalController *totalVC = [[KGGCollectTotalController alloc]initWithNibName:NSStringFromClass([KGGCollectTotalController class]) bundle:nil];
    totalVC.imageName = @"快工救援";
    [self presentViewController:totalVC animated:YES completion:nil];
}
- (IBAction)kuaigongPublishButtonClick:(id)sender {
    KGGLog(@"快工公益")
    KGGCollectTotalController *totalVC = [[KGGCollectTotalController alloc]initWithNibName:NSStringFromClass([KGGCollectTotalController class]) bundle:nil];
    totalVC.imageName = @"快工公益";
    [self presentViewController:totalVC animated:YES completion:nil];
}
- (IBAction)kuaigongLoanButtonClick:(id)sender {
    KGGLog(@"快工贷款");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    KGGLogFunc
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
