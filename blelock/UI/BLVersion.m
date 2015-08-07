//
//  BLVersion.m
//  blelock
//
//  Created by NetEase on 15/8/7.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLVersion.h"

@interface BLVersion ()

@property NSString *blId;
@property NSString *blMajor;
@property NSString *blMinor;

@end

@implementation BLVersion
- (id) init
{
    self = [super init];
    if (self)
    {
        self.blId = nil;
        self.blMajor = nil;
        self.blMinor = nil;
    }
    return self;
}

@end
