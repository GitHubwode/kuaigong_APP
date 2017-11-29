//
//  KGGJPushManager.h
//  kuaigong
//
//  Created by Ding on 2017/11/22.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KGGJPushManager : NSObject

+ (KGGJPushManager *)shareJPushManager;
// 在应用启动的时候调用
- (void)cdm_setupWithOption:(NSDictionary *)launchingOption
                     appKey:(NSString *)appKey
                    channel:(NSString *)channel
           apsForProduction:(BOOL)isProduction
      advertisingIdentifier:(NSString *)advertisingId;
// 在appdelegate注册设备处调用
- (void)cdm_registerDeviceToken:(NSData *)deviceToken;

//设置角标
- (void)cdm_setBadge:(int)badge;

//获取注册ID
- (void)cdm_getRegisterIDCallBack:(void(^)(NSString *registerID))completionHandler;

//处理推送信息
- (void)cdm_handleRemoteNotification:(NSDictionary *)remoteInfo;

//注册别名
- (void)cmd_registerAliasPhone:(NSString *)phone;
//注册标签
- (void)cmd_registerTags:(NSSet *)tags;

//删除别名
- (void)cmd_deleteAliasPhone:(NSString *)phone;
//删除标签
- (void)cmd_deleteTags:(NSSet *)tags;
//停止推送
- (void)cmd_stopJPush;
//开启推送
- (void)cmd_beginJPush;

@end
