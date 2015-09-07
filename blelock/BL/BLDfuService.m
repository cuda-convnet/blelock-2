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
        }else if([[service UUID] isEqual:[CBUUID UUIDWithString:kLockServiceUUIDString]]) {
            NSLog(@"5.找到服务了:%@",service);
        }else {
            NSLog(@"5.找到其他服务");
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
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
        } else if ([[characteristic UUID] isEqual:dfuPacketCharacteristicUUID]) {
            NSLog(@"Discovered dfu p Characteristic");
            dfuPacketCharacteristic = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
        }
    }
}



#pragma mark -
#pragma mark Characteristics interaction
/****************************************************************************/
/*						Characteristics Interactions						*/
/****************************************************************************/


#pragma mark -
#pragma mark Command
/****************************************************************************/
/*						            Command		  		            		*/
/****************************************************************************/

@end
