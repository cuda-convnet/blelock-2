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
        _peripheral = peripheral;
        [_peripheral setDelegate:self];
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
    
    [servicePeripheral discoverServices:serviceArray];
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSArray		*services	= nil;
    NSArray		*uuids	= [NSArray arrayWithObjects: lockControlPointCharacteristicUUID, nil];
    
    if (peripheral != _peripheral) {
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
    
    if (peripheral != _peripheral) {
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
        
        if ([[characteristic UUID] isEqual:lockControlPointCharacteristic]) {
            NSLog(@"Discovered lock Characteristic");
            lockControlPointCharacteristic = characteristic;
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

//- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
//{
//    if (peripheral != servicePeripheral) {
//        NSLog(@"Wrong peripheral\n");
//        return ;
//    }
//    
//    if ([error code] != 0) {
//        NSLog(@"Error %@\n", error);
//        return ;
//    }
//    
//    /* Temperature change */
//    if ([[characteristic UUID] isEqual:lockControlPointCharacteristic]) {
//        [peripheralDelegate alarmServiceDidChangeTemperature:self];
//        return;
//    }
//    
//}
//
//- (void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
//{
//    /* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
//    [peripheral readValueForCharacteristic:characteristic];
//    
//    /* Upper or lower bounds changed */
//    if ([characteristic.UUID isEqual:lockControlPointCharacteristic]) {
//        [peripheralDelegate alarmServiceDidChangeTemperatureBounds:self];
//    }
//}
@end
