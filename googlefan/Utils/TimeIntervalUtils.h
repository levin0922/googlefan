//
//  TimeIntervalUtils.h
//  Three Hundred
//
//  Created by 郭雪 on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimeIntervalUtils : NSObject

@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;

- (void)clearDataFormatter;

+ (NSString *)getLocalTimeZone;

+ (TimeIntervalUtils *)sharedInstance;
+ (NSString*)shortTextFromTimeIntervalSince1970:(int)timeInterval;
+ (NSString*)fullTextFromTimeIntervalSince1970:(int)timeInterval;
+ (NSString*)relativeTextFromTimeIntervalSince1970:(int)timeInterval;

+ (NSString *)getNowDateString_H;
+ (NSString *)getNowDateString_YMD;
+ (NSString *)getNowTimeString_HMS;
+ (NSString *)getNowTimeString_HM_12;
+ (NSString *)getNowTimeString_HM;
+ (NSString *)getNowTimeString_YMDHM;

+ (NSString *)getStringFromTimeIntervalSince1970_YMD:(int)timeInterval;
+ (NSString *)getStringFromTimeIntervalSince1970_HMS_12:(int)timeInterval;
+ (NSString *)getTimeString_MinutesFromTimeIntervalSince1970:(int)timeInterval;

+ (NSString *)getStringFromDate_YMD:(NSDate *)sdate;
+ (NSString *)getStringFromDate_HMS_12:(NSDate *)sdate;
+ (NSString *)getStringFromDate_HMS:(NSDate *)sdate;
+ (NSString *)getStringFromDate_YMDHM:(NSDate *)sdate;
+ (NSString *)getStringFromDate_MDHM:(NSDate *)sdate;
+ (NSString *)getStringFromDate_H:(NSDate *)sdate;
+ (NSString *)getStringFromDate_HM_12:(NSDate *)sdate;
+ (NSString *)getStringFromDate_HM:(NSDate *)sdate;

+ (NSString *)getDetailStringFromDate:(NSDate *)sdate;

+ (NSDate *)getDateFromString:(NSString *)string;

@end
