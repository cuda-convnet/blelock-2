//
//  BlLoginManager.m
//  blelock
//
//  Created by liudongdong on 15/7/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BlLoginManager.h"

@implementation BlLoginManager

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static BlLoginManager *gInstance;
    dispatch_once(&onceToken, ^{
        gInstance = [[BlLoginManager alloc] init];
    });
    return gInstance;
    
}

@end
