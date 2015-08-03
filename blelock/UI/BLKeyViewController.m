//
//  BLKeyViewController.m
//  blelock
//
//  Created by biliyuan on 15/7/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLKeyViewController.h"
#import "BLUserViewController.h"
@interface BLKeyViewController ()

@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UIView *operateUIView;
@property (nonatomic, strong) UIButton *operateUIButton;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UITableView *keyTableView;

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBService *service;
@property (nonatomic, strong) CBService *interestingService;
@property (nonatomic, strong) CBCharacteristic *interestingCharacteristic;


@end

@implementation BLKeyViewController

{
    NSArray *dataArray;
}

- (void)loadView {
    //Creates the view that the controller manages.
    CGRect frame = [UIScreen mainScreen].bounds;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navframe = self.navigationController.navigationBar.frame;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //导航栏
    
    [self.navigationController setNavigationBarHidden:YES];
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, rectStatus.size.height, frame.size.width, navframe.size.height)];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationItem setTitle:@"钥匙"];
    [_navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    //右边按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, navframe.size.height, navframe.size.height);
    [rightButton setBackgroundImage: [UIImage imageNamed : @"user.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(gotoBLUserView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    navigationItem.rightBarButtonItem = rightItem;
    
    //把导航栏集合添加入导航栏中，设置动画关闭
    [_navigationBar pushNavigationItem:navigationItem animated:NO];
    [view addSubview:_navigationBar];
    
    //操作区背景
    _operateUIView = [[UIView alloc] initWithFrame:CGRectMake(0, (rectStatus.size.height+navframe.size.height), frame.size.width, (frame.size.height-rectStatus.size.height-navframe.size.height)/2)];
    _operateUIView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:_operateUIView];
    
    //操作图标
    _operateUIButton = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-100)/2, (frame.size.height-_operateUIView.frame.size.height)/2-100, 100, 100)];
    [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"bluetooth.png"] forState:UIControlStateNormal];
    [_operateUIButton addTarget:self action:@selector(openBluetooth) forControlEvents:UIControlEventTouchUpInside];
    
    [_operateUIView addSubview:_operateUIButton];
   
    //操作提示
    _hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_operateUIButton.frame), frame.size.width, 44)];
    _hintLabel.text = @"点击这里打开蓝牙";
    _hintLabel.textColor = [UIColor whiteColor];
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    _hintLabel.font = [UIFont systemFontOfSize:14.0f];
    _hintLabel.backgroundColor = [UIColor clearColor];
    [_operateUIView addSubview:_hintLabel];
    
    //钥匙列表
    _keyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_operateUIView.frame), frame.size.width, _operateUIView.frame.size.height)];
    _keyTableView.backgroundColor = [UIColor whiteColor];
    [view addSubview:_keyTableView];

    //钥匙列表数据初始化
    _keyTableView.dataSource = self;
    _keyTableView.delegate = self;
    dataArray = [NSArray arrayWithObjects:@"翠苑四区",@"工商管理楼", @"土木科技楼", @"阿木的家", @"网易六楼", @"网易宿舍837", @"浙大玉泉", @"浙大紫金港", @"浙大西溪", @"浙大曹主", nil];
    [_keyTableView reloadData];
    
    self.view = view;
    
    //蓝牙
    
    
    
}


- (void)viewDidLoad
{
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
}




//导航栏里右按钮
- (void)gotoBLUserView
{
    BLUserViewController * blUserViewController = [[BLUserViewController alloc]init];
    [self.navigationController pushViewController: blUserViewController animated:YES];
}

//操作图标:打开蓝牙
- (void)openBluetooth
{
    NSLog(@"打开蓝牙");
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil]; //重点这里要建立委托
    NSLog(@"ok");
}

- (void) clickRightButton
{
    
}


//<UITableViewDataSource>里必须实现的
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //Tells the data source to return the number of rows in a given section of a table view. (required)
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Asks the data source for a cell to insert in a particular location of the table view. (required)
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //config the cell
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed : @"key.png"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


//<UITableViewDelegate>里实现的
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Asks the delegate for the height to use for a row in a specified location.
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Tells the delegate that the specified row is now selected.
    NSLog(@"%@", [dataArray objectAtIndex:indexPath.row]);
}

//蓝牙
//打开蓝牙，并扫描周边
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"蓝牙已打开,请扫描外设");
            [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"touch.png"] forState:UIControlStateNormal];
            _hintLabel.text = @"请触摸门锁上的灯";
            //扫描周边，要把第一个nil改掉
            [_manager scanForPeripheralsWithServices:nil options:nil];
            //找到门锁，关闭扫描以节约电源
            [_manager stopScan];
            NSLog(@"Scanning stopped");
            //链接门锁周边
            [_manager connectPeripheral:_peripheral options:nil];
            //确保周边的代理
            _peripheral.delegate = self;
            //发现周边的服务,要把nil改掉,UUID
            [_peripheral discoverServices:nil];
            //发现服务的特征,nil返回所有特征，可改成自己感兴趣的特征
            NSLog(@"Discovering characteristics for service %@", _interestingService);
            [_peripheral discoverCharacteristics: nil forService: _interestingService];
            //读取特征值
            NSLog(@"Reading value for characteristic %@", _interestingCharacteristic);
            [_peripheral readValueForCharacteristic: _interestingCharacteristic];
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
    NSData *data = characteristic.value;
    //parse the data as needed
}







@end