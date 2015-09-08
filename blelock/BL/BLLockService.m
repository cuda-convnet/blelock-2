//
//  BLLockService.m
//  blelock
//
//  Created by NetEase on 15/8/31.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLLockService.h"
#import "BLDiscovery.h"

NSString *kLockServiceUUIDString = @"d62a2015-7fac-a2a3-bec3-a68869e0f2bf";
NSString *kLockControlPointCharacteristicUUIDString = @"d62a9900-7fac-a2a3-bec3-a68869e0f2bf";
NSString *kLockControlPointDescriptorUUIDString = @"00002902-0000-1000-8000-00805f9b34fb";

@interface BLLockService() <CBPeripheralDelegate> {
@private
    CBPeripheral		*servicePeripheral;
    
    CBService			*lockService;
    
    CBCharacteristic    *lockControlPointCharacteristic;
    
    CBDescriptor        *lockDescriptor;
    
    CBUUID              *lockServiceUUID;
    CBUUID              *lockControlPointCharacteristicUUID;
    CBUUID              *lockDescriptorUUID;
    
    id<BLLockServiceProtocol>	peripheralDelegate;
}
@end



@implementation BLLockService

#pragma mark -
#pragma mark Init
/****************************************************************************/
/*								Init										*/
/****************************************************************************/
- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<BLLockServiceProtocol>)controller
{
    self = [super init];
    if (self) {
        servicePeripheral = peripheral;
        [servicePeripheral setDelegate:self];
        peripheralDelegate = controller;
        
        lockServiceUUID	= [CBUUID UUIDWithString:kLockServiceUUIDString];
        lockControlPointCharacteristicUUID = [CBUUID UUIDWithString:kLockControlPointCharacteristicUUIDString];
        lockDescriptorUUID = [CBUUID UUIDWithString:kLockControlPointDescriptorUUIDString];
    }
    return self;
}

#pragma mark -
#pragma mark Service interaction
/****************************************************************************/
/*							Service Interactions							*/
/****************************************************************************/
- (void) start {
    CBUUID	*serviceUUID	= [CBUUID UUIDWithString:kLockServiceUUIDString];
    NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID, nil];
    
    //[servicePeripheral discoverServices:serviceArray];
    [servicePeripheral discoverServices:nil];
    NSLog(@"寻找锁服务");
}

- (void) resetToDfuMode {
    //进入DFU模式
    NSLog(@"1.发送进入DFU模式命令");
    Byte keyBytes[] = {2,3,4,5,6,7,8,9,10,11,12,13,16,15,16,17};
    NSData *dataToDfu = [self commandResetToDfuMode:keyBytes length:16];
    [servicePeripheral writeValue:dataToDfu forCharacteristic:lockControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@"找到锁服务了");
    NSArray		*services	= nil;
    NSArray		*uuids	= [NSArray arrayWithObjects: lockControlPointCharacteristicUUID, nil];
    
    if (peripheral != servicePeripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    services = [peripheral services];
    if (!services || ![services count]) {
        return ;
    }
    
    lockService = nil;
    for (CBService *service in services) {
        NSLog(@"discovered characteristic %@", [service UUID]);
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kLockServiceUUIDString]]) {
            lockService = service;
            break;
        }
    }
    
    if (lockService) {
        [peripheral discoverCharacteristics:uuids forService:lockService];
    }
}


- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
{
    NSArray *characteristics = [service characteristics];
    CBCharacteristic *characteristic;
    
    if (peripheral != servicePeripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (service != lockService) {
        NSLog(@"Wrong Service.\n");
        return ;
    }
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    for (characteristic in characteristics) {
        NSLog(@"discovered characteristic %@", [characteristic UUID]);
        
        if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kLockControlPointCharacteristicUUIDString]]) {
            NSLog(@"Discovered lock Characteristic");
            lockControlPointCharacteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSLog(@"监听：%@", characteristic);
            //随便验证钥匙的命令
            Byte keyBytes[] = {2,3,4,5,6,7,8,9,10,11,12,13,16,15,16,17};
            NSData *dataToWrite = [self commandVerifyConstantLockKey:keyBytes length:16];
            [peripheral writeValue:dataToWrite forCharacteristic:lockControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
            
            
        }
    }
    
}

