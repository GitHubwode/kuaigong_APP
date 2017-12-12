//
//  KGGWithdrawViewController.h
//  kuaigong
//
//  Created by Ding on 2017/9/8.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGMyWalletCardModel;

typedef void(^RemoveBankCard)();

@interface KGGWithdrawViewController : UIViewController

@property (nonatomic, copy) RemoveBankCard removeBlock;

@property (nonatomic, strong) KGGMyWalletCardModel *cardModel;

@end
