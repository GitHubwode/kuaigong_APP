//
//  KGGRegardKGViewController.m
//  kuaigong
//
//  Created by Ding on 2017/10/31.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGRegardKGViewController.h"

@interface KGGRegardKGViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *storeView;

@end

@implementation KGGRegardKGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *curVersion =  [NSBundle currentVersion];
    self.versionLabel.text = [NSString stringWithFormat:@"快工 %@",curVersion];
    
    [UILabel changeLineSpaceForLabel:self.messageLabel WithSpace:5.0];
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
