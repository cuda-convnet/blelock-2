//
//  BLKeyView.m
//  blelock
//
//  Created by biliyuan on 15/8/3.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLKeyView.h"
@interface BLKeyView() <UITableViewDelegate, UITableViewDataSource>
{
    UIView *view;
    UINavigationBar *navigationBar;
    UINavigationItem *navigationItem;
    UIButton *rightButton;
    UIBarButtonItem *rightItem;
    UIView *operateUIView;
    UIButton *operateUIButton;
    UILabel *hintLabel;
    UITableView *keyTableView;
    id<BLKeyViewDelegate> caller;
    NSArray *data;
    NSString *str;
    
}
@property(nonatomic, retain) id<BLKeyViewDelegate> caller;
@property(nonatomic, retain) NSArray *data;


@end

@implementation BLKeyView

@synthesize caller, data, state, keyState;

-(id)initWithCaller:(id<BLKeyViewDelegate>)_caller data:(NSArray *)_data
{
    if (self = [super initWithFrame:CGRectZero])
    {
        self.caller = _caller;
        self.data = _data;
        [self prepare];
    }
    return self;
}

-(void)prepare
{
    //Creates the view that the controller manages.
    CGRect frame = [UIScreen mainScreen].bounds;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navframe = CGRectMake(0, 0, frame.size.width, 44);
    
    view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    //导航栏
    
    navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, rectStatus.size.height, frame.size.width, navframe.size.height)];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    //创建一个导航栏集合
    navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationItem setTitle:@"钥匙"];
    [navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    //右边按钮
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, navframe.size.height, navframe.size.height);
    [rightButton setBackgroundImage: [UIImage imageNamed : @"user.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(gotoBLUser) forControlEvents:UIControlEventTouchUpInside];
    rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    navigationItem.rightBarButtonItem = rightItem;
    
    //把导航栏集合添加入导航栏中，设置动画关闭
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [view addSubview:navigationBar];
    
    //操作区背景
    operateUIView = [[UIView alloc] initWithFrame:CGRectMake(0, (rectStatus.size.height+navframe.size.height), frame.size.width, (frame.size.height-rectStatus.size.height-navframe.size.height)/2)];
    operateUIView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:operateUIView];
    
    //操作图标
    operateUIButton = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-100)/2, (frame.size.height-operateUIView.frame.size.height)/2-100, 100, 100)];
    [operateUIButton setBackgroundImage: [UIImage imageNamed : @"bluetooth.png"] forState:UIControlStateNormal];
    [operateUIButton addTarget:self action:@selector(openBluetooth) forControlEvents:UIControlEventTouchUpInside];
    
    [operateUIView addSubview:operateUIButton];
    
    //操作提示
    hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(operateUIButton.frame), frame.size.width, 44)];
    hintLabel.text = @"点击这里打开蓝牙";
    hintLabel.textColor = [UIColor whiteColor];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.font = [UIFont systemFontOfSize:14.0f];
    hintLabel.backgroundColor = [UIColor clearColor];
    [operateUIView addSubview:hintLabel];
    
    //钥匙列表
    keyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(operateUIView.frame), frame.size.width, operateUIView.frame.size.height)];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //Tells the data source to return the number of rows in a given section of a table view. (required)
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Asks the data source for a cell to insert in a particular location of the table view. (required)
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //config the cell
    cell.textLabel.text = [data objectAtIndex:indexPath.row];
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
    NSLog(@"%@", [data objectAtIndex:indexPath.row]);
}


- (void) gotoBLUser
{
    if ([caller respondsToSelector:@selector(gotoBLUserView)])
    {
        [caller gotoBLUserView];
    }
}
//蓝牙相关操作
- (void) openBluetooth
{
    if ([caller respondsToSelector:@selector(openBluetoothView)])
    {
        [caller openBluetoothView];
    }
}

- (void) changeForBLState
{
    //1——蓝牙打开了
    //0——蓝牙关闭着
    //-1——设备不支持BLE
    switch (state) {
        case 1:
        {
            [operateUIButton setBackgroundImage: [UIImage imageNamed : @"touch.png"] forState:UIControlStateNormal];
            [operateUIView setBackgroundColor: [UIColor blueColor]];
            hintLabel.text = @"请触摸门锁上的灯";
            
            break;
        }
        case 0:
        {
            break;
        }
        case -1:
        {
            ///////////////用于测试
            [operateUIButton setBackgroundImage: [UIImage imageNamed : @"touch.png"] forState:UIControlStateNormal];
            [operateUIView setBackgroundColor: [UIColor blueColor]];
            hintLabel.text = @"请触摸门锁上的灯";
            break;
        }
        default:
            break;
    }
    
}

-(void)changeForKeyState
{
    //1——搜索到锁周边
    //0——附近没有锁
    //2——锁被打开
    //-1——锁打开失败
    switch (keyState) {
        case 2:
        {
            [operateUIButton setBackgroundImage: [UIImage imageNamed : @"openLock.png"] forState:UIControlStateNormal];
            [operateUIView setBackgroundColor:[UIColor greenColor]];
            hintLabel.text = @"门锁已打开，请转动把手进门";
            //[operateUIButton setBackgroundImage: [UIImage imageNamed : @"home.png"] forState:UIControlStateNormal];
            //hintLabel.text = @"欢迎您！";
            break;

        }
        case 1:
        {
            [operateUIButton setBackgroundImage: [UIImage imageNamed : @"connect.png"] forState:UIControlStateNormal];
            hintLabel.text = @"连接中，请耐心等待";
            break;
        }
        case 0:
        {
            break;
        }
        case -1:
        {
            break;
        }
        default:
            break;
    }

}

@end