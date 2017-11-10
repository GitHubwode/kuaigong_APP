
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
    
    _remark = _remark.length == 0 ? @"没有特殊要求":_remark;
    
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
    
//    人数
    if (_fare == 0) {
       _orderDetails = [NSString stringWithFormat:@"订单详情:%@%lu人, 工作%lu天,每天工作%@小时 每天%.f元,无车费。",_workerType,(unsigned long)_number,(unsigned long)_days,_whenLong,_unitPrice];
    }else{
        _orderDetails = [NSString stringWithFormat:@"订单详情:%@%lu人, 工作%lu天,每天工作%@小时 每天%.f元,车费每辆%.f元。",_workerType,(unsigned long)_number,(unsigned long)_days,_whenLong,_unitPrice,_fare];
    }
    _differentPrice = _totalAmount - _fare;
    //隐藏电话点好
    _hidePhone = [NSString numberSuitScanf:_contactsPhone];
    
    //头像地址
    if (_avatarUrl.length > 0) {
        _avatarUrl = [NSString stringWithFormat:@"https:%@",_avatarUrl];
    }
    _accpetTime = [NSString TimeStamp:_accpetTime];
    _workStartTime = [NSString OrderDetailsTimeStamp:_workStartTime];
    if (_orderUrl.length != 0) {
        _imageArray =[[_orderUrl componentsSeparatedByString:@","] mutableCopy];
    }
    if (_instance.length > 0) {
        _instance = [NSString getDistanceString:_instance];
    }
}

/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSArray *)mj_ignoredPropertyNames{
    return @[@"orderDetails", @"workerType",@"differentPrice",@"hidePhone",@"imageArray"];
}

@end
