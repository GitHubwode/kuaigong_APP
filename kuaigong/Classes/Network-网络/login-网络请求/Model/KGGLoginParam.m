//
//  KGGLoginParam.m
//  kuaigong
//
//  Created by Ding on 2017/10/9.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGLoginParam.h"

/**************************** 微信登录 ******************************/

@implementation KGGWXLoginParam
- (instancetype)initWithSex:(UserGender)sex openid:(NSString *)openid avatar:(NSString *)avatar nickname:(NSString *)nickname accessToken:(NSString *)accessToken{
    self = [super init];
    if (self) {
        self.sex = sex;
        self.openid = openid;
        self.avatar = avatar;
        self.nickname = nickname;
        self.accessToken = accessToken;
    }
    return self;
}

+ (instancetype)paramWithSex:(UserGender)sex openid:(NSString *)openid avatar:(NSString *)avatar nickname:(NSString *)nickname accessToken:(NSString *)accessToken{
    return [[self alloc]initWithSex:sex openid:openid avatar:avatar nickname:nickname accessToken:accessToken];
}

@end

/**************************** 登录 ******************************/

@implementation KGGLoginParam

- (instancetype)initWithPhone:(NSString *)phone password:(NSString *)password SmsCode:(NSString *)smsCode Mode:(NSString *)model
{
    self = [super init];
    if (self) {
        self.phone = phone;
        self.password = password;
        self.smsCode = smsCode;
        self.mode = model;
    }
    return self;
}

+ (instancetype)paramWithPhone:(NSString *)phone password:(NSString *)password SmsCode:(NSString *)smsCode Mode:(NSString *)model
{
    return [[self alloc]initWithPhone:phone password:password SmsCode:smsCode Mode:model];
}

@end

/**************************** 注册 ******************************/

@implementation KGGRegisterParam

- (instancetype)initWithPhone:(NSString *)phone password:(NSString *)password Type:(NSString *)type Code:(NSString *)code InvitationCode:(NSString *)invitationCode PersonCode:(NSString *)personCode
{
    self = [super init];
    if (self) {
        self.phone = phone;
        self.password = password;
        self.type = type;
        self.code = code;
        self.invitationCode = invitationCode;
        self.personCode = personCode;
    }
    return self;
}

+ (instancetype)paramWithPhone:(NSString *)phone password:(NSString *)password Type:(NSString *)type Code:(NSString *)code InvitationCode:(NSString *)invitationCode PersonCode:(NSString *)personCode
{
    return [[self alloc]initWithPhone:phone password:password Type:type Code:code InvitationCode:invitationCode PersonCode:personCode];
}


@end

/******************** 验证码 **********************/

@implementation KGGSMSCodeParam

- (instancetype)initWithPhone:(NSString *)phone Type:(NSString *)type Timestamp:(long)timestamp Signature:(NSString *)signature
{
    self = [super init];
    if (self) {
        self.phone = phone;
        self.type = type;
        self.timestamp = timestamp;
        self.signature = signature;
    }
    return self;
}

+ (instancetype)paramWithPhone:(NSString *)phone Type:(NSString *)type Timestamp:(long)timestamp Signature:(NSString *)signature
{
    return [[self alloc]initWithPhone:phone Type:type Timestamp:timestamp Signature:signature];
}

@end


