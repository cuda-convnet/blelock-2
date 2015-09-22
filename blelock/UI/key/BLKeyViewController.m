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
#import "UIViewController+Utils.h"
#import "BLDiscovery.h"
#import "BLLockService.h"
#import "BLDfuService.h"
//
@interface BLKeyViewController()<UITableViewDelegate,  UITableViewDataSource, BLDiscoveryDelegate, BLLockServiceProtocol, BLDfuServiceProtocol>

@property (nonatomic, strong) UIView *operateUIView;
@property (nonatomic, strong) UIButton *operateUIButton;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UITableView *keyTableView;
@property (nonatomic, strong) UIProgressView *progressView;
//@property (nonatomic, assign) NSInteger blState;
//@property (nonatomic, assign) NSInteger keyState;

@property (nonatomic, strong) NSMutableArray *keyTable;

@property (nonatomic, strong) BLLockService *currentDisplayService;
@property (nonatomic, strong) NSMutableArray *connectedServices;

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
    
    _operateUIButton = [UIViewController customButton:CGRectZero andImg:@"bluetooth_black"];
    _operateUIButton.tag = 0;
    [_operateUIButton addTarget:self action:@selector(openBluetoothOrDfu:) forControlEvents:UIControlEventTouchUpInside];
    
    _hintLabel = [UIViewController customLabel:CGRectZero andText:@"点击这里打开蓝牙" andColor:[UIColor blackColor] andFont:16.0f];
    
    _keyTableView = [UIViewController customTableView:CGRectZero andDelegate:self];
    [_keyTableView reloadData];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    _progressView.hidden = YES;
    
    [view addSubview:_operateUIView];
    [view addSubview:_operateUIButton];
    [view addSubview:_progressView];
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
    
    CGRect r5 = _progressView.frame;
    r5.origin.x = rect.size.width/2-100.0f;
    r5.origin.y = CGRectGetMaxY(_hintLabel.frame)+20.0f;
    r5.size.width = 200.0f;
    r5.size.height = 20.0f;
    _progressView.frame = r5;
}

- (void)viewDidLoad {
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
    [[BLDiscovery sharedInstance] setDiscoveryDelegate:self];
    [[BLDiscovery sharedInstance] setLockPeripheralDelegate:self];
    [[BLDiscovery sharedInstance] setDfuPeripheralDelegate:self];
    
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
- (void)openBluetoothOrDfu:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        [[BLDiscovery sharedInstance] setDiscoveryDelegate:self];
        [[BLDiscovery sharedInstance] setLockPeripheralDelegate:self];
        [[BLDiscovery sharedInstance] setDfuPeripheralDelegate:self];
        [[BLDiscovery sharedInstance] openBluetooth];
    }else if (button.tag == 1) {
        NSLog(@"dfu模式已经准备进入");
        
        [_currentDisplayService resetToDfuMode];
        
    }
    
    
}


//选择table
- (void)goToBLHouse:(NSInteger)row {
    BLHouseViewController * blHouseViewController = [[BLHouseViewController alloc]initWithKey:(BLKey *)_keyTable[row]];
    [self.navigationController pushViewController: blHouseViewController animated:YES];
}

#pragma mark -
#pragma mark BLDiscoveryDelegate
/****************************************************************************/
/*                       BLDiscoveryDelegate Methods                        */
/****************************************************************************/
- (void)discoveryDidRefresh {
    [_keyTableView reloadData];
}

- (void)changeForBluetoothState:(enum BluetoothState)bluetoothState {
    switch (bluetoothState) {
        case BLUETOOTH_IS_OPEN: {
            NSLog(@"mode:%d",((BLDiscovery *)[BLDiscovery sharedInstance]).mode);
            if (((BLDiscovery *)[BLDiscovery sharedInstance]).mode == MODE_DFU) {
                //进入DFU模式
                NSLog(@"1.开始扫描dfu");
                [[BLDiscovery sharedInstance] startScanningForServiceUUIDString:kDfuServiceUUIDString];
            } else {
                [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"touch.png"] forState:UIControlStateNormal];
                [_operateUIView setBackgroundColor: BLBlue];
                _hintLabel.text = @"请触摸门锁上的灯";
                _hintLabel.textColor = [UIColor whiteColor];
                //进入Lock模式
                [[BLDiscovery sharedInstance] setMode:MODE_NORMAL];
                [[BLDiscovery sharedInstance] setKeys:_keyTable];
                if (![[BLDiscovery sharedInstance] loadSavedDevices]) {
                    [[BLDiscovery sharedInstance] startScanningForServiceUUIDString:kLockServiceUUIDString];
                };
                [self discoveryDidRefresh];
            }
            break;
        }
        case BLUETOOTH_IS_CLOSED: {
            _hintLabel.text = @"蓝牙关闭，请打开";
            break;
        }
        case BLUETOOTH_NOT_SUPPORT: {
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
            [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"bluetooth_white.jpg"] forState:UIControlStateNormal];
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
            [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"unlock"] forState:UIControlStateNormal];
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

