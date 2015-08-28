////
////  BLKeyViewController.m
////  blelock
////
////  Created by biliyuan on 15/7/28.
////  Copyright (c) 2015年 Netease. All rights reserved.
////
//
//
#import "BLKeyViewController.h"
#import "BLUserViewController.h"
#import "BLHouseViewController.h"
//#import <CoreBluetooth/CoreBluetooth.h>
#import "BLBluetoothManager.h"
#import "BLBluetoothCommandManager.h"
#import "UIViewController+Utils.h"
//
@interface BLKeyViewController()<UITableViewDelegate,  UITableViewDataSource, BLBluetoothManagerDelegate, BLBluetoothCommandManagerDelegate>

@property (nonatomic, strong) UIView *operateUIView;
@property (nonatomic, strong) UIButton *operateUIButton;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UITableView *keyTableView;
//@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, assign) NSInteger blState;
@property (nonatomic, assign) NSInteger keyState;

@property (nonatomic, strong) NSMutableArray *keyTable;

//@property (nonatomic, strong) CBPeripheral *peripheral;
//@property (nonatomic, strong) NSMutableArray *peripheralArray;
//@property (nonatomic, strong) CBService *service;
//@property (nonatomic, strong) CBService *interestingService;
//@property (nonatomic, strong) CBCharacteristic *interestingCharacteristic;
@end

