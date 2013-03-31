//
//  PCWhenIWorkShiftParser.m
//  MStaff
//
//  Created by Maximilian Mackh on 3/20/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import "PCWhenIWorkShiftParser.h"

#import "PCWhenIWorkDateHelper.h"

@implementation PCWhenIWorkShiftParser
{
    NSMutableArray *targetArray;
    
    NSArray *shifts;
    NSArray *users;
    NSArray *positions;
    
    NSDate *now;
    
    BOOL active;
}

- (void)parseMultipleShifts
{
    now = [NSDate date];
    
    shifts = [_arrayToParse objectForKey:@"shifts"];
    users = [_arrayToParse objectForKey:@"users"];
    positions = [_arrayToParse objectForKey:@"positions"];
    
    targetArray = [NSMutableArray array];
    
    
    for (NSArray *arr in positions)
    {
        NSDictionary *obj = [NSDictionary dictionaryWithObjectsAndKeys:
                           [arr valueForKey:@"id"], @"id",
                           [arr valueForKey:@"name"], @"name",
                            [NSMutableArray array], @"shifts",
                           nil];
        
        [targetArray addObject:obj];
    }
    
    int index = 0;
    
    for (NSArray *arr in shifts)
    {
        for (NSMutableDictionary *obj in targetArray)
        {
            if ([[obj valueForKey:@"id"] intValue] ==  [[arr valueForKey:@"position_id"] intValue])
            {
                
                NSDictionary *shift = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [self timeForObjectAtIndex:index], @"title",
                                       [self nameForObjectAtIndex:index], @"detail",
                                       [NSNumber numberWithBool:active], @"active",
                                       [NSNumber numberWithInt:[[arr valueForKey:@"user_id"] intValue]], @"user_id",
                                     nil];
                
                NSMutableArray *shiftsInPosition = [obj objectForKey:@"shifts"];
                [shiftsInPosition addObject:shift];
            }
        }
        index++;
    }
    
    [_delegate whenIWorkMultipleShiftsParsed:[targetArray copy]];
}

- (void)parseSingleShift
{
    now = [NSDate date];
    shifts = [_arrayToParse objectForKey:@"shifts"];
    
    targetArray = [NSMutableArray array];
    
    NSDate *start = [PCWhenIWorkDateHelper dateFromStringWithFormat:kWhenIWorkShiftTimeStampFormat InputDateString:[_arrayToParse objectForKey:@"start"]];
    NSDate *end = [PCWhenIWorkDateHelper dateFromStringWithFormat:kWhenIWorkShiftTimeStampFormat InputDateString:[_arrayToParse objectForKey:@"end"]];
    NSArray *days =  [PCWhenIWorkDateHelper datesBetweenStartDate:start endDate:end];
    
    
    int index = 0;
    
    for (NSDate *day in days)
    {
        if ([PCWhenIWorkDateHelper date:day isBetweenDate:start andDate:end])
        {
            NSMutableDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:day,@"date",[PCWhenIWorkDateHelper parseDate:day toStringWithFormat:@"EEEE, dd.MM.yyyy"], @"dateString",[NSMutableArray array], @"shifts", nil];
            [targetArray addObject:dict];
        }
    }
    
    index = 0;
    
    for (NSArray *arr in shifts)
    {
        for (NSMutableDictionary *obj in targetArray)
        {
            if ([PCWhenIWorkDateHelper date:[obj objectForKey:@"date"] IsOnDate:[PCWhenIWorkDateHelper dateFromStringWithFormat:kWhenIWorkShiftTimeStampFormat InputDateString:[arr valueForKey:@"start_time"]]])
            {
                NSDictionary *shift = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [self timeForObjectAtIndex:index], @"title",
                                       [NSNumber numberWithBool:active], @"active",
                                       nil];
                
                NSMutableArray *shiftsInPosition = [obj objectForKey:@"shifts"];
                [shiftsInPosition addObject:shift];
            }
        }
        index++;
    }

    for (int i = 0; i < targetArray.count; i++)
    {
        NSMutableArray *arr = [[targetArray objectAtIndex:i] objectForKey:@"shifts"];
        
        if (arr.count == 0)
        {
            [targetArray removeObject:[targetArray objectAtIndex:i]];
            i--;
        }
    }
    
    [_delegate whenIWorkSingleShiftParsed:[targetArray copy]];
}

- (NSString *)timeForObjectAtIndex:(int)index
{
    NSDictionary *obj = [shifts objectAtIndex:index];
    
    NSDate *start = [PCWhenIWorkDateHelper dateFromStringWithFormat:kWhenIWorkShiftTimeStampFormat InputDateString:[obj objectForKey:@"start_time"]];
    NSDate *end = [PCWhenIWorkDateHelper dateFromStringWithFormat:kWhenIWorkShiftTimeStampFormat InputDateString:[obj objectForKey:@"end_time"]];
    
    active = [PCWhenIWorkDateHelper date:now isBetweenDate:start andDate:end];
    
    NSString *startTime = [PCWhenIWorkDateHelper parseDate:start toStringWithFormat:@"HH:mm"];
    NSString *endTime = [PCWhenIWorkDateHelper parseDate:end toStringWithFormat:@"HH:mm"];
    
    return [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
}

- (NSString *)nameForObjectAtIndex:(int)index
{
    int userID = [[[shifts objectAtIndex:index] objectForKey:@"user_id"] intValue];
    
    int userIndex = 0;
    
    for (NSDictionary *dict in users)
    {
        if ([[dict objectForKey:@"id"] intValue] == userID)
        {
            break;
        }
        
        userIndex++;
    }
    
    NSDictionary *worker = [users objectAtIndex:userIndex];
    return [NSString stringWithFormat:@"%@ %@", [worker objectForKey:@"first_name"], [worker objectForKey:@"last_name"]];
}

@end
