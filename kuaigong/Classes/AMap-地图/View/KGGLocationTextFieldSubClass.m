//
//  KGGLocationTextFieldSubClass.m
//  kuaigong
//
//  Created by Ding on 2017/9/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLocationTextFieldSubClass.h"
#import "UITextField+KGGExtension.h"

@implementation KGGLocationTextFieldSubClass

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_sousuo"]];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.layer.cornerRadius = 2.f;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.font = KGGFont(15);
        self.placeholder = @"  请输入工作地点";
        self.placeholderColor = UIColorHex(bbbbbb);
        self.textColor = UIColorHex(0x333333);
        self.xc_size = CGSizeMake(kMainScreenWidth-55.f-10.f,30.f);
    }
    return self;
}

@end
