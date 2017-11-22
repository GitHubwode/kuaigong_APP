//
//  KGGConversionListViewController.m
//  kuaigong
//
//  Created by Ding on 2017/9/12.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGConversionListViewController.h"
#import "KGGPrivateMessageViewController.h"

@interface KGGConversionListViewController ()

@end

@implementation KGGConversionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"信息中心";
    self.isShowNetworkIndicatorView = YES;
    self.conversationListTableView.backgroundColor = KGGViewBackgroundColor;
    self.conversationListTableView.tableFooterView = [UIView new];
    self.emptyConversationView = [UIView new];
    
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    //设置需要将那些类型的会话在会话列表中聚合显示
//    [self setCollectionConversationType:@[@(ConversationType_PRIVATE)]];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    KGGPrivateMessageViewController *conversationVC = [[KGGPrivateMessageViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
    
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       [self refreshConversationTableViewIfNeeded];
                   });
}

//左滑删除
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath {
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE
                                             targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}

//高度
- (CGFloat)rcConversationListTableView:(UITableView *)tableView
               heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67.0f;
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