@implementation BLKeyViewController
- (void)loadView {
    //数据初始化
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    BLKey *key = [[BLKey alloc]init];
    key.Id = 123;
    key.alias = @"翠苑四区";
    key.lock = [[BLLock alloc]init];
    key.lock.house = [[BLHouse alloc]init];
    key.lock.house.inaccurateAddress = @"杭州市西湖区文一路";
    key.owner = [[BLUser alloc]init];
    key.owner.img = @"lin.jpg";
    key.owner.name = @"林小志";
    key.owner.mobile = @"135***4245";
    key.expiredDate = [dateFormatter dateFromString:@"2015-07-14"];
    key.maxTimes = 20;
    key.usedTimes = 10;
    
    BLKey *key1 = [[BLKey alloc]init];
    key1.alias = @"阿木的家";
    BLKey *key2 = [[BLKey alloc]init];
    key2.alias = @"工商管理楼";
    BLKey *key3 = [[BLKey alloc]init];
    key3.alias = @"土木科技楼";
    BLKey *key4 = [[BLKey alloc]init];
    key4.alias = @"曹光彪主楼";
    BLKey *key5 = [[BLKey alloc]init];
    key5.alias = @"网易六楼";
    BLKey *key6 = [[BLKey alloc]init];
    key6.alias = @"浙大玉泉";
    
    _keyTable = [[NSMutableArray alloc] initWithObjects:key, key1, key2, key3, key4, key5 ,key6, nil];
    UIView *view = [UIViewController customView:CGRectZero andBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"钥匙";
    
    //导航栏按钮
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nor_user"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBLUser)];
    
    self.navigationItem.leftBarButtonItem = navLeftButton;
    self.navigationItem.rightBarButtonItem = navRightButton;
    
    _operateUIView = [UIViewController customView:CGRectZero andBackgroundColor:BLGray];
    
    _operateUIButton = [UIViewController customButton:CGRectZero andImg:@"bluetooth"];
    [_operateUIButton addTarget:self action:@selector(openBluetooth) forControlEvents:UIControlEventTouchUpInside];
    
    _hintLabel = [UIViewController customLabel:CGRectZero andText:@"点击这里打开蓝牙" andColor:[UIColor blackColor] andFont:16.0f];
    
    _keyTableView = [UIViewController customTableView:CGRectZero andDelegate:self];
    [_keyTableView reloadData];
    
    [view addSubview:_operateUIView];
    [view addSubview:_operateUIButton];
    [view addSubview:_hintLabel];
    [view addSubview:_keyTableView];
    
    self.view = view;
    
}

- (void)viewWillLayoutSubviews {
    
    CGRect rect = self.view.bounds;
    
    CGRect r1 = _operateUIView.frame;
    r1.origin.x = 0.0f;
    r1.origin.y = 64.0f;
    r1.size.width = rect.size.width;
    r1.size.height = rect.size.height/2;
    _operateUIView.frame = r1;
    
    CGRect r2 = _operateUIButton.frame;
    r2.origin.x = rect.size.width/2-50.0f;
    r2.origin.y = CGRectGetMidY(_operateUIView.frame)-50.0f;
    r2.size.width = 100.0f;
    r2.size.height = 100.0f;
    _operateUIButton.frame = r2;
    
    CGRect r3 = _hintLabel.frame;
    r3.origin.x = 0.0f;
    r3.origin.y = CGRectGetMaxY(_operateUIButton.frame);
    r3.size.width = rect.size.width;
    r3.size.height = 44.0f;
    _hintLabel.frame = r3;
    
    CGRect r4 = _keyTableView.frame;
    r4.origin.x = 0.0f;
    r4.origin.y = CGRectGetMaxY(_operateUIView.frame);
    r4.size.width = rect.size.width;
    r4.size.height = _keyTable.count*44.0f;
    _keyTableView.frame = r4;
    
}

- (void)viewDidLoad {
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoBLUser {
    BLUserViewController * blUserViewController = [[BLUserViewController alloc]init];
    [self.navigationController pushViewController: blUserViewController animated:YES];
}


//<UITableViewDataSource>里必须实现的
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Tells the data source to return the number of rows in a given section of a table view. (required)
    return [_keyTable count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Asks the data source for a cell to insert in a particular location of the table view. (required)
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //config the cell
    cell.textLabel.text = [[NSString alloc]initWithString:((BLKey *)_keyTable[indexPath.row]).alias];
    cell.imageView.image = [UIImage imageNamed : @"key"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
//<UITableViewDelegate>里实现的
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Asks the delegate for the height to use for a row in a specified location.
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_keyTableView deselectRowAtIndexPath:indexPath animated:NO];
    //Tells the delegate that the specified row is now selected.
    [self goToBLHouse:indexPath.row];
    //NSLog(@"%@", [self.data objectAtIndex:indexPath.row]);
}



//操作区打开蓝牙
- (void)openBluetooth {
    BLBluetoothManager *blBluetoothManager = [BLBluetoothManager sharedInstance];
    blBluetoothManager.delegate = self;
    BLBluetoothCommandManager *blBluetoothCommandManager = [[BLBluetoothCommandManager alloc]init];
    blBluetoothCommandManager.delegate = self;
    [blBluetoothManager openBluetooth];
}

//选择table
- (void)goToBLHouse:(NSInteger)row {
    BLHouseViewController * blHouseViewController = [[BLHouseViewController alloc]initWithKey:(BLKey *)_keyTable[row]];
    [self.navigationController pushViewController: blHouseViewController animated:YES];
}

//BLBluetoothManager代理方法
- (void)changeForBluetoothState:(enum BluetoothState)bluetoothState {
    switch (bluetoothState) {
        case BLUETOOTH_IS_OPEN: {
            [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"touch.png"] forState:UIControlStateNormal];
            [_operateUIView setBackgroundColor: BLBlue];
            _hintLabel.text = @"请触摸门锁上的灯";
            _hintLabel.textColor = [UIColor whiteColor];
            break;
        }
        case BLUETOOTH_IS_CLOSED: {
            _hintLabel.text = @"蓝牙关闭，请打开";
            break;
        }
        case BLUETOOTH_NOT_SUPPORT: {
            ///////////////用于测试
            [_operateUIButton setBackgroundImage:[UIImage imageNamed : @"bluetooth"] forState:UIControlStateNormal];
            [_operateUIView setBackgroundColor:[UIColor redColor]];
            _hintLabel.text = @"很抱歉，设备不支持BLE";
            _hintLabel.textColor = [UIColor whiteColor];
            break;
        }
        default:
            break;
    }
}

- (void)changeForLockState:(enum LockState)lockState {
   
    switch (lockState) {
        case LOCK_IS_FIND: {
            [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"connect.jpg"] forState:UIControlStateNormal];
            _hintLabel.text = @"连接中，请耐心等待";
            break;
        }
        case LOCK_NOT_FIND: {
            _hintLabel.text = @"附近没有锁";
            break;
        }
        case LOCK_IS_CONNECT: {
            _hintLabel.text = @"连接成功，正在尝试开锁";
            break;
        }
        case LOCK_NOT_CONNECT: {
            _hintLabel.text = @"连接失败";
            break;
        }
        case LOCK_IS_OPEN: {
            [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"openLock"] forState:UIControlStateNormal];
            [_operateUIView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:139/255.0 blue:69/255.0 alpha:1]];
            _hintLabel.text = @"门锁已打开，请转动把手进门";
            break;
        }
        case LOCK_IS_CLOSED: {
            _hintLabel.text = @"您没有权限开这把锁";
            break;
        }
        default:
            break;
    }
}

