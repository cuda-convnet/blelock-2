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
//#import "BLHouseViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
//
@interface BLKeyViewController()<UITableViewDelegate,  UITableViewDataSource, CBCentralManagerDelegate>

@property (nonatomic, strong) UIView *operateUIView;
@property (nonatomic, strong) UIButton *operateUIButton;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UITableView *keyTableView;
@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, assign) NSInteger blState;
@property (nonatomic, assign) NSInteger keyState;

//@property (nonatomic, strong) CBPeripheral *peripheral;
//@property (nonatomic, strong) CBService *service;
//@property (nonatomic, strong) CBService *interestingService;
//@property (nonatomic, strong) CBCharacteristic *interestingCharacteristic;
@end

@implementation BLKeyViewController
- (void)loadView {
    _tableArray = [[NSArray alloc]initWithObjects:@"翠苑四区", @"工商管理楼", @"土木科技楼", @"阿木的家", @"曹光彪主楼", @"网易六楼", @"网易宿舍837", @"浙大玉泉", nil];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithRed:238/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    //导航栏
    CGRect navframe = self.navigationController.navigationBar.frame;
    self.navigationItem.title = @"钥匙";
    //右边按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, navframe.size.height, navframe.size.height);
    [rightButton setBackgroundImage: [UIImage imageNamed : @"user.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(gotoBLUser) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    _operateUIView = [[UIView alloc] initWithFrame:CGRectZero];
    _operateUIView.backgroundColor = [UIColor colorWithRed:238/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    [view addSubview:_operateUIView];
    
    _operateUIButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"bluetooth.png"] forState:UIControlStateNormal];
    [_operateUIButton addTarget:self action:@selector(openBluetooth) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_operateUIButton];
    
    _hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _hintLabel.text = @"点击这里打开蓝牙";
    _hintLabel.textColor = [UIColor blackColor];
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    _hintLabel.font = [UIFont systemFontOfSize:16.0f];
    _hintLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:_hintLabel];

    //钥匙列表
    _keyTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _keyTableView.backgroundColor = [UIColor whiteColor];
    _keyTableView.dataSource = self;
    _keyTableView.delegate = self;
    [_keyTableView reloadData];
    [view addSubview:_keyTableView];
    
    self.view = view;
    
}

- (void)viewWillLayoutSubviews {
    
    CGRect rect = self.view.bounds;
    
    CGRect r1 = _operateUIView.frame;
    r1.origin.x = 0.0f;
    r1.origin.y = [self.topLayoutGuide length];
    r1.size.width = rect.size.width;
    r1.size.height = 250.0f;
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
    r4.size.height = rect.size.height-CGRectGetMaxY(_operateUIView.frame);
    _keyTableView.frame = r4;
    
}

- (void)viewDidLoad {
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
}

//<UITableViewDataSource>里必须实现的
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Tells the data source to return the number of rows in a given section of a table view. (required)
    return [_tableArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Asks the data source for a cell to insert in a particular location of the table view. (required)
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //config the cell
    NSString *a= [[NSString alloc]initWithString:[_tableArray objectAtIndex:indexPath.row]];
    cell.textLabel.text = a;
    cell.imageView.image = [UIImage imageNamed : @"key.png"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
//<UITableViewDelegate>里实现的
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Asks the delegate for the height to use for a row in a specified location.
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_keyTableView deselectRowAtIndexPath:indexPath animated:NO];
    //Tells the delegate that the specified row is now selected.
    //[self goToBLHouse:indexPath.row];
    //NSLog(@"%@", [self.data objectAtIndex:indexPath.row]);
}

//导航栏里右按钮
- (void)gotoBLUser {
    BLUserViewController * blUserViewController = [[BLUserViewController alloc]init];
    [self.navigationController pushViewController: blUserViewController animated:YES];
}
//操作区打开蓝牙
- (void)openBluetooth {
    _blState = 100;
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil]; //重点这里要建立委托
}

