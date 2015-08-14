//
//  AppDelegate.m
//  blelock
//
//  Created by liudongdong on 15/7/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "AppDelegate.h"
#import "BLInitManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //状态栏字体白色
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [[BLInitManager sharedInstance] launch];
    //欢迎界面停留2秒
    //[NSThread sleepForTimeInterval:2.0];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Tells the delegate that the app is about to become inactive.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //Tells the delegate that the app is now in the background.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //Tells the delegate that the app is about to enter the foreground.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //Tells the delegate that the app has become active.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //Tells the delegate when the app is about to terminate.
}

@end
