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
+ (void)myWalletAddBankCardWithParam:(NSMutableDictionary *)param completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view idCaller:(id)caller;
{
    NSString *url = KGGURL(@"/api/bank/bankCount");
    [self postFormDataWithUrl:url form:param completion:^(KGGResponseObj *responseObj) {

        KGGLog(@"%@",responseObj);
        if (!responseObj) {
            [view showHint:KGGHttpNerworkErrorTip];
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
            return ;
        }
        [KGGNotificationCenter postNotificationName:KGGAddBankCardSuccessNotifacation object:nil];
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
+ (void)myWalletWithdrawDepositWithDrawAmount:(double)withDrawAmount PassWord:(NSString *)password completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view idCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/bank/withDraw");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"withDrawAmount"] = @(withDrawAmount);
    dic[@"password"] = password;
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        
        if (!responseObj) {
            [view showHint:KGGHttpNerworkErrorTip];
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }
        if (completionHandler) {
            completionHandler(responseObj);
        }
        
    } aboveView:view inCaller:caller];
    
}

/**
 查询是否绑定银行卡
 
 */
+ (void)myWalletLookUpBandingCardCompletion:(void(^)(KGGMyWalletCardModel * cardModel,NSString *isHas))completionHandler aboveView:(UIView *)view idCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/bank/hasBankCard");
    [self requestWithURL:url httpMethod:GETHttpMethod params:nil progress:nil completion:^(KGGResponseObj *responseObj) {
        
        if (!responseObj) {
            [view showHint:KGGHttpNerworkErrorTip];
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
            return ;
        }
        NSString *isCard;
        KGGMyWalletCardModel *model;
        if ([responseObj.data isKindOfClass:[NSDictionary class]]) {
            isCard = [responseObj.data objectForKey:@"isHas"];
            KGGLog(@"responseObj:%@",responseObj);
            model = [KGGMyWalletCardModel mj_objectWithKeyValues:responseObj.data];
        }
        if (completionHandler) {
            completionHandler(model,isCard);
        }
        
    } aboveView:view inCaller:caller];
}

/**
 查询银行卡所属银行
 */
+ (void)myWalletInquireBankCarNameCarNum:(NSString *)carNum completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view idCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/bank/getBankNameByNo");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"bankCardNo"] = carNum;
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        
        if (!responseObj) {
            [view showHint:KGGHttpNerworkErrorTip];
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }
        if (completionHandler) {
            completionHandler(responseObj);
        }
    } aboveView:view inCaller:caller];
}

/**
 删除银行卡
 */
+ (void)myWalletDeleteBankCardCompletion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view idCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/bank/delBankCard");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"aaa"] = @"aaa";
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        
        if (!responseObj) {
            [view showHint:KGGHttpNerworkErrorTip];
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }
        if (completionHandler) {
            completionHandler(responseObj);
        }
        
    } aboveView:view inCaller:self];
}

/**
 修改提现密码
 @ param code 短信验证码
 @ param phone 电话号码
 @ param password 新的提现密码
 */
+ (void)myWalletWithUpdataPwdCode:(NSString *)code Phone:(NSString *)phone PassWord:(NSString *)password completion:(void(^)(KGGResponseObj *responseObj))completionHandler aboveView:(UIView *)view idCaller:(id)caller
{
    NSString *url = KGGURL(@"/api/bank/updatePwd");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"code"] = code;
    dic[@"phone"] = phone;
    dic[@"password"] = password;
    [self postFormDataWithUrl:url form:dic completion:^(KGGResponseObj *responseObj) {
        if (!responseObj) {
            [view showHint:KGGHttpNerworkErrorTip];
        }else if (responseObj.code != KGGSuccessCode){
            [view showHint:responseObj.message];
        }
        if (completionHandler) {
            completionHandler(responseObj);
        }
    } aboveView:view inCaller:caller];
    
}

@end
