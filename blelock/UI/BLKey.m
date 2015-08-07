//
//  BLKey.m
//  blelock
//
//  Created by NetEase on 15/8/7.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLKey.h"
#import "BLLockType.h"

@interface BLKey ()

@property NSString *blId;
@property NSInteger maxTimes;
@property NSInteger usedTimes;
@property NSString *expiredDate;
@property NSString *alias;
@property NSString *constKeyWord;
@property NSString *constantKeyWordExpiredDate;
@property BLLockType *blLockType;


@end

@implementation BLKey

- (id) init
{
    self = [super init];
    if (self)
    {
        self.blId = nil;
        self.blLockType = [[BLLockType alloc]init];
    }
    return self;
}


@end
