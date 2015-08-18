//
//  BLInitManager.m
//  blelock
//
//  Created by liudongdong on 15/7/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLInitManager.h"

#import "BLLoginForFirstViewController.h"
#import "BLKeyViewController.h"

#define BLLoginUserID  @"blelock.login.uid"

@interface BLInitManager ()

//@property (nonatomic, strong) UINavigationController *rootNavigationController;


@end

@implementation BLInitManager

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static BLInitManager *gInstance;
    dispatch_once(&onceToken, ^{
        gInstance = [[BLInitManager alloc] init];
    });
    return gInstance;
    
}

- (void)launch {

//    NSString *userID = [self loginUserID];
//    if ([userID length] > 0) {
//        [self setupUserWithID:userID];
//        //[self showMainViewController];
//    }
//    else
//        [self showLoginViewController];
    [self showLoginViewController];
}

- (NSString *)loginUserID {
    return [[NSUserDefaults standardUserDefaults] stringForKey:BLLoginUserID];
}

- (void)setupUserWithID:(NSString *)userID {
}

- (void)showLoginViewController {
    
    BLLoginViewController *loginVC = [[BLLoginViewController alloc] init];
    UINavigationController *rootNavigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    //导航栏统一初始化操作
    rootNavigationController.navigationBar.barTintColor = [UIColor blackColor];
    rootNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    [rootNavigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    rootNavigationController.navigationBar.translucent = NO;//导航栏不透明
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    [self showNewWindowWithViewController:rootNavigationController animated:YES];
    
}



- (void)showNewWindowWithViewController:(UIViewController*)vc animated:(BOOL)animated {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor whiteColor];
    UIApplication *application = [UIApplication sharedApplication];
    [application.delegate setWindow:window];
    
    window.rootViewController = vc;
    [window makeKeyAndVisible];
}

@end
