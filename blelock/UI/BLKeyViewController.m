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
    self.view = view;
    
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
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil]; //重点这里要建立委托
    
    
}


- (void)viewDidLoad
{
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    //Called to notify the view controller that its view is about to layout its subviews.
    
//    CGRect rect = self.view.bounds;
//    
//    CGRect r1 = _topNavigationBar.frame;
//    r1.size.width = 320.0f;
//    r1.size.height = 44.0f;
//    r1.origin.x = 0.0f;
//    r1.origin.y = 0.0f;
//    _keyTableView.frame = r1;
//
//    CGRect r2 = _operateUIView.frame;
//    r2.size.width = rect.size.width;
//    r2.size.height = 300.0f;
//    r2.origin.x = 0.0f;
//    r2.origin.y = CGRectGetMaxY(_topNavigationBar.frame);
//    _keyTableView.frame = r2;
//    
//    CGRect r3 = _operateUIImageView.frame;
//    r3.size.width = 44.0f;
//    r3.size.height = 44.0f;
//    r3.origin.x = (rect.size.width-r3.size.width)/2;
//    r3.origin.y = CGRectGetMaxY(_topNavigationBar.frame)+(300.0f-r3.size.height)/2;
//    _keyTableView.frame = r3;
//    
//    CGRect r4 = _hintLabel.frame;
//    r4.size.width = rect.size.width;
//    r4.size.height = 44.0f;
//    r4.origin.x = 0.0f;
//    r4.origin.y =CGRectGetMaxY(_operateUIImageView.frame);
//    _hintLabel.frame = r4;

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
    [self centralManagerDidUpdateState: _manager];
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
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            NSLog(@"蓝牙已打开,请扫描外设");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"蓝牙关闭...");
            break;
        default:
            NSLog(@"设备不支持BLE");
            break;
    }
}




@end