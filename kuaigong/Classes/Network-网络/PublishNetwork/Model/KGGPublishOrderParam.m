//
//  KGGPublishOrderParam.m
//  kuaigong
//
//  Created by Ding on 2017/10/11.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPublishOrderParam.h"

@implementation KGGPublishOrderParam

@end

@implementation KGGPublishCreatParam

- (instancetype)initWithUserId:(NSUInteger )userid
                          Name:(NSString *)name
                          Type:(NSString *)type
                        Number:(NSUInteger )number
                          Days:(NSUInteger )days
                     UnitPrice:(double )unitPrice
                          Fare:(double )fare
                        Remark:(NSString *)remark
                      OrderUrl:(NSString *)orderUrl
                 WorkStartTime:(NSString *)workStartTime
                       PayTime:(NSString *)payTime
                     Longitude:(CGFloat )longitude
                      Latitude:(CGFloat )latitude
                       Address:(NSString *)address
                     AvatarUrl:(NSString *)avatarUrl
                      WhenLong:(NSString *)whenLong
                      Contacts:(NSString *)contacts
                 ContactsPhone:(NSString *)contactsPhone
{
    self = [super init];
    if (self) {
        self.userId = userid;
        self.name = name;
        self.type = type;
        self.number = number;
        self.days = days;
        self.unitPrice = unitPrice;
        self.fare = fare;
        self.remark = remark;
        self.orderUrl = orderUrl;
        self.workStartTime = workStartTime;
        self.payTime = payTime;
        self.longitude = longitude;
        self.latitude = latitude;
        self.address = address;
        self.avatarUrl = avatarUrl;
        self.whenLong = whenLong;
        self.contacts = contacts;
        self.contactsPhone = contactsPhone;
    }
    return self;
}

+ (instancetype)paramWithUserId:(NSUInteger )userid
                           Name:(NSString *)name
                           Type:(NSString *)type
                         Number:(NSUInteger )number
                           Days:(NSUInteger )days
                      UnitPrice:(double )unitPrice
                           Fare:(double )fare
                         Remark:(NSString *)remark
                       OrderUrl:(NSString *)orderUrl
                  WorkStartTime:(NSString *)workStartTime
                        PayTime:(NSString *)payTime
                      Longitude:(CGFloat )longitude
                       Latitude:(CGFloat )latitude
                        Address:(NSString *)address
                      AvatarUrl:(NSString *)avatarUrl
                       WhenLong:(NSString *)whenLong
                       Contacts:(NSString *)contacts
                  ContactsPhone:(NSString *)contactsPhone
{
    return [[self alloc]initWithUserId:userid Name:name Type:type Number:number Days:days UnitPrice:unitPrice Fare:fare Remark:remark OrderUrl:orderUrl WorkStartTime:workStartTime PayTime:payTime Longitude:longitude Latitude:latitude Address:address AvatarUrl:avatarUrl WhenLong:whenLong Contacts:contacts ContactsPhone:contactsPhone];
}

@end
