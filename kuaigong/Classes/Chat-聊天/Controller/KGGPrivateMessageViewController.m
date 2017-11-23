//
//  KGGPrivateMessageViewController.m
//  kuaigong
//
//  Created by Ding on 2017/11/20.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPrivateMessageViewController.h"

@interface KGGPrivateMessageViewController ()

@end

@implementation KGGPrivateMessageViewController

- (void)viewDidAppear:(BOOL)animated {
    [JANALYTICSService startLogPageView:@"KGGPrivateMessageViewController"];
}
- (void)viewDidDisappear:(BOOL)animated {
    [JANALYTICSService stopLogPageView:@"KGGPrivateMessageViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
