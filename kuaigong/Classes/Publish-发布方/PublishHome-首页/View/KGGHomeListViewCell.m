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

@end

@implementation KGGHomeListViewCell

- (void)setPublishModel:(KGGHomePublishModel *)publishModel
{
    _publishModel = publishModel;
    self.homeTypeLabel.text = publishModel.title;
    self.homeTextField.placeholder = publishModel.placeholder;
}

- (IBAction)homeAddButtonClick:(UIButton *)sender {
    KGGLog(@"加人数");
    int num =  [self.homeTextField.text intValue];
    num++;
    self.homeTextField.text = [NSString stringWithFormat:@"%d",num];
}
- (IBAction)homeMinusButtonClick:(UIButton *)sender {
    KGGLog(@"减人数");
    int num =  [self.homeTextField.text intValue];
    if (num == 0) return;
    num--;
    self.homeTextField.text = [NSString stringWithFormat:@"%d",num];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.homeTextField.delegate = self;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.publishModel.subtitle = textField.text;
    [KGGNotificationCenter addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:textField];

}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.publishModel.subtitle = textField.text;

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



+ (NSString *)homeListIdentifier
{
    return homeListViewCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
