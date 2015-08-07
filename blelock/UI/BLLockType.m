//
//  BLLockType.m
//  blelock
//
//  Created by NetEase on 15/8/7.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLLockType.h"
#import "BLVersion.h"

@interface BLLockType ()

@property NSString *blId;
@property BLVersion *blVersion;

@end

@implementation BLLockType

- (id) init
{
    self = [super init];
    if (self)
    {
        self.blId = nil;
        self.blVersion = [[BLVersion alloc]init];
    }
    return self;
}


@end
