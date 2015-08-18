//
//  BLLock.h
//  blelock
//
//  Created by NetEase on 15/8/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLHouse.h"
#import "BLLockType.h"

@interface BLLock : NSObject

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) BLHouse *house;
@property (nonatomic, assign) BLLockType *type;
@property (nonatomic, strong) NSString *gapAddress;
@property (nonatomic, strong) NSString *constantKeyWord;
@property (nonatomic, strong) NSDate *constantKeyWordExpiredDate;
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, assign) NSInteger major;
@property (nonatomic, assign) NSInteger minjor;


@end