#pragma mark -
#pragma mark Characteristics interaction
/****************************************************************************/
/*						Characteristics Interactions						*/
/****************************************************************************/

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (peripheral != servicePeripheral) {
        NSLog(@"Wrong peripheral\n");
        return ;
    }
    
    if ([error code] != 0) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    NSData *data = characteristic.value;
    NSLog(@"收到的数据：%@", data);
    [self readCommand:data];
}


- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if ([error code] != 0) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    if ([characteristic.UUID isEqual:lockControlPointCharacteristic]) {
        NSLog(@"app发送给蓝牙命令写成功");
    }
}

//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
//    CBDescriptor *descriptor = [[CBDescriptor alloc]init];
//    for (descriptor in characteristic.descriptors) {
//        [peripheral readValueForDescriptor:descriptor];
//    }
//    
//}
//
//- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *) descriptor error:(NSError *)error {
//    NSData *data = descriptor.value;
//    NSLog(@"收到的descriptor数据：%@", data);
//}
//
#pragma mark -
#pragma mark Command
/****************************************************************************/
/*						            Command		  		            		*/
/****************************************************************************/
//app组装发送给蓝牙的命令
//获取一次性锁原语
- (NSData *)commandGetDisposableLockWord {
    Byte command[] = {OP_CODE_GET_DISPOSABLE_LOCK_WORD};
    NSData *data = [[NSData alloc] initWithBytes:command length:1];
    return data;
}

- (NSData *)commandGetConstantLockWord {
    Byte command[] = {OP_CODE_GET_CONSTANT_LOCK_WORD};
    NSData *data = [[NSData alloc] initWithBytes:command length:1];
    return data;
}

- (NSData *)commandVerifyDisposableLockKey:(const void *)key length:(Byte)length; {
    Byte command[] = {OP_CODE_VERIFY_DISPOSABLE_LOCK_KEY,length};
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:command length:2];
    [data appendBytes:key length:length];
    return [data copy];
}

- (NSData *)commandVerifyConstantLockKey:(const void *)key length:(Byte)length {
    Byte command[] = {OP_CODE_VERIFY_CONSTANT_LOCK_KEY,length};
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:command length:2];
    [data appendBytes:key length:length];
    return [data copy];
}

- (NSData *)commandGetStates {
    Byte command[] = {OP_CODE_GET_STATES};
    NSData *data = [[NSData alloc] initWithBytes:command length:1];
    return data;
}

- (NSData *)commandResetToDfuMode:(const void *)key length:(Byte)length; {
    Byte command[] = {OP_CODE_RESET_TO_DFU_MODE,length};
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:command length:2];
    [data appendBytes:key length:length];
    return [data copy];
}

- (NSData *)commandGetAllVersions {
    Byte command[] = {OP_CODE_GET_ALL_VERSIONS};
    NSData *data = [[NSData alloc] initWithBytes:command length:1];
    return data;
}

//清除加密原语
- (NSData *)commandClearEncryptWords {
    Byte command[] = {OP_CODE_CLEAR_ECNRYT_WORDS};
    NSData *data = [[NSData alloc] initWithBytes:command length:1];
    return data;
}

//读取蓝牙传给app的命令
- (void)readCommand:(NSData *)command {
    Byte *commandBytes = (Byte *)[command bytes];
    for (int i=0; i<command.length; i++) {
        NSLog(@"%d",commandBytes[i]);
    }
    if (command.length>0) {
        switch (commandBytes[0]) {
            case OP_CODE_RESPONSE_IN_LOCK_MODE: {
                NSLog(@"收到操作回应");
                [self readResponse:command];
                break;
            }
            case OP_CODE_NOTIFY_IN_LOCK_MODE: {
                NSLog(@"收到通知消息");
                [self readNotify:command];
                break;
            }
            default: {
                [self onUnknownNotificationReceived:command];
                break;

            }
        }

    } else {
        [self onUnknownNotificationReceived:command];
    }
}

