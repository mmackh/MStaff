//
//  PCWhenIWorkDateHelper.h
//  MStaff
//
//  Created by Maximilian Mackh on 3/21/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWhenIWorkShiftTimeStampFormat @"E, dd MMM yyyy HH:mm:ss Z"
#define kWhenIWorkShiftRequestTimeStampFormat @"yyyy-MM-dd"

@interface PCWhenIWorkDateHelper : NSObject

+ (NSString *)parseDateString:(NSString *)dateString WithFormat:(NSString *)sourceFormat ToFormat:(NSString *)targetFormat;

+ (NSDate *)dateFromStringWithFormat:(NSString *)sourceFormat InputDateString:(NSString *)dateString;
+ (NSString *)parseDate:(NSDate *)date toStringWithFormat:(NSString *)targetFormat;

+ (NSDate *)offsetDateByDays:(int)days FromDate:(NSDate *)date;
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format;
+ (NSArray *)datesBetweenStartDate:(NSDate *)start endDate:(NSDate *)end;

//Convenience Menthods
+ (NSString *)today;
+ (NSString *)tomorrow;

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;
+ (BOOL)date:(NSDate *)date IsOnDate:(NSDate *)onDate;

+ (NSString *)offsetDateStringByDays:(int)days FromDateString:(NSString *)dateString InputFormat:(NSString *)format;
+ (NSString *)dayOfTheWeekFromDate:(NSDate *)date;

@end
