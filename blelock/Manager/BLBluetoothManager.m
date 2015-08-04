//
//  BLBluetoothManager.m
//  blelock
//
//  Created by biliyuan on 15/8/3.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLBluetoothManager.h"


@interface BLBluetoothManager() <CBCentralManagerDelegate>


@end

@implementation BLBluetoothManager

@synthesize manager = _manager;
@synthesize peripheral = _peripheral;
@synthesize service = _service;
@synthesize interestingService = _interestingService;
@synthesize interestingCharacteristic = _interestingCharacteristic;


//蓝牙
//打开蓝牙，并扫描周边
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"蓝牙已打开,请扫描外设");
//            //[_operateUIButton setBackgroundImage: [UIImage imageNamed : @"touch.png"] forState:UIControlStateNormal];
//            //_hintLabel.text = @"请触摸门锁上的灯";
//            //首先并不是扫描，而是试图连接已经知道的周边，找不到再试图扫描，流程图如pdf48页。
//            //knownPeripherals = [_manager retrievePeripheralsWithIdentifiers:savedIdentifiers];
//            //[_manager connectPeripheral:_peripheral options:nil];
//            //链接建立后，自动调用didConnectPeripheral
//            //扫描周边，要把第一个nil改掉
//            [_manager scanForPeripheralsWithServices:nil options:nil];
//            //找到门锁，关闭扫描以节约电源
//            [_manager stopScan];
//            NSLog(@"Scanning stopped");
//            //链接门锁周边
//            [_manager connectPeripheral:_peripheral options:nil];
//            //确保周边的代理
//            //_peripheral.delegate = self;
//            //发现周边的服务,要把nil改掉,UUID
//            //太费电了,用这个代替
//            //[_peripheral discoverServices : @[firstServiceUUID, secondServiceUUID]];
//            [_peripheral discoverServices:nil];
//            //发现服务的特征,nil返回所有特征，可改成自己感兴趣的特征,太费电了换掉
//            NSLog(@"Discovering characteristics for service %@", _interestingService);
//            [_peripheral discoverCharacteristics: nil forService: _interestingService];
//            //读取特征值
//            NSLog(@"Reading value for characteristic %@", _interestingCharacteristic);
//            [_peripheral readValueForCharacteristic: _interestingCharacteristic];
//            //订阅周边特征值改变消息
//            [_peripheral setNotifyValue: YES forCharacteristic: _interestingCharacteristic];
//            //写特征值，这里的type:周边告诉APP写是否成功
//            NSLog(@"Writing value for characteristic %@", _interestingCharacteristic);
//            [_peripheral writeValue : _dataToWrite forCharacteristic : _interestingCharacteristic
//                               type : CBCharacteristicWriteWithResponse];
//            //开锁成功后，断开连接
//            [_manager cancelPeripheralConnection : _peripheral];

            break;
        }
        case CBCentralManagerStatePoweredOff:
            NSLog(@"蓝牙关闭...");
            break;
        default:
            NSLog(@"设备不支持BLE");
            break;
    }
}

//发现周边
- (void) centralManager : (CBCentralManager *) central
  didDiscoverPeripheral : (CBPeripheral *) peripheral
      advertisementData : (NSDictionary *) advertisementData
                   RSSI : (NSNumber *)RSSI
{
    NSLog(@"Discover %@", peripheral.name);
    //有问题需修改
    _peripheral = peripheral;
}

//（自动调取）蓝牙连接建立
- (void) centralManager : (CBCentralManager *) central
   didConnectPeripheral : (CBPeripheral *) peripheral
{
    NSLog(@"Peripheral connected");
}

//（自动调取）发现蓝牙服务
- (void) peripheral : (CBPeripheral *) peripheral
didDiscoverServices : (NSError *)error
{
    NSLog(@"Discovered service %@", _service);

}

//（自动调取）发现周边特征
- (void) peripheral : (CBPeripheral *) peripheral
didDiscoverCharacteristicsForService:(CBService *)service
                               error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"Discovered characteristic %@", characteristic);
    }
}

//（自动调取）读取周边特征
- (void) peripheral : (CBPeripheral *) peripheral
didUpdateValueForCharacteristic : (CBCharacteristic *)
           characteristic error : (NSError *)error
{
    //NSData *data = characteristic.value;
    //parse the data as needed
}

//（自动调取）订阅消息时发生的问题，特征值变了就会自动调用该方法
- (void) peripheral : (CBPeripheral *) peripheral
didUpdateNotificationStateForCharacteristic : (CBCharacteristic *)characteristic
                                      error : (NSError *)error
{
    if (error)
    {
        NSLog(@"Error changing notification state: %@", [error localizedDescription]);
    }
}

//（自动调用）周边反馈给App写是否成功
- (void) peripheral : (CBPeripheral *) peripheral
didWriteValueForCharacteristic : (CBCharacteristic *)characteristic
                         error : (NSError *)error
{
    if (error)
    {
        NSLog(@"Error writing characteristic value: %@", [error localizedDescription]);
    }

}

//(自动调用)断开连接
- (void) centralManager : (CBCentralManager *) central
didDisconnectPeripheral : (CBPeripheral *) peripheral
                  error : (NSError *) error
{

}



@end
