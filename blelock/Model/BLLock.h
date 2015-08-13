//
//  BLLock.h
//  blelock
//
//  Created by NetEase on 15/8/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLLock : NSObject

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, assign) NSInteger major;
@property (nonatomic, assign) NSInteger minjor;
@property (nonatomic, strong) NSString *constantKeyWord;
@property (nonatomic, strong) NSDate *constantKeyWordExpiredDate;

@end
