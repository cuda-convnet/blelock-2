//
//  BLBluetoothManager.m
//  blelock
//
//  Created by NetEase on 15/8/25.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLBluetoothManager.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import "BLBluetoothServer.h"

@interface BLBluetoothManager() <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *lockControlPointCharacteristic;
@property (nonatomic, strong) CBCharacteristic *dfuControlPointCharacteristic;
@property (nonatomic, strong) CBCharacteristic *dfuPacketCharacteristic;

@end

@implementation BLBluetoothManager

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static BLBluetoothManager *gInstance;
    dispatch_once(&onceToken, ^{
        gInstance = [[BLBluetoothManager alloc] init];
    });
    return gInstance;
    
}

- (void)openBluetooth {
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil]; //重点这里要建立委托
}

//自动调用:打开蓝牙
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOn: {
            NSLog(@"蓝牙已打开,请扫描外设");
            _bluetoothState = BLUETOOTH_IS_OPEN;
            [_delegate changeForBluetoothState:_bluetoothState];
            [self scanPeripheral];
            break;
        }
        case CBCentralManagerStatePoweredOff: {
            NSLog(@"蓝牙关闭");
            _bluetoothState = BLUETOOTH_IS_CLOSED;
            break;
        }
        case CBCentralManagerStateUnauthorized: {
            NSLog(@"未授权");
            break;
        }
        default: {
            NSLog(@"设备不支持BLE");
            _bluetoothState = BLUETOOTH_NOT_SUPPORT;
            break;
        }
    }
}


//扫描操作
- (void)scanPeripheral {
    NSLog(@"开始扫描周边");
    static NSString * const kServiceUUID = @"d62a2015-7fac-a2a3-bec3-a68869e0f2bf";
    [_manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kServiceUUID]]options:@{CBCentralManagerScanOptionAllowDuplicatesKey :@NO}];
    //30秒以后停止
    double delayInSeconds = 30.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds*NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_manager stopScan];//停止扫描
        NSLog(@"停止扫描。。");
    });
}

//自动调用：扫描外设
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"%@",peripheral.name);
    NSLog(@"%@",peripheral.identifier);
    NSLog(@"%@",[advertisementData description]);
//    //先得到里面所有的键值   objectEnumerator得到里面的对象  keyEnumerator得到里面的键值
    NSEnumerator * enumerator = [advertisementData keyEnumerator];//把keyEnumerator替换为objectEnumerator即可得到value值（1）
    
    //定义一个不确定类型的对象
    id object;
    //遍历输出
    while(object = [enumerator nextObject])
    {
        NSLog(@"键值为：%@",object);
        
        //在这里我们得到的是键值，可以通过（1）得到，也可以通过这里得到的键值来得到它对应的value值
        //通过NSDictionary对象的objectForKey方法来得到
        //其实这里定义objectValue这个对象可以直接用NSObject，因为我们已经知道它的类型了，id在不知道类型的情况下使用
        id objectValue = [advertisementData objectForKey:object];
        NSLog(@"%@所对应的value是 %@",object,objectValue);
//        if(objectValue != nil)
//        {
//            NSLog(@"%@所对应的value是 %@",object,objectValue);
//        }  
        
    }
    
    if([peripheral.name  isEqualToString:@"XXX UltraLock"]){
        _lockState = LOCK_IS_FIND;
        
        [_delegate changeForLockState:_lockState];
        [self connect:peripheral];
    }
    //超时设置_lockState = LOCK_NOT_FIND;
    
}

//连接操作
- (BOOL)connect:(CBPeripheral *)peripheral {
    _peripheral = peripheral;
    _peripheral.delegate = self;
    [_manager connectPeripheral:_peripheral options:nil];
    return YES;
}

//自动调用：成功连接锁
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"成功连接到周边: %@", peripheral);
    _lockState = LOCK_IS_CONNECT;
    [_delegate changeForLockState:_lockState];
    [_manager stopScan];
    [_peripheral discoverServices:nil];
}

//自动调用：未成功连接锁
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (error) {
        NSLog(@"未成功连接周边：%@，失败原因：%@", peripheral.name, [error localizedDescription]);
    }
    _lockState = LOCK_NOT_CONNECT;
    [_delegate changeForLockState:_lockState];
}

//自动调用：成功发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices");
    if (error)
    {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        
        //        if ([self.delegate respondsToSelector:@selector(DidNotifyFailConnectService:withPeripheral:error:)])
        //            [self.delegate DidNotifyFailConnectService:nil withPeripheral:nil error:nil];
        //
        //        return;
    }
    for (CBService *service in peripheral.services)
    {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"d62a2015-7fac-a2a3-bec3-a68869e0f2bf"]])
        {
            NSLog(@"Service found with UUID: %@", service.UUID);
            [peripheral discoverCharacteristics:nil forService:service];
            break;
        }
        
    }
}

//自动调用：成功发现特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    //    if (error)
    //    {
    //        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
    //
    //        [self error];
    //        return;
    //    }
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        //发现特征
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"d62a9900-7fac-a2a3-bec3-a68869e0f2bf"]]) {
            _lockControlPointCharacteristic = characteristic;
            NSLog(@"监听：%@", _lockControlPointCharacteristic);
            [self.peripheral setNotifyValue:YES forCharacteristic:_lockControlPointCharacteristic];
            //随便验证钥匙的命令
            Byte keyBytes[] = {2,3,4,5,6,7,8,9,10,11,12,13,16,15,16,17};
            NSData *dataToWrite1 = [BLBluetoothCommandManager commandVerifyConstantLockKey:keyBytes length:16];
            [self.peripheral writeValue:dataToWrite1 forCharacteristic:_lockControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
        }
        
    }
}

//自动调用：成功写特征值，app传达给蓝牙
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
}

//自动调用：收到蓝牙传来的消息
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    //    if (error)
    //    {
    //        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
    //        self.error_b = BluetoothError_System;
    //        [self error];
    //        return;
    //    }
    NSData *data = characteristic.value;
    NSLog(@"收到的数据：%@", data);
    BLBluetoothCommandManager *blBluetoothCommandManager = [[BLBluetoothCommandManager alloc]init];
    [blBluetoothCommandManager readCommand:data];
//    _lockState = LOCK_IS_OPEN;
//    [_delegate changeForLockState:_lockState];
    
//    _doorState = DOOR_IS_OPEN;
//    [_delegate changeForDoorState:_doorState];
    //[self decodeData:characteristic.value];
}


@end
