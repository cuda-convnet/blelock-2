//
//  BLNavigationController.m
//  blelock
//
//  Created by NetEase on 15/8/21.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLNavigationController.h"

@implementation BLNavigationController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"user"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
}

@end
