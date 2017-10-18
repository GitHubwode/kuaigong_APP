//
//  KGGStartWorkTimeViewCell.m
//  kuaigong
//
//  Created by Ding on 2017/10/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGStartWorkTimeViewCell.h"
#import "KGGCustomInfoItem.h"
#import "HcdDateTimePickerView.h"


static NSString *startWorkTimeViewCell = @"KGGStartWorkTimeViewIdentifier";

@interface KGGStartWorkTimeViewCell()

@property (nonatomic, strong) HcdDateTimePickerView * dateTimePickerView;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end

@implementation KGGStartWorkTimeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lineHeight.constant = KGGOnePixelHeight;
}

- (void)setInfoItem:(KGGCustomInfoItem *)infoItem
{
    _infoItem = infoItem;
    self.titleLabel.text = infoItem.title;
    [self.timeButton setTitle:infoItem.placeholder forState:UIControlStateNormal];
    
}
- (IBAction)workStartChooseEnsureButtonClick:(UIButton *)sender {
    
    weakSelf(self);
    self.dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateHourMinuteMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
    [self.dateTimePickerView setMinYear:2017];
    [self.dateTimePickerView setMaxYear:2022];
    self.dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
        
        weakself.infoItem.subtitle = datetimeStr;
        [weakself.timeButton setTitle:datetimeStr forState:UIControlStateNormal];
        [weakself.timeButton setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
        NSLog(@"datetimeStr:%@", datetimeStr);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date =[dateFormatter dateFromString:datetimeStr];
        
        NSString *timsSp = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
        KGGLog(@"timsSp:%@",timsSp);
    };
    
    if (self.dateTimePickerView) {
        [self.window addSubview:self.dateTimePickerView];
        [self.dateTimePickerView showHcdDateTimePicker];
    }
    
}

+ (NSString *)workStartIdentifier
{
    return startWorkTimeViewCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
