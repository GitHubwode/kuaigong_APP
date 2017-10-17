//
//  KGGCorrectOrderViewController.m
//  kuaigong
//
//  Created by Ding on 2017/10/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGCorrectOrderViewController.h"

@interface KGGCorrectOrderViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dayTextField;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *middleView;

@end

@implementation KGGCorrectOrderViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGColorA(0, 0, 0, 75);
    
    KGGLog(@"%@",self.dayTextField);
    KGGLog(@"%@",self.numTextField);
}


#pragma mark - 按钮的点击事件
- (IBAction)cancelButtonClick:(UIButton *)sender {
    KGGLog(@"取消");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sureButtonClick:(UIButton *)sender {
    KGGLog(@"确认更改");
}

- (IBAction)deleteButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 天数的加减

- (IBAction)dayAddButtonClick:(UIButton *)sender {
    KGGLog(@"天数的加");
    int num =  [self.dayTextField.text intValue];
    num++;
    self.dayTextField.text = [NSString stringWithFormat:@"%d",num];
}
- (IBAction)dayLowButtonClick:(id)sender {
    KGGLog(@"天数的加");
    int num =  [self.dayTextField.text intValue];
    if (num == 0) return;
    num--;
    self.dayTextField.text = [NSString stringWithFormat:@"%d",num];
}

#pragma mark - 人数的加减
- (IBAction)peopleNumAddButtonClick:(UIButton *)sender {
    KGGLog(@"人数的加");
    int num =  [self.numTextField.text intValue];
    num++;
    self.numTextField.text = [NSString stringWithFormat:@"%d",num];
}
- (IBAction)peopleNumLowButtonClick:(UIButton *)sender {
    KGGLog(@"人数的减");
    int num =  [self.numTextField.text intValue];
    if (num == 0) return;
    num--;
    self.numTextField.text = [NSString stringWithFormat:@"%d",num];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    KGGLog(@"开始编辑%@",textField.text);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    KGGLog(@"结束编辑%@",textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    if (self.dayTextField == textField) {
//        [self.dayTextField resignFirstResponder];
//    }else{
//        [self.numTextField resignFirstResponder];
//    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
