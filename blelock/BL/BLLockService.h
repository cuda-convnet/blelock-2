//
//  BLLockService.h
//  blelock
//
//  Created by NetEase on 15/8/31.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//锁状态
enum LockState {
    LOCK_IS_FIND,
    LOCK_NOT_FIND,
    LOCK_IS_CONNECT,
    LOCK_NOT_CONNECT,
    LOCK_IS_OPEN,
    LOCK_IS_CLOSED,
};

//门状态
enum DoorState {
    DOOR_IS_OPEN,
    DOOR_IS_CLOSED
};


/****************************************************************************/
/*						Service Characteristics								*/
/****************************************************************************/
extern NSString *kLockServiceUUIDString;                        // d62a2015-7fac-a2a3-bec3-a68869e0f2bf     Service UUID
extern NSString *kLockControlPointCharacteristicUUIDString;     // d62a9900-7fac-a2a3-bec3-a68869e0f2bf
extern NSString *kLockControlPointDescriptorUUIDString;         // 00002902-0000-1000-8000-00805f9b34fb

/****************************************************************************/
/*								Protocol									*/
/****************************************************************************/
@class BLLockService;

@protocol BLLockServiceProtocol<NSObject>

- (void)changeForLockState:(enum LockState)lockState;

@end


/****************************************************************************/
/*						Lock service.                          */
/****************************************************************************/
@interface BLLockService : NSObject

- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<BLLockServiceProtocol>)controller;
- (void) start;

@property (readonly) CBPeripheral *peripheral;
@end
