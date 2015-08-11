//
//  BLShareTo.h
//  blelock
//
//  Created by NetEase on 15/8/11.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUser.h"

@interface BLShareTo : NSObject

@property (nonatomic) NSInteger Id;
@property (nonatomic) NSInteger maxTimes;
@property (nonatomic, strong) NSDate *expiredDate;
@property (nonatomic, strong) BLUser *owner;

@end
