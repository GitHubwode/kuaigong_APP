//
//  KGGMyWalletCardModel.h
//  kuaigong
//
//  Created by Ding on 2017/12/11.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGMyWalletCardMessageModel : NSObject

/** 用户姓名 */
@property (nonatomic,copy) NSString *realName;
/** 身份证号 */
@property (nonatomic,copy) NSString *idCard;
/** 预留手机号 */
@property (nonatomic,copy) NSString *bankPhone;
/** 银行卡号 */
@property (nonatomic,copy) NSString *bankCardNo;
/** 提现密码 */
@property (nonatomic,copy) NSString *password;
/** 总金额 */
@property (nonatomic,copy) NSString *balance;
/** 可提现金额 */
@property (nonatomic,copy) NSString *drawBalance;
/** 提现状态 0可提现 1 为提现中 2为提现成功 */
@property (nonatomic,assign) NSUInteger  status;
/** 是否对公 */
@property (nonatomic,copy) NSString *isPublic;
/** 开户行名称 */
@property (nonatomic,copy) NSString *branchBankName;


//增加参数
/** 银行行名称 */
@property (nonatomic, copy) NSString *bankName;
/** 银行卡显示 */
@property (nonatomic,copy) NSString *hideBankNum;

@end

@interface KGGMyWalletCardModel : NSObject

@property (nonatomic, strong) KGGMyWalletCardMessageModel *bankAccountDO;
@property (nonatomic, copy) NSString *isHas;

@property (nonatomic, assign) BOOL isBink;

@end

