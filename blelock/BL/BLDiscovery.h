////
////  BLDiscovery.h
////  blelock
////
////  Created by NetEase on 15/8/28.
////  Copyright (c) 2015年 Netease. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <CoreBluetooth/CoreBluetooth.h>
//
//#import "BLService.h"
//
//
//
///****************************************************************************/
///*							UI protocols									*/
///****************************************************************************/
//@protocol BLDiscoveryDelegate <NSObject>
//- (void) discoveryDidRefresh;
//- (void) discoveryStatePoweredOff;
//@end
//
//
//
///****************************************************************************/
///*							Discovery class									*/
///****************************************************************************/
//@interface BLDiscovery : NSObject
//
//+ (id) sharedInstance;
//
//
///****************************************************************************/
///*								UI controls									*/
///****************************************************************************/
//@property (nonatomic, assign) id<BLDiscoveryDelegate>     discoveryDelegate;
//@property (nonatomic, assign) id<BLServiceProtocol>	      peripheralDelegate;
//
//
///****************************************************************************/
///*								Actions										*/
///****************************************************************************/
//- (void) startScanningForUUIDString:(NSString *)uuidString;
//- (void) stopScanning;
//
//- (void) connectPeripheral:(CBPeripheral*)peripheral;
//- (void) disconnectPeripheral:(CBPeripheral*)peripheral;
//
//
///****************************************************************************/
///*							Access to the devices							*/
///****************************************************************************/
//@property (retain, nonatomic) NSMutableArray    *foundPeripherals;
//@property (retain, nonatomic) NSMutableArray	*connectedServices;	// Array of LeTemperatureAlarmService
//@end
//
