//
//  NSString+KGGExtension.m
//  kuaigong
//
//  Created by Ding on 2017/8/16.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "NSString+KGGExtension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (KGGExtension)
/**
 根据最大宽度和字号，获取文字的尺寸
 
 @param font 字号
 @param maxW 最大宽度
 @return 尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}

/**
 获根据字号，获取文字的尺寸
 
 @param font 字号
 @return 尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

- (NSString *)md5String{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

- (NSString *)base64_encode {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}

- (NSString *)base64_decode {
    return [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:self options:0] encoding:NSUTF8StringEncoding];
}

- (BOOL)isPhoneNumer{
    // 1.创建匹配手机号的正则
    NSString *regex = @"^(0|86|17951)?(13[0-9]|15[012356789]|1[78][0-9]|14[57])[0-9]{8}$";
    return [self predicateWithFormat:regex];
}

- (BOOL)predicateWithFormat:(NSString *)regex{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}


- (NSString *)stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

+ (NSString *)stringWithUTF32Char:(UTF32Char)char32 {
    char32 = NSSwapHostIntToLittle(char32);
    return [[NSString alloc] initWithBytes:&char32 length:4 encoding:NSUTF32LittleEndianStringEncoding];
}

+ (NSString *)stringPerpenNumber:(NSString *)number
{
    float num = [number floatValue];
    if (num<10000.0) {
        number = [NSString stringWithFormat:@" %.f",num];
    }
    if (num>10000.0) {
        number = [NSString stringWithFormat:@" %.2f",num/10000.0];
    }
    
    return number;
}

//路径 存或者取出 Token 都要调用此方法
+ (NSString *)snh_documentDirectoryPath
{
    //使用融云 token 保存在本地沙盒中
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *str = [paths lastObject];
    NSString *creatrRongTokenPath = [str stringByAppendingPathComponent:@"dic.plst"];
    return creatrRongTokenPath;
}

//时间戳转换为所需要的样式
+(NSString *)TimeStamp:(NSString *)strTime
{
    NSTimeInterval time = [strTime doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}



- (NSString*)encodeString{
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"[]+",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}


//URLDEcode
-(NSString *)decodeString

{    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)self,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

/** 隐藏电话号码中间的位数 */
+ (NSString *)numberSuitScanf:(NSString *)number
{
    NSString *numberString = [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return numberString;
}


@end
