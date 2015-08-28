//
//  BLBluetoothCommandManager.m
//  blelock
//
//  Created by NetEase on 15/8/25.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLBluetoothCommandManager.h"
#import "BLBluetoothServer.h"

@interface BLBluetoothCommandManager()



@end

@implementation BLBluetoothCommandManager
//获取一次性锁原语
+ (NSData *)commandGetDisposableLockWord {
    Byte command[] = {OP_CODE_GET_DISPOSABLE_LOCK_WORD};
    NSData *data = [[NSData alloc] initWithBytes:command length:1];
    return data;
}

+ (NSData *)commandGetConstantLockWord {
    Byte command[] = {OP_CODE_GET_CONSTANT_LOCK_WORD};
    NSData *data = [[NSData alloc] initWithBytes:command length:1];
    return data;
}

+ (NSData *)commandVerifyDisposableLockKey:(const void *)key length:(Byte)length; {
    Byte command[] = {OP_CODE_VERIFY_DISPOSABLE_LOCK_KEY,length};
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:command length:2];
    [data appendBytes:key length:length];
    return [data copy];
}

+ (NSData *)commandVerifyConstantLockKey:(const void *)key length:(Byte)length {
    Byte command[] = {OP_CODE_VERIFY_CONSTANT_LOCK_KEY,length};
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:command length:2];
    [data appendBytes:key length:length];
    return [data copy];
}

+ (NSData *)commandGetStates {
    Byte command[] = {OP_CODE_GET_STATES};
    NSData *data = [[NSData alloc] initWithBytes:command length:1];
    return data;
}

+ (NSData *)commandResetToDfuMode:(const void *)key length:(Byte)length; {
    Byte command[] = {OP_CODE_RESET_TO_DFU_MODE,length};
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:command length:2];
    [data appendBytes:key length:length];
    return [data copy];
}

+ (NSData *)commandGetAllVersions {
    Byte command[] = {OP_CODE_GET_ALL_VERSIONS};
    NSData *data = [[NSData alloc] initWithBytes:command length:1];
    return data;
}

//清除加密原语
+ (NSData *)commandClearEncryptWords {
    Byte command[] = {OP_CODE_CLEAR_ECNRYT_WORDS};
    NSData *data = [[NSData alloc] initWithBytes:command length:1];
    return data;
}

- (void)readCommand:(NSData *)command {
    Byte *commandBytes = (Byte *)[command bytes];
    if (command.length>0) {
        switch (commandBytes[0]) {
            case OP_CODE_RESPONSE_IN_LOCK_MODE: {
                [self readResponse:command];
                break;
            }
            case OP_CODE_NOTIFY_IN_LOCK_MODE: {
                [self readNotify:command];
                break;
            }
            default: {
                [BLBluetoothServer onUnknownNotificationReceived:command];
                break;

            }
        }

    } else {
        [BLBluetoothServer onUnknownNotificationReceived:command];
    }
    //    for(int i=0;i<[command length];i++)
//        printf("testByte = %d\n",commandByte[i]);
}

- (void)readResponse:(NSData *)command{
    Byte *commandBytes = (Byte *)[command bytes];
    if (command.length>1) {
        switch (commandBytes[1]) {
            case OP_CODE_GET_DISPOSABLE_LOCK_WORD: {
                //处理
                break;
            }
                
                
                
            default:
                [BLBluetoothServer onUnknownNotificationReceived:command];
                break;
        }

    } else {
        [BLBluetoothServer onUnknownNotificationReceived:command];
    }
}

- (void)readNotify:(NSData *)command{
    Byte *commandBytes = (Byte *)[command bytes];
    if (command.length>1) {
        switch (commandBytes[1]) {
            case NOTIFY_OBJECT_LOCK: {
                //[BLBluetoothServer onLockStateChanged:LOCK_IS_OPEN];
                break;
            }
            default:
                //[BLBluetoothServer onUnknownNotificationReceived:command];
                break;
        }
        
    } else {
        [BLBluetoothServer onUnknownNotificationReceived:command];
    }

}

- (void)readNotifyObjectLock:(NSData *)command{
    Byte *commandBytes = (Byte *)[command bytes];
    if (command.length>2) {
        switch (commandBytes[2]) {
            case LOCK_STATE_UNLOCKED:
                [_delegate changeForLockState:LOCK_IS_OPEN];
                //[BLBluetoothServer onLockStateChanged:LOCK_IS_OPEN];
                break;
            case LOCK_STATE_LOCKED:
                //[BLBluetoothServer onLockStateChanged:LOCK_IS_CLOSED];
                break;
            default:
                //[BLBluetoothServer onUnknownNotificationReceived:command];
                break;
        }
    } else {
        [BLBluetoothServer onUnknownNotificationReceived:command];
    }
}
@end