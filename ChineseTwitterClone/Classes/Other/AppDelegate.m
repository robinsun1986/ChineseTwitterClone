//
//  AppDelegate.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/27/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "OauthController.h"
#import "NewFeatureController.h"
#import "AccountTool.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    self.window.rootViewController = [[OauthController alloc] init];
//    [self.window makeKeyAndVisible];
//    return YES;

    NSString *key = (NSString *)kCFBundleVersionKey;
    // 1. get version from Info.plist
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    // 2. get last version from sandbox
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if ([version isEqualToString:saveVersion]) { // not a new version
        // show status bar
        application.statusBarHidden = NO;
        
        // if an old account info exists
        if ([AccountTool sharedAccountTool].currentAccount) {
            self.window.rootViewController = [[MainController alloc] init];
        } else {
            self.window.rootViewController = [[OauthController alloc] init];
        }

    } else { // version number differs, indicates new version
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // show new feature view
        self.window.rootViewController = [[NewfeatureController alloc] init];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
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