- (void)changeForDoorState:(enum DoorState)doorState {
    
    switch (doorState) {
        case DOOR_IS_OPEN: {
            [self.operateUIButton setBackgroundImage: [UIImage imageNamed : @"house.png"] forState:UIControlStateNormal];
            self.hintLabel.text = @"欢迎您！";
            break;
        }
        case DOOR_IS_CLOSED: {
            _hintLabel.text = @"门还没开!";
            break;
        }
        default:
            break;
    }
}

////蓝牙相关操作
//- (void)bluetoothISOpen {
//    _keyState = 100;
//    [_manager scanForPeripheralsWithServices:nil options:nil];
//    //[_peripheral discoverServices:nil];
////    //高级功能：首先并不是扫描，而是试图连接已经知道的周边，找不到再试图扫描，流程图如pdf48页。
////    //knownPeripherals = [_manager retrievePeripheralsWithIdentifiers:savedIdentifiers];
//      //[_manager connectPeripheral:_peripheral options:nil];
////    //链接建立后，自动调用didConnectPeripheral
//    //扫描周边，要把第一个nil改掉
////    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
//
//    //[_manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"d62a2015-7fac-a2a3-bec3-a68869e0f2bf"]] options:nil];
////    //找到门锁，关闭扫描以节约电源
////
////    NSLog(@"Scanning stopped");
////    int a=0;
////    for(int i=0;i<100000;i++)
////    {
////        for (int b=0; b<10000; b++) {
////            a=a+i-b;
////        }
////    }
//    ////[NSThread sleepForTimeInterval:2.0];
//   // [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hello1) userInfo:nil repeats:NO];
//     // self.blKeyView.keyState = 1;
////    //连接门锁周边
////    [_manager connectPeripheral:_peripheral options:nil];
////    //确保周边的代理
////    //问题////////////////////////////////////////////////////////////////////////////////////////////
////    _peripheral.delegate = self;
////    //发现周边的服务,要把nil改掉,UUID
////    //太费电了,用这个代替
//     //[_peripheral discoverServices : @[firstServiceUUID, secondServiceUUID]];
//    //[_peripheral discoverServices:nil];
////    //发现服务的特征,nil返回所有特征，可改成自己感兴趣的特征,太费电了换掉
////    NSLog(@"Discovering characteristics for service %@", _interestingService);
////    [_peripheral discoverCharacteristics: nil forService: _interestingService];
////    //读取特征值
////    NSLog(@"Reading value for characteristic %@", _interestingCharacteristic);
////    [_peripheral readValueForCharacteristic: _interestingCharacteristic];
////    //订阅周边特征值改变消息
////    [_peripheral setNotifyValue: YES forCharacteristic: _interestingCharacteristic];
////    //写特征值，这里的type:周边告诉APP写是否成功
////    NSLog(@"Writing value for characteristic %@", _interestingCharacteristic);
////    //[_peripheral writeValue : _dataToWrite forCharacteristic : _interestingCharacteristic
////    //                   type : CBCharacteristicWriteWithResponse];
//    //[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hello2) userInfo:nil repeats:NO];
//    //self.blKeyView.keyState = 2;
////    //开锁成功后，断开连接
////    [_manager cancelPeripheralConnection : _peripheral];
//}
//

@end