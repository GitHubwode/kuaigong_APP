//
//  KGGUserManager.m
//  kuaigong
//
//  Created by Ding on 2017/10/9.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGUserManager.h"

/** 账号的存储路径 */
#define KGGAccountSavePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@interface KGGUserManager ()
@property (nonatomic, strong) NSString *deviceId;
@end

@implementation KGGUserManager

+ (instancetype)shareUserManager
{
    static id shareUserManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareUserManager = [[self alloc]init];
    });
    return shareUserManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - 登录,登出相关
/**
 登录，让登录操作和user产生依赖关系，持久化用户对象
 
 @param user 当前登录的用户
 */
- (void)loginWithCurrentUser:(KGGUserObj *)user
{
    if (!user)  return;
    [self saveAccount:user];
    _currentUser = user;
    _logined = user.token.length;
}

/**
 * 自动登录
 * 主动登录，需要设置单例的currentUser和token两个地方
 * 1.加载本地用户对象到单例中，用户没有登录时为nil
 * 2.加载本地Token到单例中,用户没有登录时为""
 */
- (void)autoLogin
{
    _currentUser = [self user];
    
    _logined = _currentUser ? _currentUser.token.length : NO;
}

/**
 退出登录
 1.删除本地存储的用户
 2.删除本地存储的token
 */
- (void)logout
{
    [self removeAccount];
    _currentUser = nil;
    _logined = NO;
    
}

/**
 提供一个专门获取token的方法, 防止currentUser为空时崩溃
 
 @return 当前用户的token
 */
- (NSString *)token
{
    KGGUserObj *user = _currentUser;
    return user ? user.token : nil;
}

- (void)updateCurrentUserName:(NSString *)name
{
    if (!_currentUser) return;
    _currentUser.nickname = name;
    [self saveAccount:_currentUser];
}

- (void)updateCurrentUserAvatar:(NSString *)avatar
{
    if (!_currentUser) return;
    _currentUser.avatarUrl = avatar;
    [self saveAccount:_currentUser];
}
- (void)updateCurrentUserSex:(NSString *)sex
{
    if (!_currentUser) return;
    _currentUser.sex = sex;
    _currentUser.sexName = [sex isEqualToString:@"MAN"] ? @"男" :@"女";
    [self saveAccount:_currentUser];
}

- (void)updateCurrentUserMobile:(NSString *)mobile
{
    if (!_currentUser) return;
    _currentUser.phone = mobile;
    _currentUser.hidePhone = [NSString numberSuitScanf:mobile];
    [self saveAccount:_currentUser];
}

- (void)updateCurrentUserNewToken:(NSString *)token
{
    if (!_currentUser) return;
    _currentUser.token = token;
    [self saveAccount:_currentUser];
}

- (void)updateCurrentUserNewType:(NSString *)userType
{
    if (!_currentUser) return;
    _currentUser.type = userType;
    [self saveAccount:_currentUser];
}

- (void)updateCurrentUserBossVIP:(BOOL)isVIP
{
    if (!_currentUser) return;
    _currentUser.hasVIP = isVIP;
    [self saveAccount:_currentUser];
}

/**
 同步用户信息到本地
 */
- (void)synchronize
{
    if (!_currentUser)  return;
    [self saveAccount:_currentUser];
}

#pragma mark -存储,删除 取出用户
- (void)saveAccount:(KGGUserObj *)user
{
    BOOL flag = [NSKeyedArchiver archiveRootObject:user toFile:KGGAccountSavePath];
    KGGLog(@"flag = %zd",flag);
    if (flag) {
        KGGLog(@"成功");
    }else{
        KGGLog(@"失败");
    }
}

- (BOOL)removeAccount{
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager removeItemAtPath:KGGAccountSavePath error:nil];
}

- (KGGUserObj *)user
{
    KGGUserObj *user =[NSKeyedUnarchiver unarchiveObjectWithFile:KGGAccountSavePath];
    KGGLog(@"=========%@",user.token);
    KGGLog(@"!!!!!!!!!!%@",user.nickname);
    return [NSKeyedUnarchiver unarchiveObjectWithFile:KGGAccountSavePath];
}

@end
