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
NSString *kDfuControlPointCharacteristicUUIDString = @"00001531-1212-efde-1523-785feabcd123";
NSString *kDfuPacketCharacteristicUUIDString = @"00001532-1212-efde-1523-785feabcd123";


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
    Byte                procedure;
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
//            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//            NSData *dataToWrite = [self commandSendStartData];
//            [peripheral writeValue:dataToWrite forCharacteristic:dfuPacketCharacteristic type:CBCharacteristicWriteWithoutResponse];
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
//    if ([error code] != 0) {
//        NSLog(@"Error %@\n", error);
//        return ;
//    }
    if ([characteristic.UUID isEqual:dfuControlPointCharacteristicUUID]) {
        NSLog(@"cp命令写成功");
        if (procedure == PROC_FIRST) {
            [servicePeripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSData *dataToWrite = [self commandSendStartData];
            [servicePeripheral writeValue:dataToWrite forCharacteristic:dfuPacketCharacteristic type:CBCharacteristicWriteWithoutResponse];
        } else if (procedure == PROC_START) {
            NSData *dataToWrite = [self commandSendInitData];
            [servicePeripheral writeValue:dataToWrite forCharacteristic:dfuPacketCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }
        

    } else if ([characteristic.UUID isEqual:dfuPacketCharacteristicUUID]) {
        NSLog(@"p命令写成功");
    }
}
#pragma mark -
#pragma mark Command
/****************************************************************************/
/*						            Command		  		            		*/
/****************************************************************************/
//cp
- (NSData *)commandStartDfuForModeOne {
    NSLog(@"命令：StartDfuForModeOne");
    procedure = PROC_FIRST;
    Byte command[] = {OP_CODE_START_DFU, MODE_DFU_UPDATE_APP};
    NSData *data = [[NSData alloc] initWithBytes:command length:2];
    return data;
}

- (NSData *)commandReceiveInit {
    NSLog(@"命令：ReceiveInit");
    Byte command[] = {OP_CODE_RECEIVE_INIT, INIT_RX};
    NSData *data = [[NSData alloc] initWithBytes:command length:2];
    return data;
}

//p
- (NSData *)commandSendStartData {
    NSLog(@"命令：SendStartData");
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"lock_a_release_1.01" ofType:@"bin"];
    NSLog(@"resourcePath: %@", resourcePath);
    NSData *resource = [[NSData alloc]initWithContentsOfFile:resourcePath];
    NSLog(@"%lu",(unsigned long)resource.length);
    //转成16进制
    NSString *hexString = [self ToHex:resource.length];
    NSLog(@"hexString:%@", hexString);
    //补零
    NSString *hexStringWithZero = [self addZero:hexString length:8];
    NSLog(@"hexStringWithZero:%@", hexStringWithZero);
    //转成little
    NSString *hexStringWithLittle = [self changeToLittleEndian:hexStringWithZero];
    NSLog(@"hexStringWithLittle:%@", hexStringWithLittle);
    //补零
    NSString *hexStringWithZero2 = [self addZero:hexStringWithLittle length:24];
    NSLog(@"hexStringWithZero2:%@", hexStringWithZero2);
    NSLog(@"%@", [self hexToBytes:hexStringWithZero2]);
    return [self hexToBytes:hexStringWithZero2];
}

- (NSDate *)commandSendInitData {
    NSLog(@"命令：SendInitData");
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"lock_a_release_1.01" ofType:@"bin"];
    NSLog(@"resourcePath: %@", resourcePath);
    NSData *resource = [[NSData alloc]initWithContentsOfFile:resourcePath];
    Byte *resourceByte = (Byte *)[resource bytes];
    short crc = [self crc16_compute:resourceByte size:resource.length];
    NSString *hexString = [self ToHex:crc];
    NSString *hexStringWithZero = [self addZero:hexString length:4];
    NSData *crcData = [self hexToBytes:hexStringWithZero];
    NSLog(@"%d",crc);
    Byte command[] = {0X0C, 0X00, 0X00, 0X0C, 0X00, 0X00, 0X00, 0X00, 1, 67, 0 };
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:command length:12];
    [data appendData:crcData];
    NSLog(@"data:%@",data);
    return [data copy];
}



