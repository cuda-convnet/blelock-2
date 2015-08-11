//
//  BLKeyViewController.m
//  blelock
//
//  Created by biliyuan on 15/7/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//


#import "BLKeyViewController.h"
#import "BLUserViewController.h"
#import "BLHouseViewController.h"
#import "BLKeyView.h"
#import "BLKey.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface BLKeyViewController () <BLKeyViewDelegate, CBCentralManagerDelegate>

@property (nonatomic, strong) BLKeyView *blKeyView;
@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBService *service;
@property (nonatomic, strong) CBService *interestingService;
@property (nonatomic, strong) CBCharacteristic *interestingCharacteristic;

@property (nonatomic, strong) BLKey *blKey;

@end

@implementation BLKeyViewController

- (void) loadView {
    self.blKeyView = [[BLKeyView alloc] initWithCaller:self];
    
    BLKey * key1 = [[BLKey alloc]init];
    BLKey * key2 = [[BLKey alloc]init];
    BLKey * key3 = [[BLKey alloc]init];
    BLKey * key4 = [[BLKey alloc]init];
    BLKey * key5 = [[BLKey alloc]init];
    BLKey * key6 = [[BLKey alloc]init];
    BLKey * key7 = [[BLKey alloc]init];
    BLKey * key8 = [[BLKey alloc]init];
    
    key1.alias = @"翠苑四区";
    key2.alias = @"工商管理楼";
    key3.alias = @"土木科技楼";
    key4.alias = @"阿木的家";
    key5.alias = @"曹光彪主楼";
    key6.alias = @"网易六楼";
    key7.alias = @"网易宿舍837";
    key8.alias = @"浙大玉泉";
    
    
    //时间处理
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //钥匙掌管者
    BLUser *user = [[BLUser alloc]init];
    user.Id = 1999;
    user.name = @"林小志";
    user.gender = @"男";
    user.headerImageId = @"lin.png";
    BLShareTo *shareTo = [[BLShareTo alloc]init];
    shareTo.Id = 103;
    shareTo.maxTimes = 10;
    shareTo.expiredDate = [dateFormatter dateFromString:@"2015-08-10 14:09:01"];
    shareTo.owner = [[BLUser alloc]init];
    shareTo.owner.Id = 1994;
    shareTo.owner.name = @"郭石头";
    shareTo.owner.mobile = @"135*****7774";
    shareTo.owner.headerImageId = @"guo.png";
    //钥匙
    BLVersion *version = [[BLVersion alloc]init];
    version.Id = 1;
    version.major = 1;
    version.minor = 1;
    BLLockType *type = [[BLLockType alloc]init];
    type.Id = 1;
    type.version = version;
    BLLock *lock = [[BLLock alloc]init];
    lock.Id = 45;
    lock.gapAddress = @"DB:2C:AA:DD:27:2A";
    lock.type = type;
    //房屋
    BLHouse *house = [[BLHouse alloc]init];
    
    key1.Id = 102;
    key1.maxTimes = 10;
    key1.usedTimes = 2;
    key1.expiredDate = [dateFormatter dateFromString:@"2015-09-30 23:59:59"];
    key1.sharedFrom = user;
    key1.shareTo = [NSArray arrayWithObjects:shareTo, nil];
    key1.lock = lock;
    key1.lock.constantKeyWord = @"1aa1rfagqtsagjytemm";
    key1.lock.constantKeyWordExpiredDate = [dateFormatter dateFromString:@"2015-04-03 16:00:00"];
    key1.lock.house = house;
    key1.lock.house.Id = 1223;
    key1.lock.house.inaccurateAddress = @"杭州市西湖区求是村";
    
    self.tableArray = [NSArray arrayWithObjects:key1, key2, key3, key4, key5, key6, key7, key8, nil];
    self.blKeyView.data = self.tableArray;
    
    [self.blKeyView addObserver:self forKeyPath:@"blState" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self.blKeyView addObserver:self forKeyPath:@"keyState" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
//////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////
    /////////////////////就是这里有问题
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
    //要不要拿到外面去作为属性呢？？？？？？？外面又不要用，不用拿出去
    [self.navigationController pushViewController: blUserViewController animated:YES];
}

//操作区打开蓝牙
- (void) openBluetoothView
{
    self.blKeyView.blState = 100;
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil]; //重点这里要建立委托
}

//选择table

- (void) goToBLHouseView: (NSInteger) rowNumber
{
    BLHouseViewController * blHouseViewController = [[BLHouseViewController alloc]init];
    //要不要拿到外面去作为属性呢？？？？？？？外面又不要用，不用拿出去
    [self.navigationController pushViewController: blHouseViewController animated:YES];
    NSLog(@"%@", [self.tableArray objectAtIndex:rowNumber]);
    
}

//////////////////////////////////////////////////////////////////////////////////////
//监听状态值的变化，执行一定的动作
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSArray *caseName = [NSArray arrayWithObjects: @"blState", @"keyState", nil];
    NSUInteger index = [caseName indexOfObject:keyPath];
    switch (index) {
        case 0:
            [self.blKeyView changeForBLState];
            break;
        case 1:
            [self.blKeyView changeForKeyState];
        default:
            break;
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
//    int a=0;
//    for(int i=0;i<100000;i++)
//    {
//        for (int b=0; b<10000; b++) {
//            a=a+i-b;
//        }
//    }
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hello1) userInfo:nil repeats:NO];
     // self.blKeyView.keyState = 1;
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
   

    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hello2) userInfo:nil repeats:NO];
    //self.blKeyView.keyState = 2;
//    //开锁成功后，断开连接
    
//    [_manager cancelPeripheralConnection : _peripheral];
    
}
///用于测试
-(void) hello1
{
    NSLog(@"bly");
    self.blKeyView.keyState = 1;
}
-(void) hello2
{
    NSLog(@"bly");
    self.blKeyView.keyState = 2;
}
- (void) dealloc
{
    //KVO释放
    [self removeObserver:self forKeyPath:@"blState"];
    [self removeObserver:self forKeyPath:@"keyState"];
    
}
@end