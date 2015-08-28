//
//  BLBluetoothCommandManager.h
//  blelock
//
//  Created by NetEase on 15/8/25.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

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

//第三个字节：通知对象的状态
#define DOOR_STATE_OPENED                   0
#define DOOR_STATE_CLOSED                   1
#define LOCK_STATE_LOCKED                   0
#define LOCK_STATE_UNLOCKED                 1
#define LOCK_STATE_UNCERTAIN                2
#define FLASH_READ_ERROR                    0

//第三个字节：OP CODE的操作结果
#define RESULT_SUCCESS                      0
#define RESULT_KEY_WORD_VALIDATE_FAILED     6
#define RESULT_FLASH_WRITING_ERROR          7
#define RESULT_FLASH_READING_ERROR          8
#define RESULT_ACTION_DISALLOWED            9
#define RESULT_COMMAND_UNRECOGNIZED         10
#define RESULT_PARAM_LENGTH_ILLEGAL         11

// dfu相关的，约定好的OP CODE
#define OP_CODE_START_DFU                   1
#define OP_CODE_RECEIVE_INIT                2
#define OP_CODE_RECEIVE_FW                  3
#define OP_CODE_VALIDATE                    4
#define OP_CODE_ACTIVATE_N_RESET            5
#define OP_CODE_SYS_RESET                   6
#define OP_CODE_IMAGE_SIZE_REQ              7
#define OP_CODE_PKT_RCPT_NOTIF_REQ          8
#define OP_CODE_RESPONSE_IN_DFU_MODE        16
#define OP_CODE_PKT_RCPT_NOTIF_IN_DFU_MODE  17

// dfu mode
#define MODE_DFU_UPDATE_SD 0X01
#define MODE_DFU_UPDATE_BL 0X02
#define MODE_DFU_UPDATE_APP 0X04

// dfu init flag
#define INIT_RX 0x00
#define INIT_COMPLETE 0x01

// dfu response state
#define RESPONSE_SUCCESS 0X01
#define RESPONSE_INVALID_STATE 0X02
#define RESPONSE_NOT_SUPPORTED 0X03
#define RESPONSE_DATA_SIZE_OVERFLOW 0X04
#define RESPONSE_CRC_ERROR 0X05
#define RESPONSE_OPERATION_FAIL 0X06

// dfu response procedure
#define PROC_START 0X01
#define PROC_INIT 0X02
#define PROC_RECEIVE_IMAGE 0X03
#define PROC_VALIDATE 0X04
#define PROC_ACTIVATE 0X05 // 这个状态不会由芯片返回
#define PROC_PKT_RCPT_REQ 0X08


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

@protocol BLBluetoothCommandManagerDelegate

@required
- (void)changeForLockState:(enum LockState)lockState;
- (void)changeForDoorState:(enum DoorState)doorState;

@end


@interface BLBluetoothCommandManager : NSObject

@property (nonatomic, strong) NSData *command;
@property (nonatomic,assign) id<BLBluetoothCommandManagerDelegate> delegate;

//app组装发送给蓝牙的命令
+ (NSData *)commandGetDisposableLockWord;
+ (NSData *)commandGetConstantLockWord;
+ (NSData *)commandVerifyDisposableLockKey:(const void *)key length:(Byte)length;
+ (NSData *)commandVerifyConstantLockKey:(const void *)key length:(Byte)length;
+ (NSData *)commandGetStates;
+ (NSData *)commandResetToDfuMode:(const void *)key length:(Byte)length;
+ (NSData *)commandGetAllVersions;
+ (NSData *)commandResetConstantLockWord;
+ (NSData *)commandSetDisposableEncryptWord;
+ (NSData *)commandSetConstantEncryptWord;
+ (NSData *)commandClearEncryptWords;

//+ (NSData *)command
//+ (NSData *)command

//app解析蓝牙发送的消息
- (void)readCommand:(NSData *)command;

@end