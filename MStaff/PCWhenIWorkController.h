//
//  PCWhenIWorkController.h
//  MStaff
//
//  Created by Maximilian Mackh on 3/20/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

#define APIHOST @"https://api.wheniwork.com"
#define APIKEY @""

#define DESKEMAIL @""
#define DESKPASSWORD @""

#define SERVICEEMAIL @""
#define SERVICEPASSWORD @""

#define KITCHENEMAIL @""
#define KITCHENPASSWORD @""

#define CLEANINGEMAIL @""
#define CLEANINGPASSWORD @""

@protocol PCWhenIWorkDelegate <NSObject>

- (void)whenIWorkLogInProcessSuccess:(BOOL)success;
- (void)whenIWorkScheduleLoaded:(NSDictionary *)schedule;
- (void)whenIWorkScheduleLoaded:(NSDictionary *)schedule ID:(int)userID;

@end

typedef NS_ENUM(NSInteger, RequestByStaff)
{
    RequestByStaffDesk = 1,
    RequestByStaffService = 2,
    RequestByStaffKitchen = 3,
    RequestByStaffCleaning = 4
};

@interface PCWhenIWorkController : NSObject

- (void)loginOnBehalf:(RequestByStaff)staff;
- (void)requestScheduleOnBehalf:(RequestByStaff)staff From:(NSString *)starting Until:(NSString *)end;
- (void)requestScheduleOnBehalf:(RequestByStaff)staff ID:(int)userID From:(NSString *)start Until:(NSString *)end;

- (BOOL)canRequestScheduleOnBehalf:(RequestByStaff)staff;

@property (strong, nonatomic) id <PCWhenIWorkDelegate> delegate;

@end
