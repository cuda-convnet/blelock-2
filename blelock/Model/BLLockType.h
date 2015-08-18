//
//  BLLockType.h
//  blelock
//
//  Created by NetEase on 15/8/17.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLLockVersion.h"

@interface BLLockType : NSObject

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) BLLockVersion *newestFirmwareVersion;

@end
