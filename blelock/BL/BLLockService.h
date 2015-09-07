//
//  BLLockService.h
//  blelock
//
//  Created by NetEase on 15/8/31.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

// lock相关的，约定好的OP CODE
//APP发送给蓝牙的第一个字节或蓝牙发送给APP的第二个字节
#define OP_CODE_GET_DISPOSABLE_LOCK_WORD    0
#define OP_CODE_GET_CONSTANT_LOCK_WORD      2
#define OP_CODE_VERIFY_DISPOSABLE_LOCK_KEY  1
#define OP_CODE_VERIFY_CONSTANT_LOCK_KEY    3
#define OP_CODE_GET_STATES                  4
#define OP_CODE_RESET_TO_DFU_MODE           5
#define OP_CODE_GET_ALL_VERSIONS            6
#define OP_CODE_RESET_CONSTANT_LOCK_WORD    7
#define OP_CODE_SET_DISPOSABLE_ENCRYPT_WORD 33
#define OP_CODE_SET_CONSTANT_ENCRYPT_WORD   34
#define OP_CODE_CLEAR_ECNRYT_WORDS          35

//蓝牙发送给APP
//第一个字节：type
//RESPONSE:第二个字节OP CODE；NOTIFY：第二个字节Notify Object
#define OP_CODE_RESPONSE_IN_LOCK_MODE       (Byte)200
#define OP_CODE_NOTIFY_IN_LOCK_MODE         (Byte)201

//第二个字节：Notify Object
#define NOTIFY_OBJECT_DOOR                  16
#define NOTIFY_OBJECT_LOCK                  17
#define NOTIFY_OBJECT_BATTERY_LEVEL         18
#define NOTIFY_OBJECT_FLASH                 19

//第三个字节：长度
//第四个字节：通知对象的状态
#define DOOR_STATE_OPENED                   0
#define DOOR_STATE_CLOSED                   1
#define LOCK_STATE_LOCKED                   0
#define LOCK_STATE_UNLOCKED                 1
#define LOCK_STATE_UNCERTAIN                2
#define FLASH_READ_ERROR                    0

//第四个字节：OP CODE的操作结果
#define RESULT_SUCCESS                      0
#define RESULT_KEY_WORD_VALIDATE_FAILED     6
#define RESULT_FLASH_WRITING_ERROR          7
#define RESULT_FLASH_READING_ERROR          8
#define RESULT_ACTION_DISALLOWED            9
#define RESULT_COMMAND_UNRECOGNIZED         10
#define RESULT_PARAM_LENGTH_ILLEGAL         11




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

@required
- (void) lockService:(BLLockService*)service changeForLockState:(enum LockState)lockState;
- (void) lockService:(BLLockService *)service changeForDoorState:(enum DoorState)doorState;
- (void) letUserControl:(BLLockService *)service;
@end


/****************************************************************************/
/*						Lock service.                          */
/****************************************************************************/
@interface BLLockService : NSObject

- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<BLLockServiceProtocol>)controller;
- (void) start;
- (void) resetToDfuMode;
@property (readonly) CBPeripheral *peripheral;
@end