//读取蓝牙传给app的命令
- (void)readCommand:(NSData *)command {
    Byte *commandBytes = (Byte *)[command bytes];
    for (int i=0; i<command.length; i++) {
        NSLog(@"%d",commandBytes[i]);
    }
    if (command.length>0) {
        switch (commandBytes[0]) {
            case OP_CODE_RESPONSE_IN_DFU_MODE: {
                NSLog(@"收到DFU操作回应");
                [self readResponse:command];
                break;
            }
            case OP_CODE_PKT_RCPT_NOTIF_IN_DFU_MODE: {
                NSLog(@"收到DFU通知消息");
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

- (void)readResponse:(NSData *)command {
    Byte *commandBytes = (Byte *)[command bytes];
    if (command.length>2) {
        switch (commandBytes[1]) {
            //阶段
            case PROC_START: {
                NSLog(@"阶段：开始");
                switch (commandBytes[2]) {
                    case RESPONSE_SUCCESS:{
                        NSLog(@"成功");
                        procedure = PROC_START;
                        NSData *dataToWrite = [self commandReceiveInit];
                        [servicePeripheral writeValue:dataToWrite forCharacteristic:dfuControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
                        break;
                    }
                    case RESPONSE_INVALID_STATE:
                        NSLog(@"状态无效");
                        break;
                    case RESPONSE_NOT_SUPPORTED:
                        NSLog(@"不支持");
                        break;
                    case RESPONSE_DATA_SIZE_OVERFLOW:
                        NSLog(@"数据尺寸溢出");
                        break;
                    case RESPONSE_CRC_ERROR:
                        NSLog(@"CRC错误");
                        break;
                    case RESPONSE_OPERATION_FAIL:
                        NSLog(@"操作失败");
                        break;
                    default:
                        break;
                }
                break;
            }
            case PROC_INIT: {
                NSLog(@"阶段：初始化");
                break;
            }
            case PROC_RECEIVE_IMAGE: {
                NSLog(@"阶段：收到图片");
                break;
            }
            case PROC_VALIDATE: {
                NSLog(@"阶段：验证");
                break;
            }
            case PROC_ACTIVATE: {
                NSLog(@"阶段：活跃");
                break;
            }
            case PROC_PKT_RCPT_REQ: {
                NSLog(@"阶段：拒绝请求");
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

- (void)readNotify:(NSData *)command {
    Byte *commandBytes = (Byte *)[command bytes];
    if (command.length>4) {
        NSLog(@"当前接收到的字节数：%d%d%d%d", commandBytes[1], commandBytes[2], commandBytes[3],commandBytes[4]);
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

//工具方法
- (NSString *)ToHex:(uint16_t)tmpid {
    NSString *nLetterValue;
    NSString *str = @"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig) {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

//补零到需要的长度
- (NSString *)addZero:(NSString *)str length:(NSInteger)length {
    
    while (str.length < length) {
        str = [@"0" stringByAppendingString:str];
    }
    NSLog(@"%@",str);
    return str;
}

- (NSString *)changeToLittleEndian:(NSString *)str {
    NSString *resultStr = @"";
    for (int i = 0; i<str.length; i=i+2) {
        NSString *tmp = [str substringWithRange:NSMakeRange(str.length-i-2, 2)];
        resultStr = [resultStr stringByAppendingString:tmp];
        
    }
    NSLog(@"%@",resultStr);
    return resultStr;
}
//16进制转成字节数组
- (NSData*) hexToBytes:(NSString *)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

-(uint16_t) crc16_compute:(const uint8_t *)p_data size:(uint32_t) size {
    uint32_t i;
    uint16_t crc = 0xffff;
    for (i = 0; i < size; i++){
        crc  = (unsigned char)(crc >> 8) | (crc << 8);
        crc ^= p_data[i];
        crc ^= (unsigned char)(crc & 0xff) >> 4;
        crc ^= (crc << 8) << 4;
        crc ^= ((crc & 0xff) << 4) << 1;
    }
    return crc;
}


@end
