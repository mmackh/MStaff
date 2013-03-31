//
//  PCAppDelegate.m
//  MStaff
//
//  Created by Maximilian Mackh on 3/20/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import "PCAppDelegate.h"

@implementation PCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self customizeAppearance];
    
    return YES;
}

- (void)customizeAppearance
{
    [[[UINavigationBar class] appearance] setBackgroundImage:[UIImage imageNamed:@"topbar"] forBarMetrics:UIBarMetricsDefault];
    [[[UISegmentedControl class] appearance] setTintColor:[UIColor colorWithRed:0.62f green:0.65f blue:0.68f alpha:1.00f]];
    [[[UIBarButtonItem class] appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor colorWithRed:0.62f green:0.65f blue:0.68f alpha:1.00f]];
    [[[UITabBar class]  appearance] setTintColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0]];
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor colorWithRed:0.44f green:0.47f blue:0.50f alpha:1.00f], UITextAttributeTextColor,
                                        [UIColor whiteColor], UITextAttributeTextShadowColor,
                                        [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                        nil] ;
    
    [[UINavigationBar appearance] setTitleTextAttributes:selectedAttributes]; 
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
