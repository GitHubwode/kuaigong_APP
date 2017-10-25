//
//  NSString+KGGExtension.h
//  kuaigong
//
//  Created by Ding on 2017/8/16.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KGGExtension)

/**
 根据最大宽度和字号，获取文字的尺寸
 
 @param font 字号
 @param maxW 最大宽度
 @return 尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

/**
 获根据字号，获取文字的尺寸
 
 @param font 字号
 @return 尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font;

/** 对字符串进行md5加密 */
- (NSString *)md5String;

- (NSString*)base64_encode;
- (NSString *)base64_decode;

/** 隐藏电话号码中间的位数 */
+ (NSString *)numberSuitScanf:(NSString *)number;

/** 判断是不是手机号码 */
- (BOOL)isPhoneNumer;

- (NSString *)stringByTrim;
+ (NSString *)stringWithUTF32Char:(UTF32Char)char32;

+ (NSString *)stringPerpenNumber:(NSString *)number;
/**  保存Token 的路径 */
+ (NSString *)snh_documentDirectoryPath;

//时间戳转换为所需要的样式
+(NSString *)TimeStamp:(NSString *)strTime;
//时间戳转换为所需要的样式
+(NSString *)PublishWorkTimeStamp:(NSString *)strTime;
//计算预约时间距离现在还剩多久
+(NSString *)getNowTimeWithString:(NSString *)aTimeString;

- (NSString*)encodeString;
-(NSString *)decodeString;

//计算当前月的总后一天是几号
+ (NSString *)getMonthBeginAndEndWith:(NSString *)dateStr;

/** 获取当前时间戳 */
+ (NSString *)getWorkBeginTime:(NSString *)beginTime;
/** 支付之间的时间戳 */
+ (NSString *)payTime:(NSString *)beginTime WorkTime:(NSString *)workTime PayTime:(NSString *)payTime;

@end
