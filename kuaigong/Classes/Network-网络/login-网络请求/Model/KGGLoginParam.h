//
//  KGGLoginParam.h
//  kuaigong
//
//  Created by Ding on 2017/10/9.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>


/**************** 微信登录 **********************/

@interface KGGWXLoginParam : NSObject
@property (nonatomic, assign) UserGender sex;
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString  *accessToken;


- (instancetype)initWithSex:(UserGender)sex
                     openid:(NSString *)openid
                     avatar:(NSString *)avatar
                   nickname:(NSString *)nickname
                accessToken:(NSString *)accessToken;
+ (instancetype)paramWithSex:(UserGender)sex
                      openid:(NSString *)openid
                      avatar:(NSString *)avatar
                    nickname:(NSString *)nickname
                 accessToken:(NSString *)accessToken;


@end

/******************** 登录 **********************/

@interface KGGLoginParam : NSObject
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *mode; //登录方式

- (instancetype)initWithPhone:(NSString *)phone
                     password:(NSString *)password
                      SmsCode:(NSString *)smsCode
                         Mode:(NSString *)model;

+ (instancetype)paramWithPhone:(NSString *)phone
                         password:(NSString *)password
                          SmsCode:(NSString *)smsCode
                             Mode:(NSString *)model;

@end


/******************** 注册 **********************/

@interface KGGRegisterParam : NSObject

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *type;//类型 boss or worker
@property (nonatomic, copy) NSString *code;//验证码
@property (nonatomic, copy) NSString * invitationCode; //公司名字
@property (nonatomic, copy) NSString *personCode;//推荐人电话

- (instancetype)initWithPhone:(NSString *)phone
                     password:(NSString *)password
                      Type:(NSString *)type
                         Code:(NSString *)code
               InvitationCode:(NSString *)invitationCode
                   PersonCode:(NSString *)personCode;

+ (instancetype)paramWithPhone:(NSString *)phone
                      password:(NSString *)password
                       Type:(NSString *)type
                          Code:(NSString *)code
                InvitationCode:(NSString *)invitationCode
                    PersonCode:(NSString *)personCode;

@end

/******************** 验证码 **********************/

@interface KGGSMSCodeParam : NSObject

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) long timestamp;
@property (nonatomic, copy) NSString *signature;//MD5签名 签名算法构成：MD5(phone + type + timestamp + secretKey)

- (instancetype)initWithPhone:(NSString *)phone
                         Type:(NSString *)type
                    Timestamp:(long )timestamp
                    Signature:(NSString *)signature;

+ (instancetype)paramWithPhone:(NSString *)phone
                          Type:(NSString *)type
                     Timestamp:(long )timestamp
                     Signature:(NSString *)signature;

@end

