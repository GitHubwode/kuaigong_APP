//
//  KGGOrderCorrectViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/10/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGOrderCorrectViewCell.h"
//#import "KGGHomePublishModel.h"
#import "KGGOrderCorrectModel.h"

#define ORDERNUMBERS @"0123456789\n"

static NSString *const orderCorrectCell = @"OrderCorrectViewCell";

@interface KGGOrderCorrectViewCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (nonatomic, assign) int number;

@end

@implementation KGGOrderCorrectViewCell
- (void)setCorrentModel:(KGGOrderCorrectModel *)correntModel
{
    _correntModel = correntModel;
    self.orderTypeLabel.text = correntModel.title;
    self.correctTextField.text = correntModel.subTitle;
    
}
//- (void)setPublishModel:(KGGHomePublishModel *)publishModel
//{
//    _publishModel = publishModel;
//    self.orderTypeLabel.text = publishModel.title;
//    self.correctTextField.placeholder = publishModel.placeholder;
//}
- (IBAction)orderAddButtonClick:(UIButton *)sender {
    KGGLog(@"加人数");
    int num =  [self.correctTextField.text intValue];
    num++;
    self.correctTextField.text = [NSString stringWithFormat:@"%d",num];
    [self correctOrderText:self.correctTextField.text];
}
- (IBAction)orderMinusButtonClick:(UIButton *)sender {
    KGGLog(@"减人数");
    int num =  [self.correctTextField.text intValue];
    if (num == 0) return;
    num--;
    self.correctTextField.text = [NSString stringWithFormat:@"%d",num];
    [self correctOrderText:self.correctTextField.text];
}

- (void)correctOrderText:(NSString *)text
{
    self.correntModel.subTitle = text;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.correctTextField.delegate = self;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.correntModel.subTitle = textField.text;
    [KGGNotificationCenter addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:textField];
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.correntModel.subTitle = textField.text;
    [self correctOrderText:textField.text];
}

- (void)textViewEditChanged:(NSNotification *)noti
{
    UITextField *textField = (UITextField *)noti.object;
    BOOL isRequired  = YES;
    if (isRequired) {
        if (textField.text.length == 0) {
            [self showHint:[NSString stringWithFormat:@"不能为空%@",self.correntModel.title]];
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.correctTextField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    
    if(textField == self.correctTextField)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:ORDERNUMBERS] invertedSet];
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

+ (NSString *)ordeCorrectIdentifier
{
    return orderCorrectCell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