/****************************************************************************/
/*				BLLockServiceProtocol Delegate Methods					*/
/****************************************************************************/
- (void) lockService:(BLLockService *)service changeForLockState:(enum LockState)lockState {
    //if (![service isEqual:currentlyDisplayingService])
        //return;
    switch (lockState) {
        case LOCK_IS_FIND: {
            [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"bluetooth_white"] forState:UIControlStateNormal];
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
            [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"unlock"] forState:UIControlStateNormal];
            [_operateUIView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:139/255.0 blue:69/255.0 alpha:1]];
            _hintLabel.text = @"门锁已打开，请转动把手进门";
            break;
        }
        case LOCK_IS_CLOSED: {
            //_hintLabel.text = @"门锁关闭";
            break;
        }
        default:
            break;
    }

}

- (void)lockService:(BLLockService *)service changeForDoorState:(enum DoorState)doorState {
    switch (doorState) {
        case DOOR_IS_OPEN: {
            [self.operateUIButton setBackgroundImage: [UIImage imageNamed : @"house"] forState:UIControlStateNormal];
            self.hintLabel.text = @"欢迎您！";
            break;
        }
        case DOOR_IS_CLOSED: {
            //_hintLabel.text = @"门还没开!";
            break;
        }
        default:
            break;
    }

}

- (void)letUserControl:(BLLockService *)service {
    [_operateUIView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:193/255.0 blue:37/255.0 alpha:1]];
    [self.operateUIButton setBackgroundImage: [UIImage imageNamed : @"update"] forState:UIControlStateNormal];
    self.hintLabel.text = @"门锁有新的固件，点击这里进行更新";
    _currentDisplayService = service;
    _operateUIButton.tag = 1;
    [_operateUIButton addTarget:self action:@selector(openBluetoothOrDfu:) forControlEvents:UIControlEventTouchUpInside];
}

/****************************************************************************/
/*				BLDfuServiceProtocol Delegate Methods					*/
/****************************************************************************/

- (void) dfuService:(BLDfuService*)service changeForDfuCommandState:(enum CommandState)commandState {
    switch (commandState) {
        case CP_START_DFU: {
            _hintLabel.text = @"start dfu";
            _progressView.hidden = NO;
            break;
        }
        case P_SEND_START_DATA: {
            _hintLabel.text = @"send start data";
            break;
        }
        case CP_INIT_BEGIN: {
            _hintLabel.text = @"init begin";
            break;
        }
        case P_SEND_INIT_DATA: {
            _hintLabel.text = @"send init data";
            break;
        }
        case CP_INIT_END: {
            _hintLabel.text = @"init end";
            break;
        }
        case CP_PKT_NOTIFY: {
            _hintLabel.text = @"pkt notify";
            break;
        }
        case CP_DATA_COMMAND: {
            _hintLabel.text = @"data command";
            break;
        }

        case P_DATA: {
            _hintLabel.text = @"send data";
            break;
        }
        case CP_VALIDATE: {
            _hintLabel.text = @"validate";
            break;
        }
        case CP_ACTIVATE: {
            _hintLabel.text = @"activate";
            break;
        }
        default:
            break;
    }
}

- (void) dfuService:(BLDfuService*)service changeForDfuProcess:(float)progressPercent {
    _progressView.progress = progressPercent;
}

- (void) dfuServiceChangeToLockMode:(BLDfuService *)service {
    _progressView.hidden = YES;
    [_operateUIButton setBackgroundImage: [UIImage imageNamed : @"bluetooth_black"] forState:UIControlStateNormal];
    [_operateUIView setBackgroundColor:BLGray];
    _hintLabel.text = @"点击这里打开蓝牙";
    _hintLabel.textColor = [UIColor blackColor];
    _operateUIButton.tag = 0;
}


@end