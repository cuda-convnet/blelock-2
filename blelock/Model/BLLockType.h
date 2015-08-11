//
//  BLLockType.h
//  blelock
//
//  Created by NetEase on 15/8/11.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLVersion.h" 

@interface BLLockType : NSObject
@property (nonatomic) NSInteger Id;
@property (nonatomic, strong) BLVersion *version;

@end
