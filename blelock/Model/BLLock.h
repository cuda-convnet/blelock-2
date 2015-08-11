//
//  BLLock.h
//  blelock
//
//  Created by NetEase on 15/8/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLLockType.h"
#import "BLHouse.h"

@interface BLLock : NSObject

@property (nonatomic) NSInteger Id;
@property (nonatomic, strong) NSString *gapAddress;
@property (nonatomic, strong) BLLockType *type;
@property (nonatomic, strong) NSString *constantKeyWord;
@property (nonatomic, strong) NSDate *constantKeyWordExpiredDate;
@property (nonatomic, strong) BLHouse *house;

@end
