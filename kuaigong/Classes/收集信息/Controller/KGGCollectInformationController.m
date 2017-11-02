//
//  KGGCollectInformationController.m
//  kuaigong
//
//  Created by Ding on 2017/11/2.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGCollectInformationController.h"

@interface KGGCollectInformationController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *IDTextField;
@property (weak, nonatomic) IBOutlet UITextField *businessTextField;
@property (weak, nonatomic) IBOutlet UITextField *nativeTextField;
@property (weak, nonatomic) IBOutlet UITextView *nowAddressTextView;

@end

@implementation KGGCollectInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.itemName;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
