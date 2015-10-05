//
//  AppDelegate.m
//  RightLeft
//
//  Created by iappscrazy on 14/06/2015.
//  Copyright (c) 2015 iappscrazy. All rights reserved.
//

#import "AppDelegate.h"
#import "GameCenterClass.h"
#import <Tapjoy/Tapjoy.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Turn on Tapjoy debug mode
    
   // [Tapjoy setDebugEnabled:YES]; //Do not set this for any version of the game released to an app store!
    //The Tapjoy connect call
//    [Tapjoy connect:@"rmyM5xlZQ0adf1S58bOZXQEBMmlOcGVQDvtsGhj1DCdrWPgX28nYg67u86hJ"];
    [Tapjoy requestTapjoyConnect:@"bf4aeef3-6aaf-4226-88d5-93861bfae2dc" secretKey:@"wxZM6bxBKrFG30KAeAh1" options:@{ TJC_OPTION_ENABLE_LOGGING : @(YES) } ];


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    GameCenterClass *GCenter = [GameCenterClass gameCenterSharedInstance];
    GCenter.leaderBoardID = @"tapcolor_topscore";
    
    [GCenter checkAuthentication:^(BOOL gameCenterAvialble) {
    }];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