- (void)readResponse:(NSData *)command{
    Byte *commandBytes = (Byte *)[command bytes];
    if (command.length>1) {
        
        switch (commandBytes[1]) {
            case OP_CODE_GET_DISPOSABLE_LOCK_WORD: {
                break;
            }
            case OP_CODE_GET_CONSTANT_LOCK_WORD: {
                break;
            }
            case OP_CODE_VERIFY_DISPOSABLE_LOCK_KEY: {
                break;
            }
            case OP_CODE_VERIFY_CONSTANT_LOCK_KEY: {
                break;
            }
            case OP_CODE_GET_STATES: {
                break;
            }
            case OP_CODE_RESET_TO_DFU_MODE: {
                if (command.length>3 && commandBytes[2]>0) {
                    switch (commandBytes[3]) {
                        case RESULT_SUCCESS:{
                            NSLog(@"2.收到通知：成功转换成DFU模式");
                            [[BLDiscovery sharedInstance] openDfuForTest];
                            //[[BLDiscovery sharedInstance] openDfu];
                            break;
                        }
                        default:
                            break;
                    }

                }
                break;
            }
            case OP_CODE_GET_ALL_VERSIONS: {
                break;
            }
            case OP_CODE_RESET_CONSTANT_LOCK_WORD: {
                break;
            }
            case OP_CODE_SET_DISPOSABLE_ENCRYPT_WORD: {
                break;
            }
            case OP_CODE_SET_CONSTANT_ENCRYPT_WORD: {
                break;
            }
            case OP_CODE_CLEAR_ECNRYT_WORDS: {
                break;
            }
            default:
                [self onUnknownNotificationReceived:command];
                break;
        }

    } else {
        [self onUnknownNotificationReceived:command];
    }
}

- (void)readNotify:(NSData *)command {
    Byte *commandBytes = (Byte *)[command bytes];
    if (command.length>1) {
        switch (commandBytes[1]) {
            case NOTIFY_OBJECT_DOOR: {
                NSLog(@"收到门状态");
                [self readNotifyObjectDoor:command];
                break;
            }
            case NOTIFY_OBJECT_LOCK: {
                NSLog(@"收到锁状态");
                [self readNotifyObjectLock:command];
                break;
            }
            case NOTIFY_OBJECT_BATTERY_LEVEL: {
                NSLog(@"收到电池状态");
                break;
            }
            case NOTIFY_OBJECT_FLASH: {
                NSLog(@"收到内存消息");
                break;
            }
            default:
                [self onUnknownNotificationReceived:command];
                break;
        }

    } else {
        [self onUnknownNotificationReceived:command];
    }

}

- (void)readNotifyObjectLock:(NSData *)command{
    Byte *commandBytes = (Byte *)[command bytes];
    if (command.length>3 && commandBytes[2]>0) {
        switch (commandBytes[3]) {
            case LOCK_STATE_UNLOCKED:
                [peripheralDelegate lockService:self changeForLockState:LOCK_IS_OPEN];
                break;
            case LOCK_STATE_LOCKED:
                [peripheralDelegate lockService:self changeForLockState:LOCK_IS_CLOSED];
                break;
            default:
                [self onUnknownNotificationReceived:command];
                break;
        }
    } else {
        [self onUnknownNotificationReceived:command];
    }
}

- (void)readNotifyObjectDoor:(NSData *)command{
    Byte *commandBytes = (Byte *)[command bytes];
    if (command.length>3 && commandBytes[2]>0) {
        switch (commandBytes[3]) {
            case DOOR_STATE_OPENED: {
                NSLog(@"门开了");
                [peripheralDelegate lockService:self changeForDoorState:DOOR_IS_OPEN];
                //访问服务器查看是否有新的固件
                [peripheralDelegate letUserControl:self];
                break;
            }
            case DOOR_STATE_CLOSED: {
                [peripheralDelegate lockService:self changeForDoorState:DOOR_IS_CLOSED];
                break;
            }
            default:
                [self onUnknownNotificationReceived:command];
                break;
        }
    } else {
        [self onUnknownNotificationReceived:command];
    }
}

- (void)onUnknownNotificationReceived:(NSData *)command{
    if(command == nil)
        return;
    NSString *commandString = [[NSString alloc] initWithData:command encoding:NSUTF8StringEncoding];
    NSLog(@"接受到一条不能理解的通知，内容是%@",commandString);
    // 异常情况要上报服务器
}



@end
