//
//  KGGCollectTotalController.m
//  kuaigong
//
//  Created by Ding on 2017/11/2.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGCollectTotalController.h"

@interface KGGCollectTotalController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;

@end

@implementation KGGCollectTotalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle.text = self.imageName;
    if ([self.imageName isEqualToString:@"快工救援"]) {
        self.imageView.image = [UIImage imageNamed:@"publishHeader1"];
    }else{
        self.imageView.image = [UIImage imageNamed:@"publishHeader2"];
    }
}
- (IBAction)cancelButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
