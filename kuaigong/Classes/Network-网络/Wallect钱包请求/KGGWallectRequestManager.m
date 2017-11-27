//
//  KGGWallectRequestManager.m
//  kuaigong
//
//  Created by Ding on 2017/11/27.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGWallectRequestManager.h"
#import "KGGMyWalletOrderDetailsModel.h"

@implementation KGGWallectRequestManager

/**
 获取收入明细
 @param page 页数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者
 */
+ (void)myWalletOrderDetailsUserType:(NSString *)userType Page:(NSUInteger )page completion:(void(^)(NSArray <KGGMyWalletOrderDetailsModel*>*response,NSString *totalMoeny))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/order/totalCount");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"page"] = @(page);
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        NSMutableArray *responseDatasource;
        NSString *totalCount;
        if (!responseObj) {
            
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }else{
            NSDictionary *walletModel = [responseObj.data objectForKey:userType];
            totalCount = [NSString stringWithFormat:@"%@",[walletModel objectForKey:@"acount"]];
            NSDictionary *pageBean = [walletModel objectForKey:@"pageBean"];
            NSArray *recordList = [pageBean objectForKey:@"recordList"];
            responseDatasource = [KGGMyWalletOrderDetailsModel mj_objectArrayWithKeyValuesArray:recordList];
        }
        if (completionHandler) {
            completionHandler(responseDatasource,totalCount);
        }
        
    } aboveView:view inCaller:caller];
}

@end