- (void)changeForBLState {
    //1——蓝牙打开了
    //0——蓝牙关闭着
    //-1——设备不支持BLE
    switch (self.blState) {
        case 1: {
            [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"touch.png"] forState:UIControlStateNormal];
            [_operateUIView setBackgroundColor: [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1]];
            _hintLabel.text = @"请触摸门锁上的灯";
            _hintLabel.textColor = [UIColor whiteColor];
            break;
        }
        case 0: {
            break;
        }
        case -1: {
            ///////////////用于测试
            [_operateUIButton setBackgroundImage:[UIImage imageNamed : @"touch.png"] forState:UIControlStateNormal];
            [_operateUIView setBackgroundColor:[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1]];
            _hintLabel.text = @"请触摸门锁上的灯";
            _hintLabel.textColor = [UIColor whiteColor];
            break;
        }
        default:
            break;
    }
}

- (void)changeForKeyState {
    //2——锁被打开
    //1——搜索到锁周边
    //0——附近没有锁
    //-1——锁打开失败
    switch (_keyState) {
        case 2: {
            [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"openLock.png"] forState:UIControlStateNormal];
            [_operateUIView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:139/255.0 blue:69/255.0 alpha:1]];
            _hintLabel.text = @"门锁已打开，请转动把手进门";
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitForSeconds) userInfo:nil repeats:NO];
            break;
        }
        case 1: {
            [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"connect.png"] forState:UIControlStateNormal];
            _hintLabel.text = @"连接中，请耐心等待";
            break;
        }
        case 0: {
            _hintLabel.text = @"附近没有锁";
            break;
        }
        case -1: {
            _hintLabel.text = @"您没有权限开这把锁";
            break;
        }
        default:
            break;
    }
}


////选择table
//- (void)goToBLHouseView:(NSInteger)rowNumber {
//    BLHouseViewController * blHouseViewController = [[BLHouseViewController alloc]initWithKey:[self.tableArray objectAtIndex:rowNumber]];
//    //要不要拿到外面去作为属性呢？？？？？？？外面又不要用，不用拿出去
//    [self.navigationController pushViewController: blHouseViewController animated:YES];
//    NSLog(@"%@", [self.tableArray objectAtIndex:rowNumber]);
//}
////////////////////////////////////////////////////////////////////////////////////////
////监听状态值的变化，执行一定的动作
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    NSArray *caseName = [NSArray arrayWithObjects: @"blState", @"keyState", nil];
//    NSUInteger index = [caseName indexOfObject:keyPath];
//    switch (index) {
//        case 0:
//            [self.blKeyView changeForBLState];
//            break;
//        case 1:
//            [self.blKeyView changeForKeyState];
//        default:
//            break;
//    }
//}
//蓝牙自动调用
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"前面");
    switch (central.state) {
        case CBCentralManagerStatePoweredOn: {
            NSLog(@"蓝牙已打开,请扫描外设");
            _blState = 1;
            break;
        }
        case CBCentralManagerStatePoweredOff: {
            NSLog(@"蓝牙关闭...");
            _blState = 0;
            break;
        }
        default: {
            NSLog(@"设备不支持BLE");
            _blState = -1;
            break;
        }
    }
    [self changeForBLState];
    ///////////为了测试
    if (_blState == 1 || _blState == -1) {
        [self bluetoothISOpen];
    }
}
//蓝牙相关操作
- (void)bluetoothISOpen {
    _keyState = 100;
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
    ////[NSThread sleepForTimeInterval:2.0];
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
- (void)hello1 {
    _keyState = 1;
    [self changeForKeyState];
}
- (void)hello2 {
    _keyState = 2;
    [self changeForKeyState];

}
- (void)waitForSeconds {
    [self.operateUIButton setBackgroundImage: [UIImage imageNamed : @"house.png"] forState:UIControlStateNormal];
    self.hintLabel.text = @"欢迎您！";
}

@end