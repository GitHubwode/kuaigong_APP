//
//  KGGMyWalletOrderDetailsModel.m
//  kuaigong
//
//  Created by Ding on 2017/11/27.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGMyWalletOrderDetailsModel.h"

@implementation KGGMyWalletOrderDetailsModel

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject{
    switch (_type) {
        case 1:
            _workerType = @"木工";
            break;
        case 2:
            _workerType = @"钢筋工";
            break;
        case 3:
            _workerType = @"内架子工";
            break;
        case 4:
            _workerType = @"外架子工";
            break;
        case 5:
            _workerType = @"泥工";
            break;
        case 6:
            _workerType = @"水电工";
            break;
        case 7:
            _workerType = @"电焊工";
            break;
        case 8:
            _workerType = @"小工";
            break;
        default:
            break;
    }
    
    
    //头像地址
    if (_avatarUrl.length > 0) {
        _avatarUrl = [NSString stringWithFormat:@"https:%@",_avatarUrl];
    }
    
    _workStartTime = [NSString OrderDetailsTimeStamp:_workStartTime];
    
    //    人数
    if (_fare == 0) {
        _orderDetails = [NSString stringWithFormat:@"订单详情:%@%lu人, 工作%lu天,每天工作%@小时 每天%.f元,无车费。",_workerType,(unsigned long)_number,(unsigned long)_days,_whenLong,_unitPrice];
        _searchOrderDetails =[NSString stringWithFormat:@"订单详情:%@%lu人, 工作%lu天,每天工作%@小时 无车费。",_workerType,(unsigned long)_number,(unsigned long)_days,_whenLong];
    }else{
        _orderDetails = [NSString stringWithFormat:@"订单详情:%@%lu人, 工作%lu天,每天工作%@小时 每天%.f元,车费%.f元。",_workerType,(unsigned long)_number,(unsigned long)_days,_whenLong,_unitPrice,_fare];
        
        _searchOrderDetails = [NSString stringWithFormat:@"订单详情:%@%lu人, 工作%lu天,每天工作%@小时",_workerType,(unsigned long)_number,(unsigned long)_days,_whenLong];
    }

    _differentPrice = [NSString stringWithFormat:@"%.2f",(_totalAmount - _fee)];
    
}

/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSArray *)mj_ignoredPropertyNames{
    return @[@"orderDetails", @"workerType",@"searchOrderDetails",@"differentPrice",@"hidePhone",@"imageArray"];
}

@end
