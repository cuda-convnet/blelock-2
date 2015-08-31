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
    MODE_UNCONNECTED,
    MODE_NORMAL,            // 正常模式
    MODE_DFU             // 升级模式
};

/****************************************************************************/
/*							UI protocols									*/
/****************************************************************************/
@protocol BLDiscoveryDelegate <NSObject>
- (void) discoveryDidRefresh;
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
- (void) startScanningForUUIDString:(NSString *)uuidString;
- (void) stopScanning;

- (void) connectPeripheral:(CBPeripheral*)peripheral;
- (void) disconnectPeripheral:(CBPeripheral*)peripheral;


/****************************************************************************/
/*							Access to the devices							*/
/****************************************************************************/
@property (assign, nonatomic) enum Mode mode;
@property (retain, nonatomic) NSMutableArray    *foundPeripherals;
@property (retain, nonatomic) NSMutableArray	*connectedServices;	// Array of BLLockService,BLDfuService
@end

