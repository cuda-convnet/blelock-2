//
//  BLUser.h
//  blelock
//
//  Created by NetEase on 15/8/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLUser : NSObject

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *headerImageId;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSMutableArray *keyTable;

@end
