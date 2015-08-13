//
//  BLKeyView.m
//  blelock
//
//  Created by biliyuan on 15/8/3.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLKeyView.h"
#import "BLKey.h"

@interface BLKeyView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *operateUIView;
@property (nonatomic, strong) UIButton *operateUIButton;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, assign) id<BLKeyViewDelegate> caller;

@end

@implementation BLKeyView

- (id)init {
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}
- (id)initWithCaller:(id<BLKeyViewDelegate>)keyCaller {
    self = [self init];
    if (self) {
        self.caller = keyCaller;
    }
    return self;
}

- (void)prepare {
    //此处获得基本尺寸
    CGRect frame = [UIScreen mainScreen].bounds;
    CGRect navframe = CGRectMake(0, 0, frame.size.width, 44);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    //操作区背景
    self.operateUIView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, (frame.size.height-navframe.size.height)/2)];
    self.operateUIView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:self.operateUIView];
    //操作图标
    self.operateUIButton = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-100)/2, (frame.size.height-self.operateUIView.frame.size.height)/2-100, 100, 100)];
    [self.operateUIButton setBackgroundImage: [UIImage imageNamed : @"bluetooth.png"] forState:UIControlStateNormal];
    [self.operateUIButton addTarget:self action:@selector(openBluetooth) forControlEvents:UIControlEventTouchUpInside];
    [self.operateUIView addSubview:self.operateUIButton];
    //操作提示
    self.hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.operateUIButton.frame), frame.size.width, 44)];
    self.hintLabel.text = @"点击这里打开蓝牙";
    self.hintLabel.textColor = [UIColor whiteColor];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.font = [UIFont systemFontOfSize:16.0f];
    self.hintLabel.backgroundColor = [UIColor clearColor];
    [self.operateUIView addSubview:self.hintLabel];
    //钥匙列表
    UITableView *keyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.operateUIView.frame), frame.size.width, self.operateUIView.frame.size.height)];
    keyTableView.backgroundColor = [UIColor whiteColor];
    [view addSubview:keyTableView];
    //钥匙列表数据初始化
    keyTableView.dataSource = self;
    keyTableView.delegate = self;
    [keyTableView reloadData];
    [self addSubview: view];
}
//////////////////////////////////////////////////////////////////////////////////////////////
//<UITableViewDataSource>里必须实现的
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Tells the data source to return the number of rows in a given section of a table view. (required)
    return [self.data count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Asks the data source for a cell to insert in a particular location of the table view. (required)
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //config the cell
    BLKey *key = [self.data objectAtIndex:indexPath.row];
    cell.textLabel.text = key.alias;
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
    //Tells the delegate that the specified row is now selected.
    [self goToBLHouse:indexPath.row];
    //NSLog(@"%@", [self.data objectAtIndex:indexPath.row]);
}
- (void)goToBLHouse:(NSInteger)row {
    if ([self.caller respondsToSelector:@selector(goToBLHouseView:)]) {
        [self.caller goToBLHouseView:row];
    }
}
//蓝牙相关操作
- (void)openBluetooth {
    if ([self.caller respondsToSelector:@selector(openBluetoothView)]) {
        [self.caller openBluetoothView];
    }
}
- (void)changeForBLState {
    //1——蓝牙打开了
    //0——蓝牙关闭着
    //-1——设备不支持BLE
    switch (self.blState) {
        case 1: {
            [self.operateUIButton setBackgroundImage: [UIImage imageNamed : @"touch.png"] forState:UIControlStateNormal];
            [self.operateUIView setBackgroundColor: [UIColor blueColor]];
            self.hintLabel.text = @"请触摸门锁上的灯";
            break;
        }
        case 0: {
            break;
        }
        case -1: {
            ///////////////用于测试
            [self.operateUIButton setBackgroundImage: [UIImage imageNamed : @"touch.png"] forState:UIControlStateNormal];
            [self.operateUIView setBackgroundColor: [UIColor blueColor]];
            self.hintLabel.text = @"请触摸门锁上的灯";
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
    switch (self.keyState) {
        case 2: {
            [self.operateUIButton setBackgroundImage: [UIImage imageNamed : @"openLock.png"] forState:UIControlStateNormal];
            [self.operateUIView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:139/255.0 blue:69/255.0 alpha:1]];
            self.hintLabel.text = @"门锁已打开，请转动把手进门";
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitForSeconds) userInfo:nil repeats:NO];
            break;
        }
        case 1: {
            [self.operateUIButton setBackgroundImage: [UIImage imageNamed : @"connect.png"] forState:UIControlStateNormal];
            self.hintLabel.text = @"连接中，请耐心等待";
            break;
        }
        case 0: {
            self.hintLabel.text = @"附近没有锁";
            break;
        }
        case -1: {
            self.hintLabel.text = @"您没有权限开这把锁";
            break;
        }
        default:
            break;
    }
}
- (void)waitForSeconds {
    [self.operateUIButton setBackgroundImage: [UIImage imageNamed : @"house.png"] forState:UIControlStateNormal];
    self.hintLabel.text = @"欢迎您！";
}

@end