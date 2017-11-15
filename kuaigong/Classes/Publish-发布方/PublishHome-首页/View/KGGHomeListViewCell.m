//
//  KGGHomeListViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/8/22.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGHomeListViewCell.h"
#import "KGGHomePublishModel.h"

#define NUMBERS @"0123456789\n"

static NSString *const homeListViewCell = @"homeListViewCell";

@interface KGGHomeListViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *homeTypeLabel;
@property (nonatomic, assign) int number;
@property (nonatomic, strong) NSMutableDictionary *param;


@end

@implementation KGGHomeListViewCell

- (void)setPublishModel:(KGGHomePublishModel *)publishModel
{
    _publishModel = publishModel;
    if ([self.homeTextField.placeholder isEqualToString:@"请填写工价"]) {
    }
    self.homeTypeLabel.text = publishModel.title;
    self.homeTextField.placeholder = publishModel.placeholder;
}

- (IBAction)homeAddButtonClick:(UIButton *)sender {
    KGGLog(@"加人数");
    int num =  [self.homeTextField.text intValue];
    if ([self.homeTextField.placeholder isEqualToString:@"请填写工价"]) {
        self.loseButton.enabled = YES;
        num=num+5;
    }else if([self.homeTextField.placeholder isEqualToString:@"用工人数"]){
      num++;
        self.param[@"peopleNum"] = @(num);
        [KGGNotificationCenter postNotificationName:KGGInputCarNumNotifacation object:nil userInfo:self.param];
    }else{
        num++;
    }
    
    self.homeTextField.text = [NSString stringWithFormat:@"%d",num];
    [self homePublishText:self.homeTextField.text];
}
- (IBAction)homeMinusButtonClick:(UIButton *)sender {
    KGGLog(@"减人数");
    int num =  [self.homeTextField.text intValue];
    if (num == 0) return;
    if ([self.homeTextField.placeholder isEqualToString:@"请填写工价"]) {
        if ([self.price isEqualToString: self.homeTextField.text]) {
          return;
        }else{
            if ([self.homeTextField.text isEqualToString:@"1"]) return;
            num=num-5;
        }
    }else if([self.homeTextField.placeholder isEqualToString:@"用工人数"]){
        num--;
        self.param[@"peopleNum"] = @(num);
        [KGGNotificationCenter postNotificationName:KGGInputCarNumNotifacation object:nil userInfo:self.param];
    }else{
        num--;
    }
    self.homeTextField.text = [NSString stringWithFormat:@"%d",num];
    [self homePublishText:self.homeTextField.text];
}

- (void)homePublishText:(NSString *)text
{
    self.publishModel.subtitle = text;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.homeTextField.delegate = self;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!self.publishModel.editabled) return;
    self.publishModel.subtitle = textField.text;
    [KGGNotificationCenter addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:textField];

}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!self.publishModel.editabled) return;
    self.publishModel.subtitle = textField.text;
    [self homePublishText:textField.text];
}

- (void)textViewEditChanged:(NSNotification *)noti
{
    UITextField *textField = (UITextField *)noti.object;
    BOOL isRequired = self.publishModel.required;
    if (isRequired) {
        if (textField.text.length == 0) {
            [self showHint:[NSString stringWithFormat:@"不能为空%@",self.publishModel.title]];
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.homeTextField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    
    if(textField == self.homeTextField)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            [MBProgressHUD showMessag:@"请输入数字"];
            return NO;
        }
    }
    return YES;
}

- (NSMutableDictionary *)param
{
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}


+ (NSString *)homeListIdentifier
{
    return homeListViewCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
