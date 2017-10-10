//
//  KGGUserObj.m
//  kuaigong
//
//  Created by Ding on 2017/10/9.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGUserObj.h"

@implementation KGGUserObj
MJCodingImplementation

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"userId": @"id"};
}

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject{
    
//    if ([_sex isEqualToString:@"MAN"]) {
//        _sexName = @"男";
//    }else{
//        _sexName = @"女";
//    }
//    
//    if ([_isLock isEqualToString:@"N"]) {
//        _isLocked = NO;
//    }else{
//        _isLocked = YES;
//    }
    _sexName = [_sex isEqualToString:@"MAN"] ? @"男" :@"女";
    _isLocked = [_isLock isEqualToString:@"N"] ? NO : YES;
    _isDeleted = [_isDelete isEqualToString:@"N"] ? NO : YES;
    
}

@end


@implementation KGGUserInfo

//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.token forKey:@"token"];
//    [aCoder encodeObject:self.userInfo.userId forKey:@"userId"];
//    [aCoder encodeObject:self.userInfo.avatarUrl forKey:@"avatarUrl"];
//    [aCoder encodeObject:self.userInfo.phone forKey:@"phone"];
//    [aCoder encodeObject:self.userInfo.isDelete forKey:@"isDelete"];
//    [aCoder encodeObject:self.userInfo.isLock forKey:@"isLock"];
//    [aCoder encodeObject:self.userInfo.nickname forKey:@"nickname"];
//    [aCoder encodeObject:self.userInfo.sex forKey:@"sex"];
//    [aCoder encodeObject:self.userInfo.type forKey:@"type"];
//    [aCoder encodeObject:self.userInfo.createDate forKey:@"createDate"];
//    [aCoder encodeObject:self.userInfo.updateDate forKey:@"updateDate"];
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super init];
//    if (self) {
//        self.token = [aDecoder decodeObjectForKey:@"token"];
//        self.userInfo.userId = [aDecoder decodeObjectForKey:@"userId"];
//        self.userInfo.avatarUrl = [aDecoder decodeObjectForKey:@"avatarUrl"];
//        self.userInfo.phone = [aDecoder decodeObjectForKey:@"phone"];
//        self.userInfo.isDelete = [aDecoder decodeObjectForKey:@"isDelete"];
//        self.userInfo.isLock = [aDecoder decodeObjectForKey:@"isLock"];
//        self.userInfo.nickname = [aDecoder decodeObjectForKey:@"nickname"];
//        self.userInfo.sex = [aDecoder decodeObjectForKey:@"sex"];
//        self.userInfo.type = [aDecoder decodeObjectForKey:@"type"];
//        self.userInfo.createDate = [aDecoder decodeObjectForKey:@"createDate"];
//        self.userInfo.updateDate = [aDecoder decodeObjectForKey:@"updateDate"];
//    }
//    return self;
//}


@end
