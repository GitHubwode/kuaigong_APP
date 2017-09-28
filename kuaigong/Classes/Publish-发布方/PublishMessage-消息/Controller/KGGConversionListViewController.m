//
//  KGGConversionListViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/12.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGConversionListViewController.h"

@interface KGGConversionListViewController ()

@end

@implementation KGGConversionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将那些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_PRIVATE),
                                          @(ConversationType_SYSTEM)]];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = @"想显示的会话标题";
    [self.navigationController pushViewController:conversationVC animated:YES];
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
