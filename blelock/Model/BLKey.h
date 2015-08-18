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

@interface BLKey : NSObject

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) BLLock *lock;
@property (nonatomic, strong) BLUser *owner;
@property (nonatomic, strong) BLKey *sharedFrom;
@property (nonatomic, strong) NSDate *expiredDate;
@property (nonatomic, assign) NSInteger maxTimes;
@property (nonatomic, assign) NSInteger usedTimes;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSMutableArray *sharerTable;

@end
