//
//  BLLockService.h
//  blelock
//
//  Created by NetEase on 15/8/31.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


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

//蓝牙状态
typedef enum {
    BLUETOOTH_IS_OPEN = 0,
    BLUETOOTH_IS_CLOSED = 1,
    BLUETOOTH_NOT_SUPPORT = 2
} BluetoothState;

@protocol BLLockServiceProtocol<NSObject>
- (void) alarmServiceDidChangeStatus:(BLLockService*)service;
@end


/****************************************************************************/
/*						Lock service.                          */
/****************************************************************************/
@interface BLLockService : NSObject

- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<BLLockServiceProtocol>)controller;
- (void) start;

@property (readonly) CBPeripheral *peripheral;
@end
