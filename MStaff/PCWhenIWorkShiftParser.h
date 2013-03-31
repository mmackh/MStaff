//
//  PCWhenIWorkShiftParser.h
//  MStaff
//
//  Created by Maximilian Mackh on 3/20/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PCWhenIWorkShiftParserDelegate <NSObject>

- (void)whenIWorkMultipleShiftsParsed:(NSArray *)shifts;
- (void)whenIWorkSingleShiftParsed:(NSArray *)shift;

@end

@interface PCWhenIWorkShiftParser : NSObject

@property (strong, nonatomic) id <PCWhenIWorkShiftParserDelegate> delegate;

@property (strong, nonatomic) NSDictionary *arrayToParse;

- (void)parseMultipleShifts;
- (void)parseSingleShift;

@end
