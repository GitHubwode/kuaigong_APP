
//
//  KGGOrderDetailsModel.m
//  kuaigong
//
//  Created by Ding on 2017/10/11.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGOrderDetailsModel.h"

@implementation KGGOrderDetailsModel
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"orderId": @"id"};
}

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject{
    
    switch (_type) {
        case 0:
            _workerType = @"木工";
            break;
        case 1:
            _workerType = @"钢筋工";
            break;
        case 2:
            _workerType = @"内架子工";
            break;
        case 3:
            _workerType = @"外架子工";
            break;
        case 4:
            _workerType = @"泥工";
            break;
        case 5:
            _workerType = @"水电工";
            break;
        case 6:
            _workerType = @"电焊工";
            break;
        case 7:
            _workerType = @"小工";
            break;
        default:
            break;
    }
    
    int allFee ;//总计费用
    allFee = (_unitPrice *9 + _fare) * _days * _number;
    
    _orderDetails = [NSString stringWithFormat:@"订单详情:%@%lu人, 工作%lu天,每天工作9小时 每小时%.f元,车费每人%.f元,总计%.f元。",_workerType,(unsigned long)_number,(unsigned long)_days,_unitPrice,_fare,_totalAmount];
    
    _differentPrice = _totalAmount - _fare;
    //隐藏电话点好
    _hidePhone = [NSString numberSuitScanf:_contactsPhone];
}

/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSArray *)mj_ignoredPropertyNames{
    return @[@"orderDetails", @"workerType",@"differentPrice",@"hidePhone"];
}

@end
