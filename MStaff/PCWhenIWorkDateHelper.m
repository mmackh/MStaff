//
//  PCWhenIWorkDateHelper.m
//  MStaff
//
//  Created by Maximilian Mackh on 3/21/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import "PCWhenIWorkDateHelper.h"


@implementation PCWhenIWorkDateHelper

+ (NSString *)parseDateString:(NSString *)dateString WithFormat:(NSString *)sourceFormat ToFormat:(NSString *)targetFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:sourceFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:targetFormat];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromStringWithFormat:(NSString *)sourceFormat InputDateString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:sourceFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)parseDate:(NSDate *)date toStringWithFormat:(NSString *)targetFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:targetFormat];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)today
{
    NSDate *now = [[NSDate alloc] init];
    return [[self dateFormatterWithFormat:kWhenIWorkShiftRequestTimeStampFormat] stringFromDate:now];
}

+ (NSString *)tomorrow
{
    return [[self dateFormatterWithFormat:kWhenIWorkShiftRequestTimeStampFormat] stringFromDate:[self offsetDateByDays:1 FromDate:[NSDate date]]];
}


+ (NSDate *)offsetDateByDays:(int)days FromDate:(NSDate *)date
{
    NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
    [deltaComps setDay:days];
    NSDate* offset = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:date options:0];
    
    return offset;
}

+ (NSDate *)offsetDateByDays:(int)days WithHourComponentReset:(int)hours FromDate:(NSDate *)date
{
    NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:days];
    [dateComponents setHour:hours];
    NSDate* offset = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    
    return offset;
}
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return dateFormatter;
}

+ (NSString *)offsetDateStringByDays:(int)days FromDateString:(NSString *)dateString InputFormat:(NSString *)format
{
    NSDate *date = [PCWhenIWorkDateHelper offsetDateByDays:days FromDate:[PCWhenIWorkDateHelper dateFromStringWithFormat:format InputDateString:dateString]];
    return [PCWhenIWorkDateHelper parseDate:date toStringWithFormat:format];
}

+ (NSString *)dayOfTheWeekFromDate:(NSDate *)date
{
    return [self parseDate:date toStringWithFormat:@"EEEE"];
}

+ (NSArray *)datesBetweenStartDate:(NSDate *)start endDate:(NSDate *)end
{
    NSMutableArray *arr = [NSMutableArray array];
    int day = 0;
    
    while (day <= [self daysBetweenDate:start andDate:end])
    {
        NSDate *date = [self offsetDateByDays:day WithHourComponentReset:13 FromDate:start];
        
        [arr addObject:date];
        
        day++;
    }
    
    return [arr copy];
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
    	return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
    	return NO;
    
    return YES;
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

+ (BOOL)date:(NSDate *)date IsOnDate:(NSDate *)onDate
{
    return ([[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:date] == [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:onDate]);
}

@end
