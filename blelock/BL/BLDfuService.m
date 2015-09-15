//
//  BLDfuService.m
//  blelock
//
//  Created by NetEase on 15/8/31.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLDfuService.h"
#import "BLDiscovery.h"

NSString *kDfuServiceUUIDString = @"00001530-1212-efde-1523-785feabcd123";
NSString *kDfuControlPointCharacteristicUUIDString = @"00001532-1212-efde-1523-785feabcd123";
NSString *kDfuPacketCharacteristicUUIDString = @"00001531-1212-efde-1523-785feabcd123";


@interface BLDfuService() <CBPeripheralDelegate> {
@private
    CBPeripheral		*servicePeripheral;
    
    CBService           *dfuService;
    
    CBCharacteristic    *dfuControlPointCharacteristic;
    CBCharacteristic    *dfuPacketCharacteristic;
    
    CBUUID              *dfuServiceUUID;
    CBUUID              *dfuControlPointCharacteristicUUID;
    CBUUID              *dfuPacketCharacteristicUUID;
    id<BLDfuServiceProtocol>	peripheralDelegate;
}
@end



@implementation BLDfuService

#pragma mark -
#pragma mark Init
/****************************************************************************/
/*								Init										*/
/****************************************************************************/
- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<BLDfuServiceProtocol>)controller
{
    NSLog(@"Dfu服务初始化");
    self = [super init];
    if (self) {
        servicePeripheral = peripheral;
        [servicePeripheral setDelegate:self];
        peripheralDelegate = controller;
        
        dfuServiceUUID = [CBUUID UUIDWithString:kDfuServiceUUIDString];
        dfuControlPointCharacteristicUUID = [CBUUID UUIDWithString:kDfuControlPointCharacteristicUUIDString];
        dfuPacketCharacteristicUUID = [CBUUID UUIDWithString:kDfuPacketCharacteristicUUIDString];
    }
    return self;
}

#pragma mark -
#pragma mark Service interaction
/****************************************************************************/
/*							Service Interactions							*/
/****************************************************************************/
- (void) start
{
    CBUUID	*serviceUUID	= [CBUUID UUIDWithString:kDfuServiceUUIDString];
    NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID, nil];
    NSLog(@"4.搜索Dfu服务");
    [servicePeripheral discoverServices:nil];
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray		*services	= nil;
    NSArray		*uuids	= [NSArray arrayWithObjects: dfuControlPointCharacteristicUUID, dfuPacketCharacteristicUUID, nil];
    
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
    
    dfuService = nil;
    
    for (CBService *service in services) {
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kDfuServiceUUIDString]]) {
            dfuService = service;
            NSLog(@"找到dfu服务了");
            break;
        }else {
            NSLog(@"找到其他服务");
        }
    }
    
    if (dfuService) {
        [peripheral discoverCharacteristics:uuids forService:dfuService];
    }
}


- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
{
    NSArray		*characteristics	= [service characteristics];
    CBCharacteristic *characteristic;
    
    if (peripheral != servicePeripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (service != dfuService) {
        NSLog(@"Wrong Service.\n");
        return ;
    }
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    for (characteristic in characteristics) {
        NSLog(@"discovered characteristic %@", [characteristic UUID]);
        
        if ([[characteristic UUID] isEqual:dfuControlPointCharacteristicUUID]) {
            NSLog(@"Discovered dfu cp Characteristic");
            dfuControlPointCharacteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSData *dataToWrite = [self commandStartDfuForModeOne];
            [peripheral writeValue:dataToWrite forCharacteristic:dfuControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
        } else if ([[characteristic UUID] isEqual:dfuPacketCharacteristicUUID]) {
            NSLog(@"Discovered dfu p Characteristic");
            dfuPacketCharacteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSData *dataToWrite = [self commandSendStartData];
            [peripheral writeValue:dataToWrite forCharacteristic:dfuPacketCharacteristic type:CBCharacteristicWriteWithResponse];
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
    if ([characteristic.UUID isEqual:dfuControlPointCharacteristic]) {
        NSLog(@"app发送给蓝牙命令写成功");
    }
}
#pragma mark -
#pragma mark Command
/****************************************************************************/
/*						            Command		  		            		*/
/****************************************************************************/
//cp
- (NSData *)commandStartDfuForModeOne {
    Byte command[] = {OP_CODE_START_DFU, MODE_DFU_UPDATE_APP};
    NSData *data = [[NSData alloc] initWithBytes:command length:2];
    return data;
}
//p



- (NSData *)commandSendStartData{
    
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"lock_a_release_1.01" ofType:@"bin"];
    NSLog(@"resourcePath: %@", resourcePath);
    NSData *resource = [[NSData alloc]initWithContentsOfFile:resourcePath];
    NSLog(@"%lu",(unsigned long)resource.length);
    NSString *size = [NSString stringWithFormat:@"%zd",resource.length];
    Byte command[] = {0X00,0X00};
    NSData *command2 = [size dataUsingEncoding:NSUTF16LittleEndianStringEncoding];
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:command length:8];
    [data appendData:command2];
    return [data copy];
     
    //NSString *filePath = [[NSBundle mainBundle] pathForResouse:@"lock_a_release_1.01" ofType:@"bin"];
    //NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
}

//读取蓝牙传给app的命令
- (void)readCommand:(NSData *)command {
    Byte *commandBytes = (Byte *)[command bytes];
    for (int i=0; i<command.length; i++) {
        NSLog(@"%d",commandBytes[i]);
    }
//    if (command.length>0) {
//        switch (commandBytes[0]) {
//            case OP_CODE_RESPONSE_IN_LOCK_MODE: {
//                NSLog(@"收到操作回应");
//                [self readResponse:command];
//                break;
//            }
//            case OP_CODE_NOTIFY_IN_LOCK_MODE: {
//                NSLog(@"收到通知消息");
//                [self readNotify:command];
//                break;
//            }
//            default: {
//                [self onUnknownNotificationReceived:command];
//                break;
//                
//            }
//        }
//        
//    } else {
//        [self onUnknownNotificationReceived:command];
//    }
}


@end
