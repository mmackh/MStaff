//
//  PCWhenIWorkController.m
//  MStaff
//
//  Created by Maximilian Mackh on 3/20/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import "PCWhenIWorkController.h"

@implementation PCWhenIWorkController
{
    NSString *tokenDesk;
    NSString *tokenService;
    NSString *tokenKitchen;
    NSString *tokenCleaning;
    
    AFHTTPClient *httpClient;
}

- (id)init {
    if (self = [super init])
    {
        NSURL *url = [NSURL URLWithString:APIHOST];
        httpClient = [AFHTTPClient clientWithBaseURL:url];
    }
    return self;
}

- (void)loginOnBehalf:(RequestByStaff)staff
{
    [self purgeCookies];
    [self networkStatusIndicator:YES];
    
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    NSString *username;
    NSString *password;
    
    switch (staff)
    {
        case RequestByStaffDesk:
            username = DESKEMAIL;
            password = DESKPASSWORD;
            break;
        case RequestByStaffService:
            username = SERVICEEMAIL;
            password = SERVICEPASSWORD;
            break;
        case RequestByStaffKitchen:
            username = KITCHENEMAIL;
            password = KITCHENPASSWORD;
            break;
        case RequestByStaffCleaning:
            username = CLEANINGEMAIL;
            password = CLEANINGPASSWORD;
            break;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            APIKEY, @"key",
                            password, @"password",
                            username, @"username",
                            nil];
    
    NSURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/2/login" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        [self setTokenOnBehalf:staff Token:[JSON objectForKey:@"token"]];
        [self networkStatusIndicator:NO];
        
        [_delegate whenIWorkLogInProcessSuccess:[self canRequestScheduleOnBehalf:staff]];
    }
                                                                                        failure:nil];
    [operation start];
}

- (void)requestScheduleOnBehalf:(RequestByStaff)staff From:(NSString *)start Until:(NSString *)end
{
    [self purgeCookies];
    [self networkStatusIndicator:YES];
    
    NSString *token = [self tokenOnBehalf:staff];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            token, @"W-Token",
                            start, @"start",
                            end, @"end",
                            @"true", @"unpublished",
                            nil];
    
     NSURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"/2/shifts" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        [_delegate whenIWorkScheduleLoaded:JSON];
        [self networkStatusIndicator:NO];
    }
    failure:nil];
    
    [operation start];
}

- (void)requestScheduleOnBehalf:(RequestByStaff)staff ID:(int)userID From:(NSString *)start Until:(NSString *)end
{
    [self purgeCookies];
    [self networkStatusIndicator:YES];
    
    NSString *token = [self tokenOnBehalf:staff];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            token, @"W-Token",
                            start, @"start",
                            end, @"end",
                            [NSString stringWithFormat:@"%i", userID], @"user_id",
                            @"true", @"unpublished",
                            nil];
    
    NSURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"/2/shifts" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             [_delegate whenIWorkScheduleLoaded:JSON ID:userID];
                                             [self networkStatusIndicator:NO];
                                         }
                                                                                        failure:nil];
    
    [operation start];
}

- (void)purgeCookies
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:APIHOST]];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

- (BOOL)canRequestScheduleOnBehalf:(RequestByStaff)staff
{
    return ([self tokenOnBehalf:staff].length > 0) ? YES : NO;
}

- (void)networkStatusIndicator:(BOOL)on
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:on];
}

- (void)setTokenOnBehalf:(RequestByStaff)staff Token:(NSString *)token
{
    token = [NSString stringWithString:token];
    switch (staff)
    {
        case RequestByStaffDesk:
        {
            tokenDesk = token;
        }
            break;
        case RequestByStaffService:
        {
            tokenService = token;
        }
            break;
        case RequestByStaffKitchen:
        {
            tokenKitchen = token;
        }
            break;
        case RequestByStaffCleaning:
        {
            tokenCleaning = token;
        }
            break;
    }
}

- (NSString *)tokenOnBehalf:(RequestByStaff)staff
{
    NSString *token;
    
    switch (staff)
    {
        case RequestByStaffDesk:
            token = tokenDesk;
            break;
        case RequestByStaffService:
            token = tokenService;
            break;
        case RequestByStaffKitchen:
            token = tokenKitchen;
            break;
        case RequestByStaffCleaning:
            token = tokenCleaning;
            break;
    }
    
    return token;
}

@end
