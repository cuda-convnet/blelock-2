//
//  BLInitManager.h
//  blelock
//
//  Created by liudongdong on 15/7/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface BLInitManager : NSObject

+ (instancetype)sharedInstance;
- (void)launch;

@end
