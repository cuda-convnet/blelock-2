//
//  BLInitManager.h
//  blelock
//
//  Created by liudongdong on 15/7/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLLoginViewController.h"
#import <UIKit/UIKit.h>
//测试更换的环境，是否有效

@interface BLInitManager : NSObject

+ (instancetype)sharedInstance;
- (void)launch;

@end
