//
//  KGGWallectRequestManager.m
//  kuaigong
//
//  Created by Ding on 2017/11/27.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGWallectRequestManager.h"
#import "KGGMyWalletOrderDetailsModel.h"
#import "KGGMyWalletCardModel.h"

@implementation KGGWallectRequestManager

/**
 获取收入明细
 @param page 页数
 @param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @param caller 方法调用者 POST /api/bank/totalCount
 */
+ (void)myWalletOrderDetailsUserType:(NSString *)userType Page:(NSUInteger )page completion:(void(^)(NSArray <KGGMyWalletOrderDetailsModel*>*response,NSString *totalMoeny, NSString *drawAcount))completionHandler aboveView:(UIView *)view inCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/bank/totalCount");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"page"] = @(page);
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        NSMutableArray *responseDatasource;
        NSString *totalCount;
        NSString *drawAcount;
        if (!responseObj) {
            
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }else{
            NSDictionary *walletModel = [responseObj.data objectForKey:userType];
            totalCount = [NSString stringWithFormat:@"%@",[walletModel objectForKey:@"acount"]];
            drawAcount = [NSString stringWithFormat:@"%@",[walletModel objectForKey:@"drawAcount"]];
            NSDictionary *pageBean = [walletModel objectForKey:@"pageBean"];
            NSArray *recordList = [pageBean objectForKey:@"recordList"];
            responseDatasource = [KGGMyWalletOrderDetailsModel mj_objectArrayWithKeyValuesArray:recordList];
        }
        if (completionHandler) {
            completionHandler(responseDatasource,totalCount,drawAcount);
        }
        
    } aboveView:view inCaller:caller];
}

/**
 添加银行卡
 @ param realName 真实姓名
 @ param idCard 身份证号
 @ param bankPhone 预留手机号
 @ param bankCardNo 银行卡号
 @ param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @ caller 方法调用者
 */
+ (void)myWalletAddBankCardRealName:(NSString *)realName IdCard:(NSString *)idCard BankPhone:(NSString *)bankPhone BankCardNo:(NSString *)bankCardNo completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view idCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/order/bankCount");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"realName"] = realName;
    dic[@"idCard"] = idCard;
    dic[@"bankPhone"] = bankPhone;
    dic[@"bankCardNo"] = bankCardNo;
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        
        if (!responseObj) {
            [view showHint:KGGHttpNerworkErrorTip];
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
            return ;
        }
        if (completionHandler) {
            completionHandler(responseObj);
        }
    } aboveView:view inCaller:caller];
}

/**
 提现
 @param withDrawAmount 提现金额
 @ param completionHandler 请求完成的回调 responseObj 为KGGResponseObj
 @ caller 方法调用者
 */
+ (void)myWalletWithdrawDepositWithDrawAmount:(double)withDrawAmount completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view idCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/order/withDraw");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"withDrawAmount"] = @(withDrawAmount);
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        
        if (!responseObj) {
            [view showHint:KGGHttpNerworkErrorTip];
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
            return ;
        }
        if (completionHandler) {
            completionHandler(responseObj);
        }
        
    } aboveView:view inCaller:caller];
    
}

/**
 查询是否绑定银行卡
 
 */
+ (void)myWalletLookUpBandingCardCompletion:(void(^)(KGGMyWalletCardModel * cardModel))completionHandler aboveView:(UIView *)view idCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/bank/hasBankCard");
    [self requestWithURL:url httpMethod:GETHttpMethod params:nil progress:nil completion:^(KGGResponseObj *responseObj) {
        
        if (!responseObj) {
            [view showHint:KGGHttpNerworkErrorTip];
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
            return ;
        }
        KGGLog(@"responseObj:%@",responseObj);
        KGGMyWalletCardModel *model = [KGGMyWalletCardModel mj_objectWithKeyValues:responseObj.data];
        if (completionHandler) {
            completionHandler(model);
        }
        
    } aboveView:view inCaller:caller];
}

@end
