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

//时间戳转换为所需要的样式
+(NSString *)OrderDetailsTimeStamp:(NSString *)strTime
{
    NSTimeInterval time = [strTime doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}
//时间戳转换为所需要的样式
+(NSString *)PublishWorkTimeStamp:(NSString *)strTime
{
    NSTimeInterval time = [strTime doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}
//获取当前时间戳
+ (NSString *)publishSetUpNowTime
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];//转为字符型
    return timeString;
}



/** 获取当前时间戳 */
+ (NSString *)getWorkBeginTime:(NSString *)beginTime
{
    NSDate *now = [NSDate date];
//    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger year = [dateComponent year];
    
    beginTime = [NSString stringWithFormat:@"%ld年%@00秒",(long)year,beginTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    NSDate *expireDate = [formatter dateFromString:beginTime];
    NSTimeInterval timeInter = [expireDate timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f",timeInter];//转为字符型
    return timeString;
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
    if (number.length == 0 || number == nil) {
        return @"";
    }else{
       NSString *numberString = [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return numberString;
    }
}

//计算当前月的总后一天是几号
+ (NSString *)getMonthBeginAndEndWith:(NSString *)dateStr
{
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"dd"];
//    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
//    NSString *s = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    return endString;
}

//获取剩余时间
+(NSString *)getNowTimeWithString:(NSString *)aTimeString
{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [formater dateFromString:aTimeString];
    NSDate  *nowDate = [NSDate date];
    // 当前时间字符串格式
    NSString *nowDateStr = [formater stringFromDate:nowDate];
    // 当前时间date格式
    nowDate = [formater dateFromString:nowDateStr];
    
    NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];
    
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        return @"0";
    }
    if (days) {
        return [NSString stringWithFormat:@"%@天 %@小时 %@分 %@秒", dayStr,hoursStr, minutesStr,secondsStr];
    }
    return [NSString stringWithFormat:@"%@小时 %@分 %@秒",hoursStr , minutesStr,secondsStr];
}

/** 支付之间的时间戳 */
+ (NSString *)payTime:(NSString *)beginTime WorkTime:(NSString *)workTime PayTime:(NSString *)payTime
{
    int dayTime = [workTime intValue] *24*3600;//工作时间的秒数
    int pay;
    if ([payTime isEqualToString:@"工期结束立即支付"]) {
//        24 *3600
        pay = 86400;
    }else if ([payTime isEqualToString:@"延后7天支付"]){
//        24 *3600*8
        pay = 691200;
    }else{
//        24 *3600*16
        pay = 1382400;
    }
    
    dayTime = dayTime+pay+[beginTime intValue];
    NSString *totalTime;
    totalTime = [NSString stringWithFormat:@"%d",dayTime];
    return totalTime;
}

/** 米换算为Km */
+ (NSString *)getDistanceString:(NSString *)string
{
    NSString *distanceString;
    int distance = 999;
    int string1 = [string intValue];
    if (distance > string1) {
        return distanceString = [NSString stringWithFormat:@"%@m",string];
    }else{
        string1 = round(string1/1000);
        return distanceString = [NSString stringWithFormat:@"%dkm",string1];
    }
}



@end
