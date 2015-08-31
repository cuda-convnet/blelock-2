//
//  BLDiscovery.m
//  blelock
//
//  Created by NetEase on 15/8/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLDiscovery.h"

@interface BLDiscovery () <CBCentralManagerDelegate, CBPeripheralDelegate> {
    CBCentralManager    *centralManager;
    BOOL				pendingInit;
}
@end


@implementation BLDiscovery

#pragma mark -
#pragma mark Init
/****************************************************************************/
/*									Init									*/
/****************************************************************************/
+ (id) sharedInstance
{
    static dispatch_once_t onceToken;
    static BLDiscovery *gInstance;
    dispatch_once(&onceToken, ^{
        gInstance = [[BLDiscovery alloc] init];
    });
    return gInstance;
}

- (id) init
{
    self = [super init];
    if (self) {
        pendingInit = YES;
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        
        _foundPeripherals = [[NSMutableArray alloc] init];
        _connectedServices = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Restoring
/****************************************************************************/
/*								Settings									*/
/****************************************************************************/
/* Reload from file. */
- (void) loadSavedDevices
{
    NSArray	*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
    
    if (![storedDevices isKindOfClass:[NSArray class]]) {
        NSLog(@"No stored array to load");
        return;
    }
    CBPeripheral	*peripheral;
    NSArray *peripherals = [NSArray array];
    peripherals = [centralManager retrievePeripheralsWithIdentifiers:storedDevices];
    /* Add to list. */
    for (peripheral in peripherals) {
        [centralManager connectPeripheral:peripheral options:nil];
    }
    [_discoveryDelegate discoveryDidRefresh];
}


- (void) addSavedDevice:(NSUUID *)identifier
{
    NSArray			*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
    NSMutableArray	*newDevices		= nil;
    
    if (![storedDevices isKindOfClass:[NSArray class]]) {
        NSLog(@"Can't find/create an array to store the identifier");
        return;
    }
    
    newDevices = [NSMutableArray arrayWithArray:storedDevices];
    if (identifier) {
        [newDevices addObject:(NSUUID *)identifier];
    }
    /* Store */
    [[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//剩余次数=0就从列表删除
- (void) removeSavedDevice:(NSUUID *)identifier
{
    NSArray			*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
    NSMutableArray	*newDevices		= nil;
    
    if ([storedDevices isKindOfClass:[NSArray class]]) {
        newDevices = [NSMutableArray arrayWithArray:storedDevices];
        
        if (identifier) {
            [newDevices removeObject:(NSUUID *)identifier];
        }
        /* Store */
        [[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark -
#pragma mark Discovery
/****************************************************************************/
/*								Discovery                                   */
/****************************************************************************/
- (void) startScanningForServiceUUID:(NSString *)uuidString
{
    NSArray			*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:uuidString], nil];
    NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [centralManager scanForPeripheralsWithServices:uuidArray options:options];
}


- (void) stopScanning
{
    [centralManager stopScan];
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //根据设备名和gap地址进行排除和找钥匙
    NSLog(@"%@",peripheral.name);
    if (![_foundPeripherals containsObject:peripheral]) {
        [_foundPeripherals addObject:peripheral];
        [_discoveryDelegate discoveryDidRefresh];
    }
}

#pragma mark -
#pragma mark Connection/Disconnection
/****************************************************************************/
/*						Connection/Disconnection                            */
/****************************************************************************/
- (void) connectPeripheral:(CBPeripheral*)peripheral
{
    if (!peripheral.state) {
        [centralManager connectPeripheral:peripheral options:nil];
    }
}


- (void) disconnectPeripheral:(CBPeripheral*)peripheral
{
    [centralManager cancelPeripheralConnection:peripheral];
}


- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (_mode == MODE_NORMAL ) {
        BLLockService *service = nil;
        /* Create a service instance. */
        service = [[BLLockService alloc] initWithPeripheral:peripheral controller:_lockPeripheralDelegate];
        [service start];
        
        if (![_connectedServices containsObject:service])
            [_connectedServices addObject:service];
        
        if ([_foundPeripherals containsObject:peripheral])
            [_foundPeripherals removeObject:peripheral];
        
        //[_lockPeripheralDelegate alarmServiceDidChangeStatus:service];
        [_discoveryDelegate discoveryDidRefresh];
        
    } else if (_mode == MODE_DFU) {
        BLDfuService *service = nil;
        service = [[BLDfuService alloc] initWithPeripheral:peripheral controller:_dfuPeripheralDelegate];
        [service start];
        
        if (![_connectedServices containsObject:service])
            [_connectedServices addObject:service];
        
        if ([_foundPeripherals containsObject:peripheral])
            [_foundPeripherals removeObject:peripheral];
        
       // [_dfuPeripheralDelegate alarmServiceDidChangeStatus:service];
        [_discoveryDelegate discoveryDidRefresh];

    }
    
}


- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Attempted connection to peripheral %@ failed: %@", [peripheral name], [error localizedDescription]);
}


- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
//    LeTemperatureAlarmService	*service	= nil;
//    
//    for (service in _connectedServices) {
//        if ([service peripheral] == peripheral) {
//            [_connectedServices removeObject:service];
//            [peripheralDelegate alarmServiceDidChangeStatus:service];
//            break;
//        }
//    }
//    
//    [discoveryDelegate discoveryDidRefresh];
}


- (void) clearDevices
{
//    LeTemperatureAlarmService	*service;
//    [foundPeripherals removeAllObjects];
//    
//    for (service in connectedServices) {
//        [service reset];
//    }
//    [connectedServices removeAllObjects];
}

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    static CBCentralManagerState previousState = -1;
    
    switch ([centralManager state]) {
        case CBCentralManagerStatePoweredOn: {
            NSLog(@"蓝牙已打开,请扫描外设");
//            _bluetoothState = BLUETOOTH_IS_OPEN;
//            [_delegate changeForBluetoothState:_bluetoothState];
//            [self scanPeripheral];
            pendingInit = NO;
            [self loadSavedDevices];
            //[centralManager retrievePeripheralsWithIdentifiers:<#(NSArray *)#>];
            [_discoveryDelegate discoveryDidRefresh];
            break;
        }
        case CBCentralManagerStatePoweredOff: {
            NSLog(@"蓝牙关闭");
            //_bluetoothState = BLUETOOTH_IS_CLOSED;
            [self clearDevices];
            [_discoveryDelegate discoveryDidRefresh];
            break;
        }
            
        case CBCentralManagerStateUnauthorized:{
            NSLog(@"未授权");
            break;
        }
            
        case CBCentralManagerStateUnsupported: {
            NSLog(@"设备不支持BLE");
            //_bluetoothState = BLUETOOTH_NOT_SUPPORT;
            break;
        }
            
        case CBCentralManagerStateUnknown: {
            NSLog(@"Bad news, let's wait for another event.");
            break;
        }
            
        case CBCentralManagerStateResetting:
        {
            //[self clearDevices];
            [_discoveryDelegate discoveryDidRefresh];
            //[_peripheralDelegate alarmServiceDidReset];
            
            pendingInit = YES;
            break;
        }
        
        default: {
            NSLog(@"error with ble");
            break;
        }
    }
    
    previousState = [centralManager state];
}
@end

