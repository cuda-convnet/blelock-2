//
//  BLKey.h
//  blelock
//
//  Created by NetEase on 15/8/11.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUser.h"
#import "BLLock.h"
#import "BLShareTo.h"

@interface BLKey : NSObject

@property (nonatomic) NSInteger Id;
@property (nonatomic) NSInteger maxTimes;
@property (nonatomic) NSInteger usedTimes;
@property (nonatomic, strong) NSDate *expiredDate;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) BLUser *sharedFrom;
@property (nonatomic, strong) NSArray *shareTo;
@property (nonatomic, strong) BLLock *lock;


@end
