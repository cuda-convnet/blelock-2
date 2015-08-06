//
//  BLKeyViewController.m
//  blelock
//
//  Created by biliyuan on 15/7/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//


#import "BLKeyViewController.h"
#import "BLUserViewController.h"
#import "BLKeyView.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLKeyViewController () <BLKeyViewDelegate, CBCentralManagerDelegate>
{
    CBCentralManager *_manager;
    CBPeripheral *_peripheral;
    CBService *_service;
    CBService *_interestingService;
    CBCharacteristic *_interestingCharacteristic;
    
    NSArray *_tableArray;
    
}

@property (nonatomic, strong) BLKeyView *blKeyView;

//蓝牙操作：延迟实例化
@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBService *service;
@property (nonatomic, strong) CBService *interestingService;
@property (nonatomic, strong) CBCharacteristic *interestingCharacteristic;

//加载数据：延迟实例化
@property (nonatomic, strong) NSArray *tableArray;

@end

@implementation BLKeyViewController

@synthesize blKeyView = _blKeyView;
@dynamic manager, peripheral, service,interestingService, interestingCharacteristic, tableArray;


- (void) loadView {
    
    self.blKeyView = [[BLKeyView alloc] initWithCaller:self];
    //self.tableArray = [NSArray arrayWithObjects:@"翠苑四区",@"工商管理楼", @"土木科技楼", @"阿木的家", @"网易六楼", @"网易宿舍837", @"浙大玉泉", @"浙大紫金港", @"浙大西溪", @"浙大曹主", nil];
    //self.blKeyView.data = self.tableArray;
    
    [self.blKeyView addObserver:self forKeyPath:@"blState" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self.blKeyView addObserver:self forKeyPath:@"keyState" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self.navigationController setNavigationBarHidden:YES];
    self.view = self.blKeyView;

}

- (void) viewDidLoad
{
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
}




//导航栏里右按钮
- (void) gotoBLUserView
{
    BLUserViewController * blUserViewController = [[BLUserViewController alloc]init];
    //要不要拿到外面去作为属性呢？？？？？？？
    [self.navigationController pushViewController: blUserViewController animated:YES];
}

//操作区打开蓝牙
- (void) openBluetoothView
{
    self.blKeyView.blState = 100;
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil]; //重点这里要建立委托
    NSLog(@"后面");
}


//////////////////////////////////////////////////////////////////////////////////////
//监听状态值的变化，执行一定的动作
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"blState"])
    {
        [self.blKeyView changeForBLState];
    }else if([keyPath isEqualToString:@"keyState"])
    {
        [self.blKeyView changeForKeyState];
    }
}



//蓝牙自动调用
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"前面");
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"蓝牙已打开,请扫描外设");
            self.blKeyView.blState = 1;
            [self bluetoothISOpen];
            break;
        }
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"蓝牙关闭...");
            self.blKeyView.blState = 0;
            
            break;
        }
        default:
        {
            NSLog(@"设备不支持BLE");
            self.blKeyView.blState = -1;
            ///////////为了测试
            [self bluetoothISOpen];
            break;
        }
    }
}

//蓝牙相关操作
- (void) bluetoothISOpen
{
    self.blKeyView.keyState = 100;
//    //高级功能：首先并不是扫描，而是试图连接已经知道的周边，找不到再试图扫描，流程图如pdf48页。
//    //knownPeripherals = [_manager retrievePeripheralsWithIdentifiers:savedIdentifiers];
//    //[_manager connectPeripheral:_peripheral options:nil];
//    //链接建立后，自动调用didConnectPeripheral
//    //扫描周边，要把第一个nil改掉
//    [_manager scanForPeripheralsWithServices:nil options:nil];
//    //找到门锁，关闭扫描以节约电源
//    [_manager stopScan];
//    NSLog(@"Scanning stopped");
    int a=0;
    for(int i=0;i<100000;i++)
    {
        for (int b=0; b<10000; b++) {
            a=a+i-b;
        }
    }

      self.blKeyView.keyState = 1;
//    //连接门锁周边
//    [_manager connectPeripheral:_peripheral options:nil];
//    //确保周边的代理
//    //问题////////////////////////////////////////////////////////////////////////////////////////////
//    _peripheral.delegate = self;
//    //发现周边的服务,要把nil改掉,UUID
//    //太费电了,用这个代替
//    //[_peripheral discoverServices : @[firstServiceUUID, secondServiceUUID]];
//    [_peripheral discoverServices:nil];
//    //发现服务的特征,nil返回所有特征，可改成自己感兴趣的特征,太费电了换掉
//    NSLog(@"Discovering characteristics for service %@", _interestingService);
//    [_peripheral discoverCharacteristics: nil forService: _interestingService];
//    //读取特征值
//    NSLog(@"Reading value for characteristic %@", _interestingCharacteristic);
//    [_peripheral readValueForCharacteristic: _interestingCharacteristic];
//    //订阅周边特征值改变消息
//    [_peripheral setNotifyValue: YES forCharacteristic: _interestingCharacteristic];
//    //写特征值，这里的type:周边告诉APP写是否成功
//    NSLog(@"Writing value for characteristic %@", _interestingCharacteristic);
//    //[_peripheral writeValue : _dataToWrite forCharacteristic : _interestingCharacteristic
//    //                   type : CBCharacteristicWriteWithResponse];
    int c=0;
    for(int i=0;i<100000;i++)
    {
        for (int b=0; b<10000; b++) {
            c=c+i-b;
        }
    }

    self.blKeyView.keyState = 2;
//    //开锁成功后，断开连接
//    [_manager cancelPeripheralConnection : _peripheral];
    
}

////////////////////////////////////////////////////////////////
//延迟实例化的对象实现set&get
- (CBCentralManager *) manager
{
    if (_manager == nil) _manager = [[CBCentralManager alloc]init];
    return _manager;
}

- (void) setManager:(CBCentralManager *)manager
{
    _manager = manager;
}

- (CBPeripheral *) peripheral
{
    if (_peripheral == nil) _peripheral = [[CBPeripheral alloc]init];
    return _peripheral;
}

- (void) setPeripheral:(CBPeripheral *)peripheral
{
    _peripheral = peripheral;
}

- (CBService *) service
{
    if (_service == nil) _service = [[CBService alloc]init];
    return _service;
}

- (void) setService:(CBService *)service
{
    _service = service;
}

- (CBService *) interestingService
{
    if (_interestingService == nil) _interestingService = [[CBService alloc] init];
    return _interestingService;
}

- (void) setInterestingService:(CBService *)interestingService
{
    _interestingService = interestingService;
}

- (CBCharacteristic *) interestingCharacteristic
{
    if (_interestingCharacteristic == nil) _interestingCharacteristic = [[CBCharacteristic alloc]init];
    return _interestingCharacteristic;
}

- (void) setInterestingCharacteristic:(CBCharacteristic *)interestingCharacteristic
{
    _interestingCharacteristic = interestingCharacteristic;
}

- (NSArray *) tableArray
{
    if (_tableArray == nil) _tableArray = [[NSArray alloc]init];
    return _tableArray;
}

- (void) setTableArray:(NSArray *)tableArray
{
    _tableArray = tableArray;
}












@end