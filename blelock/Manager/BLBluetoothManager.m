//
//  BLBluetoothManager.m
//  blelock
//
//  Created by biliyuan on 15/8/3.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLBluetoothManager.h"

@implementation BLBluetoothManager

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static BLBluetoothManager *gInstance;
    dispatch_once(&onceToken, ^{
        gInstance = [[BLBluetoothManager alloc] init];
    });
    return gInstance;
    
}

@end
