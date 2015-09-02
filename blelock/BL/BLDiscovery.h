//
//  BLDiscovery.h
//  blelock
//
//  Created by NetEase on 15/8/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "BLLockService.h"
#import "BLDfuService.h"

enum Mode {
    MODE_UNCONNECTED = 0,
    MODE_NORMAL = 1,            // 正常模式
    MODE_DFU = 2             // 升级模式
};

//蓝牙状态
enum BluetoothState {
    BLUETOOTH_IS_OPEN = 0,
    BLUETOOTH_IS_CLOSED = 1,
    BLUETOOTH_NOT_SUPPORT = 2
};


/****************************************************************************/
/*							UI protocols									*/
/****************************************************************************/
@protocol BLDiscoveryDelegate <NSObject>

@required
- (void)changeForBluetoothState:(enum BluetoothState)bluetoothState;
- (void)discoveryDidRefresh;

@end



/****************************************************************************/
/*							Discovery class									*/
/****************************************************************************/
@interface BLDiscovery : NSObject

+ (id) sharedInstance;


/****************************************************************************/
/*								UI controls									*/
/****************************************************************************/
@property (nonatomic, assign) id<BLDiscoveryDelegate>        discoveryDelegate;
@property (nonatomic, assign) id<BLLockServiceProtocol> lockPeripheralDelegate;
@property (nonatomic, assign) id<BLDfuServiceProtocol>   dfuPeripheralDelegate;


/****************************************************************************/
/*								Actions										*/
/****************************************************************************/
- (BOOL) loadSavedDevices;
- (void) startScanningForServiceUUIDString:(NSString *)uuidString;
- (void) stopScanning;

- (void) connectPeripheral:(CBPeripheral*)per.ipheral;
- (void) disconnectPeripheral:(CBPeripheral*)peripheral;


/****************************************************************************/
/*							Access to the devices							*/
/****************************************************************************/
@property (assign, nonatomic) enum Mode mode;
@property (retain, nonatomic) NSMutableArray    *foundPeripherals;
@property (retain, nonatomic) NSMutableArray	*connectedServices;	// Array of BLLockService,BLDfuService
@end

