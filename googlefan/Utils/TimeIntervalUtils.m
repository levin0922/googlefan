//
//  TimeIntervalUtils.m
//  Three Hundred
//
//  Created by 郭雪 on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TimeIntervalUtils.h"

static TimeIntervalUtils *singleton = nil;
@implementation TimeIntervalUtils
@synthesize dateFormatter = _dateFormatter;

+ (NSString *)getLocalTimeZone
{
    NSInteger sec = [[NSTimeZone systemTimeZone] secondsFromGMT];
    return [[NSNumber numberWithInteger:sec / 3600] stringValue];
}

+ (TimeIntervalUtils *)sharedInstance
{
    if (singleton == nil) {
        singleton = [[TimeIntervalUtils alloc] init];
    }
    return singleton;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
        [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    return self;
}

- (void)clearDataFormatter
{
    _dateFormatter = nil;
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setLocale:[NSLocale currentLocale]];
    [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
}

+ (NSString*)shortTextFromTimeIntervalSince1970:(int)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSTimeInterval theSeconds = [date timeIntervalSinceNow];
    int seconds = 0 - theSeconds;
    
    if (seconds < 60) {//just now
        return NSLocalizedString(@"0m", @"");
    }
    else if (seconds >= 60 && seconds < 60 * 60) {//min
        return [NSString stringWithFormat:NSLocalizedString(@"%dm", @""), seconds / 60];
    }
    else if (seconds >= 60 * 60 && seconds < 60 * 60 * 24) {//hour
        return [NSString stringWithFormat:NSLocalizedString(@"%dh", @""), seconds / (60 * 60)];
    }
    else if (seconds >= 60 * 60 * 24 && seconds < 60 * 60 * 24 * 30) {//day
        return [NSString stringWithFormat:NSLocalizedString(@"%dd", @""), seconds / (60 * 60 * 24)];
    }
    else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        return formattedDateString;
    }
}

+ (NSString*)fullTextFromTimeIntervalSince1970:(int)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSTimeInterval theSeconds = [date timeIntervalSinceNow];
    int seconds = 0 - theSeconds;
    
    if (seconds < 60) {//just now
        return NSLocalizedString(@"刚刚", @"");
    } else if (seconds >= 60 && seconds < 60 * 60) {//min
        return [NSString stringWithFormat:NSLocalizedString(@"%d分钟前", @""), seconds / 60];
    } else if (seconds >= 60 * 60 && seconds < 60 * 60 * 24) {//hour
        return [NSString stringWithFormat:NSLocalizedString(@"%d小时前", @""), seconds / (60 * 60)];
    } else if (seconds >= 60 * 60 * 24 && seconds < 60 * 60 * 24 * 30) {//day
        return [NSString stringWithFormat:NSLocalizedString(@"%d天前", @""), seconds / (60 * 60 * 24)];
    } else {
        TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
        [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd HH:mm:ss", @"")];
        return [timeutils.dateFormatter stringFromDate:date];
    }
}

+ (NSString*)relativeTextFromTimeIntervalSince1970:(int)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSTimeInterval theSeconds = [date timeIntervalSinceNow];
    int seconds = 0 - theSeconds;
    if (seconds < 60) {//just now
        return NSLocalizedString(@"刚刚", @"");
    } else if (seconds >= 60 && seconds < 60 * 60) {//min
        return [NSString stringWithFormat:NSLocalizedString(@"%d分钟前", @""), seconds / 60];
    } else if (seconds >= 60 * 60 && seconds < 60 * 60 * 24) {//hour
        return [NSString stringWithFormat:NSLocalizedString(@"%d小时前", @""), seconds / (60 * 60)];
    } else if (seconds >= 60 * 60 * 24 && seconds < 60 * 60 * 24 * 30) {//day
        return [NSString stringWithFormat:NSLocalizedString(@"%d天前", @""), seconds / (60 * 60 * 24)];
    } else if (seconds >= 60 * 60 * 24 * 30 && seconds < 60 * 60 * 24 * 30 * 12) {//day
        return [NSString stringWithFormat:NSLocalizedString(@"%d月前", @""), seconds / (60 * 60 * 24 * 30)];
    } else {//days
        return [NSString stringWithFormat:NSLocalizedString(@"%d年前", @""), seconds / (60 * 60 * 24 * 30 * 12)];
    }
}

+ (NSString *)getNowDateString_H
{
    return [self getStringFromDate_H:[NSDate date]];
}

+ (NSString *)getNowDateString_YMD
{
    return [self getStringFromDate_YMD:[NSDate date]];
}

+ (NSString *)getNowTimeString_HMS
{
    return [self getStringFromDate_HMS:[NSDate date]];
}

+ (NSString *)getNowTimeString_HM_12
{
    return [self getStringFromDate_HM_12:[NSDate date]];
}

