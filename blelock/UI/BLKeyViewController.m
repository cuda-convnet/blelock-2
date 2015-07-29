//
//  BLKeyViewController.m
//  blelock
//
//  Created by biliyuan on 15/7/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLKeyViewController.h"

@interface BLKeyViewController ()

@property (nonatomic, strong) UITableView *keyTableView;

@end

@implementation BLKeyViewController

{
    NSArray *dataArray;
}

- (void)loadView {
    CGRect tmp = [UIApplication sharedApplication].keyWindow.bounds;
    UIView *view = [[UIView alloc] initWithFrame:tmp];
    view.backgroundColor = [UIColor lightGrayColor];
    
    // Initialize table data
    
    
    
    _keyTableView = [[UITableView alloc] initWithFrame:tmp];
    //_keyTableView.header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    //_keyTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    _keyTableView.backgroundColor = [UIColor whiteColor];
    _keyTableView.dataSource = self;
    _keyTableView.delegate = self;
    [view addSubview:_keyTableView];
    
    dataArray = [NSArray arrayWithObjects:@"翠苑四区",@"工商管理楼", @"土木科技楼", @"阿木的家", @"网易六楼", @"网易宿舍837", @"浙大玉泉", @"浙大紫金港", @"浙大西溪", @"浙大曹主", nil];
    
    [_keyTableView reloadData];
    
    
    self.view = view;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

//下拉刷新时要加载数据
- (void)loadNewData{
    
}
//上拉加载更多数据
- (void)loadMoreData{
}

- (void)viewWillLayoutSubviews {
//    
//    CGRect rect = self.view.bounds;
//    
//    CGRect r1 = _keyTableView.frame;
//    r1.size.width = rect.size.width;
//    r1.size.height = rect.size.height;
//    r1.origin.x = 0.0f;
//    r1.origin.y = [self.topLayoutGuide length] + 30.0f;
//    _keyTableView.frame = r1;

}


#pragma mark -------------------
#pragma mark UITableViewDataSource
//委托里 @required 的必须实现

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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


#pragma mark -------------------
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", [dataArray objectAtIndex:indexPath.row]);
}

- (void) openBLButtonAction : (id)sender
{
}
@end