//
//  AppDelegate.h
//  FileBrowser
//
//  Created by Kobe Dai on 10/24/12.
//  Copyright (c) 2012 Kobe Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) UIWindow *window;

@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic, retain) UINavigationController *navController;

@end