+ (NSString *)getNowTimeString_HM
{
    return [self getStringFromDate_HM:[NSDate date]];
}

+ (NSString *)getNowTimeString_YMDHM
{
    return [self getStringFromDate_YMDHM:[NSDate date]];
}

+ (NSString *)getStringFromTimeIntervalSince1970_YMD:(int)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self getStringFromDate_YMD:date];
}

+ (NSString *)getStringFromTimeIntervalSince1970_HMS_12:(int)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self getStringFromDate_HMS_12:date];
}

+ (NSString *)getTimeString_MinutesFromTimeIntervalSince1970:(int)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:@"a HH:mm"];
    return [timeutils.dateFormatter stringFromDate:date];
}

+ (NSString *)getStringFromDate_YMD:(NSDate *)sdate {
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd", @"")];
    return [timeutils.dateFormatter stringFromDate:sdate];
}

+ (NSString *)getStringFromDate_HMS_12:(NSDate *)sdate
{
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:@"HH:mm:ss a"];
    return [timeutils.dateFormatter stringFromDate:sdate];
}

+ (NSString *)getStringFromDate_HMS:(NSDate *)sdate
{
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:@"HH:mm:ss"];
    return [timeutils.dateFormatter stringFromDate:sdate];
}

+ (NSString*)getStringFromDate_YMDHM:(NSDate *)sdate
{
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd HH:mm", @"")];
    return [timeutils.dateFormatter stringFromDate:sdate];
}

+ (NSString *)getStringFromDate_MDHM:(NSDate *)sdate
{
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:NSLocalizedString(@"MM-dd HH:mm", @"")];
    return [timeutils.dateFormatter stringFromDate:sdate];
}

+ (NSString *)getStringFromDate_H:(NSDate *)sdate
{
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:@"HH"];
    return [timeutils.dateFormatter stringFromDate:sdate];
}

+ (NSString *)getStringFromDate_HM_12:(NSDate *)sdate
{
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:@"HH:mm a"];
    return [timeutils.dateFormatter stringFromDate:sdate];
}

+ (NSString *)getStringFromDate_HM:(NSDate *)sdate
{
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    [timeutils.dateFormatter setDateFormat:@"HH:mm"];
    return [timeutils.dateFormatter stringFromDate:sdate];
}

+ (NSString *)getDetailStringFromDate:(NSDate *)sdate
{
    if (sdate == nil) {
        return [self getStringFromDate_YMDHM:sdate];
    }
    NSCalendar *calendar = [[TimeIntervalUtils sharedInstance].dateFormatter calendar];
    NSDate *current = [NSDate date];
    NSDateComponents *theComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                                  fromDate:sdate];
    
    NSDateComponents *currentComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                                      fromDate:current];
    
    NSTimeInterval theSeconds = [sdate timeIntervalSinceNow];
    int seconds = 0 - theSeconds;
    if (seconds < 60) {//just now
        return NSLocalizedString(@"刚刚", @"");
    } else if (seconds >= 60 && seconds < 60 * 60) {//mins
        if (currentComponents.day == theComponents.day) {
            return [NSString stringWithFormat:NSLocalizedString(@"%d分钟前", @""), seconds / 60];
        } else {
            return [NSString stringWithFormat:@"昨天%@", [self getStringFromDate_HM:sdate]];
        }
    } else if (seconds >= 60 * 60 && seconds < 60 * 60 * 24) {//hour
        if (currentComponents.day == theComponents.day) {
            return [NSString stringWithFormat:@"今天%@", [self getStringFromDate_HM:sdate]];
        } else {
            return [NSString stringWithFormat:@"昨天%@", [self getStringFromDate_HM:sdate]];
        }
    } else if (seconds >= 60 * 60 * 24 && seconds < 60 * 60 * 24 * 2) {
        if (currentComponents.day == theComponents.day) {
            return [NSString stringWithFormat:@"今天%@", [self getStringFromDate_HM:sdate]];
        } else if (currentComponents.day == theComponents.day + 1) {
            return [NSString stringWithFormat:@"昨天%@", [self getStringFromDate_HM:sdate]];
        }
    } else {
        if (currentComponents.year == theComponents.year && currentComponents.month == theComponents.month && currentComponents.day == theComponents.day + 1) {
            return [NSString stringWithFormat:@"昨天%@", [self getStringFromDate_HM:sdate]];
        }
    }
    if (currentComponents.year == theComponents.year) {
        return [self getStringFromDate_MDHM:sdate];
    } else {
        return [self getStringFromDate_YMDHM:sdate];
    }
}

+ (NSDate *)getDateFromString:(NSString *)string {
    TimeIntervalUtils *timeutils = [TimeIntervalUtils sharedInstance];
    return [timeutils.dateFormatter dateFromString:string];
}


@end
