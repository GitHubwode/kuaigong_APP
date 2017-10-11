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

- (instancetype)initWithOrder:(NSUInteger )order
                       UserId:(NSUInteger )userid
                         Name:(NSString *)name
                         Type:(NSUInteger )type
                       Number:(NSUInteger )number
                         Days:(NSUInteger )days
                    UnitPrice:(double )unitPrice
                         Fare:(double )fare
                    Longitude:(NSString *)longitude
                     Latitude:(NSString *)latitude
                       Status:(NSUInteger )status
                      Address:(NSString *)address
                     WhenLong:(NSString *)whenLong
                          Fee:(double)fee
                     Contacts:(NSString *)contacts
                ContactsPhone:(NSString *)contactsPhone
{
    self = [super init];
    if (self) {
        self.orderId = order;
        self.userId = userid;
        self.name = name;
        self.type = type;
        self.number = number;
        self.days = days;
        self.unitPrice = unitPrice;
        self.fare = fare;
        self.longitude = longitude;
        self.latitude = latitude;
        self.status = status;
        self.address = address;
        self.whenLong = whenLong;
        self.fee = fee;
        self.contacts = contacts;
        self.contactsPhone = contactsPhone;
    }
    return self;
}

+ (instancetype)paramWithOrder:(NSUInteger )order
                        UserId:(NSUInteger )userid
                          Name:(NSString *)name
                          Type:(NSUInteger )type
                        Number:(NSUInteger )number
                          Days:(NSUInteger )days
                     UnitPrice:(double )unitPrice
                          Fare:(double )fare
                     Longitude:(NSString *)longitude
                      Latitude:(NSString *)latitude
                        Status:(NSUInteger )status
                       Address:(NSString *)address
                      WhenLong:(NSString *)whenLong
                           Fee:(double)fee
                      Contacts:(NSString *)contacts
                 ContactsPhone:(NSString *)contactsPhone
{
    return [[self alloc]initWithOrder:order UserId:userid Name:name Type:type Number:number Days:days UnitPrice:unitPrice Fare:fare Longitude:longitude Latitude:latitude Status:status Address:address WhenLong:whenLong Fee:fee Contacts:contacts ContactsPhone:contactsPhone];
}

@end
