//
//  BLInitManager.m
//  blelock
//
//  Created by liudongdong on 15/7/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLInitManager.h"
#import "BLLoginViewController.h"
#import "BLLoginForFirstViewController.h"
#import "BLKeyViewController.h"

#define BLLoginUserID  @"blelock.login.uid"

@interface BLInitManager ()

@property (nonatomic, strong) UINavigationController *rootNavigationController;

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
    _rootNavigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    
    [self showNewWindowWithViewController:_rootNavigationController animated:YES];
    
}
- (void)showLoginForFirstViewController {
    
    BLLoginForFirstViewController *loginVC = [[BLLoginForFirstViewController alloc] init];
    _rootNavigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    [self showNewWindowWithViewController:_rootNavigationController animated:YES];
    
}
- (void)showKeyViewController {
    
    BLKeyViewController *loginVC = [[BLKeyViewController alloc] init];
    _rootNavigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    [self showNewWindowWithViewController:_rootNavigationController animated:YES];
    
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
