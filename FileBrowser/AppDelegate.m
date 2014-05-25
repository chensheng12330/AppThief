//
//  AppDelegate.m
//  FileBrowser
//
//  Created by Kobe Dai on 10/24/12.
//  Copyright (c) 2012 Kobe Dai. All rights reserved.
//

#import "AppDelegate.h"

#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.rootViewController = [[[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil] autorelease];
    self.navController = [[[UINavigationController alloc] initWithRootViewController: self.rootViewController] autorelease];
    self.rootViewController.fm = [NSFileManager defaultManager];
    
    
    
    [self.rootViewController.fm changeCurrentDirectoryPath:@"/var/mobile/Applications"];
    self.rootViewController.isRoot = YES;
    self.rootViewController.title  = @"Applications"; ///var/mobile/Applications
    
    // customization
    [self.rootViewController.view setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"bgPattern"]]];
    [self.navController.navigationBar setBackgroundImage: [UIImage imageNamed: @"navBar"] forBarMetrics: UIBarMetricsDefault];
    
    self.rootViewController.isPoped = NO;
    self.window.rootViewController = self.navController;
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
