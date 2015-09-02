//
//  BLDfuService.h
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
extern NSString *kDfuServiceUUIDString;                         // 00001530-1212-efde-1523-785feabcd123     Service UUID
extern NSString *kDfuControlPointCharacteristicUUIDString;      // 00001532-1212-efde-1523-785feabcd123
extern NSString *kDfuPacketCharacteristicUUIDString;            //00001531-1212-efde-1523-785feabcd123


/****************************************************************************/
/*								Protocol									*/
/****************************************************************************/
@class BLDfuService;

@protocol BLDfuServiceProtocol<NSObject>
//- (void) alarmServiceDidChangeStatus:(BLService*)service;
@end


/****************************************************************************/
/*						Dfu service.                          */
/****************************************************************************/
@interface BLDfuService : NSObject

- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<BLDfuServiceProtocol>)controller;
- (void) start;

@property (readonly) CBPeripheral *peripheral;
@end
