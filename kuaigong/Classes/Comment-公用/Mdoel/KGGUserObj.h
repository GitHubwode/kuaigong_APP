//
//  KGGUserObj.h
//  kuaigong
//
//  Created by Ding on 2017/10/9.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSUInteger,KGGUserType) {
//    KGGUserTypeWorker = 0, /** 职工 */
//    KGGUserTypeBoss /** 老板 */
//};

/** 性别 */
typedef NS_ENUM(NSUInteger, UserGender) {
    UserGenderUnknown = 0,  /** 未知 */
    UserGenderMan,          /** 男 */
    UserGenderWoman         /** 女 */
};

@interface KGGUserObj : NSObject <NSCoding>
/** 用户id */
@property (nonatomic,copy) NSString *userId;
/** 头像 */
@property (nonatomic,copy) NSString *avatarUrl;
/** 电话 */
@property (nonatomic,copy) NSString *phone;
/** 是否删除 */
@property (nonatomic,copy) NSString *isDelete;
/** 是否锁定 */
@property (nonatomic,copy) NSString *isLock;
/** 昵称 */
@property (nonatomic,copy) NSString *nickname;
/** 性别 */
@property (nonatomic,copy) NSString *sex;
/** 角色 */
@property (nonatomic,copy) NSString *type;
/** 创建时间 */
@property (nonatomic,copy) NSString *createDate;
/** 更新时间 */
@property (nonatomic,copy) NSString *updateDate;
/** 增加的属性 */
@property (nonatomic,copy) NSString *token;
@property (nonatomic, copy) NSString *sexName;
@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, assign) BOOL isDeleted;


@end


@interface KGGUserInfo : NSObject

/** token */
@property (nonatomic,copy) NSString *token;

@property (nonatomic, strong) KGGUserObj *userInfo;

@end


